package kr.ac.collage_api.competency.vo;

import lombok.Data;

@Data
public class CompetencyVO {
	private Integer formId;       // FORM_ID
    private String stdntNo;       // STDNT_NO

    private String lastAcdmcr;    // LAST_ACDMCR (최종 학력)
    private String miltrAt;       // MILTR_AT (군필 여부)
    private String desireJob;     // DESIRE_JOB (희망 직무)

    private String crqfc;         // CRQFC (자격증)
    private String edcHistory;    // EDC_HISTORY (교육 이력)
    private String mainProject;   // MAIN_PROJECT (주요 프로젝트)
    private String character;     // CHARACTER (성격)
    
    private String manageCn;		  // MANAGE_CN (자소서 내용)
    
    private String stdntNm;
    private String brthDy;
}