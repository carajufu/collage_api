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

	int insertPayInfo(PayInfoVO vo);

	List<PayInfoVO> selectPayInfoListByStudent(String stdntNo);

	List<PayInfoVO> selectPayInfoList(String stdntNo);

	List<PayHistoryVO> getHistory(Map<String, Object> param);

	int updatePayStatus(Map<String, Object> param);

	PayInfoVO selectPayInfo(Map<String, Object> param);

	int updateVirtualAccount(Map<String, Object> param);

	int selectPayAmount(Map<String, Object> param);

	int existsPayInfo(Map<String, Object> param);

	List<PayInfoVO> selectAdminPayList(Map<String, Object> params);

	void updateByRegistCtNo(RegistCtVO vo);

	void deleteByRegistCtNo(int registCtNo);

	String selectKakaoTid(Map<String, Object> param);

	void updateKakaoTid(Map<String, Object> tidParam);

	PayInfoVO getPayInfoOne(String stdntNo);
	
	
}
