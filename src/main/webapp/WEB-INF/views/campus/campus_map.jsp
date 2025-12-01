<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <sec:authorize access="hasRole('ROLE_STUDENT')">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_PROF')">
            <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
            </sec:authorize>
            <li class="breadcrumb-item"><a href="#">학교 소개</a></li>
            <li class="breadcrumb-item active" aria-current="page">캠퍼스맵</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">캠퍼스맵</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row px-5 pb-5">
    <div class="col-lg-8 mb-4">
        <div class="card shadow-sm border-0">
            <div class="card-body p-2">
                <img src="/img/map/map.png"
                     usemap="#campusMap" 
                     id="mainMapImg" 
                     class="img-fluid rounded" 
                     alt="캠퍼스 지도" 
                     >

                <map name="campusMap">
				    <area shape="rect" coords="375,271,626,424" 
				          href="#" 
				          data-name="본관" 
				          data-id="B01"
				          data-desc="총장실과 주요 행정 부서가 위치한 <br> 대학의 핵심 건물입니다." 
				          onclick="showDetail(this); return false;">
				    
				    <area shape="rect" coords="420,91,581,191" 
				          href="#" 
				          data-name="행정 본관" 
				          data-id="B02"
				          data-desc="입학·학사·총무 등 대학 운영의 <br> 중심 역할을 하는 행정 지원 건물입니다." 
				          onclick="showDetail(this); return false;">
				    
				    <area shape="rect" coords="223,362,370,474" 
				          href="#" 
				          data-name="중앙 도서관" 
				          data-id="L01"
				          data-desc="다양한 학술자료와 24시간 열람실을 갖춘 <br> 학생들의 학업 중심 공간입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="680,530,920,726" 
				          href="#" 
				          data-name="기숙사" 
				          data-id="D01"
				          data-desc="편안한 생활 환경과 <br> 안전한 시설을 제공하는 학생 거주 공간입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="22,434,184,543" 
				          href="#" 
				          data-name="학생 식당" 
				          data-id="C01"
				          data-desc="학생들에게 다양한 식단으로 <br> 식사를 제공하는 학생식당입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="685,178,892,335" 
				          href="#" 
				          data-name="문화예술관" 
				          data-id="A01"
				          data-desc="공연장, 전시실, 연습실 등을 갖춘 <br> 캠퍼스의 문화·예술 활동 중심 공간입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="121,162,369,355" 
				          href="#" 
				          data-name="공학관" 
				          data-id="10"
				          data-desc="첨단 실습실과 연구 시설을 갖춘 <br> 창의적 공학 인재 양성의 중심입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="675,333,863,512" 
				          href="#" 
				          data-name="인문관" 
				          data-id="20"
				          data-desc="폭넓은 인문학적 탐구와 <br> 비판적 사고를 기르는 융합 교육 공간입니다." 
				          onclick="showDetail(this); return false;">
				          
				    <area shape="rect" coords="356,690,673,862" 
				          href="#" 
				          data-name="경영관" 
				          data-id="30"
				          data-desc="글로벌 비즈니스 감각과 실무 역량을 <br> 강화하는 경영 교육의 핵심 공간입니다." 
				          onclick="showDetail(this); return false;">
				</map>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card shadow-sm border-primary position-sticky" id="infoCard"
					style="position: fixed; top: 150px; right: 50px; width: 380px; z-index: 1000; max-height: 80vh; overflow-y: auto;">
            <div class="card-header bg-primary text-white">
                <i class="las la-info-circle me-1"></i> 상세 정보
            </div>
            <div class="card-body d-flex flex-column justify-content-center align-items-center text-center" id="infoPanel">
                <div class="text-muted">
                    <i class="las la-map-marked-alt" style="font-size: 3rem;"></i>
                    <p class="mt-3">지도에서 건물을 클릭하면<br>상세 정보가 여기에 표시됩니다.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/image-map-resizer/1.0.10/js/imageMapResizer.min.js"></script>

<script>

	// 페이지 로드 시 리사이저 실행
	window.onload = function() {
	    if (typeof imageMapResize === 'function') {
	        imageMapResize();
	    }
	};

// 건물별 상세 정보
	const buildingInfo = {
	    "B01": { // 본관
	        floors: ["1F : 이사장실, 역사관", "2F : 총장실, 비서실", "3F : 대회의실, 접견실"]
	    },
	    "B02": { // 행정 본관
	        floors: ["1F : 입학처, 종합민원실", "2F : 교무처, 학생처", "3F : 총무처, 기획처"]
	    },
	    "L01": { // 중앙 도서관
	        floors: ["B1 : 24시 열람실, 매점", "1F : 대출/반납 데스크, 멀티미디어실", "2F : 인문/사회과학 자료실", "3F : 자연과학/예술 자료실"]
	    },
	    "D01": { // 기숙사
	        floors: ["1F : 식당, 편의점, 헬스장", "2F~5F : 남학생 생활관", "6F~10F : 여학생 생활관"]
	    },
	    "C01": { // 학생 식당
	        floors: ["1F : 학생식당", "2F : 교직원 식당, 카페"]
	    },
	    "A01": { // 문화예술관
	        floors: ["1F : 대공연장, 티켓박스", "2F : 전시실, 갤러리", "3F : 음악/무용 연습실"]
	    },
	    "10": { // 공학관
	        floors: ["1F : PC실습실, 메이커스페이스", "2F~4F : 강의실, 세미나실", "5F : 교수 연구실"]
	    },
	    "20": { // 인문관
	        floors: ["1F : 어학실습실, 라운지", "2F : 대형 강의실", "3F~4F : 소규모 강의실 및 연구실"]
	    },
	    "30": { // 경영관
	        floors: ["1F : 국제회의실, 창업지원센터", "2F~5F : 강의실", "6F : MBA 세미나실"]
	    }
	};
	
	// 클릭 시 정보 보여주기
	async function showDetail(element) {
	    //기본 정보 가져오기
	    const name = element.getAttribute('data-name');
	    const desc = element.getAttribute('data-desc');
	    const id = element.getAttribute('data-id');
	
	    //영역 선택
	    const panel = document.getElementById('infoPanel');
	    
	    const info = buildingInfo[id] || { 
	        floors: ["상세 정보가 준비되지 않았습니다."] 
	    };
	    
	    //학과 리스트
	    let deptHtml = '';
	    try{
	    	const response = await fetch(`/info/getDeptList?code=\${id}`);
	    	
	    	//리스트 가져오기
	    	if(response.ok){
	    		const deptList = await response.json();
	    		
	    		if (deptList && deptList.length > 0) {
                    deptHtml += `<div class="mb-3 animate__animated animate__fadeIn">`;
                    deptHtml += `   <h6 class="fw-bold mb-2 ms-1"><i class="las la-graduation-cap"></i> 소속 학과</h6>`;
                    deptHtml += `   <div class="d-flex flex-wrap gap-1">`;
                    
                    deptList.forEach(dept => {
                        deptHtml += `
                            <span class="badge rounded-pill me-1 mb-2 border-0" 
                                  style="background-color: #eef2ff; color: #4e73df; font-size: 0.9rem; padding: 8px 12px; font-weight: 500;">
                                \${dept}
                            </span>
                        `;
                    });
                    
                    deptHtml += `   </div>`;
                    deptHtml += `   <hr class="my-3 border-secondary opacity-25">`;
                    deptHtml += `</div>`;
                }
            }
        } catch (error) {
            console.error("학과 정보 로딩 실패:", error);
        }
	
	    //층별 안내 리스트
	    let floorListHtml = '';
	    info.floors.forEach(floor => {
	        floorListHtml += `<li class="list-group-item py-1 border-0 bg-transparent"><i class="las la-check text-primary me-2"></i>\${floor}</li>`;
	    });
	
	    //화면
	    let html = `
	        <div class="w-100 text-start animate__animated animate__fadeIn">
	            <h4 class="fw-bold text-primary mb-3">\${name}</h4>
	            <hr>
	            <p class="fs-6 mb-4">\${desc}</p>
	            
	            <div class="d-grid gap-2">
	                <button class="btn btn-outline-primary" type="button" id="toggleBtn"
	                        data-bs-toggle="collapse" 
	                        data-bs-target="#collapseDetail" 
	                        aria-expanded="false" 
	                        aria-controls="collapseDetail">
	                    <i class="las la-angle-down"></i> 상세 정보 보기
	                </button>
	            </div>
	
	            <div class="collapse mt-3" id="collapseDetail"> <div class="card card-body bg-light border-0">
	                    
	            		\${deptHtml}
	            
	                    <h6 class="fw-bold mb-2 ms-1"><i class="las la-building"></i> 층별 안내</h6>
	                    <ul class="list-group small text-muted ps-0">
	                        \${floorListHtml}
	                    </ul>
	                </div>
	            </div>
	        </div>
	    `;
	    
	    panel.innerHTML = html;
	    
	    //토글
	    const collapseElement = document.getElementById('collapseDetail');
	    const toggleBtn = document.getElementById('toggleBtn');

	    //'보기'로 변경
	    collapseElement.addEventListener('hide.bs.collapse', function () {
	        toggleBtn.innerHTML = '<i class="las la-angle-down"></i> 상세 정보 보기';
	    });

	    //'접기'로 변경
	    collapseElement.addEventListener('show.bs.collapse', function () {
	        toggleBtn.innerHTML = '<i class="las la-angle-up"></i> 상세 정보 접기';
	    });
	}
</script>