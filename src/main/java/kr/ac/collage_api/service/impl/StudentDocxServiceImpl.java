package kr.ac.collage_api.service.impl;

import kr.ac.collage_api.mapper.StudentDocxMapper;
import kr.ac.collage_api.service.StudentDocxService;
import kr.ac.collage_api.vo.ScoreRowVO;
import kr.ac.collage_api.vo.StudentDocxVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StudentDocxServiceImpl implements StudentDocxService {

    private final StudentDocxMapper studentDocxMapper;

    @Override
    public StudentDocxVO getEnrollmentDocx(String stdntNo) {
        StudentDocxVO vo = studentDocxMapper.selectStudentBasic(stdntNo);
        postProcessDegreeName(vo);
        return vo;
    }

    @Override
    public StudentDocxVO getLeaveDocx(String stdntNo) {
        StudentDocxVO vo = studentDocxMapper.selectLeaveInfo(stdntNo);
        postProcessDegreeName(vo);
        return vo;
    }

    @Override
    public StudentDocxVO getGraduationDocx(String stdntNo) {
        StudentDocxVO vo = studentDocxMapper.selectGraduationInfo(stdntNo);
        postProcessDegreeName(vo);
        return vo;
    }

    @Override
    public StudentDocxVO getTranscriptHeader(String stdntNo) {
        // 성적증명서 헤더/요약
        StudentDocxVO summary = studentDocxMapper.selectScoreSummary(stdntNo);
        if (summary == null) {
            summary = studentDocxMapper.selectStudentBasic(stdntNo);
        }
        postProcessDegreeName(summary);
        return summary;
    }

    @Override
    public List<ScoreRowVO> getTranscriptRows(String stdntNo) {
        return studentDocxMapper.selectScoreRows(stdntNo);
    }

    /**
     * postProcessDegreeName
     *
     * 목적
     *  - DB에는 학위명(degreeName) 없음
     *  - 증명서 노출 전 단과대명을 기준으로 학위명을 세팅
     *
     * 흐름
     *  1) collegeName 후보 추출
     *  2) resolveDegreeNameByCollege 로 치환
     *  3) vo.setDegreeName(...)
     * @return 
     */
    public StudentDocxVO postProcessDegreeName(StudentDocxVO vo) {
        boolean needFill =
                (vo.getDegreeName() == null || vo.getDegreeName().isBlank());

        String baseCollegeName = getBaseCollegeName(vo);

        String degree = resolveDegreeNameByCollege(baseCollegeName);

        vo.setDegreeName(degree);
		return vo;
    }

    /**
     * getBaseCollegeName
     *
     * 목적
     *  - 단과대 명칭이 어느 컬럼에 오든 뽑아냄
     *
     * 규칙
     *  1) vo.getCollegeName() 우선
     *     예: "소프트웨어융합대학"
     *  2) 없으면 전공명(majorName)에서 유추 시도
     *     예: "컴퓨터공학전공" -> "공과대학"류로 보정 불가하면 그냥 null
     *
     * 전공명으로 단과대 추정 로직은 약함. 정책적으로 필요하면 여기에 if 추가.
     */
    private String getBaseCollegeName(StudentDocxVO vo) {
        // 1순위 DB에서 직접 준 단과대명
        if (vo.getCollegeName() != null && !vo.getCollegeName().isBlank()) {
            return vo.getCollegeName().trim();
        }

        // 2순위: 전공명 기반 추정 (휴학 등 일부 쿼리가 COLLEGE_NM 안 뽑아올 경우 대비)
        // 예) "컴퓨터공학전공", "전자공학과" 등은 공학 계열로 본다
        String major = vo.getMajorName();
        if (major != null && !major.isBlank()) {
            String m = major.trim();

            // 간단한 휴리스틱
            if (m.contains("공학")) {
                return "공과대학";
            }
            if (m.contains("경영")) {
                return "경영대학";
            }
            if (m.contains("디자인") || m.contains("예술")) {
                return "예술대학";
            }
            if (m.contains("영어") || m.contains("문학") || m.contains("인문")) {
                return "인문대학";
            }
            if (m.contains("경제") || m.contains("행정") || m.contains("사회")) {
                return "사회과학대학";
            }
            if (m.contains("물리") || m.contains("화학") || m.contains("과학")) {
                return "자연과학대학";
            }
        }

        // 못찾으면 null
        return null;
    }

    /**
     * resolveDegreeNameByCollege 
     * 목적 
     *  - 학사 테이블 부재로 데이터 기반 전처리 학사 추론 
     * 입력
     *  - 단과대명 (예: "소프트웨어융합대학", "공과대학")
     * 출력
     *  - 최종 학위명 (예: "공학사", "문학사")
     *
     * 원칙
     *  1) 사전 매핑 우선
     *  2) 사전 매핑 실패시 부분 매칭
     *  3) 그래도 실패하면 "학사"
     *
     * 주의
     *  - 행정팀이 학위명 정책 바꾸면 여기 map만 손대면 된다
     *  - DB 칼럼은 그대로 둬도 된다
     */
    private String resolveDegreeNameByCollege(String collegeName) {

        if (collegeName == null || collegeName.isBlank()) {
            return "학사";
        }

        String name = collegeName.trim();

        // 완전 일치 테이블
        Map<String, String> exactMap = Map.ofEntries(
            Map.entry("공과대학",         "공학사"),
            Map.entry("소프트웨어융합대학","공학사"),
            Map.entry("공학대학",         "공학사"),

            Map.entry("인문대학",         "문학사"),
            Map.entry("문과대학",         "문학사"),

            Map.entry("사회과학대학",     "사회과학사"),
            Map.entry("상경대학",         "경영학사"),
            Map.entry("경영대학",         "경영학사"),

            Map.entry("자연과학대학",     "이학사"),
            Map.entry("과학기술대학",     "이학사"),

            Map.entry("예술대학",         "예술학사"),
            Map.entry("미디어융합대학",   "미디어학사")
        );

        // 완전일치 우선
        if (exactMap.containsKey(name)) {
            return exactMap.get(name);
        }

        // 부분 매칭 fallback
        if (name.contains("공"))                   return "공학사";
        if (name.contains("인문") || name.contains("문과")) return "문학사";
        if (name.contains("사회") || name.contains("정경")) return "사회과학사";
        if (name.contains("경영") || name.contains("상경")) return "경영학사";
        if (name.contains("자연") || name.contains("이과") || name.contains("과학"))
            return "이학사";
        if (name.contains("예술") || name.contains("디자인") || name.contains("미디어"))
            return "예술학사";

        // 마지막 안전망
        return "학사";
    }
}
