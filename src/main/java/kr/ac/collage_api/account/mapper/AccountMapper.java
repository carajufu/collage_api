package kr.ac.collage_api.account.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;

@Mapper
public interface AccountMapper {
	
	//파일 그룹 생성
	public int insertFileGroup(FileGroupVO fileGroupVO);

	//파일 디테일 생성
	public int insertFileDetail(FileDetailVO fileDetailVO);
	
	//계정아이디로 교수 아이디 가져오기
	public String getProfsrNo(String acntId);

	//계정 아이디로 학생 아이디 가져오기
	public String selectStdntNo(String acntId);

	//대학코드, 이름 가져오기
	public List<UnivVO> selectUnivCNinfo();

	//학과코드에 맞는 대학 코드, 이름 가져오기
	public List<SubjctVO> selectSubjctCNinfo(String univCode);

	//학번 뒤에 붙일 3자리 시퀀스 찾기
	public String findStdntSeq(String stdntFrontNo);

	//계정생성
	public int insertAcnt(AcntVO acntVO);

	//학생계정생성
	public int insertStdAccount(StdntVO stdntVO);

	//권한 생성 계정
	public int insertAuthor(AuthorVO authorVO);

	//검색 키워드로 학번, 학생이름 찾기
	public List<StdntVO> selectStdntInfo(String keyword);

	//학번으로 stdntVO 한행 읽어오기
	public StdntVO selectOneStdntInfo(String stdntNo);

	//학생(stdnt 테이블) 업데이트
	public int updateStdAccount(StdntVO stdntVO);
	//파일 상세정보 조회
	public FileDetailVO getFileDetailByGroupNo(Long fileGroupNo);
}
