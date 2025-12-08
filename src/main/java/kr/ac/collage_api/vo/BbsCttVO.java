package kr.ac.collage_api.vo;

import java.sql.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

//게시판
@Data
public class BbsCttVO {
	private int bbscttNo; // 게시글_번호(PK)
	private String bbscttSj; // 게시글_제목
	private String bbscttCn; // 게시글_내용
	private Date bbscttWritngDe; // 게시글_작성일시
	private int bbscttRdcnt; // 게시글_조회수
	private int bbsCode; // 게시글_유형 private String bbscttTy; 이걸 코드로 바꿈
	private Integer parntsBbscttNo; // 부모_게시글_번호
	private Long fileGroupNo; // 파일_그룹_번호(FK)
	private String acntId; // 계정_ID(FK)

	// 페이징하면 rnum 가져옴
	private int rnum;

	// 작성자 : 교직원
	private String sklstfId;
	private String sklstfNm;

	// 작성자 : 학생
	private String stdntNo;
	private String stdntNm;

	// 페이징할때 필요함. 현재 페이지에 보여지는 리스트 담아 올때 쓰는 파라미터
	private List<BbsCttVO> bbsVOList;

	// 파일 리스트 들어오는 곳
	private MultipartFile[] attachmentFiles;
}
