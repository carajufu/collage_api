//package kr.ac.collage_api.chatbot.service.impl;
//
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import kr.ac.collage_api.chatbot.mapper.ChatBotMapper;
//import kr.ac.collage_api.chatbot.service.ChatBotService;
//import kr.ac.collage_api.vo.*;
//import lombok.extern.slf4j.Slf4j;
//
//@Service
//@Slf4j
//public class ChatBotServiceImpl implements ChatBotService {
//
//    @Autowired
//    private ChatBotMapper chatBotMapper;
//
//    @Override
//    public String getAnswer(String msg, String loginId) {
//
//        AcntVO user = chatBotMapper.getUserDt(loginId);
//
//        if (user == null) {
//            return uiError("사용자 정보를 찾을 수 없습니다.");
//        }
//
//        String acntTy = user.getAcntTy();
//
//        if ("1".equals(acntTy)) {
//            return getStdntAnswer(msg, loginId);
//        } else if ("2".equals(acntTy)) {
//            return getProfAnswer(msg, loginId);
//        }
//
//        return uiError("유효한 사용자 유형이 확인되지 않습니다.");
//    }
//
//    //답변 템플릿
//    private String uiCard(String title, String body, String buttonLabel, String buttonHref) {
//
//        StringBuilder sb = new StringBuilder();
//
//        sb.append("<div class='border rounded p-3 bg-white shadow-sm'>")
//          .append("<h6 class='fw-bold mb-3'>").append(title).append("</h6>")
//          .append("<div class='mb-3' style='line-height:1.5;'>").append(body).append("</div>");
//
//        if (buttonHref != null) {
//            sb.append("<a href='").append(buttonHref)
//              .append("' class='btn btn-sm btn-primary px-3'>")
//              .append(buttonLabel).append("</a>");
//        }
//
//        sb.append("</div>");
//
//        return sb.toString();
//    }
//
//    private String uiError(String msg) {
//        return "<div class='border border-danger rounded p-3 bg-white shadow-sm'>" +
//                "<h6 class='fw-bold text-danger mb-2'>⚠ 오류</h6>" +
//                "<p class='mb-0'>" + msg + "</p></div>";
//    }
//
//    //학생 답변
//    private String getStdntAnswer(String msg, String stdntNo) {
//
//        msg = msg.replace(" ", "");
//
//        /* ------------------ 성적 ------------------ */
//        if (msg.contains("성적")) {
//
//            SbjectScreVO scoreVO = chatBotMapper.getStudentSbjScore(stdntNo);
//
//            if (scoreVO == null) return uiError("성적 정보가 조회되지 않습니다.");
//
//            int total = scoreVO.getSbjectTotpoint();
//            double avg = total / 4.0;
//
//            String body =
//                "중간시험 : <strong>" + scoreVO.getMiddleScore() + "점</strong><br>" +
//                "기말시험 : <strong>" + scoreVO.getTrmendScore() + "점</strong><br>" +
//                "과제점수 : <strong>" + scoreVO.getTaskScore() + "점</strong><br>" +
//                "출석점수 : <strong>" + scoreVO.getAtendScore() + "점</strong><br>" +
//                "<hr>" +
//                "총점 : <strong>" + total + "점</strong><br>" +
//                "평균 : <strong>" + String.format("%.2f", avg) + "점</strong>";
//
//            return uiCard("📘 성적 요약", body, null, null);
//        }
//
//        if (msg.contains("졸업")) {
//
//            String body =
//                "졸업 신청, 조건 확인은 아래 페이지에서 가능합니다.<br>" +
//                "이수학점·기준 만족 여부도 함께 확인됩니다.";
//
//            return uiCard("🎓 졸업요건 안내", body,
//                "졸업신청 이동", "/stdnt/gradu/main/All");
//        }
//
//        if (msg.contains("수강신청") || msg.contains("수강")) {
//
//            String body =
//                "수강신청은 신청 기간 내에서만 가능합니다.<br>" +
//                "현재 수강 가능 과목도 함께 조회됩니다.";
//
//            return uiCard("📚 수강신청 안내", body,
//                "수강신청 이동", "/atnlc/submint");
//        }
//        
//        if (msg.contains("등록금") || msg.contains("등록")) {
//
//            String body =
//                "등록금 고지서 조회 및 납부 기능을 제공합니다.<br>" +
//                "납부기간, 분할납부 여부도 확인 가능합니다.";
//
//            return uiCard("💰 등록금 안내", body,
//                "등록금 확인", "/payinfo/studentView/");
//        }
//
//        if (msg.contains("상담")) {
//
//            String body =
//                "지도교수 상담 또는 행정상담 예약이 가능합니다.<br>" +
//                "신청 후 승인 여부를 반드시 확인하세요.";
//
//            return uiCard("🗂 상담 예약", body,
//                "상담 예약", "/counsel/std");
//        }
//
//        if (msg.contains("강의평가") || msg.contains("평가")) {
//
//            String body =
//                "강의평가는 성적 열람 제한과 연동됩니다.<br>" +
//                "수강한 모든 과목에 대해 반드시 완료해 주세요.";
//
//            return uiCard("📝 강의평가 안내", body,
//                "강의평가 이동", "/stdnt/lecture/main/All");
//        }
//
//        if (msg.contains("증명")) {
//
//            String body =
//                "재학, 성적, 졸업 등 주요 증명서를 발급할 수 있습니다.<br>" +
//                "온라인 다운로드도 지원합니다.";
//
//            return uiCard("📄 증명서 발급", body,
//                "증명서 발급", "/cert/certDocxForm");
//        }
//
//        if (msg.contains("개설강의") || msg.contains("강의")) {
//
//            String body =
//                "이번 학기 개설된 강의 목록을 확인할 수 있습니다.<br>" +
//                "이수구분·학점·담당교수 정보도 함께 제공합니다.";
//
//            return uiCard("📘 개설강의 안내", body,
//                "개설강의 보기", "/lecture/list");
//        }
//
//        if (msg.contains("문의")) {
//
//            String body =
//                "시스템 관련 문의사항을 남길 수 있습니다.<br>" +
//                "담당부서에서 확인 후 답변드립니다.";
//
//            return uiCard("📨 문의사항 안내", body,
//                "문의 작성", "/inqry/main");
//        }
//
//        if (msg.contains("출석") || msg.contains("출결")) {
//
//            String body =
//                "과목별 출석/지각/결석 현황을 확인할 수 있습니다.";
//
//            return uiCard("📌 출석현황 안내", body,
//                "출석 조회", "/attendance/main");
//        }
//
//        return uiError("해당 요청을 이해하지 못했습니다.");
//    }
//
//    //교수 답변
//    private String getProfAnswer(String msg, String profsrNo) {
//
//        msg = msg.replace(" ", "");
//
//        if (msg.contains("강의") || msg.contains("개설강의") || msg.contains("교과")) {
//
//            List<EstblCourseVO> list = chatBotMapper.getProfessorLectureList(profsrNo);
//
//            if (list == null || list.isEmpty())
//                return uiError("담당 중인 강의가 없습니다.");
//
//            StringBuilder body = new StringBuilder();
//
//            for (EstblCourseVO lec : list) {
//                body.append("<div class='p-2 border rounded mb-2'>")
//                    .append("<strong>").append(lec.getLctreNm()).append("</strong><br>")
//                    .append("년도 ").append(lec.getEstblYear())
//                    .append(" / 학기 ").append(lec.getEstblSemstr()).append("<br>")
//                    .append("이수구분 : ").append(lec.getComplSe()).append("<br>")
//                    .append("수강인원 : ").append(lec.getAtnlcNmpr()).append("명")
//                    .append("</div>");
//            }
//
//            return uiCard("📘 담당 강의 목록", body.toString(),
//                    "강의관리 이동", "/prof/lecture/main/All");
//        }
//
//        if (msg.contains("상담")) {
//
//            List<CnsltVO> list = chatBotMapper.getProfessorCounselList(profsrNo);
//
//            if (list == null || list.isEmpty())
//                return uiCard("📞 상담 예약", "이번 주 상담 예약 학생이 없습니다.", null, null);
//
//            StringBuilder body = new StringBuilder();
//
//            for (CnsltVO c : list) {
//                body.append("<div class='p-2 border rounded mb-2'>")
//                    .append("<strong>").append(c.getStdntNm()).append("</strong><br>")
//                    .append("신청일 : ").append(c.getReqstDe()).append("<br>")
//                    .append("일자 : ").append(c.getCnsltRequstDe()).append("<br>")
//                    .append("시간 : ").append(c.getCnsltRequstHour())
//                    .append("</div>");
//            }
//
//            return uiCard("📞 상담 예약 현황", body.toString(),
//                    "상담관리 이동", "/counselprof/prof");
//        }
//
//        if (msg.contains("강의평가") || msg.contains("평가")) {
//
//            String body =
//                "강의평가 결과 및 학생 의견을 확인할 수 있습니다.<br>" +
//                "과목별 평점과 평균도 제공합니다.";
//
//            return uiCard("📝 강의평가 안내", body,
//                "강의평가 이동", "/prof/lecture/main/All");
//        }
//
//        if (msg.contains("성적입력") || msg.contains("성적")) {
//
//            String body =
//                "담당 강의의 성적 입력·수정이 가능합니다.<br>" +
//                "배점 기준과 학생별 점수 확인도 지원됩니다.";
//
//            return uiCard("📝 성적 관리", body,
//                "성적입력 이동", "/prof/grade/main/All");
//        }
//
//        return uiError("해당 요청을 이해하지 못했습니다.");
//    }
//}
package kr.ac.collage_api.chatbot.service.impl;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.chatbot.mapper.ChatBotMapper;
import kr.ac.collage_api.chatbot.service.ChatBotService;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ChatBotServiceImpl implements ChatBotService {

    @Autowired
    private ChatBotMapper chatBotMapper;

    // 반드시 AiStudio 에서 얻은 "AIzaSy..." 형태의 키를 넣으십시오.
    private static final String GEMINI_API_KEY = "AQ.Ab8RN6IQUbML4XL8-BUwVbfKtOXoMga74WjKd-ffjOrFWwJioA"; 

    @Override
    public String getAnswer(String msg, String loginId) {

        AcntVO user = chatBotMapper.getUserDt(loginId);

        if (user == null) {
            return uiError("사용자 정보를 찾을 수 없습니다.");
        }

        String acntTy = user.getAcntTy(); // 1 학생 / 2 교수

        String systemPrompt = """
                당신은 SMART_LMS 공식 챗봇입니다.

                [학생이 요청할 경우 제공 가능한 항목]
                - 성적조회 / 출석 / 강의평가 / 수강신청 / 상담예약 / 졸업요건 / 등록금 / 개설강의 / 증명서 / 문의사항

                [교수가 요청할 경우 제공 가능한 항목]
                - 담당강의 조회 / 강의평가 결과 / 상담예약 현황 / 성적입력 안내

                반드시 아래 두 가지 중 하나의 형식으로만 답하십시오.

                1) 기본 설명 문장
                2) HTML 카드 UI
                   <div class='border rounded p-3 bg-white shadow-sm'>
                     <h6 class='fw-bold mb-3'>제목</h6>
                     <div class='mb-3'>내용</div>
                     <a href='URL' class='btn btn-sm btn-primary px-3'>이동</a>
                   </div>

                HTML은 그대로 출력 가능합니다.
                """;

        String realPrompt =
                "사용자 유형: " + (acntTy.equals("1") ? "학생" : "교수") + "\n" +
                "사용자 메시지: " + msg + "\n" +
                "LMS 기준으로 정확한 도움을 주세요.\n";

        String geminiResponse = callGemini(realPrompt, systemPrompt);

        if (geminiResponse == null) {
            return uiError("Gemini 응답 오류가 발생했습니다.");
        }

        return geminiResponse;
    }


    /* ------------------------------------------------------
       GEMINI API KEY 방식 — OpenAI ChatCompletions 형식 사용
       ------------------------------------------------------ */
    private String callGemini(String userPrompt, String systemPrompt) {

        try {

            JSONObject body = new JSONObject()
                .put("model", "gemini-pro")
                .put("messages", new JSONArray()
                    .put(new JSONObject()
                        .put("role", "system")
                        .put("content", systemPrompt))
                    .put(new JSONObject()
                        .put("role", "user")
                        .put("content", userPrompt))
                );

            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(
                        "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions?key="
                        + GEMINI_API_KEY))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
                .build();

            HttpResponse<String> response =
                    HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.error("Gemini 오류: {}", response.body());
                return null;
            }

            JSONObject json = new JSONObject(response.body());

            String text =
                json.getJSONArray("choices")
                   .getJSONObject(0)
                   .getJSONObject("message")
                   .getString("content");

            return text;

        } catch (IOException | InterruptedException e) {
            log.error("Gemini 통신 오류", e);
            return null;
        }
    }


    /* ------------------ UI 템플릿 ------------------ */
    private String uiCard(String title, String body, String buttonLabel, String buttonHref) {

        StringBuilder sb = new StringBuilder();

        sb.append("<div class='border rounded p-3 bg-white shadow-sm'>")
          .append("<h6 class='fw-bold mb-3'>").append(title).append("</h6>")
          .append("<div class='mb-3' style='line-height:1.5;'>").append(body).append("</div>");

        if (buttonHref != null) {
            sb.append("<a href='").append(buttonHref)
              .append("' class='btn btn-sm btn-primary px-3'>")
              .append(buttonLabel).append("</a>");
        }

        sb.append("</div>");

        return sb.toString();
    }

    private String uiError(String msg) {
        return "<div class='border border-danger rounded p-3 bg-white shadow-sm'>" +
                "<h6 class='fw-bold text-danger mb-2'>오류</h6>" +
                "<p class='mb-0'>" + msg + "</p></div>";
    }
}
