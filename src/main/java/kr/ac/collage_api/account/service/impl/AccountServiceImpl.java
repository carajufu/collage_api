package kr.ac.collage_api.account.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.account.service.AccountService;

@Service
public class AccountServiceImpl implements AccountService{

	@Autowired
	AccountMapper accountMapper;
}
