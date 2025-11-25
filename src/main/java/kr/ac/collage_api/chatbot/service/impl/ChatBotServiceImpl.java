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
    public String getAnswer(String msg, String loginId) {

        AcntVO user = chatBotMapper.getUserDt(loginId);

        if (user == null) {
            return uiError("사용자 정보를 찾을 수 없습니다.");
        }

        String acntTy = user.getAcntTy();  // 1 학생 / 2 교수

        JSONObject dbPayload;

        if ("1".equals(acntTy)) {
            dbPayload = buildStudentJson(loginId);
        } else {
            dbPayload = buildProfessorJson(loginId);
        }

        String system =""" 
        		★★★★★ 챗봇 페르소나 및 역할 ★★★★★
				1) 당신은 대학교의 학습 관리 시스템(LMS) 챗봇입니다. 학생들의 학업 질문(강의, 과제, 성적, 공지)에 정보를 제공합니다. 어조는 항상 친절하고 명확해야 합니다.
		
				★★★★★ 절대 출력 규칙 (가장 중요) ★★★★★
				2) 당신의 응답은 반드시 <div> 로 시작하고 </div> 로 끝나야 합니다.
				3) 응답의 첫 글자가 < 가 아니거나, 마지막 글자가 > 가 아닌 경우는 절대 허용되지 않습니다.
				4) HTML 태그 외의 텍스트, 설명, 주석, 그리고 특히 코드블록( ``` )은 절대 출력하지 않습니다.
				5) "```", "html", "code" 같은 단어 자체도 절대 출력하지 않습니다.
				6) Markdown 기호(# * _ > - `)는 절대 출력하지 않습니다.
				7) 아래 카드 템플릿 구조만 출력합니다. 태그·클래스·형식 변경 금지.
				8) 질문 의도에 맞는 1개의 카드만 출력합니다.
				9) 사용자 입력을 그대로 재현하거나 인용하지 않습니다.
				
				★★★★★ 정보 처리 및 응답 규칙 (LMS 맞춤형) ★★★★★
				10) [정보 활용] 당신은 "사용자 데이터"로 학생(또는 교수)의 DB 정보가 담긴 JSON 객체를 받습니다. 사용자의 질문에 답할 때, **반드시 이 JSON 데이터를 최우선으로 참조**하여 구체적인 정보를 제공해야 합니다.
				11) [개인정보 활용] '졸업 학점', '내 성적', '수강 목록' 등 개인화된 질문을 받으면, **규칙 10에 따라 "사용자 데이터" JSON 객체를 즉시 분석**하여 답변해야 합니다. 
					- 예: "졸업 학점" 질문 시: "graduation" 객체를 분석하여 현재 이수 학점, 충족 여부를 계산하고 본문에 포함합니다. (예: "현재 총 120학점 이수(130학점 필요), 전공 50학점(50학점 필요)...")
					- 예: "내 성적" 질문 시: "score" 객체를 참조하여 점수를 알려줍니다.
				12) [스마트 링크] 답변과 관련된 페이지가 "url" 객체에 있다면, 해당 URL을 버튼의 'URL' 값으로 사용하고, '버튼명'은 "상세보기", "성적 조회 바로가기" 등 구체적으로 설정합니다.
				13) [정체성 질문] '너 누구야', '이름이 뭐야' 등 챗봇의 정체성을 묻는 경우, JSON 데이터와 관계없이 제목은 'LMS 챗봇', 본문은 '저는 학생들의 학업을 돕는 학습 관리 챗봇입니다. 무엇이든 물어보세요.', 버튼명은 'LMS 포털 바로가기', URL은 "[LMS 포털 URL]"로 설정합니다. (단, "url" 객체에 포털 URL이 있다면 그것을 사용)
				14) [정보 없음 처리] 위 모든 규칙(특히 11, 13번)에 해당하지 않고, **"사용자 데이터" JSON을 분석해도** 관련 정보를 찾을 수 없는 경우에만 이 규칙을 사용합니다. 제목은 "정보를 찾을 수 없습니다", 본문은 "요청하신 정보를 찾을 수 없습니다. LMS 포털에서 직접 확인해 주세요.", 버튼명은 "LMS 포털 바로가기", URL은 "[LMS 포털 URL]"로 설정합니다.
				
				★★★★★ 출력 형식 예시 (매우 중요) ★★★★★
				15) [절대 금지 예시] "```html" 이나 "```" 같은 마크다운 코드 블록으로 응답을 감싸지 않습니다.
				    (Bad Example: ```html <div>...</div> ``` -> (X) 절대 금지)
				16) [정상 출력 예시] 오직 HTML 태그만 출력합니다.
				    (Good Example: <div>...</div> -> (O) 이 형식으로만 응답해야 합니다.)
		        """;

        String userPrompt =
                "사용자 메시지: " + msg + "\n" +
                "사용자 데이터:\n" + dbPayload.toString(2);

        String resp = callGemini(system, userPrompt);

        if (resp == null) {
            return uiError("챗봇 응답 오류가 발생했습니다.");
        }


        int cs = resp.indexOf("```");
        int ce = resp.lastIndexOf("```");
        if (cs != -1 && ce > cs) {
            resp = resp.substring(cs + 3, ce);
        }

        resp = resp.replace("```html", "")
                   .replace("```", "")
                   .replace("html", "")
                   .trim();

        if (!resp.trim().startsWith("<div")) {
            resp = "<div>" + resp + "</div>";
        }

        return resp;
    }


    // 학생
    private JSONObject buildStudentJson(String stdntNo) {

        JSONObject root = new JSONObject();

        // 성적 (과목이 여러개로 넘어와 LIST형식으로 변경)
        List<ChatBotVO> scoreList = chatBotMapper.getStudentSbjScore(stdntNo);

        if (scoreList != null && !scoreList.isEmpty()) {

            JSONArray arr = new JSONArray();

            for (ChatBotVO vo : scoreList) {

                JSONObject s = new JSONObject();
                s.put("middle", vo.getMiddleScore());
                s.put("final",  vo.getTrmendScore());
                s.put("task",   vo.getTaskScore());
                s.put("attendance", vo.getAtendScore());
                s.put("total",  vo.getSbjectTotpoint());
                s.put("subjectName", vo.getSubjctNm());   // 과목명 있을 경우

                arr.put(s);
            }

            root.put("score", arr);
        }


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
        
        if (courses != null) {
            for (ChatBotVO c : courses) {
                JSONObject o = new JSONObject();
                o.put("name", c.getLctreNm());
                o.put("type", c.getComplSe());
                o.put("credit", c.getAcqsPnt());
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
        }

     // 상담내역
        List<Map<String, Object>> consult = chatBotMapper.getConsult(stdntNo);
        JSONArray consultArr = new JSONArray();
        
        if (consult != null) {
            for (Map<String, Object> c : consult) {
                JSONObject o = new JSONObject();
                o.put("date", c.get("REQST_DE"));
                o.put("status", c.get("CNSLT_STTUS"));
                o.put("profsrNm", c.get("profsrNm"));
                consultArr.put(o);
            }
        }
        root.put("consult", consultArr);

        // URL
        JSONObject url = new JSONObject();
        url.put("graduation", "/stdnt/gradu/main/All");
        url.put("lectureEval", "/stdnt/lecture/main/All");
        url.put("course", "/atnlc/submint");
        url.put("tuition", "/payinfo/studentView/");
        url.put("counsel", "/counsel/std");
        url.put("certificate", "/cert/certDocxForm");
        url.put("lectureList", "/lecture/list");
        url.put("inqry", "/inqry/main");
        url.put("attendance", "/attendance/main");
        root.put("url", url);

        return root;
    }


    //교수 JSON BUILD
    private JSONObject buildProfessorJson(String profNo) {

        JSONObject root = new JSONObject();

        // 담당 강의 목록
        List<ChatBotVO> lectureList = chatBotMapper.getProfessorLectureList(profNo);
        JSONArray lecArr = new JSONArray();
        if (lectureList != null) {
            for (ChatBotVO l : lectureList) {
                JSONObject o = new JSONObject();
                o.put("name", l.getLctreNm());
                o.put("year", l.getEstblYear());
                o.put("semester", l.getEstblSemstr());
                o.put("type", l.getComplSe());
                o.put("studentCount", l.getAtnlcNmpr());
                lecArr.put(o);
            }
        }
        root.put("lectureList", lecArr);

        // 상담 예약 목록
        List<ChatBotVO> cList = chatBotMapper.getProfessorCounselList(profNo);
        JSONArray cArr = new JSONArray();
        if (cList != null) {
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
        
        if (wk != null) {
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
                o.put("professorNo", w.getProfsrNo());
                wkArr.put(o);
            }
        }
        root.put("weekAcctoLrn", wkArr);

        // URL
        JSONObject url = new JSONObject();
        url.put("lectureManage", "/prof/lecture/main/All");
        url.put("gradeManage", "/prof/grade/main/All");
        url.put("counselManage", "/counselprof/prof");
        root.put("url", url);

        return root;
    }


    // GEMINI CALL
    private String callGemini(String systemPrompt, String userPrompt) {
        try {
        	
            JSONObject body = new JSONObject()
                    .put("contents", new JSONArray()
                            .put(new JSONObject()
                                    .put("parts", new JSONArray()
                                            .put(new JSONObject().put("text",
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


    //UI 템플릿
    private String uiError(String msg) {
        return "<div class='border border-danger rounded p-3 bg-white shadow-sm mb-2'>"
                + "<h6 class='fw-bold text-danger mb-2'>오류</h6>"
                + "<p class='mb-0'>" + msg + "</p>"
                + "</div>";
    }

}
