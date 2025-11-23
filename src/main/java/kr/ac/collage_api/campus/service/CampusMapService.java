package kr.ac.collage_api.campus.service;

import java.util.List;

import org.springframework.stereotype.Service;

@Service
public interface CampusMapService {

	public List<String> getDeptList(String univCode);
}
