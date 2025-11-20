package kr.ac.collage_api.account.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.account.dto.ProfSelectEditDetailDTO;
import kr.ac.collage_api.account.service.AccountService;
import kr.ac.collage_api.vo.ProfsrDgriVO;
import kr.ac.collage_api.vo.SklstfVO;
import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin("*")
@RequestMapping("/admin/acnt")
@Slf4j
@RestController
public class AccountController {

	@Autowired
	AccountService accountService;

	//대학코드 반환
	@GetMapping("/univcn")
	public Map<String,Object> selectUnivCNinfo() {

		List<UnivVO> univVOList = this.accountService.selectUnivCNinfo();

		Map<String,Object> map = new HashMap<String,Object>();

		map.put("univVOList",univVOList);

		return map;

	}

	//학과코드 반환
	@GetMapping("/sbjctcn")
	public Map<String,Object> selectSubjctCNinfo(@RequestParam("univCode") String univCode) {

		List<SubjctVO> subjctVOList = this.accountService.selectSubjctCNinfo(univCode);

		Map<String,Object> map = new HashMap<String,Object>();

		map.put("subjctVOList",subjctVOList);
		return map;

	}

	//학생계정생성
	@PostMapping("/insertstd")
	public int insertStdAccount (@RequestBody StdntVO stdntVO) {

		int result =this.accountService.insertStdAccount(stdntVO);
		return result;
	}

	//학생계정 대량생성
	@PostMapping("/insertstdbulk")
	public int insertStdAccountBulk (@RequestParam("file") MultipartFile uploadFile) {
		log.info("insertStdAccountBulk() -> uploadFile : {}", uploadFile);
		 int result = this.accountService.insertStdAccountBulk(uploadFile);

		return result;
	}

	/*
	여기서 부터 학생 계정 수정수정
	*/

	@GetMapping("/selectStdntInfo")
	public List<StdntVO> selectStdntInfo (@RequestParam("keyword") String keyword){

		List<StdntVO> stdntVOList = new ArrayList<>();

		stdntVOList = this.accountService.selectStdntInfo(keyword);

 		return stdntVOList;
	}


	@GetMapping("/stdnteditdetail/{stdntNo}")
	public StdntVO selectOneStdntInfo (@PathVariable("stdntNo") String stdntNo){
		return this.accountService.selectOneStdntInfo(stdntNo);
	}


	@PutMapping("/updatestd")
	public int updateStdAccount(@RequestBody StdntVO stdntVO) {



		int result = this.accountService.updateStdAccount(stdntVO);;

		return result;
	}

	/***
	 * 교수 계정 생성
	 */


	@PostMapping("/insertprof")
	public int insertProfAccount(@RequestBody Map<String,String> map) {

		int result = this.accountService.insertProfAccount(map);

		return result;
	}

	///admin/acnt/insertprofbulk
	@PostMapping("/insertprofbulk")
	public int insertProfAccountBulk (@RequestParam("file") MultipartFile uploadFile) {
		log.info("insertStdAccountBulk() -> uploadFile : {}", uploadFile);
		 int result = this.accountService.insertProfAccountBulk(uploadFile);

		return result;
	}


	//교수번호, 이름 검색
	@GetMapping("/selectProfInfo")
	public List<SklstfVO> selectProfInfo(@RequestParam("keyword") String keyword){
		List<SklstfVO> sklstfVOList = new ArrayList<>();
		sklstfVOList = this.accountService.selectProfInfo(keyword);
		log.info("selectProfInfo() -> sklstfVOList : {}", sklstfVOList);
		return sklstfVOList;
	}


	/*
	 * //교수번호로 수정할 데이터 가져오기
export const selectOneProfInfo = async(profsrNo: string):Promise<ProfsrVO> => {
    const {data} = await API.get<ProfsrVO>(`/admin/acnt/selecteditdetail/${profsrNo}`)
    return data;
}
	 */
	@GetMapping("/selecteditdetail/{profsrNo}")
	public ProfSelectEditDetailDTO selecteditdetail(@PathVariable("profsrNo") String profsrNo) {
		log.info("selecteditdetail() -> profsrNo : {}", profsrNo);
		ProfSelectEditDetailDTO profSelectEditDetailDTO = new ProfSelectEditDetailDTO();
		profSelectEditDetailDTO = this.accountService.selecteditdetail(profsrNo);

		return profSelectEditDetailDTO;
	}


	//교수 리스트 불러오기
	@GetMapping("/selectProfList")
	public List<SklstfVO> selectProfsrList() {

		List<SklstfVO> sklstfVOList = this.accountService.selectProfsrList();
		log.info("selectProfsrList() -> sklstfVOList : {}", sklstfVOList);
		return sklstfVOList;
	}
	///admin/acnt/proflist/
	@GetMapping("/proflist/{profsrNo}")
	public ProfSelectEditDetailDTO selectProfList(@PathVariable("profsrNo") String profsrNo) {
		log.info("selecteditdetail() -> profsrNo : {}", profsrNo);
		ProfSelectEditDetailDTO profSelectEditDetailDTO = new ProfSelectEditDetailDTO();
		profSelectEditDetailDTO = this.accountService.selecteditdetail(profsrNo);
		log.info("selectProfList() -> profSelectEditDetailDTO : {}", profSelectEditDetailDTO);
		return profSelectEditDetailDTO;
	}



	@PutMapping("/updateProfAccount")
	public int updateProfAccount(@RequestBody Map<String,String> map) {

		log.info("updateProfAccount() -> map : {}", map);
		int result = this.accountService.updateProfAccount(map);

		return result;
	}

	//교수 계정 삭제
	@DeleteMapping("/prof/{profsrNo}")
	public int deleteProfAccount(@PathVariable("profsrNo") String profsrNo) {

		int result = this.accountService.deleteProfAccount(profsrNo);

		return result;
	}

	//교수 계정 리스트 삭제 (restful에서 이게 약속된거래)
	@PostMapping("/prof/listdelete")
	public int deleteProfAccountList(@RequestBody List<String> idList) {

		int result = this.accountService.deleteProfAccountList(idList);

		return 1;
	}

	/****
	 * 교수 학위
	 */

	//교수 학위 리스트 가져오기
	@GetMapping("/dgrilist")
	public List<ProfsrDgriVO> selectProfsrDgriList() {
		List<ProfsrDgriVO> dgriVO = new ArrayList<>();
		dgriVO = this.accountService.selectProfsrDgriList();
		return dgriVO;
	}

	//교번으로 교수이름, 가져오기
	@GetMapping("/profdgri/{sklstfId}")
	public Map<String,Object> selectProfDgriInfo (@PathVariable("sklstfId") String sklstfId) {
		log.info("selectProfDgriInfo() -> sklstfId : {}", sklstfId);
		SklstfVO sklstfVO = new SklstfVO();

		sklstfVO = this.accountService.selectProfDgriInfo(sklstfId);

		String sklstfNm = sklstfVO.getSklstfNm();

		Map<String,Object> map = new HashMap<String,Object>();

		map.put("sklstfId",sklstfId);
		map.put("sklstfNm", sklstfNm);
		log.info("selectProfDgriInfo() -> map : {}", map);

		return map;
	}

	//학위 등록하기
	@PostMapping("/profdgri")
	public int insertProfDgri(@RequestBody ProfsrDgriVO profsrDgriVO) {
		int result = this.accountService.insertProfsrDgri(profsrDgriVO);
		return result;
	}

	//학위 상세 불러오기
	@GetMapping("/profdgri/detail/{dgriNo}")
	public ProfsrDgriVO selectProfDgriInfoForUpdate (@PathVariable String dgriNo) {

		ProfsrDgriVO profsrDgriVO = new ProfsrDgriVO();
		profsrDgriVO.setDgriNo(dgriNo);

		profsrDgriVO = this.accountService.selectProfDgriInfoForUpdate(profsrDgriVO);
		log.info("selectProfDgriInfoForUpdate() -> profsrDgriVO 후 : {}", profsrDgriVO);
		return profsrDgriVO;
	}


	//학위 업데이트 하기
	@PutMapping("/profdgri/detail")
	public int updateProfDgri(@RequestBody ProfsrDgriVO profsrDgriVO) {
		int result = this.accountService.updateProfDgri(profsrDgriVO);
		return result;
	}

	//학위 삭제하기
	@DeleteMapping("/profdgri/detail/{dgriNo}")
	public int deleteProfDgri(@PathVariable String dgriNo) {
		int result = this.accountService.deleteProfDgri(dgriNo);
		return result;
	}

	//학위 리스트에서 삭제
	@PostMapping("/profdgri/deletelist")
	public int deleteProfsrDgriList(@RequestBody List<String> digriVOList) {
		log.info("deleteProfsrDgriList() -> digriVOList : {}", digriVOList);
		int result = this.accountService.deleteProfsrDgriList(digriVOList);
		log.info("deleteProfsrDgriList() -> result : {}", result);
		return result;
	}


	/*
	 * export const insertProfDgriBulk = async(formData:FormData):Promise<number> =>
	 * { const {data} = await API.post<number>('/admin/acnt/profdgri/bulk',formData)
	 * return data; }
	 */

	//학위 대량 업로드
	@PostMapping("/profdgri/bulk")
	public int insertProfDgriBulk (@RequestBody MultipartFile uploadFile) {
		log.info("insertProfDgriBulk() -> uploadFile : {}", uploadFile);
		int result = this.accountService.insertProfDgriBulk(uploadFile);
		return result;

	}






}
