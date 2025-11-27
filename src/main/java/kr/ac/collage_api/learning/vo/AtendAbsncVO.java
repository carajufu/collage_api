package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AtendAbsncVO {
    private String atendAbsncNo;
    private String weekAcctoLrnNo;
    private String stdntNo;
    private String atendSttusCode;
    private String lctreDe;
}
