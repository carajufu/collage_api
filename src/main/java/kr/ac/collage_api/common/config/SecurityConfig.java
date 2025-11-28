package kr.ac.collage_api.common.config;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.security.service.impl.CustomLoginSuccessHandler;
import kr.ac.collage_api.security.service.impl.CustomLogoutSuccessHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
// CORS
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Arrays;

import kr.ac.collage_api.security.service.impl.UserDetailServiceImpl;


@Configuration
@EnableWebSecurity(debug = false)
@EnableMethodSecurity
public class SecurityConfig implements WebMvcConfigurer {


    @Autowired
    UserDetailServiceImpl detailServiceImpl; 
    // 사용자 계정/권한 조회 서비스 (UserDetailsService 구현)

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           CustomLoginSuccessHandler customLoginSuccessHandler,
                                           CustomLogoutSuccessHandler customLogoutSuccessHandler) throws Exception {
        HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        requestCache.setMatchingRequestParameterName("null");
        requestCache.setRequestMatcher(req -> {
            var httpReq = (HttpServletRequest) req;
            var uri = httpReq.getRequestURI();
            return !(uri.startsWith("/.well-known/"));
        });

        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .httpBasic(hbasic -> hbasic.disable())
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC, DispatcherType.ERROR).permitAll()
                        .requestMatchers("/",
                                "/index",
                                "/error",
                                "/login",
                                "/account/**",
                                "/api/account/**",
                                "/search",
                                "/admin/**",
                                "/20*/**",
                                "/info/**",
                                "/ws/**",
                                "/scholarship/**",
                                "/regist/**",
                                "/payinfo/**").permitAll()
                        .anyRequest().authenticated()
                )
                .requestCache(cache -> cache.requestCache(requestCache))
                .formLogin(formLogin -> formLogin.usernameParameter("acntId")
                        .passwordParameter("password")
                        .loginPage("/login")
                        .successHandler(customLoginSuccessHandler))
                .sessionManagement(session -> session.maximumSessions(1))
                .logout(logout -> logout.logoutUrl("/logout")
                        .logoutSuccessHandler(customLogoutSuccessHandler)
                        .invalidateHttpSession(true));

        return http.build();
    }
    
    @Bean  // Cors 전역설정, 컨트롤러 @CrossOrigin 사용해도 됨
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("HEAD", "GET", "POST", "PUT", "DELETE"));
        configuration.setAllowedHeaders(Arrays.asList("Authorization", "Cache-Control", "Content-Type"));
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    // FullCalendar 로컬 파일 전용 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/js/fullcalendar/**")
                .addResourceLocations("classpath:/static/js/fullcalendar/");
    }

    /**
     * 정적 리소스는 보안 필터 자체를 타지 않게 무시.
     * 이유: css/js/img 등은 로그인 전에도 필요.
     *
     * /static/**, /js/** 등은 DispatcherServlet 이전에 바로 서빙되므로
     * SecurityFilterChain 인가 검사와 무관하게 열어둔다.
     */
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring().requestMatchers(
                "/static/**", // 정적
                "/adminlte/**", // 테마
                "/images/**", // 이미지
                "/js/**", // 스크립트
                "/css/**", // 스타일
                "/favicon.ico", // 파비콘
                "/.well-known/**", // 표준 경로
                "/app/**", // 리액트 빌드 산출물 경로
                "/assets/**", // 리액트 정적 에셋
                "/resources/**" // 풀캘린더 로컬 사용
        );
    }

    /**
     * AuthenticationManager
     *
     * DaoAuthenticationProvider 기반.
     * - detailServiceImpl (UserDetailsService 구현) 사용
     * 		-> DB에서 acntId로 사용자 조회
     * 		-> BCrypt로 저장된 패스워드 리턴
     * - bCryptPasswordEncoder() 로 raw password vs 해시 비교
     *
     * 사용처:
     * - formLogin 시 Spring Security 내부적으로 사용
     * - TokenApiController (/api/login) 도 직접
     * AuthenticationManager.authenticate(...) 호출해 자격 검증 가능
     */
    @Bean
    public AuthenticationManager authenticationManager(BCryptPasswordEncoder encoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(detailServiceImpl);
        provider.setPasswordEncoder(encoder);
        return new ProviderManager(provider);
    }

    /**
     * BCryptPasswordEncoder
     *
     * 비밀번호 저장/검증 기준.
     * - 회원가입 시 평문 비밀번호를 BCrypt로 해싱해 DB PASSWORD 컬럼에 저장
     * - 로그인 시 사용자가 제출한 평문 비밀번호와 DB 해시를 비교
     *
     * 보안 팁
     * - 기본 strength 는 합리적 기본값. 운영 환경에서 CPU 상황에 맞춰 조정 가능
     */
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

}