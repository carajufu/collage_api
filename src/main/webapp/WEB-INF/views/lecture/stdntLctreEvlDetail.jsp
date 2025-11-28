<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">성적</a></li>
            <li class="breadcrumb-item"><a href="/stdnt/lecture/main/All">강의 평가</a></li>
            <li class="breadcrumb-item active" aria-current="page">${lectureInfo.lctreNm}</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">${lectureInfo.lctreNm}</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
        <h2 class="border-bottom pb-3 mb-4 fw-semibold">강의평가</h2>

        <!-- 강의 기본 정보 -->
        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-light fw-semibold">강의 정보</div>
            <div class="card-body p-4">
                <table class="table table-bordered align-middle mb-0">
                    <tbody>
                    <tr>
                        <th class="table-light" style="width:20%;">강의명</th>
                        <td>${lectureInfo.lctreNm}</td>
                    </tr>
                    <tr>
                        <th class="table-light">교수명</th>
                        <td>${lectureInfo.profsrNm}</td>
                    </tr>
                    <tr>
                        <th class="table-light">운영년도</th>
                        <td>${lectureInfo.estblYear}</td>
                    </tr>
                    <tr>
                        <th class="table-light">학기</th>
                        <td>${lectureInfo.estblSemstr}</td>
                    </tr>
                    <tr>
                        <th class="table-light">취득학점</th>
                        <td>${lectureInfo.acqsPnt}학점</td>
                    </tr>
                    <tr>
                        <th class="table-light">이수구분</th>
                        <td>${lectureInfo.complSe}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 강의 평가 입력 -->
        <div class="card shadow-sm">
            <div class="card-header bg-light fw-semibold">평가 항목</div>
            <div class="card-body p-4">

                <input type="hidden" id="estbllctreCode" value="${estbllctreCode}" />

                <form id="evalForm">

                    <c:forEach var="item" items="${evalItemList}" varStatus="vs">
                        <div class="mb-4 pb-3 border-bottom eval-block">

                            <input type="hidden"
                                   class="lctreEvlInnb"
                                   value="${item.lctreEvlInnb}" />

                            <!-- 문항 내용 -->
                            <p class="fw-semibold mb-3">
                                ${vs.count}. ${item.evlCn}
                            </p>

                            <!-- 점수 선택 (1~5점) -->
                            <div class="d-flex gap-2 justify-content-center">
                                <c:forEach var="score" begin="1" end="5">
                                    <input type="radio"
                                           class="btn-check"
                                           name="score_group_${vs.index}"
                                           id="score_${vs.index}_${score}"
                                           value="${score}">
                                    <label class="btn btn-outline-primary w-100"
                                           for="score_${vs.index}_${score}">
                                        ${score}점
                                    </label>
                                </c:forEach>
                            </div>

                            <!-- 주관식 의견 -->
                            <textarea class="form-control mt-3 eval-cn"
                                      rows="2"
                                      placeholder="주관식 의견을 입력하세요."></textarea>

                        </div>
                    </c:forEach>

                    <div class="d-flex justify-content-end mt-4">
                        <a href="/stdnt/lecture/main/All" class="btn btn-outline-primary me-2">목록으로</a>
                        <button type="button" id="submitBtn" class="btn btn-primary">평가 제출하기</button>
                    </div>

                </form>

            </div>
        </div>

    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {

    const submitBtn = document.getElementById("submitBtn");

    submitBtn.addEventListener("click", () => {

        const blocks = document.querySelectorAll(".eval-block");

        const lctreEvlInnb = [];
        const evlScore = [];
        const evlCn = [];

        for (let i = 0; i < blocks.length; i++) {
            const block = blocks[i];

            const innb = block.querySelector(".lctreEvlInnb").value;
            const checked = block.querySelector("input[type='radio']:checked");
            const textarea = block.querySelector(".eval-cn");

            if (!checked) {
                alert((i + 1) + "번 항목의 점수를 선택하세요.");
                return;
            }

            lctreEvlInnb.push(Number(innb));
            evlScore.push(Number(checked.value));
            evlCn.push(textarea.value.trim());
        }

        fetch("/stdnt/lecture/save", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                estbllctreCode: document.getElementById("estbllctreCode").value,
                lctreEvlInnb: lctreEvlInnb,
                evlScore: evlScore,
                evlCn: evlCn
            })
        })
        .then(r => r.text())
        .then(result => {
            if (result === "success") {
                alert("강의평가가 정상적으로 제출되었습니다.");
                location.href = "/stdnt/lecture/main/All";
            } else {
                alert("오류가 발생했습니다.");
            }
        })
        .catch(err => {
            console.error(err);
            alert("서버 통신 중 오류가 발생했습니다.");
        });

    });
});
</script>

<%@ include file="../footer.jsp" %>