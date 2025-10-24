<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">
			
			<h2 class="section-title">상담시간관리</h2>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>누적 상담 처리 건수</h5>
                        <p class="text-muted mb-0">45건</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>이번년도 상담 처리 건수</h5>
                        <p class="text-muted mb-0">10건</p>
                    </div>
                </div>

            <hr class="my-4">

        <h2 class="section-title">상담시간관리</h2>
        
        <table class="table table-bordered table-hover bg-white">
            <thead class="table-light">
                <tr>
                    <th>상담번호</th>
                    <th>상담일</th>
                    <th>상담시간</th>
                    <th>상태</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody id="cnstbody">
                
                <tr>
                    <td>H2025001</td>
                    <td><span class="badge bg-warning text-dark">상담</span></td>
                    <td>휴학 기간 만료</td>
                    <td>2025-03-02</td>
                </tr>

                <tr>
                    <td>R2024002</td>
                    <td><span class="badge bg-success">휴학</span></td>
                    <td>개인 사유</td>
                    <td>2024-09-01</td>
                </tr>

                <tr>
                    <td>N2024001</td>
                    <td><span class="badge bg-primary">재학</span></td>
                    <td>신입학</td>
                    <td>2024-03-02</td>
                </tr>
            </tbody>
        </table>
        </div>







        </div>
    </div>
</main>

<%@ include file="../footer.jsp" %>


<script>


//list불러오는 비동기 함수
function getList() {
    fetch ("/counsel/getlist",{
        method : "GET",
        headers : {
            "Content-type":"application/json;charset:UTF-8"
        }
    }).then(resp => {
        return resp.json();
    }).then(result => {
        console.log("성공!",result);
        console.log("성공!",result.cnsltAtVOList);
        console.log("rrrseu",result.result);
        const cnsltAts = result.cnsltAtVOList;
        const cnstbody = document.querySelector("#cnstbody");
        let str = "";
        let day = "";
        let hourStart = "";
        let hourEnd = "";
        let time ="";
        let regDay ="";
        let bg = "";
        let text = "";

        cnsltAts.forEach(cnsltAt => {
            if (cnsltAt.sttus =="1") {
                cnsltAt.sttus = "상담대기";
                bg="bg-warning";
                text = "text-dark";
            } else if (cnsltAt.sttus =="2") {
            	cnsltAt.sttus = "상담예약완료";
            	bg="bg-primary";
            	text = "text-white";
            }else if (cnsltAt.sttus =="3") {
            	cnsltAt.sttus = "상담취소";
            	bg="bg-danger";
            	text = "text-white";
            }else if (cnsltAt.sttus =="4") {
            	cnsltAt.sttus = "상담완료";
            	bg="bg-success";
            	text = "text-white";
            }
            
            day = cnsltAt.cnsltBeginDe.substring(0,10);
            hourStart = parseInt(cnsltAt.cnsltBeginDe.substring(11,13));
            hourEnd = hourStart + parseInt(cnsltAt.cnsltPosblTime);
            time = hourStart + " ~ " + hourEnd;
            regDay = cnsltAt.registDt.substring(0,10);

            

            str += `       
                <tr>
                    <td>\${cnsltAt.profsrNo}-\${cnsltAt.cnsltInnb}</td>
                    <td>\${day}</td>
                    <td>\${time}</td>
                    <td><span class="badge \${bg} \${text}">\${cnsltAt.sttus}</span></td>
                    <td>\${regDay}</td>
                </tr>
                `
        });
        
        

        
        cnstbody.innerHTML = str;

    }).catch(err=>{
        console.err("에러렁",err);
    })
}


document.addEventListener("DOMContentLoaded",function()  {
    getList();
})



</script>



<!-- 
list

 -->