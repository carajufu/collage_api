package kr.ac.collage_api.dashboard.vo;

import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
@NoArgsConstructor
public class TaskPresentnVO {
    private String taskPresentnNo;
    private String stdntNo;
    private String taskNo;
    private long fileGroupNo;
    private String taskPresentnDe;
    private String presentnAt;

    private FileGroupVO fileGroupVO;
    private List<FileDetailVO> fileDetailVOList;
}
