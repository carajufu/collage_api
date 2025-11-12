package kr.ac.collage_api.service.impl;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.mapper.DitAccountMapper;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

/*
목적
- 스프링 시큐리티가 사용자 계정 정보를 로드할 때 호출되는 진입점.
- SecurityConfig → AuthenticationManager → DaoAuthenticationProvider → UserDetailsService.loadUserByUsername 순으로 호출됨.
- 여기서 DB의 계정 정보를 읽고, 스프링 시큐리티가 이해할 수 있는 형태(CustomUser)로 변환해서 돌려줌.

역할
1) 전달받은 acntId로 DIT_ACCOUNT(+AUTHOR 리스트 포함)를 조회.
2) 조회 결과를 CustomUser로 감싼다.
   - CustomUser은 org.springframework.security.core.userdetails.User를 상속한 Principal 객체.
   - SecurityContextHolder에 Authentication으로 저장될 principal이 CustomUser가 된다.
3) 계정이 없으면 UsernameNotFoundException을 던진다.
   - 스프링 시큐리티는 이 예외를 인증 실패로 처리한다.

보안 정책
- 비밀번호(해시 포함)와 토큰은 로그에 남기지 않는다.
- 계정 ID(acntId) 정도만 info로 남기고 나머지는 debug로 제한한다.
*/
@Slf4j
@Service
@Transactional(readOnly = true) // [추가] 조회 전용 트랜잭션(읽기 일관성, 성능 최적화)
public class UserDetailServiceImpl implements UserDetailsService {

    // [변경] 생성자 주입(불변성 확보, NPE/순환참조 방지, 테스트 용이)
    private final DitAccountMapper ditAccountMapper;

    public UserDetailServiceImpl(DitAccountMapper ditAccountMapper) { // [추가]
        this.ditAccountMapper = ditAccountMapper;
    }

    /*
    loadUserByUsername
    - Spring Security가 "username" 파라미터로 전달한 값을 acntId로 보고 호출.
    - 로그인 시도 시 매번 실행된다.

    흐름
    1) DB에서 계정 조회 (acntId 기준)
    2) null이면 UsernameNotFoundException 던짐 → 인증 실패 처리
    3) 계정이 있으면 CustomUser로 감싸서 반환
       - CustomUser는 내부적으로 username(=acntId), password(해시), authorities(ROLE_...)까지 포함
       - 이후 PasswordEncoder 를 통해 평문 패스워드와 해시 비교가 진행됨

    주의
    - AcntVO 안에는 authorList(권한 목록)가 포함돼 있어야 한다.
      없으면 CustomUser 생성 시 권한이 빈 컬렉션이 되어 ROLE 체크 시 인가가 실패할 수 있다.
    */
    @Override
    public UserDetails loadUserByUsername(String acntId) throws UsernameNotFoundException {
        // [추가] 입력 검증: 공백/널인 경우도 동일하게 UsernameNotFoundException 처리(정보 노출 방지)
        if (acntId == null || acntId.isBlank()) {
            log.debug("[UserDetailServiceImpl:loadUserByUsername] blank acntId");
            throw new UsernameNotFoundException("Account not found");
        }

        // [변경] 시도 로그는 DEBUG로 하향(PII 소음 최소화)
        log.debug("[UserDetailServiceImpl:loadUserByUsername] login attempt acntId={}", acntId);

        // 1) 계정 조회(+권한 목록 매핑 필요)
        AcntVO account = this.ditAccountMapper.findById(acntId);

        if (account == null) {
            // [유지] 표준 예외로 통일해 타이밍/오류 메시지 차이를 줄임
            log.info("[UserDetailServiceImpl:loadUserByUsername] account not found acntId={}", acntId);
            throw new UsernameNotFoundException("Account not found");
        }

        // 디버그 레벨로 상세 정보(권한 수 등)만 기록. 패스워드는 기록하지 않음.
        log.debug("[UserDetailServiceImpl:loadUserByUsername] account loaded acntId={}, authorCount={}",
                account.getAcntId(),
                (account.getAuthorList() != null ? account.getAuthorList().size() : 0)
        );

        /*
        2) CustomUser 생성
        - CustomUser는 스프링 시큐리티 User를 상속하고 있음.
        - 내부적으로 다음 정보를 세팅:
          username  = account.getAcntId()
          password  = account.getPassword() (BCrypt 해시여야 함)
          authorities = account.getAuthorList()를 ROLE_... 로 매핑한 Set<GrantedAuthority>
        - 반환된 CustomUser는 AuthenticationManager 흐름에서 Principal로 사용된다.
        */
        CustomUser principal = new CustomUser(account);

        // [변경] 성공 로그는 DEBUG로(운영 소음/PII 최소화)
        log.debug("[UserDetailServiceImpl:loadUserByUsername] principal ready acntId={}", account.getAcntId());

        // 3) 스프링 시큐리티로 반환
        return principal;
    }
}
