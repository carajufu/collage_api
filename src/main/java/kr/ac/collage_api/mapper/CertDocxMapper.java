package kr.ac.collage_api.mapper;

import java.util.List;

<<<<<<< Updated upstream:src/main/java/kr/ac/collage_api/mapper/CertDocxMapper.java
=======
import kr.ac.collage_api.certificates.vo.CrtfIssuRequestVO;
import kr.ac.collage_api.certificates.vo.StudentDocxVO;
import kr.ac.collage_api.certificates.vo.TranscriptRowVO;
import kr.ac.collage_api.certificates.vo.TranscriptSummaryVO;
import kr.ac.collage_api.certificates.vo.CrtfKndVO;
>>>>>>> Stashed changes:src/main/java/kr/ac/collage_api/certificates/mapper/CertDocxMapper.java
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.CrtfIssuRequestVO;
import kr.ac.collage_api.vo.CrtfKndVO;
import kr.ac.collage_api.vo.StudentDocxVO;
import kr.ac.collage_api.vo.TranscriptRowVO;
import kr.ac.collage_api.vo.TranscriptSummaryVO;

@Mapper
public interface CertDocxMapper {

    // 증명서 종류 단건 조회
    CrtfKndVO selectCrtfKndById(@Param("crtfKndNo") String crtfKndNo);

    // 증명서 종류 전체 목록
    List<CrtfKndVO> selectAllCrtfKnd();

    // 학생 증명서용 정보 조회 (PDF 바인딩용 최소 필드 세트)
    StudentDocxVO selectStudentDocxInfo(@Param("stdntNo") String stdntNo);

    // 발급 요청 INSERT (상태 REQ)
    int insertCrtfIssuRequest(CrtfIssuRequestVO reqVO);

    // 발급 요청 상태 UPDATE (DONE 등)
    void updateCrtfIssuStatus(CrtfIssuRequestVO reqVO);

    // 발급 이력 단건 조회 (감사용)
    CrtfIssuRequestVO selectIssueRequestInfo(@Param("crtfIssuInnb") String crtfIssuInnb);

    List<CrtfIssuRequestVO> stdntNoSelectALL(@Param("stdntNo") String stdntNo);

    int existsByDocNo(@org.apache.ibatis.annotations.Param("docNo") String docNo);

    // 성적 증명서 발급용 
    List<TranscriptRowVO> selectTranscriptRows(@Param("stdntNo") String stdntNo);
    TranscriptSummaryVO selectTranscriptSummary(@Param("stdntNo") String stdntNo);
    
}
