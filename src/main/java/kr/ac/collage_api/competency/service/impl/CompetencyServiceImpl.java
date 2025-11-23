package kr.ac.collage_api.competency.service.impl;

import java.nio.file.Files;
import java.nio.file.Path;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.competency.mapper.CompetencyMapper;
import kr.ac.collage_api.competency.service.CompetencyService;
import kr.ac.collage_api.competency.vo.CompetencyVO;
import lombok.extern.slf4j.Slf4j;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Slf4j
@Service
public class CompetencyServiceImpl implements CompetencyService {

    @Autowired
    private CompetencyMapper competencyMapper;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Override
    public CompetencyVO getFormData(String stdntNo) {
        return competencyMapper.getFormData(stdntNo);
    }

    @Override
    public int insertFormData(CompetencyVO vo) {
        return competencyMapper.insertFormData(vo);
    }

    @Override
    public int updateFormData(CompetencyVO vo) {
        return competencyMapper.updateFormData(vo);
    }

    @Override
    public void saveForm(CompetencyVO form) {

    	CompetencyVO exists = competencyMapper.getFormData(form.getStdntNo());

        if (exists == null) {
            int nextId = competencyMapper.getNextFormNo();
            form.setFormId(nextId);

            competencyMapper.insertFormData(form);

        } else {
            form.setFormId(exists.getFormId());
            competencyMapper.updateFormData(form);
        }
    }

    @Override
    public String generateIntro(CompetencyVO form) {

        try {
            String prompt = buildPrompt(form);
            String examples = loadExampleEssays();
            String result = callGemini(prompt, examples);

            return result;

        } catch (Exception e) {
            log.error("자기소개서 생성 오류", e);
            return "자기소개서 생성 중 오류가 발생했습니다.";
        }
    }

    private String callGemini(String prompt, String examples) throws Exception {

        JSONObject body = new JSONObject()
                .put("contents", new JSONArray()
                        .put(new JSONObject()
                                .put("parts", new JSONArray()
                                        .put(new JSONObject().put("text",
                                                "아래는 참고 자소서 예시입니다:\n" +
                                                examples +
                                                "\n\n### 이제 학생 데이터를 바탕으로 새로운 자소서를 생성하세요 ###\n" +
                                                prompt
                                        ))
                                )
                        )
                );

        String endpoint =
                "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(endpoint))
                .header("Content-Type", "application/json")
                .header("x-goog-api-key", geminiApiKey)
                .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
                .build();

        HttpResponse<String> response =
                HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            log.error("Gemini API Error: {}", response.body());
            return "AI 응답 생성 오류가 발생했습니다.";
        }

        JSONObject json = new JSONObject(response.body());

        return json
                .getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text");
    }

    private String loadExampleEssays() {

        StringBuilder sb = new StringBuilder();
        try {
            Path folder = Path.of("src/main/resources/static/template");

            Files.list(folder).forEach(path -> {
                try {
                    String text = Files.readString(path);
                    sb.append("=== 예시 파일: ").append(path.getFileName()).append(" ===\n");
                    sb.append(text).append("\n\n");
                } catch (Exception ignore) {}
            });

        } catch (Exception e) {
            log.error("예시 자소서 로딩 실패", e);
        }

        return sb.toString();
    }

    private String buildPrompt(CompetencyVO f) {

    	return """
    	           아래는 학생 정보를 기반으로 작성해야 하는 자기소개서 지침입니다.
    	           예시 자소서는 참고용이며, 문장을 복사하거나 변형하지 말고
    	           학생의 이력에 맞춘 새로운 글을 작성하십시오.

    	           [작성 목적]
    	           - 기업용 자기소개서 형식으로 작성
    	             (지원동기 → 경험 및 역할 → 역량 및 강점 → 포부·마무리)
    	           - 직무와의 연관성을 가장 중요하게 반영
    	           - 문장은 자연스럽고 정중한 한국어(존댓말) 사용
    	           - 전체 분량은 700~1000자

    	           [학생 정보]
    	           - 최종학력: %s
    	           - 군필 여부: %s
    	           - 희망 직무: %s
    	           - 자격증: %s
    	           - 교육 이력: %s
    	           - 주요 프로젝트: %s
    	           - 성격 / 장단점: %s

    	           [작성 시 필수 준수사항]
    	           - 예시 자소서의 문체는 참고하되, 내용은 완전히 새로 구성
    	           - 단락은 3~4개의 자연스러운 문단으로 구성
    	           - 경험·프로젝트는 직무와의 연결성을 중심으로 설명
    	           - 성격(장단점)은 실제 직무에 도움이 되는 방향으로 정리
    	           - 과장된 표현·모호한 표현을 피하고 구체적인 문장을 사용
    	           """.formatted(
    	            nullToBlank(f.getLastAcdmcr()),
    	            nullToBlank(f.getMiltrAt()),
    	            nullToBlank(f.getDesireJob()),
    	            nullToBlank(f.getCrqfc()),
    	            nullToBlank(f.getEdcHistory()),
    	            nullToBlank(f.getMainProject()),
    	            nullToBlank(f.getCharacter())
    	    );
    }

    private String nullToBlank(String s) {
        return s == null ? "" : s;
    }
}
