package kr.ac.collage_api.competency.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.competency.mapper.CompetencyMapper;
import kr.ac.collage_api.competency.service.CompetencyService;
import kr.ac.collage_api.competency.vo.CompetencyVO;

@Service
public class CompetencyServiceImpl implements CompetencyService {

    @Autowired
    private CompetencyMapper comptencymapper;

    @Override
    public void createAndSaveSelfIntro(CompetencyVO vo) {
        StringBuilder sb = new StringBuilder();

        // 1. 도입부: 이름, 나이, 직무 활용
        sb.append("### [준비된 인재, ").append(vo.getName()).append("입니다]\n\n");
        sb.append("안녕하십니까. ").append(vo.getTargetJob()).append(" 직무에 지원한 ").append(vo.getAge()).append("세 ");
        sb.append(vo.getName()).append("입니다. ");
        sb.append("저는 목표를 향해 꾸준히 정진하며, 조직에 긍정적인 에너지를 더할 준비가 되어 있습니다.\n\n");

        // 2. 성장과정
        sb.append("#### [성장과정: 가치관의 형성]\n");
        sb.append("저는 '").append(vo.getGrowthProcess()).append("'이라는 가치관을 바탕으로 성장했습니다. ");
        sb.append("어떠한 상황에서도 배움을 멈추지 않고, 주어진 책임에 최선을 다하는 태도를 길러왔습니다.\n\n");

        // 3. 성격의 장점
        sb.append("#### [성격의 장점: ").append(vo.getStrength()).append("]\n");
        sb.append("저의 가장 큰 강점은 ").append(vo.getStrength()).append("입니다. ");
        sb.append("이러한 성격은 주변 동료들과 원활하게 소통하고 협업하는 데 큰 도움이 되었습니다. ");
        sb.append("입사 후에도 팀워크를 강화하는 데 기여하겠습니다.\n\n");

        // 4. 경력 사항 (입력 여부에 따른 분기 처리)
        if (vo.getCareer() != null && !vo.getCareer().trim().isEmpty()) {
            sb.append("#### [실무 경험: 현장에서 배운 노하우]\n");
            sb.append("과거 ").append(vo.getCareer()).append(" 등의 경험을 통해 실무 감각을 익혔습니다. ");
            sb.append("이 과정에서 맡은 바 임무를 완수하며 성과를 냈고, 현장에서 발생하는 돌발 상황에 대처하는 유연함을 길렀습니다.\n\n");
        } else {
            sb.append("#### [직무 준비: 탄탄한 기초]\n");
            sb.append("다양한 프로젝트와 학습을 통해 직무에 필요한 기초 역량을 착실히 다져왔습니다. ");
            sb.append("빠른 습득력으로 실무에 즉시 적응하겠습니다.\n\n");
        }

        // 5. 자격증 (입력 여부에 따른 분기 처리)
        if (vo.getCertificate() != null && !vo.getCertificate().trim().isEmpty()) {
            sb.append("#### [전문성 강화: 끊임없는 자기계발]\n");
            sb.append("직무 전문성을 높이기 위해 ").append(vo.getCertificate()).append(" 등을 취득하였습니다. ");
            sb.append("이러한 노력은 ").append(vo.getTargetJob()).append(" 업무를 수행하는 데 있어 전문적인 지식 기반이 될 것입니다.\n\n");
        }

        // 6. 지원동기 및 포부
        sb.append("#### [지원동기 및 포부]\n");
        sb.append(vo.getMotivation()).append(" 때문에 귀사에 지원하게 되었습니다. ");
        sb.append(vo.getName()).append("의 열정과 역량이 귀사의 비전 달성에 기여할 수 있도록 최선을 다하겠습니다.");

        // 결과 세팅 및 저장
        vo.setFinalResult(sb.toString());
        comptencymapper.insertSelfIntro(vo);
    }

    @Override
    public CompetencyVO getSelfIntroDetail(int introNo) {
        return comptencymapper.selectSelfIntro(introNo);
    }

    @Override
    public List<CompetencyVO> getSelfIntroList(String stdntNo) {
        return comptencymapper.selectSelfIntroList(stdntNo);
    }
}