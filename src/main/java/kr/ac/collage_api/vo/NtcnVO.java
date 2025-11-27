package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NtcnVO {

	private int ntcnNo;
	private String acntId;
	private String ntcnCn;
	private String ntcnItnadr;
	private String sender;
	private String cnfirmAt;
	private Date registDt;

}
