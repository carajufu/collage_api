package kr.ac.collage_api.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.extern.slf4j.Slf4j;

//설정 파일임을 표시
@Slf4j
@Configuration
public class FileConfig implements WebMvcConfigurer {

	/*
	 * 웹 주소와 파일의 위치 매핑
	 * 주소줄에 이렇게 쓰면 /upload/2024/11/12/개똥이.jpg
	 * D:/upload/2024/11/12/개똥이.jpg
	 */

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		log.debug("addResourceHandlers 실행!");
		registry.addResourceHandler("/upload/**") // 웹 접근 경로
				.addResourceLocations("file://D:/upload/"); // 서버내 실제 경로
	}

}
