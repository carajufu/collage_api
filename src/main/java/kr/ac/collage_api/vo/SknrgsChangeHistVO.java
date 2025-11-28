package kr.ac.collage_api.vo;

import lombok.Data;

//학적 변동 이력
@Data
public class SknrgsChangeHistVO {
	private int sknrgsHistInnb;   //학적이력고유번호(PK)	SKNRGS_HIST_INNB(PK)
	private int sknrgsChangeInnb; //학적변동고유번호(FK)	SKNRGS_CHANGE_INNB(FK)
	private String changeDe;      //변동일자	CHANGE_DE
	private String sknrgs;        //학적	SKNRGS
	private String changeResn;    //변동사유	CHANGE_RESN
}
