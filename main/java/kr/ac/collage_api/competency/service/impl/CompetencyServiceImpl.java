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

@Service
public class CompetencyServiceImpl implements CompetencyService {

    @Autowired
    private CompetencyMapper competencyMapper;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    // 기본 정보 조회
    @Override
    public CompetencyVO getFormData(String stdntNo) {
        return competencyMapper.getFormData(stdntNo);
    }

    // 기본 정보
    @Override
    public int insertFormData(CompetencyVO vo) {
        return competencyMapper.insertFormData(vo);
    }

    // 기본 정보
    @Override
    public int updateFormData(CompetencyVO vo) {
        return competencyMapper.updateFormData(vo);
    }

    // 내 이력 전체 조회
    @Override
    public List<CompetencyVO> getAllByStdntNo(String stdntNo) {
        return competencyMapper.getAllByStdntNo(stdntNo);
    }
    
    @Override
    public void deleteOneManageCn(String stdntNo, int formId) {
        competencyMapper.deleteManageCnOne(stdntNo, formId);
    }


    // 기본 폼 저장
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

    // 자소서 버전 전체 삭제
    @Override
    public void deleteManageCn(String stdntNo) {
        competencyMapper.deleteManageCnAll(stdntNo);
    }

    // 저장된 전체 자소서 리스트
    @Override
    public List<CompetencyVO> getManageCnList(String stdntNo) {
        return competencyMapper.getManageCnList(stdntNo);
    }

    // AI 자기소개서 생성
    @Override
    public String generateIntro(CompetencyVO form) {

        try {
            String prompt = buildPrompt(form);
            String examples = loadExampleEssays();
            return callGemini(prompt, examples);

        } catch (Exception e) {
            log.error("자기소개서 생성 오류", e);
            return "자기소개서 생성 중 오류가 발생했습니다.";
        }
    }

    // Gemini API 호출
    private String callGemini(String prompt, String examples) throws Exception {

        JSONObject body = new JSONObject()
                .put("contents", new JSONArray()
                        .put(new JSONObject()
                                .put("parts", new JSONArray()
                                        .put(new JSONObject().put("text",
                                                "아래는 참고 자소서 예시입니다:\n" +
                                                        examples +
                                                        "\n\n### 학생 데이터를 기반으로 새로운 자소서를 생성하세요 ###\n" +
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

    // 예시 자소서 불러오기
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

    // 프롬프트 생성
    private String buildPrompt(CompetencyVO f) {

        return """
               아래는 학생 정보를 기반으로 작성해야 하는 자기소개서 지침입니다.

               [학생 정보]
               - 최종학력: %s
               - 군필 여부: %s
               - 희망 직무: %s
               - 자격증: %s
               - 교육 이력: %s
               - 주요 프로젝트: %s
               - 성격 / 장단점: %s
               
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

    // AI 자소서 버전 INSERT (최신 이력 기반으로 새 행 추가)
    @Override
    public void insertManageCn(String stdntNo, String resultIntro) {

        CompetencyVO base = competencyMapper.getFormData(stdntNo);
        int nextId = competencyMapper.getNextFormNo();

        CompetencyVO vo = new CompetencyVO();
        vo.setFormId(nextId);
        vo.setStdntNo(stdntNo);

        if (base != null) {
            vo.setLastAcdmcr(base.getLastAcdmcr());
            vo.setMiltrAt(base.getMiltrAt());
            vo.setDesireJob(base.getDesireJob());
            vo.setCrqfc(base.getCrqfc());
            vo.setEdcHistory(base.getEdcHistory());
            vo.setMainProject(base.getMainProject());
            vo.setCharacter(base.getCharacter());
        }

        vo.setManageCn(resultIntro);
        competencyMapper.insertManageCn(vo);
    }

    // (사용 시) saveManageCn 구현도 유지할 수 있음
    @Override
    public void saveManageCn(CompetencyVO vo) {

        CompetencyVO base = competencyMapper.getFormData(vo.getStdntNo());
        int nextId = competencyMapper.getNextFormNo();

        CompetencyVO insertVo = new CompetencyVO();
        insertVo.setFormId(nextId);
        insertVo.setStdntNo(vo.getStdntNo());

        if (base != null) {
            insertVo.setLastAcdmcr(base.getLastAcdmcr());
            insertVo.setMiltrAt(base.getMiltrAt());
            insertVo.setDesireJob(base.getDesireJob());
            insertVo.setCrqfc(base.getCrqfc());
            insertVo.setEdcHistory(base.getEdcHistory());
            insertVo.setMainProject(base.getMainProject());
            insertVo.setCharacter(base.getCharacter());
        }

        insertVo.setManageCn(vo.getManageCn());
        competencyMapper.insertManageCn(insertVo);
    }
}
