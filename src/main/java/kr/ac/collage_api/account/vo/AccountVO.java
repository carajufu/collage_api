package kr.ac.collage_api.account.vo;

import lombok.Data;

@Data
public class AccountVO {
    private String name;
    private Integer birthYear;
    private String educationLevel;
    private String military;
    private String targetJob;
    private String certificates;
    private String eduHistory;
    private String projects;
    private String strengths;
}