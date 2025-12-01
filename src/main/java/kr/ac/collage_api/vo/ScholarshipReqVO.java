package kr.ac.collage_api.vo;

import lombok.Data;

@Data
public class ScholarshipReqVO {
	private int schlReqNo;
	private String stdntNo;
	private String schlType;
	private int schlAmount;
	private String status;
	private String docFile;
	private String memo;
	private String rejectReason;
	private String payBank;
	private String payAcnt;
	private String payDe;
	private String reqDe;
}
