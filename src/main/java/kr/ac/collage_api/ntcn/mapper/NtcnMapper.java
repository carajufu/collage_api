package kr.ac.collage_api.ntcn.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.NtcnVO;

@Mapper
public interface NtcnMapper {

	//알림 저장
	int insertNtcn(NtcnVO ntcnVO);

	//안 읽은 알림 가져오기
	List<NtcnVO> selectUnreadNtcnList(String acntId);

	//읽었을때 cnfirmAt 값 변경
	int updateNtcnCnfirmAt(int ntcnNo);

}
