package kr.ac.collage_api.common.util;

import org.springframework.stereotype.Component;

import java.util.Calendar;

/**
 * <p>
 * CurrentSemstr 클래스는 현재 연도를 가져오고 시스템 날짜를 기반으로 현재 학기 기간을
 * 결정하는 유틸리티 메서드를 제공합니다.
 * 이 클래스는 주로 애플리케이션에서 연도 및 학기 정보를 계산하고 반환하는 데 사용됩니다.
 * </p>
 *
 * <p>
 * 학기 기간은 다음과 같이 정의됩니다: <br>
 * - "1학기" (First Semester): 3월(3)부터 7월(7)까지 <br>
 * - "2학기" (Second Semester): 9월(9)부터 12월(12)까지
 * </p>
 *
 * <p>
 * 정의된 학기 기간을 벗어나는 달은 학기 기간에 대해 null을 반환합니다.
 * </p>
 */
@Component
public class CurrentSemstr {
    Calendar cal = Calendar.getInstance();

    /**
     * Retrieves the current year as a string based on the system calendar.
     *
     * @return the current year in string format
     */
    public String getYear() {
        String year = Integer.toString(cal.get(Calendar.YEAR));
        return year;
    }

    /**
     * Determines the current academic period based on the current month.
     *
     * The method uses the system calendar to identify the current month and returns
     * the corresponding academic period.
     * - If the month is between March (3) and July (7), the method returns "1학기" (First Semester).
     * - If the month is between September (9) and December (12), the method returns "2학기" (Second Semester).
     * - For months outside of these ranges, the method returns null.
     *
     * @return the current academic period as a string ("1학기" or "2학기"), or null if the current month does not fall within a defined academic period
     */
    public String getCurrentPeriod() {
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        String currentPeriod = null;

        if(currentMonth >= 3 && currentMonth <= 7) {
            currentPeriod = "1학기";
        } else if(currentMonth >= 9 && currentMonth <= 12) {
            currentPeriod = "2학기";
        }

        return currentPeriod;
    }
<<<<<<< HEAD
=======

>>>>>>> 3687477d9bda041a2c0225abb3ea552e7d15e5bc
}
