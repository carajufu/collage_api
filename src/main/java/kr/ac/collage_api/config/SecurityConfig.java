package kr.ac.collage_api.config;

import jakarta.servlet.DispatcherType;
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
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

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
                .requestMatchers("/css/**", "/js/**", "/img/**", "/favicon.ico");
    }

    @Bean
    BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, CustomLoginSuccessHandler customLoginSuccessHandler, CustomLogoutSuccessHandler customLogoutSuccessHandler) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .httpBasic(hbasic -> hbasic.disable())
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
                        .requestMatchers("/", "/login", "/accessError").permitAll()
                        .anyRequest().authenticated()
                )
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
