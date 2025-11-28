<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.all.min.js"></script>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-5 overflow-auto">

			<h2 class="section-title">나의 상담 관리</h2>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>상담 요청 건수</h5>
                        <p class="text-muted mb-0" id="sumTotal"></p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>상담 완료 건수</h5>
                        <p class="text-muted mb-0" id="sumSuccess"></p>
                    </div>
                </div>

            <hr class="my-4">

        <h2 class="section-title">상담 요청 리스트</h2>

        <table class="table table-bordered table-hover bg-white">
            <thead class="table-light">
                <tr class="text-center">
                    <th>상담번호</th>
                    <th>상담요청일</th>
                    <th>상담요청 교시</th>
                    <th>신청상태</th>
                    <th>상담신청일</th>
                </tr>
            </thead>
            <tbody id="cnsltbody">

            </tbody>
        </table>
        </div>

        <div class="text-end">
		 <!-- Button trigger modal -->
			<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
			  상담 신청 하기
			</button>
		</div>
        </div>
    </div>

<%@ include file="../footer.jsp" %>



<script>

//요일 구하는 함수
function getWeekend(sDate) {
    const d = new Date(sDate);
    const weekend = ["일","월","화","수","목","금","토"];
    return weekend[d.getDay()];
}


//학생 상담 list불러오는 비동기 함수
function getStdList() {
    fetch ("/counsel/stdlist",{
        method : "GET",
        headers : {
            "Content-type":"application/json;charset:UTF-8"
        }
    }).then(resp => {
        return resp.json();
    }).then(result => {
        console.log("cnsltVOList : ",result.cnsltVOList);
        console.log("profsrVOList : ",result.profsrVOList);
        console.log("cnsltVOCountList : ",result.cnsltVOCountList);

        //나의 상담관리 카운트수
        const cs = result.cnsltVOCountList;
        let sumTotal = 0;
        let sumSuccess = 0;
        cs.forEach(c => {
            if (c.sttus ==4) { sumSuccess = c.cnt;}

            sumTotal += c.cnt;
        })

        console.log(sumTotal);
        console.log(sumSuccess);
        document.querySelector("#sumTotal").textContent = sumTotal+"건";
        document.querySelector("#sumSuccess").textContent = sumSuccess+"건";



        //상담 리스트
        const cnslts = result.cnsltVOList;
        const cnsltbody = document.querySelector("#cnsltbody");

        if (cnslts.length > 0) {
            document.querySelector("#modalStdntNo").value = cnslts[0].stdntNo;
        } else {
            cnsltbody.innerHTML = `<tr><td colspan="5">상담이력이 없습니다.</td></tr>`;
        }

        let str = "";
        let day = "";
        let time ="";
        let regDay ="";
        let bg = "";
        let text = "";



        cnslts.forEach(cnslt => {
            if (cnslt.sttus =="1") {
            	cnslt.sttus = "상담예약 진행중";
                bg="bg-warning";
                text = "text-dark";
            } else if (cnslt.sttus =="2") {
            	cnslt.sttus = "상담예약 완료";
            	bg="bg-primary";
            	text = "text-white";
            }else if (cnslt.sttus =="3") {
            	cnslt.sttus = "상담 취소";
            	bg="bg-danger";
            	text = "text-white";
            }else if (cnslt.sttus =="4") {
            	cnslt.sttus = "상담 완료";
            	bg="bg-success";
            	text = "text-white";
            }//진행상태
    	    regDay = cnslt.reqstDe.substring(0,10);	//상담신청일
            time = cnslt.cnsltRequstHour + " 교시"; //상담요청교시
            day = cnslt.cnsltRequstDe.substring(0,10); //요청일

            str += `
                <tr onClick="seletCnsltDetail(\${cnslt.cnsltInnb})" style="cursor:pointer;"class="text-center">
                    <td>\${cnslt.stdntNo}-\${cnslt.cnsltInnb}</td>
                    <td>\${day}</td>
                    <td>\${time}</td>
                    <td><span style="width:100px; display: inline-block; text-align: center;"  class="badge \${bg} \${text}">\${cnslt.sttus}</span></td>
                    <td>\${regDay}</td>
                </tr>
                `;
        });

        cnsltbody.innerHTML = str;

        /////  모달창에 교수님 리스트 띄우기 /////

      /*   <select class="form-select is-invalid" id="myprofsr" required="">
         */

        const profsrs = result.profsrVOList;
        const modalProfsr = document.querySelector("#myprofsr");
        let modalStr ="<option selected disabled >상담 교수님 선택</option>";

        profsrs.forEach(profsr => {
                let profsrNo = profsr.profsrNo;
                let sklstfNm = profsr.sklstfNm;

                modalStr += `
                        <option value="\${profsrNo}">\${sklstfNm} 교수님</option>
                `;

        });

        modalProfsr.innerHTML = modalStr;
        // modalProfsr.appendChild(modalStr);



        //교수님 선택시 상담 가능시간 노출되기//

        modalProfsr.addEventListener('change', function() {

            const profsrNo = this.value;
            if (profsrNo) {

                fetch(`/counsel/myprof?profsrNo=\${profsrNo}`,{
                    method:"GET"})
                .then(resp => {
                    return resp.json();
                }).then(result => {


                    const lctres = result.lctreTimetableVOList;
                    const cnslts = result.cnsltVOList;

                    document.querySelector("#dateDiv").style.display="block";
                    let datePicker = document.querySelector("#datePicker");
                    let today  = new Date();
                    let yyyy = (String)(today.getFullYear());
                    let mm = String(today.getMonth()+1).padStart(2,'0');
                    let dd = String(today.getDate()).padStart(2,'0');
                    let strToday = `\${yyyy}-\${mm}-\${dd}`;

                    let timeDiv = document.querySelector("#timeDiv");


                    datePicker.addEventListener("change", function() {

                        if (strToday>=datePicker.value) {
                        	Swal.fire({
								title: '알림!',
                        		text: '상담등록은 익일부터 가능합니다.',
                        		icon: 'info',
                        		confirmButtonText: '확인'
                        		});

                            datePicker.value="";
                            return;
                        }

                        let weekend = getWeekend(datePicker.value);

                        if (weekend =="토" || weekend =="일") {
                        	Swal.fire({
								title: '주말 싱담 예약 불가!',
                        		text: '주말에는 상담예약이 어렵습니다.',
                        		icon: 'info',
                        		confirmButtonText: '확인'
                        		});
                            datePicker.value="";
                            return;
                        }


                        //allPeriods = 총 교시 ex 1교시, 2교시 ~ 9교시
                        const allPeriods = [1,2,3,4,5,6,7,8,9];
                        const excludedPeriods = new Set();

                        lctres.forEach(lctre => {
                            if (weekend === lctre.lctreDfk) {
                                const start = lctre.beginTm;
                                const end = lctre.endTm;

                                for(let i = start ; i <=end; i++) {
                                    excludedPeriods.add(i);
                                }
                            }
                        })

                        cnslts.forEach(cnslt => {

                            const cnsltRequstDe = cnslt.cnsltRequstDe.substring(0,10);
                            if (datePicker.value == cnsltRequstDe) {
                                excludedPeriods.add(parseInt(cnslt.cnsltRequstHour));
                            }
                        })

                        //교수님 상담 안되는 시간 필터링
                        const availPeriods = allPeriods.filter(period => {
                            return !excludedPeriods.has(period);
                        })

                        let modalTimeStr ="<option selected disabled >상담 시간 선택</option>";
                        const modalTimeSelected = document.querySelector("#modalTimeSelected");

                        availPeriods.forEach(period => {
                            modalTimeStr += `
                                <option value="\${period}">\${period}교시</option>
                            `;
                        })

                        modalTimeSelected.innerHTML = modalTimeStr;


                        timeDiv.style.display = "block";

                        contentDiv.style.display = "block";

                    })


                }).catch(error => {
                    console.log("error : ",error);
                })



            }//end if
        });//end modalProfsr




    }).catch(err=>{
        console.err("에러렁",err);
    })
}//end getStdList


//modal 교수님 리스트에 따라



/**
 *  여기가 전체 시~ 작
 */
document.addEventListener("DOMContentLoaded",function()  {
    getStdList();



})

</script>




<!-- 상담 신청 Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form>
        <div class="modal-body">
                <input type="hidden" id="modalStdntNo"/ >
    <!-- 입력 받아야 할것 -->
            <label for="myprofsr" class="form-label">상담 교수님 선택</label>
            <select class="form-select form-select-lg" id="myprofsr" required="">
            </select>
            <br>
            <div class="mb-3" id="dateDiv" style="display:none" >
                <label for="datePicker" class="form-label">날짜 선택</label>
                <input type="date" class="form-control" id="datePicker" >
            </div>
            <br>
            <div id="timeDiv" style="display:none" >
                <label for="modalTimeSelected" class="form-label">상담 교시 선택</label>
                <select class="form-select form-select-lg" id="modalTimeSelected" required="">
                </select>
            </div>
            <br>
            <div id="contentDiv" style="display:none" >
                <label for="modalContent" class="form-label">상담 신청 내용</label>
                <input type="text" class="form-control" id="modalContent" />
            </div>

        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" id="modalClose" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="reserveCounsel">상담 신청</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
    //상담신청 버튼
    document.querySelector("#reserveCounsel").addEventListener("click",function() {
        //   <button type="button" class="btn btn-primary" id="reserveCounsel">상담 받기</button>
        //상담받기 요청하기 (insert)

        let profsrNo =  document.querySelector("#myprofsr").value;

        let cnsltRequstDe = document.querySelector("#datePicker").value;
        let cnsltRequstHour = document.querySelector("#modalTimeSelected").value;
        let cnsltRequstCn = document.querySelector("#modalContent").value;
        const stdntNo = document.querySelector("#modalStdntNo").value;


        let data = {
            "profsrNo" : profsrNo,
            "cnsltRequstDe" : cnsltRequstDe,
            "cnsltRequstHour" : cnsltRequstHour,
            "cnsltRequstCn" : cnsltRequstCn,
            "stdntNo" : stdntNo
        }

        fetch("/counsel/create",{
            method:"POST",
            headers:{
                "Content-Type":"application/json;charset:UTF-8"
            },
            body:JSON.stringify(data)
        }).then(resp => {
            return resp.json();
        }).then(result => {
            document.querySelector("#myprofsr").value ="";
            document.querySelector("#datePicker").value ="";
            document.querySelector("#modalTimeSelected").value ="";
            document.querySelector("#modalContent").value ="";
            dateDiv.style.display= "none";
            timeDiv.style.display= "none";
            contentDiv.style.display= "none";

            document.querySelector("#modalClose").click();
            getStdList();
        }).catch(error => {
            console.error(error);
        })
    })

    //목록 디테일 보기
    function seletCnsltDetail(cnsltInnb) {
        fetch(`/counsel/seletCnsltDetail?cnsltInnb=\${cnsltInnb}`,{
            method:"GET"
        }).then(resp => {
            return resp.json();
        }).then(result => {
            console.log(result);
            console.log(result.cnsltVO);
            console.log(result.cnsltVO.cnsltInnb);
            let cnsltVO = result.cnsltVO;
            const cnsltDetailModalEl = document.querySelector("#cnsltDetailModal");
            const cnsltDetailModal = new bootstrap.Modal(cnsltDetailModalEl);

            document.querySelector("#modal-cnsltInnb").value = cnsltVO.stdntNo+" - "+cnsltVO.cnsltInnb ;
            document.querySelector("#modal-cnsltRequstDe").value = cnsltVO.cnsltRequstDe.substring(0,10);
            document.querySelector("#modal-cnsltRequstHour").value = cnsltVO.cnsltRequstHour + " 교시";
            document.querySelector("#modal-cnsltRequstCn").value = cnsltVO.cnsltRequstCn;
            document.querySelector("#modal-reqstDe").value = cnsltVO.reqstDe.substring(0,10);


            if (cnsltVO.sttus =="1") {
            	cnsltVO.sttus = "상담예약 진행중";
            } else if (cnsltVO.sttus =="2") {
            	cnsltVO.sttus = "상담예약 완료";
            }else if (cnsltVO.sttus =="3") {
            	cnsltVO.sttus = "상담 취소";
            }else if (cnsltVO.sttus =="4") {
            	cnsltVO.sttus = "상담 완료";
            }//진행상태

            document.querySelector("#modal-sttus").value = cnsltVO.sttus;
            document.querySelector("#modal-sklstfNm").value = cnsltVO.sklstfNm;

            const modalcnsltMthd = document.querySelector("#modal-cnsltMthd");
            if (cnsltVO.cnsltMthd ==null) {
                modalcnsltMthd.parentElement.style.display="none";
            } else {
                modalcnsltMthd.value = cnsltVO.cnsltMthd;
                modalcnsltMthd.parentElement.style.display="block";
            }

            const modalcanclReason = document.querySelector("#modal-canclReason");
            if (cnsltVO.canclReason ==null) {
                modalcanclReason.parentElement.style.display="none";
            } else {
                modalcanclReason.value = cnsltVO.canclReason;
                modalcanclReason.parentElement.style.display="block";
            }

            const cnsltResult = document.querySelector("#modal-cnsltResult"); //상담완료
            if (cnsltVO.cnsltResult ==null) {
            	cnsltResult.parentElement.style.display="none";
            } else {
            	cnsltResult.value = cnsltVO.cnsltResult;
            	cnsltResult.parentElement.style.display="block";
            }

            cnsltDetailModal.show();

        }).catch(error => {
            console.log(error);
        })
    }


</script>


<!--
cnsltInnb 상담번호 : stdntNo-cnsltInnb학생번호-상담고유번호
상담요청일 :
cnsltRequstDe: "2025-10-30T00:00:00.000+00:00"
상담요청 교시 :
cnsltRequstHour: "6" + 교시
상담요청내용 :
cnsltRequstCn : "ㄱㄱ"
신청일
reqstDe: "2025-10-28T06:53:50.000+00:00"
진행상태  : 상태
sttus : "1"
상담 교수님 : 교직원명
sklstfNm : "김교수"

상담방식 :              //상담예약완료 (상태 2,4 일 경우 보임)
cnsltMthd: null
취소이유 :              //상담취소 (상태)
canclReason

상담결과 :
cnsltResult: null




-->



<!-- 상담 상세 modal -->
<div class="modal fade" id="cnsltDetailModal" tabindex="-1" aria-labelledby="cnsltDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="cnsltDetailModalLabel">상담 상세</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body container-fluid">
        <form>
        <div class="row">
       		<div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-cnsltInnb" class="col-form-label">상담번호</label>
	            <input type="text" class="form-control bg-light" id="modal-cnsltInnb" readonly>
	          </div>
	        </div>
	        <div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-cnsltRequstDe" class="col-form-label">상담요청일</label>
	            <input type="text" class="form-control bg-light" id="modal-cnsltRequstDe" readonly>
	          </div>
	        </div>
	        <div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-cnsltRequstHour" class="col-form-label">상담요청 교시</label>
	            <input type="text" class="form-control bg-light" id="modal-cnsltRequstHour" readonly>
	          </div>
	        </div>
        </div>
		<div class="row">
	      <div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-sttus" class="col-form-label">신청상태</label>
	            <input type="text" class="form-control bg-light" id="modal-sttus" readonly>
	          </div>
          </div>
          <div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-reqstDe" class="col-form-label">신청일</label>
	            <input type="text" class="form-control bg-light" id="modal-reqstDe" readonly>
	          </div>
          </div>
          <div class="col-md-4">
	          <div class="mb-3">
	            <label for="modal-sklstfNm" class="col-form-label">담당 교수님</label>
	            <input type="text" class="form-control bg-light" id="modal-sklstfNm" readonly>
	          </div>
          </div>
        </div>
          <div class="mb-3">
            <label for="modal-cnsltRequstCn" class="col-form-label">상담요청 내용</label>
            <input type="text" class="form-control bg-light" id="modal-cnsltRequstCn" readonly>
          </div>
          <div class="mb-3" style="display:none">
            <label for="modal-cnsltMthd" class="col-form-label">상담방식</label>
            <input type="text" class="form-control bg-light" id="modal-cnsltMthd" readonly>
          </div>
          <div class="mb-3" style="display:none">
            <label for="modal-canclReason" class="col-form-label">취소 사유</label>
            <input type="text" class="form-control bg-light" id="modal-canclReason" readonly>
          </div>
          <div class="mb-3" style="display:none">
            <label for="modal-cnsltResult" class="col-form-label">상담 결과</label>
            <textarea class="form-control bg-light" id="modal-cnsltResult" readonly></textarea>
          </div>

        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

