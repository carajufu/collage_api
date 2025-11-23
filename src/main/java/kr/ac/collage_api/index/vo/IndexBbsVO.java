package kr.ac.collage_api.index.vo;

import lombok.Data;
import java.util.Date;

/**
 * INDEX 메인 페이지 공통 게시판 요약 데이터 VO(Value Object, 화면 전달용 값 객체)
 *
 * 코드 의도
 * - 메인(index) 페이지에 노출할 공지/행사/학술 게시글 목록 한 줄(row)를 표현하는 전용 DTO 역할.
 * - BBS, BBS_CTT 조인 결과를 MyBatis로 매핑해서 컨트롤러 → JSP로 넘길 때 사용.
 *
 * 데이터 흐름
 * - 입력: IndexBbsMapper.selectMainBbsList(bbsCode) 쿼리 결과 한 행.
 * - 가공: 서비스/컨트롤러에서 별도 가공 없이 그대로 Model에 담겨 뷰로 전달.
 * - 출력: JSP에서 공지/행사/논문 섹션 테이블(제목, 작성일, 조회수 등) 렌더링에 사용.
 *
 * 계약(전제·보장)
 * - bbscttNo, bbsCode, bbscttSj, bbscttWritngDe는 NOT NULL이라는 전제로 화면에서 사용한다.
 * - VO 자체는 불변식 검증이나 비즈니스 로직을 가지지 않고, 순수 데이터 컨테이너로만 사용한다.
 *
 * 보안·안전 전제
 * - 현재 필드는 비회원도 식별 가능한 게시글 정보만 포함(개인정보·민감정보 없음)을 전제로 비회원 화면에 노출한다.
 * - 추후 작성자 이름, 학번 등 식별 정보 필드를 추가할 경우 권한 체크/마스킹 정책을 먼저 설계해야 한다.
 *
 * 유지보수자 가이드
 * - BBS_CTT/BBS 스키마 변경(컬럼 추가/타입 변경) 시 : 
 * 			 VO 필드
 * 			 → Mapper resultMap
 * 			 → index.jsp 순서로 정합성 점검.
 * 
 * - index 전용 용도이므로, 다른 도메인(상세 화면, 관리용 게시판 등)까지 
 * 		재사용하지 말고 별도 VO로 분리하는 것이 안전하다.
 */
@Data
public class IndexBbsVO {

    // 게시글 고유 번호 (BBS_CTT.BBSCTT_NO, PK)
    private Long bbscttNo;

    // 게시판 코드 (BBS.BBS_CODE, 1=공지, 2=행사, 3=학술/논문 등)
    private Integer bbsCode;

    // 게시판 이름 (BBS.BBS_NM, 화면 섹션 타이틀 또는 라벨 표시에 사용 가능)
    private String bbsNm;

    // 썸네일 이미지 등 
    private String fileGroupNo;
    
    // 게시글 제목 (BBS_CTT.BBSCTT_SJ, 메인에서 링크 텍스트로 사용)
    private String bbscttSj;

    // 게시글 내용 요약 또는 전문 (BBS_CTT.BBSCTT_CN, 필요 시 일부만 잘라서 사용)
    private String bbscttCn;

    // 게시글 작성일 (BBS_CTT.BBSCTT_WRITNG_DE, 메인 노출 시 yyyy-MM-dd 포맷으로 렌더링)
    private Date bbscttWritngDe;

    // 조회수 (BBS_CTT.BBSCTT_RDCNT, 인기글/정렬 기준 등에 활용 가능)
    private Integer bbscttRdcnt;
}
