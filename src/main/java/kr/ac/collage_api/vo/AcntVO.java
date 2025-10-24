package kr.ac.collage_api.vo;

<<<<<<< HEAD
import lombok.Data;

import java.util.List;

//계정
@Data
public class AcntVO {
	private String acntId;   //계정_ID(PK)
	private String password; //비밀번호
	private String acntTy;   //계정_유형
    private String fileGroupNo;

    private List<AuthorVO> authorVOList;
}
=======
import java.util.List;

import lombok.Data;

//계정
@Data
public class AcntVO {
	private String acntId;    //계정_ID(PK)
	private int fileGroupNo;  //파일그룹번호
	private String password;  //비밀번호
	private String acntTy;    //계정_유형
	private String authorId;   //권한ID(PK)	AUTHOR_ID(PK)

	private List<AuthorVO> authorVOList;
}
>>>>>>> 065f1d3a4570b58f75c1d1a9fc72716128730d4b


