package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.learning.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import kr.ac.collage_api.learning.mapper.LearningPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LearningPageServiceImpl {
    @Autowired
    LearningPageMapper learningPageMapper;

    @Autowired
    UploadController uploadController;

    public Map<String, Object> getLearningPage(String lecNo) {
        List<Map<String, Object>> weekInfoList = learningPageMapper.getLearningPage(lecNo);

        Map<String, Object> lectureInfo = learningPageMapper.getLectureInfo(lecNo);

        Map<String, Object> infoMap = new HashMap<>();
        infoMap.put("weekList", weekInfoList);
        infoMap.put("lecInfo", lectureInfo);


//        todo: estbl_course의 profsr_no로 교수 정보 검색하기 null 체크 구현 필 estbl이 list에 어떻게 담기는지 확인 필요
//        weekInfoList.add(learningPageMapper.getProfInfo())

        // todo: list 반환 말고 map으로 list와 교수 정보 담아서 보내야할듯
        return infoMap;
    }

    public List<TaskVO> taskList(String lecNo, String weekNo) {
        return learningPageMapper.taskList(lecNo, weekNo);
    }

    public TaskPresentnVO getSubmitTask(String taskNo, String studentNo) {
        return learningPageMapper.getSubmitTask(taskNo, studentNo);
    }

    @Transactional
    public int taskFileUpload(String taskpresentnNo, MultipartFile[] files) {
        Long fileGroupNo = uploadController.fileUpload(files);

        return learningPageMapper.taskFileUpload(taskpresentnNo, fileGroupNo);
    }
}
