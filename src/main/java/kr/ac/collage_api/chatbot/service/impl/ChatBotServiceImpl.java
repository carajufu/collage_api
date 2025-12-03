package kr.ac.collage_api.chatbot.service.impl;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.chatbot.mapper.ChatBotMapper;
import kr.ac.collage_api.chatbot.service.ChatBotService;
import kr.ac.collage_api.chatbot.vo.ChatBotVO;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ChatBotServiceImpl implements ChatBotService {

    @Autowired
    private ChatBotMapper chatBotMapper;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Value("${gemini.api.url}")
    private String geminiApiUrl;


    @Override
    public String getAnswer(String msg, String loginId, List<Map<String, String>> history) {

        String fixed = keywordMapping(msg);
        if (fixed != null) {
            return fixed;
        }

        AcntVO user = chatBotMapper.getUserDt(loginId);
        if (user == null) {
            return uiError("사용자 정보를 찾을 수 없습니다.");
        }

        String acntTy = user.getAcntTy();  // 1 학생 / 2 교수

        JSONObject dbPayload = "1".equals(acntTy)
                ? buildStudentJson(loginId)
                : buildProfessorJson(loginId);

        JSONArray histArr = new JSONArray();
        if (history != null) {
            for (Map<String, String> h : history) {
                JSONObject o = new JSONObject();
                o.put("role", h.get("role"));
                o.put("content", h.get("content"));
                histArr.put(o);
            }
        }

        String system = """
                당신은 대학교 학습관리시스템(SMART_LMS)의 챗봇입니다.

                [출력 규칙 - 절대 위반 금지]
                1) 응답은 반드시 <div> 로 시작해서 </div> 로 끝냅니다.
                2) 아래 템플릿의 바깥에는 아무것도 출력하지 않습니다.
                3) Markdown 기호(#, *, _, `, >, -)와 ``` 같은 코드블록 표기는 절대 출력하지 않습니다.
                4) "html", "code" 같은 단어를 태그 밖에 출력하지 않습니다.
                5) 사용자 질문을 그대로 복붙하거나 재인용하지 않습니다.

                [출력 템플릿 - 이 구조만 사용]
                <div class="chat-card border rounded p-3 shadow-sm bg-white mb-2">
                    <p class="mb-3">{{content}}</p>
                    <a class="btn btn-primary btn-sm" href="{{url}}">{{button}}</a>
                </div>

                [데이터 사용 규칙 - 학생]
                1) 나는 곧 "사용자 데이터"라는 JSON을 함께 받습니다.
                2) 성적/점수 관련 질문:
                   - score 배열과 graduation 객체를 분석해서
                     이수 학점, 전필/교필 학점, GPA(학생 성적 평균)를 요약합니다.
                3) 졸업 관련 질문:
                   - graduation 객체만 이용해서 졸업요건 충족 여부를 계산합니다.
                4) 수강신청/수강내역/시간표 질문:
                   - courses, timetable 배열을 사용합니다.
                5) 등록금/장학금 질문:
                   - payInfo 배열을 사용합니다.
                6) 출석/결석 관련 질문:
                   - attendance 배열을 사용합니다.
                7) 휴학/복학/자퇴 같은 학적 변경 질문:
                   - changeHistory 배열을 사용합니다.
                8) 상담 관련 질문:
                   - consult(학생), counselList(교수)를 사용합니다.

                [데이터 사용 규칙 - 교수]
                1) 강의/담당 과목 질문:
                   - lectureList, lectureTime 배열을 사용합니다.
                2) 과제/퀴즈/주차별 학습 질문:
                   - weekAcctoLrn 배열을 사용합니다.
                3) 상담 관리 질문:
                   - counselList 배열을 사용합니다.

                [URL 사용 규칙]
                1) URL 버튼은 항상 url 객체에서 가장 관련 있는 값을 골라 href 에 넣습니다.
                   예) 졸업 → url.graduation, 성적 → url.semesterGrade,
                       수강신청 → url.courseApply, 수강내역 → url.courseList,
                       시간표 → url.timetable, 등록금 → url.tuition,
                       상담 → url.counsel, 출석 → url.attendance 등
                2) url 객체에 적절한 키가 없다면, url.dashboard 또는 "/dashboard/student" 를 사용합니다.

                [스몰톡 / 가벼운 대화]
                1) "안녕", "반가워", "고마워" 같은 인사/가벼운 대화가 들어오면:
                   - 너무 길지 않게 1~2문장으로 부드럽게 답하고,
                   - 마지막에는 학사/성적/수강/졸업 안내가 가능하다는 말을 같이 전합니다.
                   - 예시: "안녕하세요. 저는 SMART_LMS 챗봇입니다. 학사·성적·수강·졸업 관련해서 무엇을 도와드릴까요?"
                2) 날씨/기분/밥먹었냐 등 LMS와 크게 상관없는 질문:
                   - 인간처럼 장황하게 대답하지 말고,
                   - "저는 챗봇이지만 LMS 관련 업무는 도와드릴 수 있다"는 메시지를 중심으로 짧게 답합니다.
                3) 스몰톡이더라도 출력 형식은 반드시 위 템플릿(<div>…)을 지켜야 합니다.

                [정체성/예외 처리]
                1) "너 누구야", "챗봇이 뭐 해줘" 등 정체성을 묻는 질문:
                   - content: "저는 SMART_LMS에서 학사·성적·수강·졸업 정보를 도와주는 챗봇입니다. 무엇이 궁금하신가요?"
                   - button: "학습관리 대시보드로 이동"
                   - url: url.dashboard 가 있으면 그것을 사용, 없으면 "/dashboard/student" 사용
                2) JSON 어디에도 관련 정보가 없으면:
                   - content: "요청하신 정보를 LMS에서 직접 확인해 주세요."
                   - button: "LMS 이동"
                   - url: url.dashboard 또는 "/dashboard/student"

                위 규칙과 템플릿을 항상 지키면서, 사용자의 질문과 JSON 데이터를 결합해
                한 장의 카드만 생성합니다.
                """;

        StringBuilder userPrompt = new StringBuilder();
        userPrompt.append("사용자 메시지: ").append(msg).append("\n\n");
        userPrompt.append("대화 히스토리(JSON 배열):\n")
                  .append(histArr.toString(2))
                  .append("\n\n");
        userPrompt.append("사용자 데이터(JSON):\n")
                  .append(dbPayload.toString(2));

        String resp = callGemini(system, userPrompt.toString());
        if (resp == null) {
            return uiError("챗봇 응답 오류가 발생했습니다.");
        }

        return sanitizeGeminiResponse(resp);
    }

    @Override
    public String getAnswer(String msg, String loginId) {
        return getAnswer(msg, loginId, null);
    }

    // 키워드 매핑
    private String keywordMapping(String msg) {

        if (msg == null) return null;

        String m = msg.replace(" ", "").toLowerCase();

        if (m.contains("내성적이 몇점인지 알려줘")) {
            return fixedCard(
                    "성적 조회 안내",
                    "학생 성적은 성적 조회 메뉴에서 확인할 수 있습니다.",
                    "/stdnt/grade/main/All",
                    "성적 조회"
            );
        }

        if (m.contains("내 이번학기 수강신청내역을 알려줘")) {
            return fixedCard(
                    "수강신청 안내",
                    "수강신청은 LMS 수강신청 메뉴에서 가능합니다.",
                    "/atnlc/submit",
                    "수강신청 이동"
            );
        }

        return null;
    }

    private String fixedCard(String title, String body, String url, String btn) {
        return "<div class='chat-card border rounded p-3 bg-white mb-2'>"
                + "<h5 class='fw-bold mb-2'>" + title + "</h5>"
                + "<p class='mb-3'>" + body + "</p>"
                + "<a class='btn btn-primary btn-sm' href='" + url + "'>" + btn + "</a>"
                + "</div>";
    }

    // Gemini 응답 정제
    private String sanitizeGeminiResponse(String resp) {

        if (resp == null || resp.trim().isEmpty()) {
            return defaultCard(
                    "정보를 찾을 수 없습니다",
                    "요청하신 정보를 LMS에서 직접 확인해 주세요.",
                    "/dashboard/student",
                    "LMS 이동"
            );
        }

        resp = resp.replace("```html", "");
        resp = resp.replace("```", "");
        resp = resp.replaceAll("[#*_`]", "");
        resp = resp.trim();

        int start = resp.indexOf("<div");
        int end = resp.lastIndexOf("</div>");
        if (start != -1 && end != -1 && end + 6 <= resp.length()) {
            resp = resp.substring(start, end + 6);
        }

        resp = resp.trim();

        if (!resp.startsWith("<div")) {
            return defaultCard(
                    "안내",
                    resp,
                    "/dashboard/student",
                    "LMS 이동"
            );
        }

        if (!resp.startsWith("<div class=\"chat-card")) {
            StringBuilder sb = new StringBuilder();
            sb.append("<div class=\"chat-card border rounded p-3 shadow-sm bg-white mb-2\">");
            sb.append(resp);
            sb.append("</div>");
            resp = sb.toString();
        }

        return resp;
    }

    private String defaultCard(String title, String body, String url, String buttonText) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div class=\"chat-card border rounded p-3 shadow-sm bg-white mb-2\">");
        sb.append("<h5 class=\"fw-bold mb-2\">").append(title).append("</h5>");
        sb.append("<p class=\"mb-3\">").append(body).append("</p>");
        sb.append("<a class=\"btn btn-primary btn-sm\" href=\"").append(url).append("\">")
          .append(buttonText).append("</a>");
        sb.append("</div>");
        return sb.toString();
    }

    // 학생 JSON BUILD
    private JSONObject buildStudentJson(String stdntNo) {
        JSONObject root = new JSONObject();

        // 성적
        List<ChatBotVO> scoreList = chatBotMapper.getStudentSbjScore(stdntNo);
        JSONArray scoreArr = new JSONArray();
        if (scoreList != null && !scoreList.isEmpty()) {
            for (ChatBotVO vo : scoreList) {
                JSONObject s = new JSONObject();
                s.put("middle", vo.getMiddleScore());
                s.put("final", vo.getTrmendScore());
                s.put("task", vo.getTaskScore());
                s.put("attendance", vo.getAtendScore());
                s.put("total", vo.getSbjectTotpoint());
                s.put("subjectName", vo.getSubjctNm());
                scoreArr.put(s);
            }
        }
        root.put("score", scoreArr);

        // 전체 이수학점
        int totalPnt = chatBotMapper.getAllPnt(stdntNo);

        // 과목별 이수구분
        List<Map<String, Object>> compl = chatBotMapper.getSubjectCompletions(stdntNo);

        int majorP = 0;
        int liberalP = 0;

        if (compl != null) {
            for (Map<String, Object> c : compl) {
                String tp = String.valueOf(c.get("COMPL_SE"));
                int p = Integer.parseInt(String.valueOf(c.get("ACQS_PNT")));

                if ("전필".equals(tp)) majorP += p;
                if ("교필".equals(tp)) liberalP += p;
            }
        }

        // GPA
        double gpa = chatBotMapper.getCumulativeGpa(stdntNo);

        // 졸업 요건 상태
        JSONObject grad = new JSONObject();
        grad.put("totalPoint", totalPnt);
        grad.put("majorReqPnt", majorP);
        grad.put("liberalReqPnt", liberalP);
        grad.put("gpa", gpa);

        root.put("graduation", grad);

        // 개설 교과 (수강 신청 내역)
        List<ChatBotVO> courses = chatBotMapper.getStudentAtnlc(stdntNo);
        JSONArray courseArr = new JSONArray();

        if (courses != null && !courses.isEmpty()) {
            for (ChatBotVO c : courses) {
                JSONObject o = new JSONObject();
                o.put("name", c.getLctreNm());
                o.put("type", c.getComplSe());
                o.put("credit", c.getAcqsPnt());
                o.put("year", c.getReqstYear());
                o.put("semester", c.getReqstSemstr());
                courseArr.put(o);
            }
        }
        root.put("courses", courseArr);

        // 기본정보
        ChatBotVO info = chatBotMapper.getStudentInfo(stdntNo);
        if (info != null) {
            JSONObject i = new JSONObject();
            i.put("name", info.getStdntNm());
            i.put("grade", info.getGrade());
            i.put("major", info.getSubjctNm());
            root.put("info", i);
        } else {
            root.put("info", new JSONObject());
        }

        // 상담내역
        List<Map<String, Object>> consult = chatBotMapper.getConsult(stdntNo);
        JSONArray consultArr = new JSONArray();

        if (consult != null && !consult.isEmpty()) {
            for (Map<String, Object> c : consult) {
                JSONObject o = new JSONObject();
                o.put("date", c.get("REQST_DE"));
                o.put("status", c.get("CNSLT_STTUS"));
                o.put("profsrNm", c.get("profsrNm"));
                consultArr.put(o);
            }
        }
        root.put("consult", consultArr);

        // 시간표
        List<ChatBotVO> timetableList = chatBotMapper.getStudentTimetable(stdntNo);
        JSONArray timetableArr = new JSONArray();
        if (timetableList != null && !timetableList.isEmpty()) {
            for (ChatBotVO t : timetableList) {
                JSONObject o = new JSONObject();
                o.put("lectureName", t.getLctreNm());
                o.put("room", t.getLctrum());
                o.put("dayOfWeek", t.getLctreDfk());
                o.put("beginTime", t.getBeginTm());
                o.put("endTime", t.getEndTm());
                timetableArr.put(o);
            }
        }
        root.put("timetable", timetableArr);

        // 등록금 정보
        List<Map<String, Object>> payInfoList = chatBotMapper.getStudentPayInfo(stdntNo);
        JSONArray payInfoArr = new JSONArray();
        if (payInfoList != null && !payInfoList.isEmpty()) {
            for (Map<String, Object> p : payInfoList) {
                JSONObject o = new JSONObject();
                o.put("amount", p.get("PAY_GLD"));
                o.put("scholarship", p.get("SCHLSHIP"));
                o.put("status", p.get("PAY_STTUS"));
                o.put("date", p.get("PAY_DE"));
                payInfoArr.put(o);
            }
        }
        root.put("payInfo", payInfoArr);

        // 출결 정보
        List<Map<String, Object>> attendanceList = chatBotMapper.getStudentAttendance(stdntNo);
        JSONArray attendanceArr = new JSONArray();
        if (attendanceList != null && !attendanceList.isEmpty()) {
            for (Map<String, Object> a : attendanceList) {
                JSONObject o = new JSONObject();
                o.put("lectureName", a.get("LCTRE_NM"));
                o.put("statusCode", a.get("ATEND_STTUS_CODE"));
                o.put("week", a.get("WEEK"));
                attendanceArr.put(o);
            }
        }
        root.put("attendance", attendanceArr);

        // 학적 변경 이력
        List<Map<String, Object>> changeList = chatBotMapper.getStudentChangeHistory(stdntNo);
        JSONArray changeArr = new JSONArray();
        if (changeList != null && !changeList.isEmpty()) {
            for (Map<String, Object> ch : changeList) {
                JSONObject o = new JSONObject();
                o.put("changeType", ch.get("CHANGE_TY"));
                o.put("status", ch.get("REQST_STTUS"));
                o.put("requestDate", ch.get("CHANGE_REQST_DT"));
                changeArr.put(o);
            }
        }
        root.put("changeHistory", changeArr);

        // URL
        JSONObject url = new JSONObject();
        url.put("tuition", "/payinfo/studentView");
        url.put("courseApply", "/atnlc/submit");
        url.put("courseCart", "/atnlc/cart");
        url.put("courseList", "/atnlc/stdntLctreList");
        url.put("lectureEval", "/stdnt/lecture/main/All");
        url.put("semesterGrade", "/stdnt/grade/main/All");
        url.put("lectureList", "/lecture/list");
        url.put("graduation", "/stdnt/gradu/main/All");
        url.put("enrollmentInfo", "/enrollment/status");
        url.put("enrollmentChange", "/enrollment/change");
        url.put("certificate", "/certificates/DocxForm");
        url.put("certificateHistory", "/certificates/DocxHistory");
        url.put("counsel", "/counsel/std");
        url.put("dashboard", "/dashboard/student");
        url.put("timetable", "/schedule/timetable");
        url.put("calendar", "/schedule/calendar");
        url.put("campusMap", "/info/campus/map");
        url.put("inqry", "/inqry/main");
        url.put("attendance", "/attendance/main");
        root.put("url", url);

        return root;
    }
    
    // 교수 JSON BUILD
    private JSONObject buildProfessorJson(String profNo) {

        JSONObject root = new JSONObject();

        // 담당 강의 목록
        List<ChatBotVO> lectureList = chatBotMapper.getProfessorLectureList(profNo);
        JSONArray lecArr = new JSONArray();
        if (lectureList != null && !lectureList.isEmpty()) {
            for (ChatBotVO l : lectureList) {
                JSONObject o = new JSONObject();
                o.put("name", l.getLctreNm());
                o.put("year", l.getEstblYear());
                o.put("semester", l.getEstblSemstr());
                o.put("type", l.getComplSe());
                o.put("evalMethod", l.getEvlMthd());
                o.put("studentCount", l.getAtnlcNmpr());
                lecArr.put(o);
            }
        }
        root.put("lectureList", lecArr);

        // 상담 예약 목록
        List<ChatBotVO> cList = chatBotMapper.getProfessorCounselList(profNo);
        JSONArray cArr = new JSONArray();
        if (cList != null && !cList.isEmpty()) {
            for (ChatBotVO c : cList) {
                JSONObject o = new JSONObject();
                o.put("studentName", c.getStdntNm());
                o.put("applyDate", c.getReqstDe());
                o.put("date", c.getCnsltRequstDe());
                o.put("time", c.getCnsltRequstHour());
                cArr.put(o);
            }
        }
        root.put("counselList", cArr);

        // 주차별 학습/과제/제출현황
        List<ChatBotVO> wk = chatBotMapper.getProfWeekAcctoLrn(profNo);
        JSONArray wkArr = new JSONArray();

        if (wk != null && !wk.isEmpty()) {
            for (ChatBotVO w : wk) {
                JSONObject o = new JSONObject();
                o.put("weekNo", w.getWeek());
                o.put("lectureCode", w.getEstbllctreCode());
                o.put("learnTheme", w.getLrnThema());
                o.put("learnContent", w.getLrnCn());
                o.put("hasTask", w.getTaskAt());
                o.put("taskNo", w.getTaskNo());
                o.put("taskTitle", w.getTaskSj());
                o.put("taskContent", w.getTaskCn());
                o.put("taskStartDate", w.getTaskBeginDe());
                o.put("taskEndDate", w.getTaskClosDe());
                o.put("hasQuiz", w.getQuizAt());
                o.put("submissionNo", w.getTaskPresentnNo());
                o.put("studentNo", w.getStdntNo());
                o.put("isSubmitted", w.getPresentnAt());
                wkArr.put(o);
            }
        }
        root.put("weekAcctoLrn", wkArr);

        // 교수 시간표 / 강의 시간 정보
        List<ChatBotVO> profTimeList = chatBotMapper.getProfLctreTime(profNo);
        JSONArray profTimeArr = new JSONArray();
        if (profTimeList != null && !profTimeList.isEmpty()) {
            for (ChatBotVO t : profTimeList) {
                JSONObject o = new JSONObject();
                o.put("lectureCode", t.getEstbllctreCode());
                o.put("profNo", t.getProfsrNo());
                o.put("credit", t.getAcqsPnt());
                o.put("room", t.getLctrum());
                o.put("type", t.getComplSe());
                o.put("studentCount", t.getAtnlcNmpr());
                o.put("evalMethod", t.getEvlMthd());
                o.put("year", t.getEstblYear());
                o.put("semester", t.getEstblSemstr());
                o.put("subjectCode", t.getLctreCode());
                o.put("lectureName", t.getLctreNm());
                o.put("timetableNo", t.getTimetableNo());
                o.put("dayOfWeek", t.getLctreDfk());
                o.put("beginTime", t.getBeginTm());
                o.put("endTime", t.getEndTm());
                profTimeArr.put(o);
            }
        }
        root.put("lectureTime", profTimeArr);

        // URL
        JSONObject url = new JSONObject();
        url.put("lectureManage", "/prof/lecture/main/All");
        url.put("gradeManage", "/prof/grade/main/All");
        url.put("counselManage", "/counselprof/prof");
        root.put("url", url);

        return root;
    }

    // Gemini CALL
    private String callGemini(String systemPrompt, String userPrompt) {
        try {

            JSONObject body = new JSONObject()
                    .put("contents", new JSONArray()
                            .put(new JSONObject()
                                    .put("parts", new JSONArray()
                                            .put(new JSONObject()
                                                    .put("text",
                                                            systemPrompt + "\n\n" + userPrompt))
                                    )
                            )
                    );

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(geminiApiUrl))
                    .header("Content-Type", "application/json")
                    .header("x-goog-api-key", geminiApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
                    .build();

            HttpResponse<String> response =
                    HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.error("Gemini 오류: {}", response.body());
                return null;
            }

            JSONObject json = new JSONObject(response.body());

            return json
                    .getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .getString("text");

        } catch (Exception e) {
            log.error("Gemini 통신 오류", e);
            return null;
        }
    }

    private String uiError(String msg) {
        return "<div class='border border-danger rounded p-3 bg-white shadow-sm mb-2'>"
                + "<h6 class='fw-bold text-danger mb-2'>오류</h6>"
                + "<p class='mb-0'>" + msg + "</p>"
                + "</div>";
    }

}
