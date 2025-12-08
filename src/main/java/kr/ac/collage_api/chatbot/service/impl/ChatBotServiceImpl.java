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

//    @Value("${gemini.api.key}")
//    private String geminiApiKey;
//
//    @Value("${gemini.api.url}")
//    private String geminiApiUrl;


//    @Override
//    public String getAnswer(String msg, String loginId, List<Map<String, String>> history) {
//
//        String fixed = keywordMapping(msg);
//        if (fixed != null) {
//            return fixed;
//        }
//
//        AcntVO user = chatBotMapper.getUserDt(loginId);
//        if (user == null) {
//            return uiError("사용자 정보를 찾을 수 없습니다.");
//        }
//
//        String acntTy = user.getAcntTy();  // 1 학생 / 2 교수
//
//        JSONObject dbPayload = "1".equals(acntTy)
//                ? buildStudentJson(loginId)
//                : buildProfessorJson(loginId);
//
//        JSONArray histArr = new JSONArray();
//        if (history != null) {
//            for (Map<String, String> h : history) {
//                JSONObject o = new JSONObject();
//                o.put("role", h.get("role"));
//                o.put("content", h.get("content"));
//                histArr.put(o);
//            }
//        }
//
//        String system = """
//               ★★★★★ 챗봇 페르소나 및 역할 ★★★★★
//            1) 당신은 LMS 학습 관리 챗봇이지만, 학업 정보 외에도 사용자의 일상적 질문(기분, 날씨, 식사, 추천 등)에 자연스럽게 대화형으로 응답할 수 있습니다. 모든 대답은 친절하고 명확해야 합니다.
//
//            ★★★★★ 절대 출력 규칙 (가장 중요) ★★★★★
//            2) 당신의 응답은 반드시 <div> 로 시작하고 </div> 로 끝나야 합니다.
//            3) 첫 글자가 < 가 아니거나, 마지막 글자가 > 가 아닌 경우는 절대 허용되지 않습니다.
//            4) HTML 태그 외의 텍스트, 설명, 주석, 코드블록 형태는 절대 출력하지 않습니다.
//            5) "```", "html", "code" 등의 단어는 절대 출력하지 않습니다.
//            6) Markdown 기호(# * _ > - `)는 절대 출력하지 않습니다.
//            7) 아래 카드 템플릿 구조만 출력합니다. 태그·클래스·형식 변경 금지.
//            8) 질문 의도에 맞는 단 하나의 카드만 출력합니다.
//            9) 사용자 입력 문장을 그대로 복붙하거나 반복하지 않습니다.
//
//            ★★★★★ 질문 판별 규칙 (우선 적용) ★★★★★
//            10) 사용자의 질문이 학업과 무관한 일상 대화(예: 점심, 저녁, 기분, 날씨, 추천, 취미, 소소한 잡담 등)라면, JSON 분석 없이 자연스러운 대화 답변을 생성합니다.
//            11) 이 경우 제목은 대화 주제를 요약한 문장으로, 본문은 친절한 자연 대화로 작성합니다.
//            12) **일상 대화 카드에는 버튼(이동 링크)을 절대 포함하지 않습니다.**
//
//            ★★★★★ 학업 정보 처리 규칙 (두 번째 우선순위) ★★★★★
//            13) 사용자의 질문이 학업 관련이면 JSON을 최우선으로 분석해 답변합니다.
//            14) 졸업, 성적, 수강, 과제, 공지 등 개인 정보가 포함된 질문은 JSON 내 해당 객체를 분석하여 실제 수치·상태를 포함한 상세한 답변을 생성합니다.
//            15) 관련 URL이 JSON의 url 객체에 존재하면 버튼의 URL로 적용하고 버튼명은 “상세보기”, “조회하기” 등으로 작성합니다.
//
//            ★★★★★ 정체성 질문 처리 ★★★★★
//            16) “너 누구야” 등 챗봇의 존재를 묻는 경우:
//                - 제목: LMS 챗봇
//                - 본문: 저는 학생들의 학업과 편의를 돕는 학습 관리 챗봇입니다. 무엇이든 편하게 물어보세요.
//                - 버튼명: LMS 포털 바로가기
//                - URL: JSON의 포털 주소 또는 "/"
//
//            ★★★★★ 정보 없음 처리 ★★★★★
//            17) 위 모든 규칙에 해당하지 않을 때만 사용:
//                - 제목: 정보를 찾을 수 없습니다
//                - 본문: 요청하신 정보를 찾을 수 없습니다. LMS 포털에서 직접 확인해 주세요.
//                - 버튼명: LMS 포털 바로가기
//                - URL: JSON 포털 주소 또는 "/"
//
//            ★★★★★ 출력 형식 (절대 변경 금지) ★★★★★
//            18) 어떤 경우에도 코드블록을 사용하지 않고 <div>...</div> 만 출력합니다.
//
//            ※ 중요: 일상 대화일 때 “추천하기 어렵습니다, LMS 관련 질문만 가능합니다”와 같은
//            거부형 문장을 절대 출력하지 마십시오.
//
//            ※ 중요: 일상 대화에서는 음식 추천, 기분 응답, 자연스러운 대답 모두 허용합니다.
//                """;
//
//        StringBuilder userPrompt = new StringBuilder();
//        userPrompt.append("사용자 메시지: ").append(msg).append("\n\n");
//        userPrompt.append("대화 히스토리(JSON 배열):\n")
//                .append(histArr.toString(2))
//                .append("\n\n");
//        userPrompt.append("사용자 데이터(JSON):\n")
//                .append(dbPayload.toString(2));
//
//        String resp = callGemini(system, userPrompt.toString());
//        if (resp == null) {
//            return uiError("챗봇 응답 오류가 발생했습니다.");
//        }
//
//        return sanitizeGeminiResponse(resp);
//    }

//    @Override
//    public String getAnswer(String msg, String loginId) {
//        return getAnswer(msg, loginId, null);
//    }

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
//    private String callGemini(String systemPrompt, String userPrompt) {
//        try {
//
//            JSONObject body = new JSONObject()
//                    .put("contents", new JSONArray()
//                            .put(new JSONObject()
//                                    .put("parts", new JSONArray()
//                                            .put(new JSONObject()
//                                                    .put("text",
//                                                            systemPrompt + "\n\n" + userPrompt))
//                                    )
//                            )
//                    );
//
//            HttpRequest request = HttpRequest.newBuilder()
//                    .uri(URI.create(geminiApiUrl))
//                    .header("Content-Type", "application/json")
//                    .header("x-goog-api-key", geminiApiKey)
//                    .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
//                    .build();
//
//            HttpResponse<String> response =
//                    HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
//
//            if (response.statusCode() != 200) {
//                log.error("Gemini 오류: {}", response.body());
//                return null;
//            }
//
//            JSONObject json = new JSONObject(response.body());
//
//            return json
//                    .getJSONArray("candidates")
//                    .getJSONObject(0)
//                    .getJSONObject("content")
//                    .getJSONArray("parts")
//                    .getJSONObject(0)
//                    .getString("text");
//
//        } catch (Exception e) {
//            log.error("Gemini 통신 오류", e);
//            return null;
//        }
//    }

    private String uiError(String msg) {
        return "<div class='border border-danger rounded p-3 bg-white shadow-sm mb-2'>"
                + "<h6 class='fw-bold text-danger mb-2'>오류</h6>"
                + "<p class='mb-0'>" + msg + "</p>"
                + "</div>";
    }

}

