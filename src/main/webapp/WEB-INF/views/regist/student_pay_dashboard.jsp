<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active">등록금 납부</li>
        </ol>
    </nav>

    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">등록금 납부 현황</h2>
        <div class="my-3 bg-primary" style="width:120px;height:5px;"></div>
    </div>
</div>


<!-- ======================= 등록금 현황 ======================= -->
<div class="row px-5">
    <div class="card shadow-sm border-0">
        <div class="card-body">
            <h4 class="fw-bold mb-3">최근 학기 납부 정보</h4>
            <p class="text-muted mb-4">현재학기 : ${year}년 / ${semstr}</p>

            <table class="table table-hover align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th>학번</th><th>이름</th><th>금액</th><th>장학금</th>
                    <th>상태</th><th>방식</th><th>납부일</th>
                    <th>가상계좌</th><th>연도</th><th>학기</th>
                    <th>신청일</th><th>납부마감</th>
                    <th>영수증</th><th>결제</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="p" items="${payList}">
                    <tr>
                        <td>${p.stdntNo}</td>
                        <td>${p.stdntNm}</td>

                        <td class="fw-bold"><fmt:formatNumber value="${p.payGld}" />원</td>

                        <td>
                            <c:choose>
                                <c:when test="${p.schlship == 0}">
                                    <span class="text-muted">없음</span>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${p.schlship}" />원
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <span class="badge ${p.paySttus eq '완납' ? 'bg-success' : 'bg-danger'}">${p.paySttus}</span>
                        </td>

                        <td>${p.payMthd != null ? p.payMthd : '-'}</td>
                        <td>${p.payDe != null ? p.payDe : '-'}</td>
                        <td>${p.vrtlAcntno != null ? p.vrtlAcntno : '-'}</td>

                        <td>${p.rqestYear}</td>
                        <td>${p.rqestSemstr}</td>
                        <td>${p.rqestDe}</td>
                        <td>${p.payEndde}</td>

                        <!-- ★ PDF = 새 팝업으로 띄우기 -->
                        <td>
                            <c:if test="${p.paySttus eq '완납'}">
                                <button class="btn btn-dark btn-sm" onclick="openPDF('${p.stdntNo}')">보기</button>
                            </c:if>
                        </td>

                        <td>
                            <c:if test="${p.paySttus ne '완납'}">
                                <button class="btn btn-outline-primary btn-sm"
                                        onclick="openPay('${p.stdntNo}','${p.registCtNo}','${p.payGld}','${p.schlship}','${p.rqestYear}','${p.rqestSemstr}')">
                                    결제하기
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>

        </div>
    </div>
</div>


<!-- ======================= 결제 처리 Modal ======================= -->
<div class="modal fade" id="payModal">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content shadow-lg border-0">

            <div class="modal-header">
                <h5 class="fw-bold">등록금 결제 확인</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <table class="table table-bordered align-middle mb-3">
                    <tbody>
                        <tr><th style="width:120px;">학번</th><td id="mStd"></td></tr>
                        <tr><th>적용 학기</th><td id="mYS"></td></tr>
                        <tr><th>장학금</th><td id="mSch"></td></tr>
                    </tbody>
                </table>

                <div class="border rounded bg-light p-3 text-center mb-4">
                    <div class="fw-bold">최종 결제 금액</div>
                    <div class="fs-4 fw-bold text-primary mt-1" id="mAmt"></div>
                </div>

                <label class="fw-bold mb-2">결제 방식 선택</label>
                <select id="mMethod" class="form-select">
                    <option value="KAKAO">카카오페이</option>
                    <option value="TOSS">토스페이</option>
                </select>

            </div>

            <div class="modal-footer d-flex justify-content-between">
                <button class="btn btn-danger" data-bs-dismiss="modal" style="width:48%;">취소</button>
                <button class="btn btn-primary fw-bold" id="doPay" style="width:48%;">결제 진행</button>
            </div>

        </div>
    </div>
</div>



<script>
let stdNo, ctNo, amt, sch;
let modalPay;

// 결제 처리
document.addEventListener("DOMContentLoaded", ()=>{

    modalPay = new bootstrap.Modal(document.getElementById("payModal"));

    document.getElementById("doPay").onclick = ()=>{

        fetch("/payinfo/payment/start",{
            method:"POST",
            headers:{ "Content-Type":"application/json"},
            body:JSON.stringify({
                stdntNo:stdNo,
                registCtNo:ctNo,
                amount:amt,
                method:document.getElementById("mMethod").value
            })
        })
        .then(r=>r.json())
        .then(res=>{
            if(res.url){
                let payWin = window.open(res.url,"PAY_WINDOW","width=480,height=720,left=100,top=50");
                if(!payWin || payWin.closed){
                    alert("팝업이 차단되었습니다. 브라우저 팝업 허용 필요");
                }
            }
        })
    };
});


// 결제 모달 오픈
function openPay(a,b,c,d,y,s){
    stdNo=a; ctNo=b; amt=c; sch=d;

    document.getElementById("mStd").innerText=a;
    document.getElementById("mAmt").innerText=Number(c).toLocaleString()+"원";
    document.getElementById("mSch").innerText=d==0?"없음":Number(d).toLocaleString()+"원";
    document.getElementById("mYS").innerText=y+"년 "+s;

    modalPay.show();
}


// PDF 팝업 열기
function openPDF(no){
    window.open(
        "/payinfo/receipt/"+no,
        "RECEIPT_VIEW",
        "width=900,height=1000,left=100,top=30,resizable=yes"
    );
}
</script>

<%@ include file="../footer.jsp" %>
