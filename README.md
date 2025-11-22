## Collage API

Collage API는 대학 관련 업무(학생, 수강신청, 성적, 졸업, 증명서, 상담 등)를 관리하기 위한 Spring Boot 3 애플리케이션입니다. Oracle 데이터베이스를 백엔
드로 사용하며, JSP 뷰를 통해 웹 UI를 제공합니다. 또한 Gemini 생성형 AI API와 연동하여 챗봇 기능도 포함하고 있습니다.

### 기술 스택

- Java 21
- Spring Boot 3.5.x
- Spring Web, Security, OAuth2 Resource Server
- MyBatis (XML 매퍼 사용)
- Oracle Database (JDBC)
- JSP + JSTL (`src/main/webapp/WEB-INF/views` 아래 뷰 파일)
- Maven (래퍼 포함: `mvnw` / `mvnw.cmd`)
- Gemini API 연동 (`org.json` + HTTP)

### 프로젝트 구조

- `pom.xml` – Maven 빌드 설정 및 의존성 관리
- `src/main/java/kr/ac/collage_api` – 메인 애플리케이션 패키지
    - `CollageApiApplication` – Spring Boot 진입점
    - `account`, `admin`, `certificates`, `chatbot`, `competency`, `counsel`, `dashboard`, `enrollment`, `grade`, `graduation`, `learning`, `lecture`,
      `regist`, `security`, `stdnt`, `vo` 등 기능별 모듈 패키지
- `src/main/resources` – 설정 및 리소스
    - `application.properties` – 핵심 Spring Boot 설정(DB, MyBatis, 파일 업로드, Gemini API 등)
    - `mybatis/mapper` – MyBatis XML 매퍼
    - `static` – 정적 리소스(CSS/JS/이미지 등)
- `src/main/webapp/WEB-INF/views` – 각 기능별 JSP 뷰
    - 공통 레이아웃: `header.jsp`, `footer.jsp`, `template.jsp`
    - 기능별 디렉터리: `dashboard`, `enrollment`, `grade`, `graduation`, `lecture`, `stdnt` 등
- `src/test/java/kr/ac/collage_api` – Spring Boot 컨텍스트 로드 테스트

### 사전 준비 사항

- JDK 21 설치 및 `JAVA_HOME` 환경변수 설정
- Maven 3.9+ (또는 Maven 래퍼 사용)
- `application.properties`에 설정된 Oracle DB에 접속 가능한 환경
- 챗봇 기능 사용 시 유효한 Gemini API Key

### 설정

기본 설정 파일은 `src/main/resources/application.properties`입니다. 주요 항목은 다음과 같습니다.

- 서버 설정:
    - `server.port=8085`
- JSP 뷰 리졸버:
    - `spring.mvc.view.prefix=/WEB-INF/views/`
    - `spring.mvc.view.suffix=.jsp`
- Oracle 데이터소스(예시):
    - `spring.datasource.url=jdbc:oracle:thin:@host:port/service`
    - `spring.datasource.username=...`
    - `spring.datasource.password=...`
- MyBatis:
    - `mybatis.type-aliases-package=kr.ac.collage_api.vo, kr.ac.collage_api.**.vo`
    - `mybatis.mapper-locations=classpath:mybatis/mapper/*-Mapper.xml`
- 파일 업로드:
    - `spring.servlet.multipart.max-file-size=10MB`
    - `spring.servlet.multipart.max-request-size=10MB`
- Gemini API:
    - `gemini.api.key=YOUR_API_KEY`
    - `gemini.api.model=gemini-2.5-flash-latest`
    - `gemini.api.url=https://generativelanguage.googleapis.com/v1/models/${gemini.api.model}:generateContent`

보안상 실제 계정 정보나 API Key는 저장소에 커밋하지 않는 것이 좋습니다. 운영/팀 환경에서는 다음과 같이 관리하는 것을 권장합니다.

- 환경 변수나 JVM 시스템 프로퍼티로 민감 정보 오버라이드
- `application-local.properties`와 같은 로컬 프로파일 파일을 만들어 VCS에서 제외하고,
  애플리케이션 실행 시 `--spring.profiles.active=local` 옵션 사용

### 애플리케이션 실행

프로젝트 루트(`collage_api`)에서 Maven 래퍼를 사용해 애플리케이션을 실행할 수 있습니다.

  ```bash
  # Unix/macOS
  ./mvnw spring-boot:run

  # Windows
  mvnw.cmd spring-boot:run

  애플리케이션은 application.properties에 설정된 포트(기본 8085)로 기동되며, 예시는 다음과 같습니다.

  - http://localhost:8085/login – 로그인 화면 (Security 설정에 따라 다를 수 있음)
  - http://localhost:8085/dashboard/... – 대시보드 및 기타 기능 페이지 (컨트롤러 매핑에 따라 URL 구성)

  실행 가능한 JAR를 빌드하려면:

  # Unix/macOS
  ./mvnw clean package

  # Windows
  mvnw.cmd clean package

  빌드 후 JAR 실행:

  java -jar target/collage_api-0.0.1-SNAPSHOT.jar

  ### 데이터베이스 & MyBatis

  애플리케이션은 MyBatis를 사용해 데이터베이스와 연동합니다. 주요 사항:

  - 매퍼 XML은 src/main/resources/mybatis/mapper/*-Mapper.xml에 위치합니다.
  - mybatis.type-aliases-package는 VO 패키지(kr.ac.collage_api.vo 등)로 설정되어 있어 XML에서 간단하게 타입을 참조할 수 있습니다.
  - Oracle 데이터베이스 스키마가 매퍼 XML에서 사용하는 테이블/컬럼과 일치하는지 확인해야 합니다.

  ### 프론트엔드 (JSP 뷰)

  - JSP 템플릿은 src/main/webapp/WEB-INF/views 아래에 위치합니다.
  - 공통 레이아웃 및 UI 컴포넌트:
      - header.jsp – 상단 바, 내비게이션, 헤더 레이아웃
      - footer.jsp – 푸터 및 공용 스크립트
      - template.jsp – 기본 레이아웃 템플릿
  - 기능별 뷰는 폴더 단위로 구성됩니다.
      - 예: dashboard, enrollment, grade, graduation, lecture, stdnt 등
  - 정적 리소스(CSS/JS)는 src/main/resources/static/assets 아래에 번들링됩니다.

  ### 보안

  - Spring Security 및 OAuth2 Resource Server 의존성이 포함되어 있습니다.
  - JSP에서 spring-security-taglibs를 사용하여 인증/권한에 따라 화면 요소를 제어할 수 있습니다.
  - 외부에 서비스를 공개하기 전에
    src/main/java/kr/ac/collage_api/security 하위의 보안 설정을 반드시 확인하고 필요한 정책(인증 방식, 권한, CORS 등)을 구성해야 합니다.

  ### 테스트

  기본적인 Spring Boot 컨텍스트 로드 테스트는 다음 위치에 있습니다.

  - src/test/java/kr/ac/collage_api/CollageApiApplicationTests.java

  테스트 실행:

  # Unix/macOS
  ./mvnw test

  # Windows
  mvnw.cmd test

  ### 개발 팁

  - 자동 재시작을 위해 devtools를 사용할 수 있습니다.
      - org.springframework.boot:spring-boot-devtools가 runtime 스코프로 이미 포함되어 있습니다.
  - 프로파일을 사용해 로컬/스테이징/운영 환경 설정을 분리하세요.
      - spring.profiles.active 프로퍼티 활용
  - 새로운 기능을 추가할 때의 추천 흐름:
      - kr.ac.collage_api 하위에 새 패키지 생성 (예: course, notice)
      - 해당 패키지에 Controller/Service/Mapper/VO 클래스 추가
      - src/main/webapp/WEB-INF/views/<기능명> 아래에 JSP 뷰 생성
      - src/main/resources/mybatis/mapper 아래에 MyBatis 매퍼 XML 추가

  ### 라이선스

  현재 이 프로젝트에는 명시적인 라이선스가 선언되어 있지 않습니다.
  프로젝트를 공개하거나 배포할 계획이 있다면 사용하려는 라이선스를 결정하고, 별도의 LICENSE 파일을 추가하는 것을 권장합니다.
