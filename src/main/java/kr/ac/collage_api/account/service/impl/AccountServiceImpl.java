package kr.ac.collage_api.account.service.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.account.service.AccountService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AccountServiceImpl implements AccountService{

	@Autowired
	AccountMapper accountMapper;
	
	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Override
	public List<UnivVO> selectUnivCNinfo() {
		return this.accountMapper.selectUnivCNinfo();
	}

	@Override
	public List<SubjctVO> selectSubjctCNinfo(String univCode) {
		return this.accountMapper.selectSubjctCNinfo(univCode);
	}

	@Transactional
	@Override
	public int insertStdAccount(StdntVO stdntVO) {
		// 1.학번 만들기
		// 연도2자리 + 단과대코드 2자리 + 학과코드 2자리 + 일련번호 3자리(001~999)
		// 비밀번호는 생년월일을 암호화한 것
		

		String entschDe = stdntVO.getEntschDe().replaceAll("-", "");
		String year = entschDe.substring(2,4);
		 
		String stdntFrontNo = year + stdntVO.getUnivCode() + stdntVO.getSubjctCode();
		
		String stdntNo = this.accountMapper.findStdntSeq(stdntFrontNo);
		
		if ("0".equals(stdntNo)) {
			stdntNo = stdntFrontNo + "001";
		} else {
			stdntNo = String.valueOf(Integer.parseInt(stdntNo) + 1);
		}
		
		
		//2. 계정 생성
		String brthdy = stdntVO.getBrthdy().replaceAll("-", "");
		String password = this.bCryptPasswordEncoder.encode(brthdy);
		
		AcntVO acntVO = new AcntVO();
		acntVO.setAcntId(stdntNo);
		acntVO.setPassword(password);
		acntVO.setAcntTy("1");			//학생은 1
		
		int insertAcntResult = this.accountMapper.insertAcnt(acntVO);
				
		//2-2. 권한 생성
		AuthorVO authorVO = new AuthorVO();
		/*
		 *   private String acntId;
    private String authorId; //권한ID(PK)	AUTHOR_ID(PK)
    private String alwncDe; //부여일자	ALWNC_DE
    private String authorNm; //권한_명	AUTHOR_NM
    private String authorDc; //권한_설명	AUTHOR_DC
		*/
		authorVO.setAcntId(stdntNo);
		authorVO.setAuthorNm("ROLE_STUDENT");
		authorVO.setAuthorDc("학생");
		
		
		int insertAuthorResult = this.accountMapper.insertAuthor(authorVO);
		
		
		
		//3. 학생계정 생성
		
		
		stdntVO.setAcntId(stdntNo);
		stdntVO.setStdntNo(stdntNo);
		stdntVO.setBrthdy(brthdy); 
		stdntVO.setSknrgsSttus("재학");		//학생계정생성시 학적은 재학으로 세팅. 학적에서 해야겟지?
		stdntVO.setEntschDe(entschDe);
	
		return this.accountMapper.insertStdAccount(stdntVO);
		
	}

	@Transactional
	@Override
	public int insertStdAccountBulk(MultipartFile uploadFile) {
		
		int result = 0;
		
		try (BufferedReader reader = new BufferedReader(
		     new InputStreamReader(uploadFile.getInputStream(),StandardCharsets.UTF_8))) 
			
			{
			String headerLine = reader.readLine();
			if(headerLine==null) {
				throw new IllegalArgumentException("csv 파일이 비어 있습니다.");
			}
			
			String[] headers = headerLine.split(",");
			Map<String,Integer> headerMap = new HashMap<>();
			for(int i = 0; i<headers.length; i++) {
				headerMap.put(headers[i].trim(),i);
			}
			
			String line;
			int lineNumber = 1;
			while ((line = reader.readLine())!=null) {
				lineNumber++;
				
				try {
					String[] data = line.split(",", -1);
					
					StdntVO stdntVO = new StdntVO();
					
					stdntVO.setStdntNm(getValueByHeader(data, headerMap, "stdntNm"));
					stdntVO.setBrthdy(getValueByHeader(data, headerMap, "brthdy"));
					stdntVO.setCttpc(getValueByHeader(data, headerMap, "cttpc"));
					stdntVO.setEmgncCttpc(getValueByHeader(data, headerMap, "emgncCttpc"));
					stdntVO.setBassAdres(getValueByHeader(data, headerMap, "bassAdres"));
					stdntVO.setDetailAdres(getValueByHeader(data, headerMap, "detailAdres"));
					stdntVO.setZip(getValueByHeader(data, headerMap, "zip"));
	                stdntVO.setUnivCode(getValueByHeader(data, headerMap, "univCode"));
	                stdntVO.setSubjctCode(getValueByHeader(data, headerMap, "subjctCode"));
	                stdntVO.setGrade(getValueByHeader(data, headerMap, "grade"));
	                stdntVO.setEntschDe(getValueByHeader(data, headerMap, "entschDe"));
	                stdntVO.setBankNm(getValueByHeader(data, headerMap, "bankNm"));
	                stdntVO.setAcnutno(getValueByHeader(data, headerMap, "acnutno"));
	                
	    
	                result += insertStdAccount(stdntVO);
	        		
					
				} catch (Exception e) {
					throw new IllegalArgumentException(
							lineNumber+ "번째 줄 파싱 오류 : "+e.getMessage());
				}
			}
		
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		return result;
	}
	
	
	//계정 대량 생산때 사용하는 것
	public String getValueByHeader(String[] data, Map<String,Integer> headerMap, String headerName) {
		Integer index = headerMap.get(headerName);
		if (index==null || index >= data.length) {
			return null;
		}
		String value = data[index].trim();
		return value.isEmpty() ? null : value;
	}

	
	
	
	@Override
	public List<StdntVO> selectStdntInfo(String keyword) {
		return this.accountMapper.selectStdntInfo(keyword);
	}

	@Override
	public StdntVO selectOneStdntInfo(String stdntNo) {
		StdntVO stdntVO= this.accountMapper.selectOneStdntInfo(stdntNo);
		log.info("selectOneStdntInfo() -> stdntVO : {}", stdntVO);
		
		
		String brthdy = strToDateStr(stdntVO.getBrthdy());
		String entschDe = strToDateStr(stdntVO.getEntschDe());
		String grdtnDe = strToDateStr(stdntVO.getGrdtnDe());
		stdntVO.setBrthdy(brthdy);
		stdntVO.setEntschDe(entschDe);
		stdntVO.setGrdtnDe(grdtnDe);
		
		
		
	
		return stdntVO;
	}
	
	public static String strToDateStr(String str) {
		if (str ==null ) {
			return null;
		}
		
		String year = str.substring(0,4);
		String month = str.substring(4,6);
		String day = str.substring(6,8);
		
		str = year + "-" + month + "-" + day;
		return str;
	}

	@Transactional
	@Override
	public int updateStdAccount(StdntVO stdntVO) {
		String entschDe = stdntVO.getEntschDe().replaceAll("-", "");
		String brthdy = stdntVO.getBrthdy().replaceAll("-", "");
		
		stdntVO.setEntschDe(entschDe);
		stdntVO.setBrthdy(brthdy);
		
		if (stdntVO.getGrdtnDe() !=null) {
			String grdtnDe = stdntVO.getGrdtnDe().replaceAll("-", "");
			stdntVO.setGrdtnDe(grdtnDe);
		}
		
		return this.accountMapper.updateStdAccount(stdntVO);
	}
}
