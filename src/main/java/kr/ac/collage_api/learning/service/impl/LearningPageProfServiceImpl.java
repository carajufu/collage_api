package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.learning.mapper.LearningPageProfMapper;
import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LearningPageProfServiceImpl {
    @Autowired
    LearningPageProfMapper learningPageProfMapper;

    public List<AtendAbsncVO> getAttendByLecture(String estbllctreCode) {
        return learningPageProfMapper.getAttendByLecture(estbllctreCode);
    }

}
