package kr.ac.collage_api.security.service.impl;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.security.mapper.DitAccountMapper;
import kr.ac.collage_api.security.service.DitAccountService;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

/*
목적
- 계정(ACNT 테이블) 등록 및 조회 비즈니스 로직.
- 비밀번호 암호화, 권한 할당, 트랜잭션 처리까지 책임.
- 스프링 시큐리티 + JWT 구조에서 "회원 생성 시 계정/권한이 유효하게 DB에 올라가도록" 만드는 계층.

정책
1. 평문 비밀번호 절대 로깅 금지.
2. DB 저장 전 반드시 BCrypt 해시 적용.
3. insert 계정 / insert 권한은 같은 트랜잭션으로 처리(@Transactional).
4. userSave 가 단일 진입점. userSaveAuth 는 외부에서 직접 호출 안 하는 게 정상.
5. null / 빈 비밀번호 즉시 차단. 보안상 필수.

주의
- 이 서비스는 세션이나 SecurityContextHolder 를 만지지 않음.
  JWT 발급은 TokenApiController + TokenProvider 가 맡는다.
*/
@Slf4j
@Service
@Transactional(readOnly = true) // [추가] 기본 조회 트랜잭션은 읽기 전용. 쓰기는 개별 메서드에서 해제.
public class DitAccountServiceImpl implements DitAccountService {

    // [변경] 생성자 주입을 위한 final 필드(불변성 확보, 테스트 용이)
    private final DitAccountMapper ditAccountMapper;
    private final BCryptPasswordEncoder bCryptPasswordEncoder; // BCryptPasswordEncoder(전문용어(단방향 해시 알고리즘 구현체))

    // [추가] 생성자 주입(스프링이 빈을 주입). 필드 주입(@Autowired) 제거.
    public DitAccountServiceImpl(
            DitAccountMapper ditAccountMapper,
            BCryptPasswordEncoder bCryptPasswordEncoder
    ) {
        this.ditAccountMapper = ditAccountMapper;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    /**
     * 회원가입 처리.
     *
     * 흐름:
     * 1) 입력받은 AcntVO(acntId, password 등)를 검사한다.
     * 2) 비밀번호 평문을 BCrypt 해시로 치환한다.
     * 3) 계정 정보를 DIT_ACCOUNT 에 insert 한다.
     * 4) 권한 정보를 AUTHOR 등에 insert 한다.
     * 5) 총 처리 건수를 반환한다. (계정 insert + 권한 insert)
     *
     * 트랜잭션:
     * - 계정 insert 후 권한 insert 가 실패하면 롤백되어야 하므로 @Transactional.
     *
     * 보안:
     * - 평문 비밀번호는 로그에 남기지 않는다.
     * - 해시 이후 값만 객체에 세팅한다.
     */
    @Transactional // [유지] 쓰기 트랜잭션. 클래스 기본 readOnly=true를 여기서 해제.
    @Override
    public int userSave(AcntVO acntVO) {
        if (acntVO == null) {
            throw new IllegalArgumentException("acntVO is null");
        }
        if (acntVO.getAcntId() == null || acntVO.getAcntId().isBlank()) {
            throw new IllegalArgumentException("acntId is required");
        }
        if (acntVO.getPassword() == null || acntVO.getPassword().isBlank()) {
            // 비밀번호 없이 가입 시도는 차단. 보안상 필수.
            throw new IllegalArgumentException("password is required");
        }

        // 디버그용 로깅. 민감정보(password)는 절대 출력 금지.
        log.debug("[DitAccountService:userSave] signup request acntId={}", acntVO.getAcntId());

        // 1. 비밀번호 해시 (평문 -> BCrypt 해시)
        final String rawPassword = acntVO.getPassword(); // 평문(로컬 변수, 로그·전달 금지)
        final String hashedPassword = this.bCryptPasswordEncoder.encode(rawPassword); // 해시
        acntVO.setPassword(hashedPassword); // 객체에 해시만 보관

        // 2. 계정 정보 저장 (DIT_ACCOUNT 등)
        final int result = this.ditAccountMapper.userSave(acntVO);
        log.debug("[DitAccountService:userSave] userSave insertCount={}, acntId={}", result, acntVO.getAcntId());

        // 3. 권한 정보 저장 (AUTHOR 등)
        final int authResult = this.ditAccountMapper.userSaveAuth(acntVO);
        log.debug("[DitAccountService:userSave] userSaveAuth insertCount={}, acntId={}", authResult, acntVO.getAcntId());

        // 4. 총 처리 건수 리턴 (계정 + 권한)
        final int total = result + authResult;
        log.debug("[DitAccountService:userSave] totalInsertCount={}, acntId={}", total, acntVO.getAcntId());

        return total;
    }

    /**
     * 계정 상세 조회.
     *
     * 역할:
     * - 로그인 후 뷰에서 사용자 정보 표시할 때 사용.
     * - SecurityContextHolder 의 principal(username=acntId) 로 다시 DB 조회할 때 사용.
     *
     * 반환:
     * - AcntVO (비밀번호 해시 포함 주의)
     * - authorList 가 채워져 있으면 권한 정보까지 포함.
     *
     * 로깅:
     * - 비밀번호는 로그 내보내지 않음.
     */
    @Override
    public AcntVO findById(String acntId) {
        if (acntId == null || acntId.isBlank()) {
            throw new IllegalArgumentException("acntId is required");
        }

        AcntVO vo = this.ditAccountMapper.findById(acntId);

        if (vo == null) {
            log.debug("[DitAccountService:findById] acntId={} not found", acntId);
            return null;
        }

        log.debug("[DitAccountService:findById] acntId={} loaded, authorCount={}",
                acntId, (vo.getAuthorVOList() != null ? vo.getAuthorVOList().size() : 0));

        return vo;
    }

    /**
     * 권한만 단독으로 저장하는 경로.
     * 정상 시나리오에서는 외부에서 직접 호출하지 않는 것이 맞다.
     * userSave() 안에서 이미 userSaveAuth()를 호출하고 있기 때문.
     *
     * 통일성을 위해 mapper 호출하도록 해둠.
     * 외부에서 호출할 경우에도 동일한 동작(권한 insert)을 수행.
     */
    @Transactional // [추가] 쓰기 동작이므로 트랜잭션 필요
    @Override
    public int userSaveAuth(AcntVO acntVO) {
        if (acntVO == null || acntVO.getAcntId() == null || acntVO.getAcntId().isBlank()) {
            throw new IllegalArgumentException("acntVO/acntId is required for userSaveAuth");
        }

        int result = this.ditAccountMapper.userSaveAuth(acntVO);
        log.debug("[DitAccountService:userSaveAuth] acntId={}, insertCount={}", acntVO.getAcntId(), result);

        return result;
    }
}
