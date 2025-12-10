# 프로젝트 소개
- 본 프로젝트는 <strong>(재)대덕인재개발원 [K-Digital Training] 전자정부 프레임워크 & React(AWS) 기반 풀-스택 개발자 양성과정 (9기)</strong>에서 수행된 최종 팀 프로젝트 결과물입니다.

# 팀 구성원
- [carjufu](https://github.com/carjufu)
- [shk-log](https://github.com/shk-log)
- [bellrain21](https://github.com/bellrain21)
- [momong315](https://github.com/momong315)
- [mingkong-cloud](https://github.com/mingkong-cloud)
- [Hasxxd](https://github.com/Hasxxd)
- [xloor99](https://github.com/xloor99)


# Collage API

Spring Boot 3.5 / Java 21 기반의 대학 포털형 웹 애플리케이션입니다. 계정 관리, 수강 신청, 성적, 졸업 요건, 증명서 발급, 상담, 대시보드, 학습 도구, Gemini 기반 챗봇, JSP UI를 제공하며 Oracle DB와 MyBatis(XML 매퍼)로 연동됩니다.

## 기술 스택
- Java 21, Spring Boot 3.5.x
- Spring Web, Spring Security + OAuth2 Resource Server, WebSocket
- MyBatis(XML 매퍼), Oracle Database(ojdbc11)
- JSP + JSTL (`src/main/webapp/WEB-INF/views`)
- Maven Wrapper(`mvnw` / `mvnw.cmd`), Lombok, DevTools(runtime only)
- Gemini API 연동(org.json + httpclient5)
- 파일 업로드/이미지 처리(commons-fileupload, commons-io, thumbnailator/imgscalr)
- PDF/HTML 렌더링(OpenPDF, OpenHTMLToPDF)

## 프로젝트 구조
- `pom.xml` - Maven 빌드 설정 및 의존성
- `src/main/java/kr/ac/collage_api/CollageApiApplication.java` - Spring Boot 진입점
- `src/main/java/kr/ac/collage_api/*` - 기능 패키지(`account`, `admin`, `campus`, `certificates`, `chatbot`, `competency`, `counsel`, `dashboard`, `enrollment`, `grade`, `graduation`, `learning`, `lecture`, `regist`, `schedule`, `scholarship`, `security`, `stdnt`, `websocket`, `vo`)
- `src/main/resources/application.properties` - 기본 프로파일 설정(DB, MyBatis, 파일 업로드, Gemini/Kakao API 키 등)
- `src/main/resources/mybatis/mapper/*-Mapper.xml` - MyBatis XML 매퍼
- `src/main/resources/static` - 정적 리소스(CSS/JS/이미지)
- `src/main/webapp/WEB-INF/views` - JSP 뷰(`header.jsp`, `footer.jsp`, `template.jsp` 및 기능별 폴더)
- `src/test/java/kr/ac/collage_api` - Spring Boot 테스트

## 관리자용 React 대시보드

본 프로젝트는 전체 학사 포털의 **백엔드 API 서버 및 JSP 기반 사용자 화면(학생/교수용)** 을 제공하며,  
**학사행정 관리자 기능**은 별도의 React 기반 관리자 대시보드 프로젝트에서 제공합니다.

관리자용 프론트엔드 코드는 아래 저장소에서 확인하실 수 있습니다.

- Collage React (학사행정 관리자): https://github.com/carajufu/collage_react  

해당 React 프로젝트는 다음과 같은 관리자 업무 화면을 포함합니다.

- 홈 대시보드: 재학생/개설 강좌/재직 교수 수 카드, 학과·학적 상태 통계 차트(Recharts 기반)
- 학적/계정/학위 관리: ag-Grid 및 MUI DataGrid를 활용한 신청·계정·학위 조회/등록/수정
- 단과대·학과·전공 관리: 트리 기반 구조 탐색 및 상세 정보 관리
- 등록/장학 관리: 등록금 고지/납부 내역, 장학금 및 환급 관리
- 수강/강의 관리: 개설 강의 조회, 신규 강의 개설 및 편집
- 게시판·상담·캘린더: 공지/상담 통계, 학사 일정 캘린더(FullCalendar 기반)

실행 방법, 상세 기술 스택(React 19, Vite, MUI 7, React Router v7 등)과  
백엔드 연동 정보(`http://localhost:8085` API 기준)는  
위 React 저장소의 README를 참고해 주세요.

## 선행 조건
- JDK 21 설치 및 `JAVA_HOME` 설정
- Maven 3.9+ (또는 제공된 Maven Wrapper)
- Oracle DB 접속 정보와 스키마 계정
- Gemini API Key 필수, Kakao Pay Key(결제 모의 흐름용)

## 설정
기본 설정은 `src/main/resources/application.properties`에 있습니다.

예시:
```properties
server.port=8085
spring.datasource.url=jdbc:oracle:thin:@host:port/service
spring.datasource.username=your_username
spring.datasource.password=your_password
mybatis.mapper-locations=classpath:mybatis/mapper/*-Mapper.xml
mybatis.type-aliases-package=kr.ac.collage_api.vo, kr.ac.collage_api
gemini.api.key=YOUR_GEMINI_KEY
gemini.api.model=gemini-2.5-flash-latest
gemini.api.url=https://generativelanguage.googleapis.com/v1/models/${gemini.api.model}:generateContent
kakao.admin-key=YOUR_KAKAO_ADMIN_KEY
```

권장: `application-local.properties`로 복사하거나 환경 변수를 사용하고, `--spring.profiles.active=local`로 실행하세요.

## 민감정보/로컬 설정 복원
민감정보는 모두 공백/대체 문구로 마스킹되어 있으니 실제 배포 전에 아래 항목을 채워주세요.
- `src/main/resources/application.properties`: `spring.datasource.url`, `spring.datasource.username`, `spring.datasource.password`를 실제 Oracle 접속 정보로 변경
- `src/main/resources/application.properties`: `kakao.admin-key`를 발급 키로 교체하고, 필요 시 `kakao.cid`와 리다이렉트 URL을 운영 도메인에 맞게 수정
- Gemini 사용 시 같은 파일(또는 `application-local.properties`)에 `gemini.api.key`와 필요하면 `gemini.api.model`·`gemini.api.url` 값을 설정
- 이메일 인증(EmailJS) 사용 시 `EmailJSClient`의 `SERVICE_ID`, `TEMPLATE_ID`, `PUBLIC_KEY`를 실제 값으로 교체
- 공공데이터 포털(특일 정보) 사용 시 `SpcdeHolidayServiceImpl`의 `serviceKey`를 발급받은 키로 교체
- Gemini 연동 로직은 현재 `ChatBotServiceImpl`, `CompetencyServiceImpl`에서 주석 처리되어 있으니, 사용 시 주석 해제 후 키를 주입(`@Value`)하거나 설정 파일에 추가
비밀 값은 가급적 `application-local.properties`로 분리해 Git에 커밋하지 않도록 관리하세요.

## 실행
프로젝트 루트(`collage_api`)에서 Maven Wrapper로 실행:

```bash
# Unix/macOS
./mvnw spring-boot:run

# Windows
mvnw.cmd spring-boot:run
```

기본 포트는 `8085`입니다.
- `http://localhost:8085/login` - 로그인 페이지(보안 적용)
- `http://localhost:8085/dashboard/...` - 대시보드 및 기능 페이지(컨트롤러 참고)

실행 가능한 JAR 빌드는:

```bash
# Unix/macOS
./mvnw clean package

# Windows
mvnw.cmd clean package

java -jar target/collage_api-0.0.1-SNAPSHOT.jar
```

## 테스트
Spring Boot 테스트 실행:

```bash
# Unix/macOS
./mvnw test

# Windows
mvnw.cmd test
```

## 참고
- 보안 설정은 `src/main/java/kr/ac/collage_api/security`에 있으며, Spring Security + OAuth2 Resource Server, 커스텀 로그인/로그아웃 핸들러, JSP용 시큐리티 태그라이브러리를 포함합니다.
- JSP 템플릿은 `src/main/webapp/WEB-INF/views`에 있고, 공통 레이아웃과 기능별 폴더로 구성됩니다.
- MyBatis 매퍼는 `src/main/resources/mybatis/mapper`에 있으며, Mapper 인터페이스의 ID와 XML을 일치시키세요.
