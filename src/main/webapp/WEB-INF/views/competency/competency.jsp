<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>AI 자기소개서 생성</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>자기소개서 생성기</h2>
    <p class="text-muted">정보를 입력하면 멋진 자기소개서가 완성됩니다!</p>
    <hr>
    
    <form action="/selfIntro/generate" method="post">
        
        <h5 class="mt-4 text-primary">1. 기본 정보</h5>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>이름</label>
                <input type="text" name="name" class="form-control" placeholder="홍길동" required>
            </div>
            <div class="form-group col-md-6">
                <label>나이</label>
                <input type="number" name="age" class="form-control" placeholder="25" required>
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>희망 직무</label>
                <input type="text" name="targetJob" class="form-control" placeholder="예: 백엔드 개발자" required>
            </div>
             <div class="form-group col-md-6">
                <label>제목</label>
                <input type="text" name="introTitle" class="form-control" placeholder="예: 열정 가득한 신입사원 지원서" required>
            </div>
        </div>

        <h5 class="mt-4 text-primary">2. 스펙 및 경험 (없으면 공란 가능)</h5>
        <div class="form-group">
            <label>경력/경험 사항</label>
            <textarea name="career" class="form-control" rows="2" placeholder="예: OO회사 인턴 6개월, 교내 캡스톤 디자인 프로젝트 팀장"></textarea>
        </div>
        <div class="form-group">
            <label>보유 자격증</label>
            <textarea name="certificate" class="form-control" rows="2" placeholder="예: 정보처리기사, SQLD, 토익 850점"></textarea>
        </div>

        <h5 class="mt-4 text-primary">3. 키워드 입력</h5>
        <div class="form-group">
            <label>성장과정 핵심 가치관</label>
            <input type="text" name="growthProcess" class="form-control" placeholder="예: 책임감, 성실함, 도전" required>
        </div>
        <div class="form-group">
            <label>나의 강점 (성격)</label>
            <input type="text" name="strength" class="form-control" placeholder="예: 꼼꼼함, 친화력" required>
        </div>
        <div class="form-group">
            <label>지원 동기</label>
            <textarea name="motivation" class="form-control" rows="3" placeholder="예: 귀사의 혁신적인 비전에 공감하여..." required></textarea>
        </div>

        <div class="text-center mt-4 mb-5">
            <button type="submit" class="btn btn-primary btn-lg btn-block">자동 생성 시작</button>
        </div>
    </form>
</div>
</body>
</html>