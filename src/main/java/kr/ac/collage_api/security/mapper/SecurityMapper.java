package kr.ac.collage_api.security.mapper;

import kr.ac.collage_api.vo.AcntVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SecurityMapper {
    AcntVO findAcnt(String username);

    String findStudentName(String id);

    String findStaffName(String id);

    String findStudentSubjct(String id);

    String findProfSubjct(String id);



    // 종우
    String findByNameAndBirth(String name, String birth);

    int existsByAcntIdAndEmail(String acntId, String email);

    int updatePasswordByAcntIdAndEmail(String acntId, String email, String encoded);

    AcntVO findById(String acntId);

    int userSaveAuth(AcntVO acntVO);

    String findAuthoritiesByAcntId(String acntId);

    String findStdntNoByAcntId(String acntId);

    String findProfsrNoByAcntId(String acntId);
}
