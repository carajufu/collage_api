package kr.ac.collage_api.regist.mapper;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.PayHistoryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.PayInfoVO;
import kr.ac.collage_api.vo.RegistCtVO;

@Mapper
public interface PayInfoMapper {

	int insertPayInfo(PayInfoVO payInfoVO);

	List<PayInfoVO> selectPayInfoListByStudent(@Param("stdntNo") String stdntNo);

    List<PayInfoVO> selectPayInfoList(@Param("stdntNo") String stdntNo);

	int updatePayStatus(Map<String, Object> param);

	PayInfoVO selectPayInfo(@Param("stdntNo") String stdntNo, @Param("registCtNo") int registCtNo);

	int updateVirtualAccount(@Param("stdntNo") String stdntNo, @Param("registCtNo") int registCtNo,
			@Param("accountNo") String accountNo);

	int selectPayAmount(@Param("stdntNo") String stdntNo, @Param("registCtNo") int registCtNo);

	int existsPayInfo(@Param("stdntNo") String stdntNo, @Param("registCtNo") int registCtNo);

	List<PayInfoVO> selectAdminPayList(Map<String, Object> params);

	void updateByRegistCtNo(RegistCtVO vo);

	void deleteByRegistCtNo(int registCtNo);

    List<PayHistoryVO> getHistory(@Param("paramMap") Map<String, Object> paramMap,
                                @Param("name") String name);
}
