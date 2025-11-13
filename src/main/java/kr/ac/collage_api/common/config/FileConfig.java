package kr.ac.collage_api.common.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class FileConfig implements WebMvcConfigurer {

	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		log.debug("addResourceHandlers 실행!");
		
//		registry.addResourceHandler("/upload/**") //이거 안됨.. 이거 안써도 업로드 폴더 안에 잘들어감
		registry.addResourceHandler("/20*/**")
				.addResourceLocations("file:///D:/upload/");
		
	}
	
}
