<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

    <div class="row pt-3 px-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
                <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
                <li class="breadcrumb-item active" aria-current="page">성적 관리</li>
            </ol>
        </nav>

        <div class="col-12 page-title mt-2">
            <h2 class="fw-semibold">성적 관리</h2>
            <div class="my-4 p-0 bg-primary" style="width:100px;height:5px;"></div>
        </div>
    </div>

    <div class="row pt-3 px-5">
        <div class="col-xxl-12 col-12">

            <div class="d-flex justify-content-end mb-3 mt-0">
                <input type="text" id="lectureSearch" class="form-control w-25" placeholder="강의명 / 코드 / 연도 / 학기 검색">
                <button type="submit" class="btn btn-primary ms-2">검색</button>
            </div>
        
            <c:if test="${empty allCourseList}">
                <div class="alert alert-warning text-center">등록된 강의가 없습니다.</div>
            </c:if>

            <c:if test="${not empty allCourseList}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="table-light">
                            <tr>
                                <th>No.</th>
                                <th class="text-start">강의명</th>
                                <th>강의코드</th>
                                <th>강의실</th>
                                <th>이수구분</th>
                                <th>개설년도</th>
                                <th>개설학기</th>
                                <th>성적입력</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="course" items="${allCourseList}" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td class="text-start fw-semibold">${course.lctreNm}</td>
                                    <td>${course.lctreCode}</td>
                                    <td>${course.lctrum}</td>
                                    <td>${course.complSe}</td>
                                    <td>${course.estblYear}</td>
                                    <td>${course.estblSemstr}</td>
                                    <td>
                                        <a href="/prof/grade/main/detail/${course.estbllctreCode}" class="btn btn-sm btn-primary">보기</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

        </div>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function () {

  const searchInput = document.getElementById("lectureSearch");
  const table = document.querySelector("table");
  const rows = table.getElementsByTagName("tr");
  const searchBtn = document.querySelector(".btn.btn-primary");

  searchBtn.addEventListener("click", (e)=>{
    e.preventDefault();
    searchInput.dispatchEvent(new Event("keyup"));
  });

  searchInput.addEventListener("keyup", ()=>{
    const keyword = searchInput.value.toLowerCase();

    for (let i =1; i<rows.length; i++){
      rows[i].style.display = rows[i].innerText.toLowerCase().includes(keyword) ? "" : "none";
    }
  });

});
</script>

<%@ include file="../footer.jsp" %>