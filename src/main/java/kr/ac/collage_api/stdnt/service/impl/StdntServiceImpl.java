package kr.ac.collage_api.stdnt.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.stdnt.mapper.StdntMapper;
import kr.ac.collage_api.stdnt.service.StdntService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.SemstrScreVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class StdntServiceImpl implements StdntService {

    @Autowired
    private StdntMapper stdntMapper;

    @Override
    public StdntVO getStdntInfo(String stdntNo) {
        return stdntMapper.selectStdntInfo(stdntNo);
    }

    @Override
    public StdntVO getStdntInfoByName(String stdntNm) {
        return stdntMapper.selectStdntInfoByName(stdntNm);
    }

    @Override
    public AcntVO getAcntInfo(String acntId) {
        return stdntMapper.getAcntInfo(acntId);
    }

    @Override
    public List<SemstrScreVO> getSemstrList(String stdntNo) {
        return stdntMapper.getSemstrList(stdntNo);
    }

    @Override
    public Map<String, String> getYearSemBySemstrInnb(Integer semstrScreInnb) {
        if (semstrScreInnb == null) return null;
        return stdntMapper.getYearSemBySemstrInnb(semstrScreInnb);
    }

    @Override
    public List<EstblCourseVO> getCourseList(String stdntNo, String year, String semstr) {
        return stdntMapper.getCourseList(stdntNo, year, semstr);
    }

    @Override
    public int getTotalAcqsPnt(String stdntNo) {
        Integer v = stdntMapper.getTotalAcqsPnt(stdntNo);
        return v == null ? 0 : v.intValue();
    }

    @Override
    public List<Map<String, Object>> getPntByComplSe(String stdntNo, String year, String semstr) {
        return stdntMapper.getPntByComplSe(stdntNo, year, semstr);
    }

    @Override
    public List<Map<String, Object>> getAttendanceSummary(String stdntNo) {
        return stdntMapper.getAttendanceSummary(stdntNo);
    }
}
