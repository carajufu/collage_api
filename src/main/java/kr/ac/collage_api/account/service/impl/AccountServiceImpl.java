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

import kr.ac.collage_api.account.dto.ProfSelectEditDetailDTO;
import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.account.service.AccountService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import kr.ac.collage_api.vo.ProfsrDgriVO;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.SklstfVO;
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
		String email = stdntVO.getEmail();

		log.info("insertStdAccount() -> email : {}", email);

		AcntVO acntVO = new AcntVO();
		acntVO.setAcntId(stdntNo);
		acntVO.setPassword(password);
		acntVO.setAcntTy("1");			//학생은 1
		acntVO.setEmail(email);

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
					stdntVO.setEmail(getValueByHeader(data,headerMap,"email"));
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



	@Transactional
	@Override
	public int insertProfAccount(Map<String, String> map) {

		int result = 0;

		AcntVO acntVO = new AcntVO();
		SklstfVO sklstfVO = new SklstfVO();
		ProfsrVO profsrVO = new ProfsrVO();
		ProfsrDgriVO profsrDgriVO = new ProfsrDgriVO();
		AuthorVO authorVO = new AuthorVO();

		String sklstfNm = map.get("sklstfNm");

		String brthdy = map.get("brthdy").replaceAll("-", "");
        String nlty = map.get("nlty");
		String cttpc = map.get("cttpc");
		String emgncCttpc = map.get("emgncCttpc");
		String emailAdres = map.get("emailAdres");
		String ecnyDe = map.get("ecnyDe").replaceAll("-", "");
		String hffcSttus = map.get("hffcSttus");

		String retireDe = map.get("retireDe");
		if (retireDe !=null && !retireDe.equals("null") && retireDe.length() !=0 ) {
			retireDe = map.get("retireDe").replaceAll("-", "");
		} else {
			retireDe = null;
		}

		String zip = map.get("zip");
		String bassAdres = map.get("bassAdres");
		String detailAdres = map.get("detailAdres");
		String major = map.get("major");
		String dgri = map.get("dgri");
		String acqsEngn = map.get("acqsEngn");
		String acqsDe = map.get("acqsDe").replaceAll("-", "");
		String univCode = map.get("univCode");
		String subjctCode = map.get("subjctCode");
		String clsf = map.get("clsf");
		String labrumLc = map.get("labrumLc");
		String bankNm = map.get("bankNm");
		String acnutno = map.get("acnutno");

		//1.계정 테이블 입력
		String partOfId = "P"+ecnyDe.substring(2,4);
		String maxAcntId = this.accountMapper.findIdSeq(partOfId);

		String acntId = "P"+(Integer.parseInt(maxAcntId.substring(1,5))+1);
		String password = this.bCryptPasswordEncoder.encode(brthdy);
		String acntTy = ("2");

		acntVO.setAcntId(acntId);
		acntVO.setPassword(password);
		acntVO.setAcntTy(acntTy);

		result = this.accountMapper.insertAcnt(acntVO); //있는거 재활용

		//2.교직원 테이블 입력
		sklstfVO.setAcntId(acntId);
		sklstfVO.setSklstfId(acntId);
		sklstfVO.setSklstfNm(sklstfNm);
		sklstfVO.setEcnyDe(ecnyDe);
		sklstfVO.setRetireDe(retireDe);
		sklstfVO.setBrthdy(brthdy);
		sklstfVO.setCttpc(cttpc);
		sklstfVO.setEmgncCttpc(emgncCttpc);
		//sklstfVO.setPsitnDept(null);	// 교직원 소속 나중에 쓰려면 오픈! sql문도 작성해야 함
		//sklstfVO.setRspofc(null);		// 교직원 직책 나중에 쓰려면 오픈! sql문도 작성해야 함
		sklstfVO.setHffcSttus(hffcSttus);
		sklstfVO.setBankNm(bankNm);
		sklstfVO.setAcnutno(acnutno);
		sklstfVO.setBassAdres(bassAdres);
		sklstfVO.setDetailAdres(detailAdres);
		sklstfVO.setZip(zip);

		result += this.accountMapper.insertSklstf(sklstfVO);

		//3.교수 테이블 입력
		profsrVO.setProfsrNo(acntId);
		profsrVO.setSklstfId(acntId);
		profsrVO.setSubjctCode(subjctCode);
		profsrVO.setClsf(clsf);
		profsrVO.setLabrumLc(labrumLc);
		profsrVO.setNlty(nlty);
		profsrVO.setEmailAdres(emailAdres);

		result += this.accountMapper.insertProfsr(profsrVO);

		//4.교수 학위 입력
		profsrDgriVO.setProfsrNo(acntId);
		profsrDgriVO.setMajor(major);
		profsrDgriVO.setDgri(dgri);
		profsrDgriVO.setAcqsEngn(acqsEngn);
		profsrDgriVO.setAcqsDe(acqsDe);

		result += this.accountMapper.insertProfsrDgri(profsrDgriVO);

		//5.계정 권한 입력

		authorVO.setAcntId(acntId);
		authorVO.setAuthorNm("ROLE_PROF");
		authorVO.setAuthorDc("교수");

		result += this.accountMapper.insertAuthor(authorVO);

		return result;
	}

	@Transactional
	@Override
	public int insertProfAccountBulk(MultipartFile uploadFile) {

	int result = 0;


     try (BufferedReader reader = new BufferedReader( new
     InputStreamReader(uploadFile.getInputStream(),StandardCharsets.UTF_8)))

     { String headerLine = reader.readLine(); if(headerLine==null) { throw new
     IllegalArgumentException("csv 파일이 비어 있습니다."); }

     String[] headers = headerLine.split(",");
     Map<String,Integer> headerMap = new HashMap<>();
     for(int i = 0; i<headers.length; i++) { headerMap.put(headers[i].trim(),i);}

     String line;
     int lineNumber = 1;
     while ((line = reader.readLine())!=null) {
     lineNumber++;

     try { String[] data = line.split(",", -1);

     Map<String,String> map = new HashMap<>();

    map.put("sklstfNm",String.valueOf(getValueByHeader(data, headerMap, "sklstfNm")));

	map.put("brthdy",String.valueOf(getValueByHeader(data, headerMap, "brthdy")));
    map.put("nlty",String.valueOf(getValueByHeader(data, headerMap, "nlty")));
	map.put("cttpc",String.valueOf(getValueByHeader(data, headerMap, "cttpc")));
	map.put("emgncCttpc",String.valueOf(getValueByHeader(data, headerMap, "emgncCttpc")));
	map.put("emailAdres",String.valueOf(getValueByHeader(data, headerMap, "emailAdres")));
	map.put("ecnyDe",String.valueOf(getValueByHeader(data, headerMap, "ecnyDe")));
	map.put("hffcSttus",String.valueOf(getValueByHeader(data, headerMap, "hffcSttus")));
	map.put("retireDe",String.valueOf(getValueByHeader(data, headerMap, "retireDe")));
	map.put("zip",String.valueOf(getValueByHeader(data, headerMap, "zip")));
	map.put("bassAdres",String.valueOf(getValueByHeader(data, headerMap, "bassAdres")));
	map.put("detailAdres",String.valueOf(getValueByHeader(data, headerMap, "detailAdres")));
	map.put("major",String.valueOf(getValueByHeader(data, headerMap, "major")));
	map.put("dgri",String.valueOf(getValueByHeader(data, headerMap, "dgri")));
	map.put("acqsEngn",String.valueOf(getValueByHeader(data, headerMap, "acqsEngn")));
	map.put("acqsDe",String.valueOf(getValueByHeader(data, headerMap, "acqsDe")));
	map.put("univCode",String.valueOf(getValueByHeader(data, headerMap, "univCode")));
	map.put("subjctCode",String.valueOf(getValueByHeader(data, headerMap, "subjctCode")));
	map.put("clsf",String.valueOf(getValueByHeader(data, headerMap, "clsf")));
	map.put("labrumLc",String.valueOf(getValueByHeader(data, headerMap, "labrumLc")));
	map.put("bankNm",String.valueOf(getValueByHeader(data, headerMap, "bankNm")));
	map.put("acnutno",String.valueOf(getValueByHeader(data, headerMap, "acnutno")));

     result += insertProfAccount(map);


     } catch (Exception e) { throw new IllegalArgumentException( lineNumber+
     "번째 줄 파싱 오류 : "+e.getMessage()); } }

     } catch (IOException e1) {
    	 e1.printStackTrace();
     }
		return result;

	}

	@Override
	public List<SklstfVO> selectProfInfo(String keyword) {
		return this.accountMapper.selectProfInfo(keyword);
	}

	//관리자, 교수 수정페이지 진입시 기존 값 불러오기
	@Override
	public ProfSelectEditDetailDTO selecteditdetail(String profsrNo) {
		return this.accountMapper.selecteditdetail(profsrNo);



	}

	//교수 계정 리스트 불러오기
	@Override
	public List<SklstfVO> selectProfsrList() {
		return this.accountMapper.selectProfsrList();
	}

	//교수 게정 수정

	@Transactional
	@Override
	public int updateProfAccount(Map<String, String> map) {
		int result = 0;
/*
		updateProfAccount() -> map :
		{profsrNo=P2401, subjctCode=11, clsf=정교수, labrumLc=A-201, nlty=KOR
		, emailAdres=P2401@gmail.com, sklstfNm=김철수, ecnyDe=2010-03-01, retireDe=null, brthdy=1975-05-10
		, cttpc=010-1111-2222, emgncCttpc=010-9999-2401, psitnDept=null, rspofc=null, hffcSttus=1
		, bankNm=국민은행, acnutno=110-234-567890, bassAdres=대전광역시 유성구 대학로 123
		, detailAdres=대우아파트 101동 202호, zip=34134, univCode=10}
	*/



		SklstfVO sklstfVO = new SklstfVO();
		ProfsrVO profsrVO = new ProfsrVO();

		String profsrNo = map.get("profsrNo");
		String sklstfNm = map.get("sklstfNm");

		String brthdy = map.get("brthdy").replaceAll("-", "");
        String nlty = map.get("nlty");
		String cttpc = map.get("cttpc");
		String emgncCttpc = map.get("emgncCttpc");
		String emailAdres = map.get("emailAdres");
		String ecnyDe = map.get("ecnyDe").replaceAll("-", "");
		String hffcSttus = map.get("hffcSttus");

		String retireDe = map.get("retireDe");
		if (retireDe !=null && !retireDe.equals("null") && retireDe.length() !=0 ) {
			retireDe = map.get("retireDe").replaceAll("-", "");
		} else {
			retireDe = null;
		}


		String zip = map.get("zip");
		String bassAdres = map.get("bassAdres");
		String detailAdres = map.get("detailAdres");


		String subjctCode = map.get("subjctCode");
		String clsf = map.get("clsf");
		String labrumLc = map.get("labrumLc");
		String bankNm = map.get("bankNm");
		String acnutno = map.get("acnutno");


		//2.교직원 테이블 입력
		sklstfVO.setSklstfId(profsrNo);
		sklstfVO.setSklstfNm(sklstfNm);
		sklstfVO.setEcnyDe(ecnyDe);
		sklstfVO.setRetireDe(retireDe);
		sklstfVO.setBrthdy(brthdy);
		sklstfVO.setCttpc(cttpc);
		sklstfVO.setEmgncCttpc(emgncCttpc);
		//sklstfVO.setPsitnDept(null);	// 교직원 소속 나중에 쓰려면 오픈! sql문도 작성해야 함
		//sklstfVO.setRspofc(null);		// 교직원 직책 나중에 쓰려면 오픈! sql문도 작성해야 함
		sklstfVO.setHffcSttus(hffcSttus);
		sklstfVO.setBankNm(bankNm);
		sklstfVO.setAcnutno(acnutno);
		sklstfVO.setBassAdres(bassAdres);
		sklstfVO.setDetailAdres(detailAdres);
		sklstfVO.setZip(zip);

		result += this.accountMapper.updateSklstf(sklstfVO);

		//3.교수 테이블 입력
		profsrVO.setProfsrNo(profsrNo);
		profsrVO.setSubjctCode(subjctCode);
		profsrVO.setClsf(clsf);
		profsrVO.setLabrumLc(labrumLc);
		profsrVO.setNlty(nlty);
		profsrVO.setEmailAdres(emailAdres);

		result += this.accountMapper.updateProfsr(profsrVO);


		return result;

	}

	@Transactional
	@Override
	public int deleteProfAccount(String profsrNo) {

		int result = 0;
		// 권한, 학위, 교수, 교직원 계정
		// ACNT_ID, PROFSR_NO , profsr_no, sklstf_id, acnt_id
		String acntId = profsrNo;

		//권한 author 삭제
		result += this.accountMapper.deleteAuthor(acntId);

		//학위 삭제
		result += this.accountMapper.deleteProfsrDgri(profsrNo);

		//교수 삭제
		result += this.accountMapper.deleteProfsr(profsrNo);

		//교직원 삭제
		result += this.accountMapper.deleteSklstf(acntId);

		//계정 삭제
		result += this.accountMapper.deleteAcntId(acntId);


		return result;
	}

	@Transactional
	@Override
	public int deleteProfAccountList(List<String> idList) {

		int result = 0;
		for (int i = 0;i<idList.size();i++) {
			result += deleteProfAccount(idList.get(i));
		}

		return result;
	}


	/***
	 * 교수 학위
	 */

	@Override
	public List<ProfsrDgriVO> selectProfsrDgriList() {
		return this.accountMapper.selectProfsrDgriList();
	}

	@Override
	public SklstfVO selectProfDgriInfo(String sklstfId) {
		return this.accountMapper.selectProfDgriInfo(sklstfId);
	}

	@Override
	public int insertProfsrDgri(ProfsrDgriVO profsrDgriVO) {
		log.info("insertProfsrDgri() -> profsrDgriVO : {}", profsrDgriVO);
		String acqsDe = profsrDgriVO.getAcqsDe().replaceAll("-", "");
		profsrDgriVO.setAcqsDe(acqsDe);

		return this.accountMapper.insertProfsrDgri(profsrDgriVO);


	}

	@Transactional
	@Override
	public ProfsrDgriVO selectProfDgriInfoForUpdate(ProfsrDgriVO profsrDgriVO) {

		profsrDgriVO = this.accountMapper.selectProfDgriInfoForUpdate(profsrDgriVO);

		String acqsDe = profsrDgriVO.getAcqsDe();

		StringBuilder sb = new StringBuilder(acqsDe);

		sb.insert(4, "-"); //1999-0909
		sb.insert(7, "-");

		profsrDgriVO.setAcqsDe(sb.toString());
		return profsrDgriVO;
	}

	@Override
	public int updateProfDgri(ProfsrDgriVO profsrDgriVO) {
		String acqsDe = profsrDgriVO.getAcqsDe().replaceAll("-", "");
		profsrDgriVO.setAcqsDe(acqsDe);

		return this.accountMapper.updateProfDgri(profsrDgriVO);
	}

	@Override
	public int deleteProfDgri(String dgriNo) {
		return this.accountMapper.deleteProfDgri(dgriNo);
	}

	@Override
	public int deleteProfsrDgriList(List<String> digriVOList) {

		int result = 0;
		for (String dgriNo : digriVOList) {

			result += this.accountMapper.deleteProfDgri(dgriNo);
		}

		return result;
	}

	@Transactional
	@Override
	public int insertProfDgriBulk(MultipartFile uploadFile) {

		int result = 0;

		try (BufferedReader reader = new BufferedReader( new
		     InputStreamReader(uploadFile.getInputStream(),StandardCharsets.UTF_8)))

		     { String headerLine = reader.readLine(); if(headerLine==null) { throw new
		     IllegalArgumentException("csv 파일이 비어 있습니다."); }

		     String[] headers = headerLine.split(",");
		     Map<String,Integer> headerMap = new HashMap<>();
		     for(int i = 0; i<headers.length; i++) { headerMap.put(headers[i].trim(),i);}

		     String line;
		     int lineNumber = 1;
		     while ((line = reader.readLine())!=null) {
		     lineNumber++;

		     try { String[] data = line.split(",", -1);

		     Map<String,String> map = new HashMap<>();

		     ProfsrDgriVO profsrDgriVO = new ProfsrDgriVO();

		     profsrDgriVO.setSklstfNm(String.valueOf(getValueByHeader(data, headerMap, "sklstfNm")));
		     profsrDgriVO.setProfsrNo(String.valueOf(getValueByHeader(data, headerMap, "profsrNo")));
		     profsrDgriVO.setMajor(String.valueOf(getValueByHeader(data, headerMap, "major")));
		     profsrDgriVO.setDgri(String.valueOf(getValueByHeader(data, headerMap, "dgri")));
		     profsrDgriVO.setAcqsEngn(String.valueOf(getValueByHeader(data, headerMap, "acqsEngn")));
		     profsrDgriVO.setAcqsDe(String.valueOf(getValueByHeader(data, headerMap, "acqsDe")));



	      result += insertProfsrDgri(profsrDgriVO);


	      } catch (Exception e) { throw new IllegalArgumentException( lineNumber+
	      "번째 줄 파싱 오류 : "+e.getMessage()); } }

	      } catch (IOException e1) {
	     	 e1.printStackTrace();
	      }
	 	return result;



	}












}
