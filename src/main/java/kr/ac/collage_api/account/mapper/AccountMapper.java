package kr.ac.collage_api.account.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.account.dto.ProfSelectEditDetailDTO;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import kr.ac.collage_api.vo.ProfsrDgriVO;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.SklstfVO;
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

	//P+입사년도2자리 로 시퀀스 확인
	public String findIdSeq(String partOfId);

	//교직원 계정 생성
	public int insertSklstf(SklstfVO sklstfVO);

	//교수 계정 생성
	public int insertProfsr(ProfsrVO profsrVO);

	//학위 입력
	public int insertProfsrDgri(ProfsrDgriVO profsrDgriVO);

	//검색 키워드로 교번, 이름 찾기
	public List<SklstfVO> selectProfInfo(String keyword);

	//교수 아이디로 교수 계정 수정페이지 정보 찾기
	public ProfSelectEditDetailDTO selecteditdetail(String profsrNo);

	//교수 계정 리스트 불러오기
	public List<SklstfVO> selectProfsrList();

	//교직원 테이블 업데이트
	public int updateSklstf(SklstfVO sklstfVO);

	//교수 테이블 업데이트
	public int updateProfsr(ProfsrVO profsrVO);

	//권한 삭제
	public int deleteAuthor(String acntId);

	//학위 삭제
	public int deleteProfsrDgri(String profsrNo);

	//교수 삭제
	public int deleteProfsr(String profsrNo);

	//교직원 삭제
	public int deleteSklstf(String acntId);

	//계정삭제
	public int deleteAcntId(String acntId);

	/**
	 * 교수 학위
	 */

	//교수 학위 리스트 가져오기
	public List<ProfsrDgriVO> selectProfsrDgriList();

	//교수 아이디에 맞는 교수 이름 가져오기
	public SklstfVO selectProfDgriInfo(String sklstfId);

	//교수 학위 상세 정보 가져오기
	public ProfsrDgriVO selectProfDgriInfoForUpdate(ProfsrDgriVO profsrDgriVO);

	//교수 학위 상세 수정
	public int updateProfDgri(ProfsrDgriVO profsrDgriVO);

	//교수 학위 삭제
	public int deleteProfDgri(String dgriNo);



}
