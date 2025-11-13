package kr.ac.collage_api.lecture.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.ac.collage_api.common.attach.service.BeanController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletResponse;
import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/lecture")
@Slf4j
@Controller
public class LectureController {

	@Autowired
	LectureService lectureService;
	
	@Autowired
	BeanController beanController;
	
	// 개설 강의 조회
	@GetMapping("/list")
	public String list(Model model, EstblCourseVO estblCourseVO, 
					   @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
					   @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
		
		estblCourseVO.setKeyword(keyword);
		estblCourseVO.setComplSe(complSe);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.list(estblCourseVO);
		log.info("list()->estblCourseVOList : {}", estblCourseVOList);
		
		model.addAttribute("estblCourseVOList", estblCourseVOList);
		
		return "lecture/stdntLctreSubmit";
	}
	
	// 강의 세부 정보
	@GetMapping("/detail/{estbllctreCode}")
	@ResponseBody
	public Map<String,Object> detail(@PathVariable String estbllctreCode) {
		log.info("detail()->estbllctreCode : {}", estbllctreCode);
		EstblCourseVO estblCourseVO = lectureService.detail(estbllctreCode);
		log.info("detail()->estblCourseVO : {}", estblCourseVO);
		
		int result = 0;
		
		if(estblCourseVO != null) {
			result = 1;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		map.put("estblCourseVO", estblCourseVO);
		
		return map;
	}
	
	// 강의계획서 다운로드
	@GetMapping("/downloadFile")
	public void DownloadFile (@RequestParam("fileGroupNo") long fileGroupNo,
							  HttpServletResponse response) {
		try {
			
			FileDetailVO fileVO = lectureService.getFileDetail(fileGroupNo);
			log.info("DownloadFile()->fileVO : {}", fileVO);
			
			if(fileVO == null) {
				response.setContentType("text/plain; charset=UTF-8");
				response.getWriter().write("파일 정보를 찾을 수 없습니다.");
				return;
			}
			
			String uploadRoot = beanController.getUploadFolder();
			String relativePath = fileVO.getFileStreplace();
			
			String fullPath = uploadRoot + relativePath.replace("/", File.separator);
			
			File file = new File(fullPath);
			
			log.info("DownloadFile()->file : {}", file.getAbsolutePath());
			
			if(!file.exists()) {
				response.setContentType("text/plain; charset=UTF-8");
				response.getWriter().write("등록된 강의계획서가 없습니다. 경로 : " + file.getAbsolutePath());
				return;
			}
			
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileVO.getFileNm(), "UTF-8") + "\"");
			response.setHeader("Content-Transfer-Encoding", "binary");
			
			try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
				 BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream())) {
				
				byte[] buffer = new byte[1024];
				int bytesRead;
				while ((bytesRead = in.read(buffer)) != -1) {
					out.write(buffer, 0, bytesRead);
				}
				out.flush();
			}
			
		} catch(Exception e) {
			response.reset(); // 이미 설정된 헤더 초기화
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 상태 코드 설정
	        response.setContentType("text/plain; charset=UTF-8");
	        try {
	            response.getWriter().write("파일 다운로드 중 서버 오류가 발생했습니다: " + e.getMessage());
	        } catch (IOException ioException) {
	            // ignore
	        }
		}
		
	}
}
