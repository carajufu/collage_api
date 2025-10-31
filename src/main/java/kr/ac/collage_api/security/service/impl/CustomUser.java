package kr.ac.collage_api.security.service.impl;

import kr.ac.collage_api.vo.AcntVO;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;
import java.util.stream.Collectors;

@Getter
@Setter
public class CustomUser extends User {
    private AcntVO acntVO;

    public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }

    public CustomUser(AcntVO acntVO) {
        super(acntVO.getAcntId(), acntVO.getPassword(), acntVO.getAuthorVOList()
                .stream()
                .map(auth -> new SimpleGrantedAuthority(auth.getAuthorNm()))
                .collect(Collectors.toList())
        );

        this.acntVO = acntVO;
    }
}
