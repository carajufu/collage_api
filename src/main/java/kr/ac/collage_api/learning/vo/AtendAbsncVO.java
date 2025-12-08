package kr.ac.collage_api.learning.vo;

import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.WeekAcctoLrnVO;
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

    private WeekAcctoLrnVO weekAcctoLrnVO;
    private StdntVO stdntVO;
}
