<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<style>
    body{
        background:#f2f2f2;
        margin:0;
        padding:20px 0;
        font-family:'Pretendard',sans-serif;
    }

    .receipt-page{
        width:900px;
        margin:0 auto;
        background:white;
        padding:45px 55px;
        border:1px solid #111;
        box-sizing:border-box;
    }

    /* 상단문서형태 */
    .doc-header{
        width:100%;
        text-align:center;
        margin-bottom:25px;
    }
    .doc-header .title{
        font-size:26px;
        font-weight:800;
        margin-top:8px;
        letter-spacing:2px;
    }
    .doc-header .sub{
        font-size:14px;
        margin-top:4px;
        color:#444;
    }

    /* 발급번호 + 로고라인 */
    .doc-top-line{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:15px;
    }
    .doc-top-line img{
        height:45px;
        object-fit:contain;
    }
    .doc-top-line .issue-info{
        font-size:13px;
        text-align:right;
        line-height:1.5;
    }

    /* 공문테이블 공통 */
    table.StdTbl{
        width:100%;
        border-collapse:collapse;
        font-size:13px;
    }
    .StdTbl th, .StdTbl td{
        border:1px solid #000;
        padding:6px 8px;
    }
    .StdTbl th{
        background:#f7f7f7;
        font-weight:700;
        width:18%;
        text-align:center;
        white-space:nowrap;
    }

    .mt-25{ margin-top:25px; }
    .mt-15{ margin-top:15px; }

    .final-total{
        width:96%;
        border:2px solid #000;
        padding:12px 15px;
        margin-top:25px;
        font-size:15px;
        display:flex;
        justify-content:space-between;
        align-items:center;
    }
    .final-total .money{
        font-size:21px;
        font-weight:900;
    }

    /* 발급/직인 */
    .sign-area{
        text-align:right;
        margin-top:45px;
        font-size:14px;
        line-height:1.9;
    }
    .sign-area .seal{
        display:inline-block;
        width:90px;height:90px;
        margin-left:10px;
        border:1px solid #000;
        position:relative;overflow:hidden;
        vertical-align:middle;
    }
    .seal img{width:100%;height:100%;object-fit:contain;}

    .notice{
        margin-top:28px;
        font-size:12px;
        line-height:1.6;
    }

    .no-print{
        margin-top:20px;
        padding:10px 16px;
        background:black;
        color:white;
        border:none;
        font-size:14px;
        border-radius:3px;
        cursor:pointer;
        min-width:140px;
    }

    @media print{
        body{background:white;padding:0;}
        .no-print{display:none;}
        .receipt-page{border:none;width:100%;padding:35px;}
    }
</style>




<div class="receipt-page">

    <!-- 로고 + 발급정보 -->
    <div class="doc-top-line">
        <img src="/img/logo/univ-logo-kor-vite.svg" alt="대덕대학교">
        <div class="issue-info">
            영수증 번호 : ${info.payNo}<br>
            발급일 : ${info.payDe}
        </div>
    </div>

    <!-- 제목 -->
    <div class="doc-header">
        <div class="title">등록금 납입 영수증</div>
    </div>

    <!-- 학생 정보 -->
    <table class="StdTbl">
        <tr>
            <th>학번</th><td>${info.stdntNo}</td>
            <th>성명</th><td>${info.stdntNm}</td>
        </tr>
        <tr>
            <th>대학 / 학과</th>
            <td colspan="3">${info.univName} / ${info.subjctName}</td>
        </tr>
        <tr>
            <th>학년</th><td>${info.rqestGrade}학년</td>
            <th>학년도 / 학기</th><td>${info.rqestYear}년 ${info.rqestSemstr}</td>
        </tr>
    </table>

    <!-- 납입 내역 -->
    <table class="StdTbl mt-25">
        <tr>
            <th>구분</th>
            <th>금액</th>
            <th>비고</th>
        </tr>
        <tr>
            <td>등록금</td>
            <td><fmt:formatNumber value="${info.payGld}"/> 원</td>
            <td></td>
        </tr>
        <tr>
            <td>장학금 감면액</td>
            <td><fmt:formatNumber value="${info.schlship}"/> 원</td>
            <td></td>
        </tr>
        <tr>
            <td>기타</td>
            <td>0 원</td>
            <td></td>
        </tr>
    </table>

    <!-- 최종 납입 -->
    <div class="final-total">
        <span>실 납부 금액</span>
        <span class="money">
            <fmt:formatNumber value="${info.payGld - info.schlship}"/> 원
        </span>
    </div>

    <!-- 결재/직인 -->
    <div class="sign-area">
        위 금액을 영수하였음을 증명합니다.<br>
        ${info.rqestYear}년 ${fn:substring(info.payDe,4,6)}월 ${fn:substring(info.payDe,6,8)}일<br>
        대덕대학교 총장
        <span class="seal"><img src="/cert-templates/seal.png"></span>
    </div>

    <div class="notice">
        ※ 본 영수증은 등록금 납부사실에 대한 공식 증명서이며,<br>
        금융기관 제출·장학금 심사·행정 처리에 활용 가능합니다.
    </div>

    <button class="no-print" onclick="window.print()">PDF 출력</button>
    <button class="no-print" onclick="downloadPDF()">PDF 다운로드</button>
</div>



<script>
    async function downloadPDF(){
        const el=document.querySelector(".receipt-page");
        const btns=document.querySelectorAll(".no-print");
        btns.forEach(b=>b.style.display="none");
        const canvas=await html2canvas(el,{scale:2});
        const img=canvas.toDataURL("image/png");
        const pdf=new jspdf.jsPDF("p","mm","a4");
        const w=pdf.internal.pageSize.getWidth();
        const h=canvas.height*(w/canvas.width);
        pdf.addImage(img,"PNG",0,0,w,h);
        pdf.save("등록금_영수증.pdf");
        btns.forEach(b=>b.style.display="inline-block");
    }
</script>
