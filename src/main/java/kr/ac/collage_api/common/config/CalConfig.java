package kr.ac.collage_api.common.config;

import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

public class CalConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/libs/fullcalendar/**")
                .addResourceLocations("classpath:/assets/libs//fullcalendar/");
    }
}
