package kr.ac.collage_api.common.util;

import java.util.Calendar;

import org.springframework.stereotype.Component;

@Component
public class CurrentSemstr {
	
	Calendar cal = Calendar.getInstance();

    public String getYear() {
        String year = Integer.toString(cal.get(Calendar.YEAR));
        return year;
    }

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

}
