package kr.ac.collage_api.campus.service.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.campus.mapper.CampusMapMapper;
import kr.ac.collage_api.campus.service.CampusMapService;

@Service
public class CampusMapServiceImpl implements CampusMapService {

	@Autowired
    private CampusMapMapper mapper;

    @Override
    public List<String> getDeptList(String univCode) {
        return mapper.selectDeptListByUnivCode(univCode);
    }

}
