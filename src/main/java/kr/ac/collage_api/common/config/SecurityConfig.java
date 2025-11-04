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

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    @Autowired
    UserDetailsService userDetailsService;

    @Bean
    public WebSecurityCustomizer configure() {
        return web -> web.debug(false)
                .ignoring()
                .requestMatchers("/css/**", "/js/**", "favicon.ico");
    }

    @Bean
    BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

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
                .httpBasic(hbasic -> hbasic.disable())
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
                        .requestMatchers("/", "/login", "/accessError", "/.well-known/**", "/admin/**").permitAll()
                        .anyRequest().authenticated()
                )
                .requestCache(cache -> cache.requestCache(requestCache))
                .formLogin(formLogin -> formLogin.loginPage("/login")
                        .successHandler(customLoginSuccessHandler))
                .sessionManagement(session -> session.maximumSessions(1))
                .logout(logout -> logout.logoutUrl("/logout")
                        .logoutSuccessHandler(customLogoutSuccessHandler)
                        .invalidateHttpSession(true));

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http,
                                                       BCryptPasswordEncoder bCryptPasswordEncoder,
                                                       UserDetailsService userDetailsService
                                                       ) throws Exception {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(bCryptPasswordEncoder);

        return new ProviderManager(authProvider);
    }
}
