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
                        <h5>요청 받은 상담 건수</h5>
                        <p class="text-muted mb-0" id="sumTotal"></p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>총 상담 완료 건수</h5>
                        <p class="text-muted mb-0" id="sumSuccess"></p>
                    </div>
                </div>

            <hr class="my-4">

            <h2 class="section-title">상담 요청 리스트</h2>
                  <div class="text-end">
			    	 <div id="example1_filter" class="dataTables_filter" style="float:right;">
			          <div class="dropup-center dropup">
			            <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
			              진행 상태별 모아보기
			            </button>
			            <ul class="dropdown-menu">
			              <li><a class="dropdown-item status-filter" href="#" value="">전체 보기</a></li>
			              <li><a class="dropdown-item status-filter" href="#" value="1">예약 대기중</a></li>
			              <li><a class="dropdown-item status-filter" href="#" value="2">상담예약 완료</a></li>
			              <li><a class="dropdown-item status-filter" href="#" value="3">상담 취소</a></li>
			              <li><a class="dropdown-item status-filter" href="#" value="4">상담 완료</a></li>
			            </ul>
			          </div>
			          </div>
			      </div>

            <table class="table table-bordered table-hover bg-white">
                <thead class="table-light">
                    <tr class="text-center">
                        <th>상담번호</th>
                        <th>상담요청일</th>
                        <th>상담요청 교시</th>
                        <th>신청상태</th>
                        <th>상담방법</th>
                        <th>상담신청일</th>
                    </tr>
                </thead>
                <tbody id="cnsltbody">

                </tbody>
            </table>
        </div>
        <div class="card-footer clearfix border-0" id="pagingArea">
			<!--  justify-content-center : style="justify-content:center;" -->


		</div>


        </div>
    </div>

<%@ include file="../footer.jsp" %>



<script>



//교수 상담 list불러오는 비동기 함수
function getCnsltList(currentPage = 1, keyword ='') {
    fetch (`/counselprof/proflist?currentPage=\${currentPage}&keyword=\${keyword}`,{
        method : "GET",
        headers : {
            "Content-type":"application/json;charset:UTF-8"
        }
    }).then(resp => {
        return resp.json();
    }).then(result => {
        console.log("result : ",result);
        console.log("cnsltVOList : ",result.cnsltVOList);
        console.log("currentPage : ",result.currentPage);
        console.log("keyword : ",result.keyword);
        console.log("startPage : ",result.startPage);
        console.log("endPage : ",result.endPage);
        console.log("totalPages : ",result.totalPage);

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

        let pagingAreaHTML = document.querySelector("#pagingArea");

        //상담 리스트
        const cnslts = result.cnsltVOList;
        const cnsltbody = document.querySelector("#cnsltbody");

        if (!cnslts || cnslts.length === 0) {
            cnsltbody.innerHTML = `<tr><td colspan="5">요청 받은 상담 내역이 없습니다.</td></tr>`;
            pagingAreaHTML.innerHTML = "";
            return;
        }

        let str = "";
        let day = "";
        let time ="";
        let regDay ="";
        let bg = "";
        let text = "";

        const startPage = result.startPage;
        const endPage = result.endPage;
        const totalPages = result.totalPage;
        const currentKeyword = result.keyword;
        const currentPage = result.currentPage;

        cnslts.forEach(cnslt => {
            if (cnslt.sttus =="1") {
            	cnslt.sttus = "상담예약 대기중";
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
            mthd = cnslt.cnsltMthd;	//상담방법
            if (mthd == null) mthd = "미정";

            str += `
                <tr onClick="seletCnsltDetail(\${cnslt.cnsltInnb})" style="cursor:pointer;"class="text-center">
                    <td>\${cnslt.stdntNo}-\${cnslt.cnsltInnb}</td>
                    <td>\${day}</td>
                    <td>\${time}</td>
                    <td><span style="width:100px; display: inline-block; text-align: center;" class="badge \${bg} \${text}">\${cnslt.sttus}</span></td>
                    <td>\${mthd}</td>
                    <td>\${regDay}</td>
                </tr>
                `;
        });

        cnsltbody.innerHTML = str;

        let pagingArea = "";
        pagingArea += "<ul class='pagination pagination-sm m-0 justify-content-center'>";

        if(startPage > 5) {
        	pagingArea += `<li class='page-item'><a class='page-link'
                            href='javascript:getCnsltList(\${startPage-5}),"\${currentKeyword}")'>«</a></li>`;
        }//end if

        for(let pNo=startPage;pNo<=endPage;pNo++) {

            const activeClass = (pNo ===currentPage) ? 'active' : '';

        	pagingArea += `<li class='page-item \{activeClass}'><a class='page-link'
                            href='javascript:getCnsltList(\${pNo},"\${currentKeyword}")'>\${pNo}</a></li>`;
        }//end for

        if(endPage < totalPages) {
        	pagingArea += `<li class='page-item'><a class='page-link'
                            href='javascript:getCnsltList(\${startPage+5}),"\${currentKeyword}")'>»</a></li>`;
        }//end if

        pagingArea += "</ul>";
        pagingArea += `<input type='hidden' value='\${currentPage}' id='currentPageForModal'>`;

        console.log("pagingArea",pagingArea);
        pagingAreaHTML.innerHTML = pagingArea;




    }).catch(error=>{
        console.err("에러렁",error);
    })
}//end getCnsltList




/**
 *  여기가 전체 시~ 작
 */
document.addEventListener("DOMContentLoaded",function()  {
    getCnsltList();

    // ================================
   	// 상태별로 모아보기 : ex)상담완료 선택시 상담완료 리스트만 보기

   	const statusFilters = document.querySelectorAll(".status-filter");
   	const dropdownBtn = document.querySelector(".dropdown-toggle");

   	statusFilters.forEach(filter => {
		filter.addEventListener("click", function(e) {
			e.preventDefault();

			let statusValue = this.getAttribute("value");
			let statusText = this.textContent;

			dropdownBtn.textContent = statusText;

			getCnsltList(1,statusValue);

		})
   	})



	//==================================

      const btnAccept = document.querySelector("#btnAccept");   //상담수락
      const btnCancle = document.querySelector("#btnCancle");   //상담취소
      const btnComplete = document.querySelector("#btnComplete");//상담완료
      const cnsltMthd = document.querySelector("#modal-cnsltMthd"); //상담방법
      const canclReason = document.querySelector("#modal-canclReason"); //취소이유
      const cnsltResult = document.querySelector("#modal-cnsltResult"); //상담완료

      const cnsltInnb = document.querySelector("#modal-cnsltInnb"); //상담번호
      const modalClose = document.querySelector("#modalClose"); //모달창


    //상담 수락 버튼 클릭시 상태
      btnAccept.addEventListener("click",function() {
        if (cnsltMthd.value=="null") {
          console.log("상담방법null  일때:",cnsltMthd.value)
          Swal.fire({
				title: '요청',
				text: '상담방법을 선택하세요!',
				icon: 'info',
				confirmButtonText: '확인'
			});

          cnsltMthd.focus();
          return;
        }

        console.log("아아디? 뭔가 있을때  일때:",cnsltInnb.value);

        let data = {
          "cnsltInnb" : cnsltInnb.value,
          "sttus" : "2",
          "cnsltMthd" : cnsltMthd.value
        }

        fetch("/counselprof/patchAccept",{
          method:"PATCH",
          headers : {
            "Content-type" : "application/json;charset:UTF-8"
          },
          body : JSON.stringify(data)
        }).then(resp => {
            return resp.json();
        }).then(result => {
          console.log("성공",result);
          modalClose.click();
          const currentPageForModal = document.querySelector("#currentPageForModal").value;
          console.log("currentPageForModal",currentPageForModal);
          getCnsltList(currentPageForModal);

        }).catch(error => {
          console.error("에러",error);
        })



      })

      //취소버튼 클릭시
      btnCancle.addEventListener("click",function() {
        if (canclReason.value =="" ) {
          canclReason.parentElement.style.display = "block";
          canclReason.focus();
          Swal.fire({
				title: '요청',
				text: '취소 이유를 작성하세요!',
				icon: 'info',
				confirmButtonText: '확인'
			});

          return;
        }

        let data = {
          "cnsltInnb" : cnsltInnb.value,
          "sttus" : "3",
          "canclReason" : canclReason.value
        }

        fetch("/counselprof/patchCancl",{
          method:"PATCH",
          headers : {
            "Content-type" : "application/json;charset:UTF-8"
          },
          body : JSON.stringify(data)
        }).then(resp => {
            return resp.json();
        }).then(result => {
          console.log("성공",result);
          modalClose.click();
          const currentPageForModal = document.querySelector("#currentPageForModal").value;
          console.log("currentPageForModal",currentPageForModal);
          getCnsltList(currentPageForModal);
        }).catch(error => {
          console.error("에러",error);
        })

      })

      btnComplete.addEventListener("click",function() {
        if (cnsltResult.value =="" ) {
          cnsltResult.parentElement.style.display = "block";
          cnsltResult.focus();
          Swal.fire({
				title: '요청',
				text: '상담결과를 작성해주세요. 상담결과는 학생과 공유합니다.',
				icon: 'info',
				confirmButtonText: '확인'
			});

          return;
        }

        let data = {
          "cnsltInnb" : cnsltInnb.value,
          "sttus" : "4",
          "cnsltResult" : cnsltResult.value
        }

        fetch("/counselprof/patchResult",{
          method:"PATCH",
          headers : {
            "Content-type" : "application/json;charset:UTF-8"
          },
          body : JSON.stringify(data)
        }).then(resp => {
            return resp.json();
        }).then(result => {
          console.log("성공",result);

          modalClose.click();
          const currentPageForModal = document.querySelector("#currentPageForModal").value;
          console.log("currentPageForModal",currentPageForModal);
          getCnsltList(currentPageForModal);

        }).catch(error => {
          console.error("에러",error);
        })

      })


})

</script>




<script>

  

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

            document.querySelector("#modal-cnsltInnb").value = cnsltVO.cnsltInnb ;
            document.querySelector("#modal-cnsltRequstDe").value = cnsltVO.cnsltRequstDe.substring(0,10);
            document.querySelector("#modal-cnsltRequstHour").value = cnsltVO.cnsltRequstHour + " 교시";
            document.querySelector("#modal-cnsltRequstCn").value = cnsltVO.cnsltRequstCn;
            document.querySelector("#modal-reqstDe").value = cnsltVO.reqstDe.substring(0,10);
            document.querySelector("#modal-stdntNo").value = cnsltVO.stdntNo;



            const btnAccept = document.querySelector("#btnAccept");   //상담수락
            const btnCancle = document.querySelector("#btnCancle");   //상담취소
            const btnComplete = document.querySelector("#btnComplete");//상담완료
            const cnsltMthd = document.querySelector("#modal-cnsltMthd"); //상담방법
            const canclReason = document.querySelector("#modal-canclReason"); //취소이유
            const cnsltResult = document.querySelector("#modal-cnsltResult"); //상담완료

            const cnsltMthdVideo = document.querySelector("#modal-cnsltMthd-video"); //상담방법-비디오버튼


            cnsltMthd.value = cnsltVO.cnsltMthd;
            canclReason.value = cnsltVO.canclReason;
            cnsltResult.value = cnsltVO.cnsltResult;

            cnsltMthdVideo.parentElement.style.display="none";

            if (cnsltMthd.value =="VIDEO" && cnsltVO.sttus =="2") {
            	cnsltMthdVideo.parentElement.style.display="block";
            }


            /*
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
                modalcanclReason.value = cnsltVO.cnsltMthd;
                modalcanclReason.parentElement.style.display="block";
            }

            */

            btnAccept.style.display="none";
            btnCancle.style.display="none";
            btnComplete.style.display="none";


            canclReason.parentElement.style.display = "none";
            cnsltResult.parentElement.style.display = "none";

            cnsltMthd.removeAttribute('disabled');
            cnsltMthd.classList.remove('bg-light');

            canclReason.removeAttribute('readonly','');
            canclReason.classList.remove('bg-light');
            cnsltResult.removeAttribute('readonly','');
            cnsltResult.classList.remove('bg-light');

            if (cnsltVO.sttus =="1") {
            	cnsltVO.sttus = "상담예약 진행중";
                btnAccept.style.display="block";
                btnCancle.style.display="block";
            } else if (cnsltVO.sttus =="2") {
            	cnsltVO.sttus = "상담예약 완료";
              btnCancle.style.display="block";
              btnComplete.style.display="block";
              //싱담방식 :속성 readonly 클래스 bg-light
              cnsltMthd.setAttribute('disabled','');
              cnsltMthd.classList.add('bg-light');
            }else if (cnsltVO.sttus =="3") {
            	cnsltVO.sttus = "상담 취소";
              //상담방식  :속성 readonly 클래스 bg-light
              cnsltMthd.setAttribute('disabled','');
              cnsltMthd.classList.add('bg-light');
              cnsltMthd.parentElement.style.display = "none";
              //상담 취소  :속성 readonly 클래스 bg-light
              canclReason.parentElement.style.display = "block";
              canclReason.setAttribute('readonly','');
              canclReason.classList.add('bg-light');
            }else if (cnsltVO.sttus =="4") {
              cnsltVO.sttus = "상담 완료";
              //상담방식  :속성 readonly 클래스 bg-light
              cnsltMthd.setAttribute('disabled','');
              cnsltMthd.classList.add('bg-light');
              //상담완료  :속성 readonly 클래스 bg-light
              cnsltResult.parentElement.style.display = "block";
              cnsltResult.setAttribute('readonly','');
              cnsltResult.classList.add('bg-light');

            }//진행상태

            document.querySelector("#modal-sttus").value = cnsltVO.sttus;
            document.querySelector("#modal-stdntNm").value = cnsltVO.stdntNm;






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
    <div class="modal-content">
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
	              <label for="modal-stdntNm" class="col-form-label">상담 학생</label>
	              <input type="text" class="form-control bg-light" id="modal-stdntNm" readonly>
                <input type="hidden" id="modal-stdntNo" />
	            </div>
	          </div>
          </div>

            <div class="mb-3">
              <label for="modal-cnsltRequstCn" class="col-form-label">상담요청 내용</label>
              <input type="text" class="form-control bg-light" id="modal-cnsltRequstCn" readonly>
            </div>

		   <div class="row ">
	          <div class="col-md-6">
		          <div class="mb-3">
		              <label for="modal-cnsltMthd" class="col-form-label">상담방식</label>
		              <select class="form-select form-select-lg" id="modal-cnsltMthd" required="">
		                <option selected disabled value=null >상담방식 선택</option>
		                <option value="OFFLINE">OFFLINE</option>
		                <option value="VIDEO">VIDEO</option>
		          	  </select>
		          </div>
	          </div>
	          <div class="col-md-6 mt-4" >
	          	<span class="col-form-label"> 상담일, 상담시간에 아래 버튼을 클릭해서 video 상담을 시작하세요.</span><br/>
	          	<button type="button" id="modal-cnsltMthd-video" class="btn btn-primary" onClick="startVideoConsult()">Video 상담 시작</button>
	          </div>
	      </div>
          <div class="mb-3" style="display:none">
            <label for="modal-canclReason" class="col-form-label">취소 사유</label>
            <textarea class="form-control" id="modal-canclReason"></textarea>
          </div>
          <div class="mb-3" style="display:none">
            <label for="modal-cnsltResult" class="col-form-label">상담 결과</label>
            <textarea class="form-control" id="modal-cnsltResult"></textarea>
          </div>


        </form>
      </div>
      <div class="modal-footer">

        <button type="button" class="btn btn-primary" style="display:none" id="btnAccept">상담수락</button> <!--예약 대기중 상태만 보임 예약하거나 취소하면 안보임-->
        <button type="button" class="btn btn-danger" style="display:none" id="btnCancle">상담취소</button> <!-- 취소사유썻는지 확인하고 취소처리 취소 후 안보임-->
        <button type="button" class="btn btn-success" style="display:none" id="btnComplete"">상담완료</button> <!-- 취소사유썻는지 확인하고 취소처리 취소 후 안보임
         -->
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="modalClose">Close</button>
      </div>
    </div>
  </div>
</div>
