package kr.ac.collage_api.dashboard.vo;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

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
