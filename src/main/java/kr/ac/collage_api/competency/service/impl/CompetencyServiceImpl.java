package kr.ac.collage_api.competency.service.impl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

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

    /** insert/update 통합 */
    @Override
    public void saveForm(CompetencyVO form) {
        CompetencyVO exists = competencyMapper.getFormData(form.getStdntNo());
        if (exists == null) {
            competencyMapper.insertFormData(form);
        } else {
            competencyMapper.updateFormData(form);
        }
    }


    @Override
    public String generateIntro(CompetencyVO form) {

        try {
            // 1) 프롬프트 구성
            String prompt = buildPrompt(form);

            // 2) 자소서 예시 파일 4~6개 로딩
            String examples = loadExampleEssays();

            // 3) Gemini 호출
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
            // 예시파일 폴더 위치
            Path folder = Path.of("src/main/resources/essays");

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
               아래의 학생 정보를 기반으로 자기소개서를 작성하세요.
               문장은 자연스럽고 한국어 존댓말을 사용하며,
               기업 자기소개서 형식(지원동기 → 경험 → 강점 → 마무리)을 따르십시오.

               [학생 정보]
               - 최종학력: %s
               - 군필여부: %s
               - 희망직무: %s
               - 자격증: %s
               - 교육이력: %s
               - 주요 프로젝트: %s
               - 성격/장단점: %s

               [추가 요구사항]
               - 700~1000자
               - 내용은 직무와 연관성 있게
               - 문단 구분은 자연스럽게
               - 예시 자소서의 문체는 참고만 하고 복사하지 말고 새로운 글을 작성
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
