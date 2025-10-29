package kr.ac.collage_api.common.config;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Component;

//파일업로드를 위한 파일 -저장경로 설정
@Component
public class BeanController {
	
	private String uploadFolder = "D:\\upload";
	
	private String folder ="";
	
	public String getUploadFolder() {
		return uploadFolder;
	}
	
	public String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
		
	}
			
	
	
	
}
