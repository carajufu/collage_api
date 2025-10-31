package kr.ac.collage_api.security.service.impl;

import kr.ac.collage_api.security.mapper.SecurityMapper;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class UserDetailImpl implements UserDetailsService {
    @Autowired
    SecurityMapper securityMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AcntVO acntVO = securityMapper.findAcnt(username);
        log.info("chkng acntVO >> {}", acntVO);

        return acntVO == null ? null : new CustomUser(acntVO);
    }
}
