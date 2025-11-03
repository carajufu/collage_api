package kr.ac.collage_api.enrollment.vo;

import java.util.Date;

import lombok.Data;

@Data
public class EnrollmentVO {

	private int sknrgsChangeInnb;
	private String changeTy;
	private String efectOccrrncSemstr;
	private String tmpabssklTy;            //휴학유형   휴학할때 군휴학인지, 일반휴학인지..
	private String reqstResn;
	private Date changeReqstTm;
	private String reqstSttus;
	private Date confmComptTm;
	private String returnResn;
	private Date lastUpdtTm;
	private String stdntId;
	

}
