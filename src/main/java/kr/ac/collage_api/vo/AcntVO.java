package kr.ac.collage_api.vo;

import java.util.List;

import lombok.Data;

@Data
public class AcntVO {
    private String acntId;        // 계정 ID (PK)
    private Long fileGroupNo;     // 프로필 이미지 등 첨부 파일 그룹 번호
    private String password;      // 비밀번호 (BCrypt 해시)
    private String acntTy;        // 계정 유형 코드 (예: 관리자/교수/학생 등)

    private List<AuthorVO> authorList; // AUTHOR 레코드 목록 (이 계정이 가진 권한/역할들)
}

/*
- ACNT : AUTHOR = 1 : N
- 이 계정(ACNT_ID)에 연결된 AUTHOR 행들(권한/역할 정보)을 보유
*/