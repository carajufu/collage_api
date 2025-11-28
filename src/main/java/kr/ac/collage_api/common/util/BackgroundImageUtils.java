package kr.ac.collage_api.common.util;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourcePatternResolver;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public final class BackgroundImageUtils {

    private BackgroundImageUtils() {
        // 인스턴스화 금지
    }

    /** 
     * 목적 : 메인페이지 백그라운드 이미지 리스트 리턴
     * classpath:/static/images/background/ 하위 이미지 파일명 목록 반환
     *
     * @param resourceResolver ResourcePatternResolver (컨트롤러에서 주입받은 것 전달)
     * @return 이미지 파일명 목록
     */
    public static List<String> resolveBackgroundImages(ResourcePatternResolver resourceResolver)
            throws IOException {

        Resource[] resources =
                resourceResolver.getResources("classpath:/static/img/background/*.*");

        return Arrays.stream(resources)
                .map(Resource::getFilename)
                .filter(Objects::nonNull)
                .filter(name -> name.matches("(?i).+\\.(png|jpe?g|gif|webp)$"))
                .toList();
    }
}
