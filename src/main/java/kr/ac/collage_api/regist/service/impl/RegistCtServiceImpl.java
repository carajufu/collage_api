package kr.ac.collage_api.regist.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.regist.mapper.PayInfoMapper;
import kr.ac.collage_api.regist.mapper.RegistCtMapper;
import kr.ac.collage_api.regist.service.RegistCtService;
import kr.ac.collage_api.vo.PayInfoVO;
import kr.ac.collage_api.vo.RegistCtVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class RegistCtServiceImpl implements RegistCtService {

    @Autowired
    private RegistCtMapper registCtMapper;

    @Autowired
    private PayInfoMapper payInfoMapper;

    // 등록금 고지 등록 + PAY_INFO 자동 생성
    @Transactional
    @Override
    public int insertRegist(RegistCtVO registCtVO) {
        // 중복 방지 체크
        int exists = registCtMapper.checkDuplicateRegist(registCtVO);
        if (exists > 0) {
            log.warn("⚠️ 이미 동일한 등록금 고지 존재: {}", registCtVO);
            return 0;
        }

        // REGIST_CT 등록
        int result = registCtMapper.insertRegist(registCtVO);

        // 성공 시 PAY_INFO 자동 생성
        if (result > 0) {
            log.info("✅ REGIST_CT 등록 완료 -> PAY_INFO 자동 생성 시작");

            // 해당 학과·학년의 재학생 목록 조회
            List<StdntVO> stdntList = registCtMapper.selectStudentsByDeptAndGrade(registCtVO.getSubjctCode(),
                    registCtVO.getRqestGrade());

            // 각 학생별 PAY_INFO 생성
            for (StdntVO stdnt : stdntList) {
                PayInfoVO payInfo = new PayInfoVO();
                payInfo.setStdntNo(stdnt.getStdntNo());
                payInfo.setRegistCtNo(registCtVO.getRegistCtNo());
                payInfo.setPayGld(registCtVO.getRqestGld());
                payInfo.setPaySttus("미납");

                payInfoMapper.insertPayInfo(payInfo);
            }

            log.info("💳 PAY_INFO 자동 등록 완료 ({}명)", stdntList.size());
        }

        return result;
    }

    // 등록금 고지 목록 조회
    @Override
    public List<RegistCtVO> selectRegistList() {
        return registCtMapper.selectRegistList();
    }

    // 중복 등록 확인
    @Override
    public int checkDuplicateRegist(RegistCtVO registCtVO) {
        return registCtMapper.checkDuplicateRegist(registCtVO);
    }

    @Override
    public List<Map<String, Object>> selectUnivList() {
        log.info("🎓 단과대 목록 조회");
        return registCtMapper.selectUnivList();
    }

    @Override
    public List<Map<String, Object>> selectSubjectsByUniv(String univCode) {
        log.info("🏫 {} 단과대의 학과 목록 조회", univCode);
        return registCtMapper.selectSubjectsByUniv(univCode);
    }

    @Override
    @Transactional
    public int autoGenerate(String rqestYear, String rqestSemstr) {
        log.info("⚙️ 자동 납부 정보 생성 실행: {}년도 {} 기준", rqestYear, rqestSemstr);

        // 해당 년도·학기의 등록금 고지 내역 가져오기
        List<RegistCtVO> registList = registCtMapper.selectRegistList();

        int totalInserted = 0;

        for (RegistCtVO regist : registList) {
            if (regist.getRqestYear().equals(rqestYear) && regist.getRqestSemstr().equals(rqestSemstr)) {

                // 해당 학과·학년의 재학생 조회
                List<StdntVO> stdntList = registCtMapper.selectStudentsByDeptAndGrade(regist.getSubjctCode(),
                        regist.getRqestGrade());

                // 각 학생별 PAY_INFO 자동 생성
                for (StdntVO stdnt : stdntList) {
                    PayInfoVO payInfo = new PayInfoVO();
                    payInfo.setStdntNo(stdnt.getStdntNo());
                    payInfo.setRegistCtNo(regist.getRegistCtNo());
                    payInfo.setPayGld(regist.getRqestGld());
                    payInfo.setPaySttus("미납");

                    payInfoMapper.insertPayInfo(payInfo);
                    totalInserted++;
                }
            }
        }

        log.info("💳 PAY_INFO 자동 생성 완료 (총 {}건)", totalInserted);
        return totalInserted;
    }

    @Override
    public List<Map<String, Object>> selectUnissuedSubjects(Map<String, Object> params) {
        return registCtMapper.selectUnissuedSubjects(params);
    }

    @Override
    public int updateRegistCt(RegistCtVO vo) {

        // 등록금 테이블 업데이트
        registCtMapper.updateRegistCt(vo);

        // PayInfo는 금액/만료일만 수정
        payInfoMapper.updateByRegistCtNo(vo);

        return 1;
    }

    @Override
    public void deleteRegistCt(int registCtNo) {

        // 1) 해당 등록금과 연결된 PAY_INFO 먼저 삭제
        payInfoMapper.deleteByRegistCtNo(registCtNo);

        // 2) 그 후 등록금 REGIST_CT 삭제
        registCtMapper.deleteRegistCt(registCtNo);
    }
}