package kr.ac.collage_api.schedule.controller;

import kr.ac.collage_api.schedule.service.ScheduleEventService;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.service.TimetableService;
import kr.ac.collage_api.schedule.vo.CalendarEventVO;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import kr.ac.collage_api.schedule.vo.TimetableEventVO;
import kr.ac.collage_api.security.mapper.SecurityMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/schedule")
@RequiredArgsConstructor
public class ScheduleEventApiController {

    private final ScheduleEventService scheduleEventService;
    private final SpcdeHolidayService spcdeHolidayService;
    private final TimetableService timetableService;
    private final SecurityMapper ditAccountMapper;

    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE;
    private static final DateTimeFormatter BASIC = DateTimeFormatter.BASIC_ISO_DATE;

    @GetMapping("/events")
    public List<ScheduleEventVO> getAllEvents(
            @AuthenticationPrincipal UserDetails principal,
            @RequestParam String start,
            @RequestParam String end
    ) {

        // === 1. 날짜 정규화 (FullCalendar: [start, end) → end-1일까지 포함) ===
        LocalDate startDate = LocalDate.parse(start, ISO);
        LocalDate endExclusive = LocalDate.parse(end, ISO);
        LocalDate endInclusive = endExclusive.minusDays(1);

        String startYmd = startDate.format(BASIC);      // YYYYMMDD
        String endYmd = endInclusive.format(BASIC);     // YYYYMMDD

        // === 2. 사용자 컨텍스트 분기 (게스트 vs 인증 사용자) ===
        String acntId  = null;
        String role    = null;
        String stdntNo = null;
        String profsrNo = null;

        if (principal != null) {
            // 로그인된 경우: 기존 로직 유지
            acntId = principal.getUsername();
            log.info("[ScheduleEventApiController] getAllEvents : AUTH user acntId={}, start={}, end={}",
                    acntId, start, end);

            role = ditAccountMapper.findAuthoritiesByAcntId(acntId);

            if ("ROLE_STUDENT".equals(role)) {
                stdntNo = ditAccountMapper.findStdntNoByAcntId(acntId);
                if (stdntNo == null) {
                    log.warn("[ScheduleEventApiController] getAllEvents : ROLE_STUDENT but no STDNT_NO, acntId={}", acntId);
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN, "학생 번호 없음");
                }
            } else if ("ROLE_PROF".equals(role)) {
                profsrNo = ditAccountMapper.findProfsrNoByAcntId(acntId);
                if (profsrNo == null) {
                    log.warn("[ScheduleEventApiController] getAllEvents : ROLE_PROF but no PROFSR_NO, acntId={}", acntId);
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN, "교수 번호 없음");
                }
            } else if ("ROLE_ADMIN".equals(role)) {
                // 관리자: 별도 식별자 없이 전체 조회 (Mapper 쿼리 규칙에 따름)
            } else {
                // 이상한 권한이면 그냥 막음 (게스트가 아니라 "로그인된 이상한 계정"이므로)
                log.warn("[ScheduleEventApiController] getAllEvents : unsupported role access, acntId={}, role={}", acntId, role);
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "지원하지 않는 권한");
            }

            log.info("[ScheduleEventApiController] getAllEvents : resolved principal. acntId={}, role={}, stdntNo={}, profsrNo={}, range={}~{}",
                    acntId, role, stdntNo, profsrNo, startYmd, endYmd);

        } else {
            // 비로그인: 게스트 모드
            // role/stdntNo/profsrNo 는 그대로 null → Mapper 에서 "공개 학사 일정"만 조회하도록 설계
            log.info("[ScheduleEventApiController] getAllEvents : GUEST access start={}, end={}", start, end);
        }

        // === 3. 결과 리스트 생성 ===
        List<ScheduleEventVO> result = new ArrayList<>();

        // 3-1. 공휴일 매핑 (로그인 여부와 무관하게 항상 추가)
        List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(startDate, endInclusive);
        for (CalendarEventVO h : holidays) {
            ScheduleEventVO vo = new ScheduleEventVO();
            vo.setId("H_" + h.getCategory() + "_" + h.getStart());
            vo.setTitle(h.getTitle());
            vo.setType(h.isHoliday() ? "HOLIDAY" : h.getCategory());
            vo.setStartDate(h.getStart());   // ISO yyyy-MM-dd
            vo.setEndDate(null);             // allDay: end 미설정
            vo.setAllDay(true);
            vo.setMemo(h.isHoliday()
                    ? "공공데이터포털 기준 공휴일"
                    : "공공데이터포털 기준 기념일/국경일");
            result.add(vo);
        }
        log.debug("[ScheduleEventApiController] getAllEvents : mapped holidays count={}", holidays.size());

        // 3-2. DB 일정 통합 조회
        // - guest (role=null, stdntNo=null, profsrNo=null):
        //     → Mapper 에서 "공개 학사 일정(SCHAFS/ADMIN_* 등)" 만 반환하도록 WHERE 조건 설계 필요
        // - student/prof/admin:
        //     → 기존 개인 일정 + 학사 일정 모두 포함
        List<ScheduleEventVO> dbEvents =
                scheduleEventService.getAllEvents(role, stdntNo, profsrNo, startYmd, endYmd);
        log.debug("[ScheduleEventApiController] dbEvents : {}", dbEvents);

        if (dbEvents != null && !dbEvents.isEmpty()) {
            result.addAll(dbEvents);
        }

        log.info("[ScheduleEventApiController] getAllEvents : response ready. acntId={}, totalEvents={}, dbEvents={}, holidays={}",
                acntId, result.size(), dbEvents == null ? 0 : dbEvents.size(), holidays.size());

        return result;
    }

    
    @GetMapping("/timetable/lectures")
    public List<TimetableEventVO> getTimetable(
            @AuthenticationPrincipal UserDetails principal,
            @RequestParam String start,
            @RequestParam String end) {

        // 비인증 요청 차단
        if (principal == null) {
            log.warn("[ScheduleEventApiController] getTimetable : unauthorized access start={}, end={}", start, end);
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "인증 필요");
        }

        String acntId = principal.getUsername();
        String role = ditAccountMapper.findAuthoritiesByAcntId(acntId);

        // 파라미터 검증: FullCalendar에서 넘어오는 기본 형식(YYYY-MM-DD) 전제
        if (start == null || end == null || start.isBlank() || end.isBlank()) {
            log.warn("[ScheduleEventApiController] getTimetable : invalid date range acntId={}, start={}, end={}",
                    acntId, start, end);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "조회 기간(start, end)은 필수입니다.");
        }

        log.info("[ScheduleEventApiController] getTimetable : request acntId={}, role={}, range={}~{}",
                acntId, role, start, end);

        List<TimetableEventVO> result = new ArrayList<>();

        // 학생 시간표 조회
        if ("ROLE_STUDENT".equals(role)) {
            // ACNT_ID → STDNT_NO 매핑 실패 시 즉시 차단 (데이터 불일치 보호)
            String stdntNo = ditAccountMapper.findStdntNoByAcntId(acntId);
            if (stdntNo == null || stdntNo.isBlank()) {
                log.warn("[ScheduleEventApiController] getTimetable : ROLE_STUDENT but no STDNT_NO, acntId={}", acntId);
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "학생 정보가 존재하지 않습니다.");
            }

            List<TimetableEventVO> events = timetableService.getStudentTimetable(stdntNo, start, end);
            if (events != null && !events.isEmpty()) {
                result.addAll(events);
            }

            log.info("[ScheduleEventApiController] getTimetable : student timetable loaded. acntId={}, stdntNo={}, size={}",
                    acntId, stdntNo, events == null ? 0 : events.size());
        }
        // 교수 시간표 조회
        else if ("ROLE_PROF".equals(role)) {
            // ACNT_ID → PROFSR_NO 매핑 실패 시 즉시 차단
            String profsrNo = ditAccountMapper.findProfsrNoByAcntId(acntId);
            if (profsrNo == null || profsrNo.isBlank()) {
                log.warn("[ScheduleEventApiController] getTimetable : ROLE_PROF but no PROFSR_NO, acntId={}", acntId);
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "교수 정보가 존재하지 않습니다.");
            }

            List<TimetableEventVO> events = timetableService.getProfessorTimetable(profsrNo, start, end);
            if (events != null && !events.isEmpty()) {
                result.addAll(events);
            }

            log.info("[ScheduleEventApiController] getTimetable : professor timetable loaded. acntId={}, profsrNo={}, size={}",
                    acntId, profsrNo, events == null ? 0 : events.size());
        }
        // 허용되지 않은 권한
        else {
            log.warn("[ScheduleEventApiController] getTimetable : unsupported role. acntId={}, role={}", acntId, role);
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "시간표 조회 권한이 없습니다.");
        }

        // 최종 응답 로그
        log.info("[ScheduleEventApiController] getTimetable : response ready. acntId={}, role={}, totalEvents={}",
                acntId, role, result.size());

        return result;
    }
}
