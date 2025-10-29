package kr.ac.collage_api.security.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.security.mapper.SecurityMapper;
import kr.ac.collage_api.stdnt.mapper.StdntMapper;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserDetailImpl implements UserDetailsService {
    @Autowired
    SecurityMapper securityMapper;
    
    @Autowired
    private StdntMapper stdntMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        AcntVO acntVO = securityMapper.findAcnt(username);
        log.info("chkng acntVO >> {}", acntVO);
        
        CustomUser customUser = null;
        
        if("1".equals(acntVO.getAcntTy())) {
        	StdntVO stdntVO = stdntMapper.findStdntByAcntId(acntVO.getAcntId());

        	log.info("chkng stdntVO >> {}", stdntVO);
        	if(stdntVO != null) {
        		acntVO.setStdntVO(stdntVO);
        	}
        }

        log.info("chking acntVO >> {}", acntVO);
        customUser = new CustomUser(acntVO);
        
        return customUser;
    }
}
