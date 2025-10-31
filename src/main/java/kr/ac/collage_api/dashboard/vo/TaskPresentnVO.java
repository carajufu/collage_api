package kr.ac.collage_api.dashboard.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TaskPresentnVO {
    private String taskPresentnNo;
    private String stdntNo;
    private String taskNo;
    private int fileGroupNo;
    private String taskPresentnDe;
    private String presentnAt;
}
