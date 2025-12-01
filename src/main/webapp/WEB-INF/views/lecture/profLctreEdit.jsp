<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사정보</a></li>
            <li class="breadcrumb-item"><a href="#">강의</a></li>
            <li class="breadcrumb-item"><a href="/prof/lecture/mng/list">개설 강의 관리</a></li>
            <li class="breadcrumb-item active" aria-current="page">강의 정보 입력</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">강의 정보 입력</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
    <div id="main-container" class="container-fluid">
		<h5 class="card-title py-4">강의 정보 입력</h5>
			<div class="card" id="card">
				<form action="javascript:void(0);" id="lectureForm" novalidate>
					<c:forEach var="e" items="${estblCourseVOList}" varStatus="stat">
						<div class="card-header align-items-center d-flex">
	                        <h4 class="card-title mb-0 flex-grow-1">${e.allCourse.lctreNm}&nbsp;(${e.sklstf.sklstfNm})</h4>
	                        <div class="flex-shrink-0">
	                            <div class="form-check form-switch form-switch-right form-switch-md" id="badge">
	                            	<h5><span class="badge rounded-pill bg-secondary-subtle text-secondary"> &nbsp; </span></h5>
	                            </div>
	                        </div>
                    	</div>
                		<div class="card-body row">
						    <div class="col-lg-6" style="padding-right: 20px;">
							    <div class="row">
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="firstNameinput" class="form-label">교과목ID</label>
							                <input type="text" class="form-control" value="${e.estbllctreCode}" id="firstNameinput" disabled>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="lastNameinput" class="form-label">이수구분</label>
							                <input type="text" class="form-control" value="${e.complSe}" id="lastNameinput" disabled>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="lastNameinput" class="form-label">강의명</label>
							                <input type="text" class="form-control" value="${e.allCourse.lctreNm}" id="lastNameinput" disabled>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="compnayNameinput" class="form-label">선수과목</label>
							                <input type="text" class="form-control" value="${e.allCourse.preLecture}" placeholder="-" id="compnayNameinput" disabled>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="compnayNameinput" class="form-label">개설학과</label>
							                <input type="text" class="form-control" value="${e.subjctNm}" id="compnayNameinput" disabled>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="phonenumberInput" class="form-label">취득학점</label>
							                <input type="text" class="form-control" value="${e.acqsPnt}" id="phonenumberInput" disabled>
							            </div>
							        </div><!--end col-->
							   
							        
							        <!-- 교수 입력 부분 -->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="atnlcNmprInput" class="form-label">수강 인원</label>
							                <input type="number" class="form-control" id="atnlcNmprInput" value="${e.atnlcNmpr}" required>
							                <div class="invalid-feedback">수강 인원을 입력해 주세요.</div>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-3">
							                <label for="lctreUseLangInput" class="form-label">수업 언어</label>
							                <select id="lctreUseLangInput" class="form-select" required>
							                    <option value="-"
							                    	<c:if test="${e.lctreUseLang==null}"></c:if>
							                    >-</option>
							                    <option value="KOR"
							                    	<c:if test="${e.lctreUseLang=='KOR'}">selected</c:if>
							                    >KOR</option>
							                    <option value="ENG"
							                    	<c:if test="${e.lctreUseLang=='ENG'}">selected</c:if>
							                    >ENG</option>
							                </select>
							                <div class="invalid-feedback">수업 언어를 선택해 주세요.</div>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-6">
							                <label for="timetableInput" class="form-label">강의 시간표</label>
							                <div>
			                                    <div class="card card-body timetable-card" required>
			                                        <div class="avatar-sm mb-3">
			                                            <div class="avatar-title bg-primary-subtle text-primary fs-17 rounded">
			                                                <i class=" ri-calendar-line"></i>
			                                            </div>
			                                        </div>
			                                        <c:choose>
				                                        <c:when test="${!empty e.timetable.lctreDfk}">
			                                        		<p class="card-text" id="timetableInput">
					                                        	${e.cmmn}&nbsp;${fn:substring(e.lctrum,1,4)}호 / &nbsp;${e.timetable.lctreDfk}&nbsp;${e.timetable.beginTm},${e.timetable.endTm}
					                                        </p>
			                                        	</c:when>
			                                        	<c:when test="${empty e.timetable.lctreDfk}">
				                                        	<p class="card-text text-muted" id="timetableInput">
				                                        		강의실, 강의시간을 선택해 주세요.
			                                       		 	</p>
			                                        	</c:when>
			                                        </c:choose>
<!-- 				                                        <a type="button" data-bs-toggle="modal" data-bs-target="#modalTime" class="btn btn-primary">선택</a> -->
			                                        <button type="button" class="btn btn-primary" id="modalTimeBtn" data-bs-toggle="modal" data-bs-target="#modalTime">선택</button>
			                                    </div>
			                                </div>
							            </div>
							        </div><!--end col-->
							        <div class="col-6">
							            <div class="mb-6">
							                <label for="evlMthdInput" class="form-label">평가 방식</label>
							                <div class="card card-body">
								                <!-- Radio Buttons -->
												<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
												    <input type="radio" class="btn-check" name="btnradio" id="btnradio1" autocomplete="off"
												    	<c:if test="${e.evlMthd=='절대'}">checked</c:if>
												    >
												    <label class="btn btn-outline-primary" for="btnradio1">절대</label>
												
												    <input type="radio" class="btn-check" name="btnradio" id="btnradio2" autocomplete="off"
												    	<c:if test="${e.evlMthd=='상대'}">checked</c:if>
												    >
												    <label class="btn btn-outline-primary" for="btnradio2">상대</label>
												
												    <input type="radio" class="btn-check" name="btnradio" id="btnradio3" autocomplete="off"
												    	<c:if test="${e.evlMthd=='PF'}">checked</c:if>
												    >
												    <label class="btn btn-outline-primary" for="btnradio3">P/F</label>
												</div>
												<hr/>
												<label for="rateInput" class="form-label">평가 반영 비율</label>
												<div>
													<div class="input-group col-1 mb-1">
													    <div class="input-group-text">
													        <input class="form-check-input mt-0 eval-check" type="checkbox" value="atendScoreReflctRate" aria-label="Checkbox for following number input"
													        	<c:if test="${e.atendScoreReflctRate!=0 || e.atendScoreReflctRate != ''}">checked</c:if>
													        >
													        <span style="margin-left:8px;">출결</span>
													    </div>
													    <input type="number" class="form-control eval-input" aria-label="Text input with checkbox" disabled
													    	<c:if test="${e.atendScoreReflctRate!=0}">value="${e.atendScoreReflctRate}"</c:if>
													    >
													</div>
													<div class="input-group col-1 mb-1">
													    <div class="input-group-text">
													        <input class="form-check-input mt-0 eval-check" type="checkbox" value="taskScoreReflctRate" aria-label="Checkbox for following number input"
													        	<c:if test="${e.taskScoreReflctRate!=0 || e.taskScoreReflctRate != ''}">checked</c:if>
													        >
													        <span style="margin-left:8px;">과제</span>
													    </div>
													    <input type="number" class="form-control eval-input" aria-label="Text input with checkbox" disabled
													    	<c:if test="${e.taskScoreReflctRate!=0}">value="${e.taskScoreReflctRate}"</c:if>
													    >
													</div>
													<div class="input-group col-1 mb-1">
													    <div class="input-group-text">
													        <input class="form-check-input mt-0 eval-check" type="checkbox" value="middleTestScoreReflctRate" aria-label="Checkbox for following number input"
													        	<c:if test="${e.middleTestScoreReflctRate!=0 || e.middleTestScoreReflctRate != ''}">checked</c:if>
													        >
													        <span style="margin-left:8px;">중간고사</span>
													    </div>
													    <input type="number" class="form-control eval-input" aria-label="Text input with checkbox" disabled
													    	<c:if test="${e.middleTestScoreReflctRate!=0}">value="${e.middleTestScoreReflctRate}"</c:if>
													    >
													</div>
													<div class="input-group col-1 mb-1">
													    <div class="input-group-text">
													        <input class="form-check-input mt-0 eval-check" type="checkbox" value="trmendTestScoreReflctRate" aria-label="Checkbox for following number input"
													        	<c:if test="${e.trmendTestScoreReflctRate!=0 || e.trmendTestScoreReflctRate != ''}">checked</c:if>
													        >
													        <span style="margin-left:8px;">기말고사</span>
													    </div>
													    <input type="number" class="form-control eval-input" aria-label="Text input with checkbox" disabled
													    	<c:if test="${e.trmendTestScoreReflctRate!=0}">value="${e.trmendTestScoreReflctRate}"</c:if>
													    >
													</div>
												</div>
											</div>
							                <div class="invalid-feedback">평가 방식을 선택해 주세요.</div>
							            </div>
							        </div><!--end col-->
							        <!--end col-->
						         </div>
							    <!--end row-->
							</div>
							<div class="col-lg-6" style="border-left: 1px solid #ddd; padding-left: 20px;">
								<div>
						            <div class="mb-3">
						                <label for="lastNameinput" class="form-label">강의계획서</label>
						                <div id="fileInputDiv">
						                	<c:choose>
						                		<c:when test="${!empty e.file.fileStreplace}">
							                		<div class="btn-group" role="group">
							                			<button 
							                				class="btn btn-outline-primary" 
							                				id="fileDownload"  
							                				data-filegroupno="${e.fileGroupNo}"
							                			>${e.file.fileNm}</button>
							                			<button class="btn btn-primary" id="editFileBtn">수정</button>
							                		</div>
						                		</c:when>
						                		<c:when test="${empty e.file.fileStreplace}">
									                <input type="file" class="form-control" id="fileinput" required>
										            <div class="invalid-feedback">강의계획서 파일을 첨부해 주세요.</div>
										        </c:when>
								            </c:choose>
							            </div>
						            </div>
							        </div><!--end col-->
								<div class="d-flex align-items-center">
									<label for="emailidInput" class="form-label">
										주차별 학습 목표
										<span class="badge rounded-pill bg-secondary-subtle text-secondary" id="weekBadge">0 / 15</span>
									</label>
									<a class="btn btn-primary btn-sm ms-auto" id="addWeekBtn">&nbsp;+&nbsp;</a>
								</div>
								<div class="accordion custom-accordionwithicon" id="weekInfo">
									<c:choose>
										<c:when test="${empty e.weekAcctoLrnVO}">
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week1">
										            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#week1Content" aria-expanded="true" aria-controls="week1Content">
										                <i class="ri-pencil-line"></i> &nbsp;&nbsp;1주차&nbsp;&nbsp;
										                <i class="ri-error-warning-fill"></i>
										            </button>
										        </h2>
										        <div id="week1Content" class="accordion-collapse collapse show" aria-labelledby="week1" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week2">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week2Content" aria-expanded="false" aria-controls="week2Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;2주차
										            </button>
										        </h2>
										        <div id="week2Content" class="accordion-collapse collapse" aria-labelledby="week2" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week3">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week3Content" aria-expanded="false" aria-controls="week3Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;3주차
										            </button>
										        </h2>
										        <div id="week3Content" class="accordion-collapse collapse" aria-labelledby="week3" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week4">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week4Content" aria-expanded="false" aria-controls="week4Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;4주차
										            </button>
										        </h2>
										        <div id="week4Content" class="accordion-collapse collapse" aria-labelledby="week4" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week5">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week5Content" aria-expanded="false" aria-controls="week5Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;5주차
										            </button>
										        </h2>
										        <div id="week5Content" class="accordion-collapse collapse" aria-labelledby="week5" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week6">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week6Content" aria-expanded="false" aria-controls="week6Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;6주차
										            </button>
										        </h2>
										        <div id="week6Content" class="accordion-collapse collapse" aria-labelledby="week6" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week7">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week7Content" aria-expanded="false" aria-controls="week7Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;7주차
										            </button>
										        </h2>
										        <div id="week7Content" class="accordion-collapse collapse" aria-labelledby="week7" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
										    <div class="accordion-item">
										        <h2 class="accordion-header" id="week8">
										            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week8Content" aria-expanded="false" aria-controls="week8Content">
										                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;8주차
										            </button>
										        </h2>
										        <div id="week8Content" class="accordion-collapse collapse" aria-labelledby="week8" data-bs-parent="#weekInfo">
										            <div class="accordion-body">
										                <div class="d-flex mb-2 align-items-center">
										            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
											                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required>
											            </div>
										                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
											            <div class="d-flex mb-2 align-items-center">
											            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
											                <input type="text" class="form-control lrnCn" id="firstNameinput" required>
											            </div>
										            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
										            </div>
										        </div>
										    </div>
									    </c:when>
									    <c:when test="${!empty e.weekAcctoLrnVO}">
									    	<c:forEach var="w" items="${e.weekAcctoLrnVO}" varStatus="stat">
									    		
									    		<c:set var="week" value="${w.week}"/>
									    
										    	<div class="accordion-item">
											        <h2 class="accordion-header" id="week${week}">
											            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#week${week}Content" aria-expanded="true" aria-controls="week${week}Content">
											                <i class="ri-pencil-line"></i> &nbsp;&nbsp;${week}주차&nbsp;&nbsp;
											            </button>
											        </h2>
											        <div id="week${week}Content" class='accordion-collapse collapse
											        	<c:if test="${week == '1'}"> show </c:if>' aria-labelledby="week${week}" data-bs-parent="#weekInfo">
											            <div class="accordion-body">
											                <div class="d-flex mb-2 align-items-center">
											            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
												                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}" required
												                	   value="${w.lrnThema}">
												            </div>
											                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
												            <div class="d-flex mb-2 align-items-center">
												            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
												                <input type="text" class="form-control lrnCn" id="firstNameinput" required
												                	   value="${w.lrnCn}">
												            </div>
											            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
											            </div>
											        </div>
											    </div>
										    </c:forEach>
									    </c:when>
								    </c:choose>
								</div>
							</div>
							<div class="col-lg-12 mt-3">
					            <div class="text-end">
				                	<button type="button" class="btn btn-primary" id="editBtn" style="display:none;">수정</button>
					                <button type="submit" class="btn btn-primary" id="submitBtn">입력 완료</button>
					            </div>
					        </div>
					    </div>
					</c:forEach>
				</form>
               </div>
        </div>
    </div>
</div>

<div id="modalTime" class="modal fade zoomIn" tabindex="-1" aria-labelledby="zoomInModalLabel" aria-modal="true" role="dialog">
	<div class="modal-dialog modal-lg">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h5 class="modal-title" id="zoomInModalLabel">강의 시간표</h5>
	            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	        </div>
	        <div class="modal-body">
	        	<!-- 모달 내용 -->
	        	<div>
		        	<h5 class="fs-16">건물</h5>
					<div id="cmmn"> 
					    <input type="radio" class="btn-check" name="cmmn" id="roomEng" autocomplete="off">
					    <label class="btn btn-outline-primary me-2" for="roomEng" data-filter="A">공학관</label>
					
					    <input type="radio" class="btn-check" name="cmmn" id="roomHum" autocomplete="off">
					    <label class="btn btn-outline-primary me-2" for="roomHum" data-filter="B">인문관</label>
					
					    <input type="radio" class="btn-check" name="cmmn" id="roomBiz" autocomplete="off">
					    <label class="btn btn-outline-primary me-2" for="roomBiz" data-filter="C">경영관</label>
					</div>
					<h5 class="fs-16">강의실</h5>
					<div id="lctrum">
						<p>건물을 선택해 주세요.</p>
					</div>
				</div>
				<hr/>
        		<h5 class="fs-16">강의 시간</h5>
				<div class="timeInfoArea">
					<p>강의실을 선택해 주세요.</p>
	        	</div>
	        	<div role="complementary" class="gridjs gridjs-container" style="width: 100%;">
					<div class="gridjs-wrapper" style="height: auto;">
						<table role="grid" class="gridjs-table" id="timetable" style="height: auto;">
							<thead class="gridjs-thead">
								<tr class="gridjs-tr">
									<th data-column-id="id" class="gridjs-th" style="width: 10%;">
									<div class="gridjs-th-content">\</div>
									</th>
									<th data-column-id="id" class="gridjs-th" style="width: 18%;">
									<div class="gridjs-th-content">월</div>
									</th>
									<th data-column-id="name" class="gridjs-th" style="width: 18%;">
									<div class="gridjs-th-content">화</div>
									</th>
									<th data-column-id="date" class="gridjs-th" style="width: 18%;">
									<div class="gridjs-th-content">수</div>
									</th>
									<th data-column-id="total" class="gridjs-th" style="width: 18%;">
									<div class="gridjs-th-content">목</div>
									</th>
									<th data-column-id="status" class="gridjs-th" style="width: 18%;">
									<div class="gridjs-th-content">금</div>
									</th>
								</tr>
							</thead>
							<tbody class="gridjs-tbody">
								<tr class="gridjs-tr" data-column-id="1">
									<th data-column-id="time1" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">1교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="2">
									<th data-column-id="time2" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">2교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="3">
									<th data-column-id="time3" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">3교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="4">
									<th data-column-id="time4" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">4교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="5">
									<th data-column-id="time5" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">5교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="6">
									<th data-column-id="time6" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">6교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="7">
									<th data-column-id="time7" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">7교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
								<tr class="gridjs-tr" data-column-id="8">
									<th data-column-id="time8" style="border: 1px solid #dee2e6;">
										<div class="gridjs-th-content">8교시</div></th>
									<td data-column-id="mon" class="gridjs-td"></td>
									<td data-column-id="tue" class="gridjs-td"></td>
									<td data-column-id="wed" class="gridjs-td"></td>
									<td data-column-id="thu" class="gridjs-td"></td>
									<td data-column-id="fri" class="gridjs-td"></td>
								</tr>
						</tbody>
					</table>
					</div>
				</div>
	        </div>
	        <div class="modal-footer">
	            <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
	            <button type="button" class="btn btn-primary" id="timetableSave">선택</button>
	        </div>
	
	    </div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div>


<script type="text/javascript">

	const courseInfo = [
		<c:forEach var="e" items="${estblCourseVOList}" varStatus="stat">
			{
				estbllctreCode : "${e.estbllctreCode}",
				lctreNm : "${e.allCourse.lctreNm}",
				acqsPnt : "${e.acqsPnt}",
				sklstfNm : "${e.sklstf.sklstfNm}",
				estblSttus : "${e.estblSttus}",
				endTm : "${e.timetable.endTm}",
				weekAcctoLrnVO : "${e.weekAcctoLrnVO}"
			}
		</c:forEach>
	];
	
	console.log(courseInfo);
	
	const editBtn = document.querySelector("#editBtn");
	const submitBtn = document.querySelector("#submitBtn");
	
	// 입력완료 강의 화면 렌더링(폼 비활성화)
	if (courseInfo[0].estblSttus == 1) {
		document.querySelector(".card-title").textContent = "강의 정보";
		
		document.querySelector("#atnlcNmprInput").setAttribute("disabled", true);
		document.querySelector("#lctreUseLangInput").setAttribute("disabled", true);
		document.querySelector("#modalTimeBtn").classList.remove("btn-primary");
		document.querySelector("#modalTimeBtn").setAttribute("style", "background-color:#e9ebec; border: none;");
		document.querySelector("#modalTimeBtn").setAttribute("disabled", true);
		document.querySelectorAll('input[name="btnradio"]').forEach(radio => {
		    radio.disabled = true;
		});
		document.querySelectorAll('input[type="checkbox"]').forEach(chk => {
			chk.disabled = true;
		});
		console.log(document.querySelectorAll(".eval-input"));
		document.querySelectorAll(".eval-input").forEach(eval => {
			eval.disabled = true;
		})
		document.querySelector("#fileDownload").setAttribute("disabled", true);
		document.querySelector("#editFileBtn").setAttribute("disabled", true);
		document.querySelectorAll(".lrnThema").forEach(lrnThema => {
			lrnThema.disabled = true;
		});
		document.querySelectorAll(".lrnCn").forEach(lrnCn => {
			lrnCn.disabled = true;
		});
		document.querySelector("#addWeekBtn").setAttribute("style", "display:none;");
		editBtn.setAttribute("style", "display:in-block;");
		submitBtn.setAttribute("style", "display:none;");
	}
	
	
	// 수정 모드
	editBtn.addEventListener("click", () => {
		document.querySelector(".card-title").textContent = "강의 정보 수정";
		
		document.querySelector("#atnlcNmprInput").removeAttribute("disabled");
		document.querySelector("#lctreUseLangInput").removeAttribute("disabled");
		document.querySelector("#modalTimeBtn").classList.add("btn-primary");
		document.querySelector("#modalTimeBtn").removeAttribute("style");
		document.querySelector("#modalTimeBtn").removeAttribute("disabled");
		document.querySelectorAll('input[name="btnradio"]').forEach(radio => {
		    radio.disabled = false;
		});
		document.querySelectorAll('.eval-check').forEach(chk => {
			chk.disabled = false;
			
			const input = chk.closest(".input-group").querySelector(".eval-input");
			
			input.disabled = !chk.checked;
		});
		document.querySelector("#fileDownload").removeAttribute("disabled");
		document.querySelector("#editFileBtn").removeAttribute("disabled");
		document.querySelectorAll(".lrnThema").forEach(lrnThema => {
			lrnThema.disabled = false;
		});
		document.querySelectorAll(".lrnCn").forEach(lrnCn => {
			lrnCn.disabled = false;
		});
		document.querySelector("#addWeekBtn").setAttribute("style", "display:in-block;");
		editBtn.setAttribute("style", "display:none;");
		submitBtn.setAttribute("style", "display:in-block;");
	})
	
	
	// 평가 비율 체크박스 활성화
	const isViewMode = courseInfo[0].estblSttus == 1;
	document.querySelectorAll('.eval-check').forEach(chk => {
	    const input = chk.closest('.input-group').querySelector('.eval-input');
	
	    if (isViewMode) {
	    	input.disabled = true;
	    } else {
	    	// 초기 상태 세팅
		    input.disabled = !chk.checked;
	    }
	    
	    // 체크할 때마다 동작
	    chk.addEventListener('change', () => {
	    	
	    	input.disabled = !chk.checked;
	    	
	    	if (!chk.checked) {
	    		input.value = "";
	            input.classList.remove("is-invalid");
	    	} 
	    });
	});
	
	
	// 상태 뱃지 렌더링 함수
	const badge = document.querySelector("#badge");
	let sttusValue = courseInfo[0].estblSttus;
	
	const renderStatusBadge = (estblSttus) => {
		estblSttus = estblSttus.toString();
		switch (estblSttus) {
				case "0" : 
					return `<h5><span class="badge rounded-pill bg-secondary-subtle text-secondary"> 미입력 </span></h5>`;
				case "1" : 
					return `<h5><span class="badge rounded-pill bg-success-subtle text-success"> 입력완료 </span></h5>`;
				case "2" : 
					return `<h5><span class="badge rounded-pill bg-primary-subtle text-primary"> 승인 </span></h5>`;
				case "3" : 
					return `<h5><span class="badge rounded-pill bg-danger-subtle text-danger"> 반려 </span></h5>`;
				default :
					return "";
		} 
	}
	
	const renderHeader = () => {
		let sttusValue = courseInfo[0].estblSttus;
		badge.innerHTML = renderStatusBadge(sttusValue);
	}
	
	
	// 강의계획서 수정
	const fileInputDiv = document.querySelector("#fileInputDiv");
	const defaultHTML = fileInputDiv.innerHTML;
	
	const hanleEditClick = () => {
		let fileHTML = `
			<div class="d-flex align-items-center gap-2">
				<input type="file" class="form-control" id="fileinput" required>
	            <div class="invalid-feedback">강의계획서 파일을 첨부해 주세요.</div>
	            <button class="btn btn-outline-primary" id="cancleEditBtn" style="white-space: nowrap;">수정 취소</button>
	        </div>
		`;
		fileInputDiv.innerHTML = fileHTML;
		
		// 수정 취소
		const cancleEditBtn = document.querySelector("#cancleEditBtn");
		
		cancleEditBtn.addEventListener("click", () => {
			fileInputDiv.innerHTML = defaultHTML;
			
			addEditListener();
		});
	}
	
	const addEditListener = () => {
		const editFileBtn = document.querySelector("#editFileBtn");
		
		if(editFileBtn) {
			editFileBtn.addEventListener("click", hanleEditClick);
		}
	}
	
	
	// 주차별 강의 목표 추가 함수
	const addWeekBtn = document.querySelector("#addWeekBtn");
	const weekBadge = document.querySelector("#weekBadge");
	const weekElement = document.querySelectorAll(".accordion-item");
	const badgeValue = weekElement.length;
	
	if (weekBadge) {
		weekBadge.textContent = `\${badgeValue}/15`;
	}
	
	const getMaxWeekNumber = () => {
		const headers = document.querySelectorAll(".accordion-header");
		console.log(headers);
		let max = 0;
		
		headers.forEach(header => {
			const id = header.id;
			const num = parseInt(id.replace("week", ""));
			if (num > max) {
				max = num;
			}
		});
		return max;
	}
	
	addWeekBtn.addEventListener("click", (event) => {
		const maxWeek = getMaxWeekNumber();
		const newWeek = maxWeek + 1;
		
		const weekHTML = `
			<div class="accordion-item">
		        <h2 class="accordion-header" id="week\${newWeek}">
		            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week\${newWeek}Content" aria-expanded="true" aria-controls="week\${newWeek}Content">
		                <i class="ri-pencil-line"></i> &nbsp;&nbsp;\${newWeek}주차
		            </button>
		        </h2>
		        <div id="week\${newWeek}Content" class="accordion-collapse collapse" aria-labelledby="week\${newWeek}" data-bs-parent="#weekInfo">
		            <div class="accordion-body">
		            	<div class="d-flex mb-2 align-items-center">
		            		<p class="form-label me-2 mb-0" style="width:30px;">주제</p>
			                <input type="text" class="form-control lrnThema" id="lrnThema\${newWeek}">
			            </div>
		                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
			            <div class="d-flex mb-2 align-items-center">
			            	<p class="form-label me-2 mb-0" style="width:30px;">내용</p>
			                <input type="text" class="form-control lrnCn" id="firstNameinput">
			            </div>
		            	<div class="invalid-feedback">학습 내용을 입력해 주세요.</div>
		            </div>
		        </div>
		    </div>
		`;
		
		const badgeHTML = `
			\${newWeek} / 15
		`;
		if (maxWeek >= 15) {
			Swal.fire("강의 목표 주차를 모두 추가하셨습니다.");
		} else {
			document.querySelector("#weekInfo").insertAdjacentHTML("beforeend", weekHTML);
			weekBadge.innerHTML = badgeHTML;
		}
	})
	
	
	// 선택값 저장 변수
	let selectedCmmn = null;
	let selectedLctrum = null;
	let selectedTime = null;
	
	
	const modalTime = document.getElementById("modalTime");
	
	modalTime.addEventListener("show.bs.modal", (event) => {
		const modalTimeBtn = event.relatedTarget;
			
		// 시간표 정보 불러오기
		fetch("/prof/lecture/mng/edit/timetable")
			.then(response => {
				if(!response.ok) {
					throw new Error("서버 오류 발생...");
				}
				return response.json();
			})
			.then(data => {
				allLctreData = data.list;
				console.log("fetch 요청 allLctreData : ", allLctreData);

				timetableLctrum = {};
				
				allLctreData.forEach(item => {
					const roomCode = item.lctrum;
					
					if (!timetableLctrum[roomCode]) {
						timetableLctrum[roomCode] =[];
					}
					timetableLctrum[roomCode].push(item);
				});
				
				console.log(timetableLctrum);
				
				const timeInfoArea = modalTime.querySelector(".timeInfoArea");
				timeInfoArea.innerHTML = `<p>강의실을 선택해 주세요.</p>`;

			})
			.catch(error => {
				console.error("fetch 에러 : ", error);
				timeInfoArea.innerHTML = `<p>시간표 정보를 불러오지 못했습니다.</p>`;
			});
	});
	
	
	const lctrums = {
			A: 	 [
					'101', '102', '103', '104', '105', '106', '107',
				    '201', '202', '203', '204', '205', '206', '207',
				    '301', '302', '303', '304', '305', '306', '307'
				 ],
			B:   [
					'101', '102', '103', '104', '105',
				    '201', '202', '203', '204', '205', '206', '207',
				    '301', '302', '303', '304', '305', '306', '307'	
				 ],
			C:   [
					'201', '202', '203', '204', '205',
				    '301', '302', '303', '304', '305',
				    '401', '402', '403', '404', '405',
				    '501', '502', '503', '504', '505'	
				 ]
	};
	
	const lctrum = document.getElementById("lctrum");
	const cmmnGroup = document.getElementById("cmmn");
	
	
	// 강의실 렌더링 함수
	const renderLctrum = (cmmnKey) => {
		
		selectedCmmn = cmmnKey;
		const rooms = lctrums[cmmnKey];
		lctrum.innerHTML = ``;
		
		if (!rooms) {
			lctrum.innerHTML = `<p>강의실 정보가 없습니다.</p>`;
			return;
		}
		
		const roomBtnsHTML = rooms.map(no => {
			
			const completeLctrum = cmmnKey + no;
			return `
				<input type="radio" class="btn-check" name="lctrum" id="lctrum\${no}" autocomplete="off">
				<label class="btn btn-outline-primary me-2 mb-2" for="lctrum\${no}" data-room-no="\${completeLctrum}">\${no} 호</label>
				`;
		}).join("");
		
		lctrum.innerHTML += roomBtnsHTML;
	}
	
	cmmnGroup.addEventListener("click", (event) => {
		if(event.target.tagName == "LABEL") {
			const cmmnKey = event.target.dataset.filter;
			console.log(cmmnKey);
			if (cmmnKey) {
				renderLctrum(cmmnKey);
			}
		}
	});
	
	
	// 강의실 -> 시간표 렌더링
	const timetableArea = document.querySelector("#timetableArea");
	
	lctrum.addEventListener("click", (event) => {
		if (event.target.tagName == "LABEL") {
			const roomNo = event.target.dataset.roomNo;
			console.log(roomNo);
			selectedLctrum = roomNo;
			if (roomNo) {
				renderTimetable(roomNo);
			}
		}
	});

	
	let allLctreData;
	
	const timetable = document.querySelector("#timetable");
	const dayMap = {
			"월" : "mon",
			"화" : "tue",
			"수" : "wed",
			"목" : "thu",
			"금" : "fri"
	};
	
	
	// 시간표 렌더링 함수
	const renderTimetable = (selectedRoomCode) => {
		
		selectedBegin = null;
		selectedEnd = null;
		
		if (!timetable) { return; }
		
		// 시간표 테이블 초기화
		timetable.querySelectorAll(".gridjs-td").forEach(cell => {
			cell.innerHTML = "";
			cell.classList.remove('occupied-cell');
			cell.removeAttribute("data-is-occupied");
			cell.classList.remove("selected", "disabled-cell", "start-time", "end-time");
		});
		
		console.log("allLctreData : ", allLctreData);
		
		const filteredLctre = allLctreData.filter(item => {
			return item.lctrum == selectedRoomCode;
		});
		
		console.log("filteredLctre : ", filteredLctre);
		
		filteredLctre.forEach(lec => {
			
			const lctre = lec.lctreNm;
		    console.log("현재 처리 중인 수업 :", lctre);
		    
		    const lecCode = lec.estbllctreCode;
			const lctreNm = lec.lctreNm;
			const sklstfNm = lec.sklstfNm;
			const daykey = dayMap[lec.lctreDfk];
			const beginTm = lec.beginTm;
			const endTm = lec.endTm;
			
			if ( !daykey || !beginTm || !endTm || lecCode == courseInfo[0].estbllctreCode ) { return; }
			
			const lecContainer = document.createElement('div');
			lecContainer.classList.add('lecture-info-item');
			
			lecContainer.innerHTML = `
				<strong>\${lctreNm}</strong><br>
				<span class="text-muted">\${sklstfNm}</span>
			`;
			
			for (let timeSlot = beginTm; timeSlot <= endTm; timeSlot++) {
				const targetCell = timetable.querySelector(
					`tr[data-column-id="\${timeSlot}"] td[data-column-id="\${daykey}"]`	
				);
				
				if (targetCell) {
					const clonedLecContainer = lecContainer.cloneNode(true);
					
					targetCell.appendChild(clonedLecContainer);
					targetCell.classList.add("occupied-cell", "disabled-cell");
					targetCell.setAttribute("data-is-occupied", "true");
				}
			}
		});
	}
	
	
	let selectTime;
	let selectedBegin = null;
	let selectedEnd = null;

	const tdHTML = `
		<strong>\${courseInfo[0].lctreNm}</strong><br>
		<span class="text-muted">\${courseInfo[0].sklstfNm}</span>
	`;
	
	timetable.addEventListener("click", (event) => {
		if (event.target.tagName == "TD") {
			
			const td = event.target;
			const tr = event.target.closest("tr");
			
			const time = tr.getAttribute("data-column-id");
			const day = td.getAttribute("data-column-id");
			
			const dayKey = Object.keys(dayMap).find(k => dayMap[k] == day);
			
			if(!selectedBegin) {
				
				selectedBegin = td;

				td.classList.add("selected");
				td.innerHTML = tdHTML;
				
			} else if ( !selectedEnd && td.selected != true ){
				
				selectedEnd = td;
				
				td.classList.add("selected");
				td.innerHTML = tdHTML;
			}
			
			selectedTime = {
					lctreDfk : dayKey, 
					beginTm : selectedBegin.closest("tr").dataset.columnId,
					endTm : selectedEnd.closest("tr").dataset.columnId 
			};
			
			console.log("선택한 시간 : ", selectedTime);
		}
	});
	
	
	document.querySelector("#timetableSave").addEventListener("click", ()=> {
		
		if ( !selectedCmmn || !selectedLctrum || !selectedTime ) {
			Swal.fire("시간표 정보를 모두 선택하세요.");
			return;
		}
	
		const msg = `
			강의실 : \${cmmnMap[selectedCmmn]} \${selectedLctrum.substring(1,4)}호 <br/>
			강의 시간 : \${selectedTime.lctreDfk} \${selectedTime.beginTm},\${selectedTime.endTm} <br/><br/>
			
			선택하시겠습니까?
		`;
			
		Swal.fire({
			icon: "question",
			html: msg,
			showCancelButton: true,
			confirmButtonText: "예",
			cancelButtonText: "아니오"
		})
		.then((result) => {
			if(result.isConfirmed) {
				Swal.fire("선택되었습니다.")
				const modal = bootstrap.Modal.getInstance(document.getElementById("modalTime"));
				modal.hide();
				
				renderSelectedData();
			}
		});
			
		
	});

	
	const timetableInput = document.querySelector("#timetableInput");
	const cmmnMap = {
			"A" : "공학관",
			"B" : "인문관",
			"C" : "경영관"
	};

	const renderSelectedData = () => {
		
		const selectedCmmn = selectedLctrum.substring(0,1);
		const selectedRoom = selectedLctrum.substring(1,4);
		
		timetableInput.classList.remove("text-muted");
		timetableInput.innerHTML = `
			\${cmmnMap[selectedCmmn]}&nbsp;\${selectedRoom}호 / &nbsp;&nbsp;\${selectedTime.lctreDfk}&nbsp;\${selectedTime.beginTm},\${selectedTime.endTm}
		`;
	}
	

	
	
	// 폼 데이터 저장 함수
	const getData = () => {
		
		const evlMthdElement = document.querySelector("input[name='btnradio']:checked");
		const atendCheckBox = document.querySelector("input[value='atendScoreReflctRate']");
		const atendRateInput = atendCheckBox.parentElement.nextElementSibling;
		const taskCheckBox = document.querySelector("input[value='taskScoreReflctRate']");
		const taskRateInput = taskCheckBox.parentElement.nextElementSibling;
		const middleTestCheckbox = document.querySelector("input[value='middleTestScoreReflctRate']");
		const middleTestRateInput = middleTestCheckbox.parentElement.nextElementSibling;
		const trmendTestCheckbox = document.querySelector("input[value='trmendTestScoreReflctRate']");
		const trmendTestRateInput = trmendTestCheckbox.parentElement.nextElementSibling;
		
		const estbllctreCode = courseInfo[0].estbllctreCode;
		const atnlcNmpr = document.getElementById("atnlcNmprInput").value;
		const lctreUseLang = document.getElementById("lctreUseLangInput").value;
		let evlMthd = "";
		if (evlMthdElement) {
			if (evlMthdElement.id == "btnradio1") {
				evlMthd = "절대";
			} else if (evlMthdElement.id == "btnradio2") {
				evlMthd = "상대";
			} else if (evlMthdElement.id == "btnradio3") {
				evlMthd = "PF"
			}
		}
		const file = document.querySelector("#fileinput").files[0];
		const atendScoreReflctRate = atendCheckBox.checked ? atendRateInput.value : 0;
		const taskScoreReflctRate = taskCheckBox.checked ? taskRateInput.value : 0;
		const middleTestScoreReflctRate = middleTestCheckbox.checked ? middleTestRateInput.value : 0;
		const trmendTestScoreReflctRate = trmendTestCheckbox.checked ? trmendTestRateInput.value : 0;
		const timetable = {
				lctreDfk : selectedTime.lctreDfk,
				beginTm : parseInt(selectedTime.beginTm,10),
				endTm : parseInt(selectedTime.endTm,10)
		};
		
		// 주차별 학습 목표 데이터 저장
		const weeklyGoals = [];
		
		const themeInputs = document.querySelectorAll(".lrnThema");
		const contentInputs = document.querySelectorAll(".lrnCn");
		
		themeInputs.forEach((themeInput, index) => {
			const contentInput = contentInputs[index];
			
			const weekNumber = index + 1;
			
			weeklyGoals.push({
				week: weekNumber,
				lrnThema: themeInput.value,
				lrnCn: contentInput.value
			});
		});
		
		let data = new FormData();
		
		data.append("estbllctreCode" , estbllctreCode);
		data.append("atnlcNmpr" , parseInt(atnlcNmpr,10));
		data.append("lctreUseLang" , lctreUseLang);
		data.append("evlMthd" , evlMthd);
		data.append("uploadFile" , file);
		data.append("atendScoreReflctRate" , parseInt(atendScoreReflctRate,10));
		data.append("taskScoreReflctRate" , parseInt(taskScoreReflctRate,10));
		data.append("middleTestScoreReflctRate" , parseInt(middleTestScoreReflctRate,10));
		data.append("trmendTestScoreReflctRate" , parseInt(trmendTestScoreReflctRate,10));
		data.append("lctrum" , selectedLctrum);
		data.append("jsonTimetable" , JSON.stringify(timetable));
		data.append("jsonWeeklyGoals" , JSON.stringify(weeklyGoals));
		
		return data;
	};
	
	
	const lectureForm = document.getElementById("lectureForm");
	const timetableCard = document.querySelector(".timetable-card");
	
	// 시간표 데이터 유무 검사
	const isTimetableSelected = (lctrum) => {
		
		const hasExistingTimetable =
			typeof courseInfo[0].endTm != "undefined" && courseInfo[0].endTm;
		
		const hasSelectedTime =
			typeof selectedTime != "undefined" && selectedTime && selectedTime.endTm;
		
		return hasExistingTimetable || hasSelectedTime;
	};
	
	if (submitBtn && lectureForm) {
		submitBtn.addEventListener("click", function(event) {
			event.preventDefault();
			lectureForm.classList.add("was-validated");
			let isTimetableValid = isTimetableSelected(lctrum);
			let formIsValid = lectureForm.checkValidity();
			
			if (!isTimetableValid) {
				timetableCard.classList.add("is-invalid");
				timetableInput.classList.remove("text-muted");
				timetableInput.setAttribute("style", "color:#dc3545;");
				formIsValid = false;
			} else {
				timetableCard.classList.remove("is-invalid");
				timetableInput.removeAttribute("style");
				timetableCard.setAttribute("style", "border: 1px solid #3cd188;");
			}
			
			if (!formIsValid) {
				Swal.fire({
					  icon: "warning",
					  title: "",
					  text: "강의 정보를 모두 입력해 주세요."
				});
			
				event.stopPropagation();
				console.error("폼 유효성 검사 실패. 필수 입력 필드 확인");
				
				return;
				
			} else {
				console.log("폼 유효성 검사 통과. 데이터 처리 시작");
				
				const data = getData();
				
				let formData = new FormData();
				
				console.log("입력 완료 버튼 click");
				console.log("입력 정보 : ", data);
				
				Swal.fire({
					icon: "question",
					html: "강의 입력 정보를 저장하시겠습니까?",
					showCancelButton: true,
					confirmButtonText: "예",
					cancelButtonText: "아니오"
				})
				.then((result) => {
					if (result.isConfirmed) {
						
						fetch("/prof/lecture/mng/edit/confirm", {
							method: "post",
							body: data
						})
						.then(response => {
							if(!response.ok) {
								throw new Error("서버 오류 발생");
							}
							return response.json();
						})
						.then(data => {
							const result = data.result;
							
								if (result == 3) {
									Swal.fire({
										icon: "success",
										title: "입력 완료",
										text: "강의 입력 정보를 저장했습니다.<br/> 개설 강의 목록에서 처리 상태를 확인할 수 있습니다."
									})
									.then((result) => {
										window.location.reload();
									});
								} else {
									console.error("입력 실패 : ", error);
									Swal.fire({
										  icon: "error",
										  title: "입력 실패",
										  text: "입력 정보 저장에 실패했습니다. 다시 시도해 주세요."
									});
								}
								
						})
						.catch(error => {
							console.error("입력 실패 : ", error);
							Swal.fire({
								  icon: "error",
								  title: "입력 실패",
								  text: "입력 정보 저장에 실패했습니다. 다시 시도해 주세요."
							});
						})
					}
				})
			}
		});
	}
	
	renderHeader();
	addEditListener();
	
	
</script>
<style>
.bg-secondary-subtle {
  background-color: #e2e3e5 !important;  /* Bootstrap subtle secondary 회색 */
  color: #6c757d !important;
}

.gridjs-td {
	height: 75px;
}

.gridjs-td:hover {
	background-color: #e8ebff;
	cursor: pointer;
}

.gridjs-td.selected  {
	background-color: #c7dbff;
}

.disabled-cell {
	background-color: #ffece7 !important;
	pointer-events: none;
}

.form-check-input:checked {
  background-color: #222e83 !important;  /* 원하면 원하는 색 */
  border-color: #222e83 !important;
}

.form-switch .form-check-input:checked {
  background-color: #00c853 !important; /* 스위치 바 색 */
  border-color: #00c853 !important;
}

.form-switch .form-check-input:checked::after {
  background-color: #fff; /* 동그라미 색 */
}

.timetable-card.is-invalid {
    border: 1px solid #f7666e !important;
/*     border-color: #dc3545 !important; /* Bootstrap Danger Color */ */
/*     box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important; /* Red glow */ */
}

</style>

<%@ include file="../footer.jsp" %>
