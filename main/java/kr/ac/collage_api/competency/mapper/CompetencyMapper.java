package kr.ac.collage_api.competency.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.competency.vo.CompetencyVO;

@Mapper
public interface CompetencyMapper {

    // 다음으로 사용할 FORM_ID 값을 조회
    int getNextFormNo();

    // 학생 번호로 저장된 기본 폼 데이터
    CompetencyVO getFormData(String stdntNo);

    // 학생 번호로 저장된 모든 이력 목록
    List<CompetencyVO> getAllByStdntNo(String stdntNo);

    // 기본 이력 폼 데이터를 삽입
    int insertFormData(CompetencyVO vo);

    //학생의 기본 이력 폼 데이터를 업데이트
    int updateFormData(CompetencyVO vo);

    //AI가 생성한 자기소개서 내용을 새 버전으로 삽입
    int insertManageCn(CompetencyVO vo);

    //AI 생성 자기소개서 목록만 조회
    List<CompetencyVO> getManageCnList(String stdntNo);

    //학생의 AI 생성 자기소개서 전체 버전을 삭제\
    int deleteManageCnAll(String stdntNo);

	void deleteManageCnOne(String stdntNo, int formId);
}