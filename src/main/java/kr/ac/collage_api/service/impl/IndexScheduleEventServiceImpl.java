package kr.ac.collage_api.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.mapper.IndexScheduleEventMapper;
import kr.ac.collage_api.service.IndexScheduleEventService;
import kr.ac.collage_api.vo.ScheduleEventVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class IndexScheduleEventServiceImpl implements IndexScheduleEventService {

    private final IndexScheduleEventMapper indexScheduleEventMapper;

    @Override
    public List<ScheduleEventVO> selectIndexScheduleEvents(Map<String, Object> param) {
        if (log.isDebugEnabled()) {
            log.debug("selectIndexScheduleEvents param={}", param);
        }

        List<ScheduleEventVO> result = indexScheduleEventMapper.selectIndexScheduleEvents(param);

        if (log.isDebugEnabled()) {
            log.debug("selectIndexScheduleEvents size={}", 
                      result != null ? result.size() : 0);
        }

        return result;
    }
}
