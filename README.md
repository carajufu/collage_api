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
