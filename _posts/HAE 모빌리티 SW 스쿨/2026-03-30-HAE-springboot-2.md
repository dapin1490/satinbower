---
title: "스프링부트 (2)"
author: dapin1490
date: 2026-03-30 19:00:00 +09:00
categories: [HAE, 스프링부트]
tags: [현대오토에버, 모빌리티, 스프링부트, MVC, REST API, Thymeleaf, MyBatis, SQL]
render_with_liquid: false
use_math: true
---

> table of contents
{: .prompt-tip }

- [블로그 백엔드 데모 구현하기](#블로그-백엔드-데모-구현하기)
  - [1. 시작하기](#1-시작하기)
  - [2. `application.properties` 수정하기](#2-applicationproperties-수정하기)
  - [2.5. 시작부터 첫 설정까지의 흐름](#25-시작부터-첫-설정까지의-흐름)
  - [3. 서버 연결 테스트](#3-서버-연결-테스트)
  - [4. 객체 규격화](#4-객체-규격화)
  - [5. 자바로 SQL 작성하기](#5-자바로-sql-작성하기)
  - [6. 서비스 만들기](#6-서비스-만들기)
  - [7. 컨트롤러 만들기](#7-컨트롤러-만들기)
  - [8. UI 만들기](#8-ui-만들기)
  - [자 이게 요점이야](#자-이게-요점이야)
- [SQL 연동 백엔드 데모 구현하기](#sql-연동-백엔드-데모-구현하기)
  - [큰 그림: 스프링부트가 하는 일](#큰-그림-스프링부트가-하는-일)
  - [1. 스타터 프로젝트 + `application.properties` (MyBatis 제외)](#1-스타터-프로젝트--applicationproperties-mybatis-제외)
  - [2. `User.java` (모델 / 도메인)](#2-userjava-모델--도메인)
  - [3. `UserMapper.java` + `UserMapper.xml` (DB 접근 계층)](#3-usermapperjava--usermapperxml-db-접근-계층)
  - [4. `UserService.java` (비즈니스 로직)](#4-userservicejava-비즈니스-로직)
  - [5. `UserController.java` + 서버 첫 실행](#5-usercontrollerjava--서버-첫-실행)
  - [6. `application.properties`에 MyBatis 설정 추가](#6-applicationproperties에-mybatis-설정-추가)
  - [7. `DashboardViewController` + `dashboard.html` (UI)](#7-dashboardviewcontroller--dashboardhtml-ui)
  - [요약](#요약)

## 블로그 백엔드 데모 구현하기

### 1. 시작하기

Spring Initializr에서 프로젝트 설정을 갖추어 초기 폴더를 만든다. 이 내용은 `pom.xml`에 작성되고, 이 프로젝트의 "아키텍처 방향"을 정한다: 웹 API + JDBC 기반 데이터 접근 + H2로 학습용 DB.

- `java.version=17`
- Spring Boot parent: `spring-boot-starter-parent` 버전 `3.5.13`
- 주요 의존성
    - `spring-boot-starter-web`: 웹 계층(내장 Tomcat, 컨트롤러 요청 처리, REST API 형태의 응답)
    - `spring-boot-starter-data-jdbc`: "JPA가 아니라 JDBC 기반"으로 DB 접근(이 프로젝트는 실제로 `JdbcTemplate`을 사용)
    - `h2`(runtime): 개발/학습용 인메모리 DB 드라이버
    - `spring-boot-starter-thymeleaf`: (있다면) 서버 사이드 템플릿 렌더링용
    - `spring-boot-devtools`: 개발 중 자동 재시작 같은 편의 기능
    - `spring-boot-starter-test`: 테스트 도구

### 2. `application.properties` 수정하기

> 파일 경로: `src/main/resources/application.properties`

프로젝트에서 `src/main/resources/application.properties`는 Spring Boot가 시작할 때 자동으로 읽는 설정 파일이다. 여기 설정들은 크게 3묶음으로 이해할 수 있다.

1. 애플리케이션/식별 정보
    - `spring.application.name=post`: 애플리케이션 이름(로그, 표시 등에서 사용)
2. DB 연결(H2 인메모리) 설정
    - `spring.datasource.driver-class-name=org.h2.Driver`
    - `spring.datasource.username=sa`
    - `spring.datasource.url=jdbc:h2:mem:testdb`

        여기서 중요한 부분은 `jdbc:h2:mem:testdb` .

        - "메모리에만 존재하는 DB"를 뜻해서,
        - 서버 실행할 때마다 새로 시작하고,
        - 프로세스 종료하면 데이터도 사라짐. (학습/실습에 매우 편함)
3. H2 콘솔 + SQL 자동 초기화
    - `spring.h2.console.enabled=true`
    - `spring.h2.console.path=/h2-console`

        이 덕분에 브라우저에서 보통 `http://localhost:8080/h2-console` 같은 경로로 현재 DB 상태를 눈으로 확인할 수 있다(기본 포트는 `server.port`를 따로 안 줬으니 Spring Boot 기본값 8080).

    - `spring.sql.init.encoding=UTF-8`
    - `spring.sql.init.mode=always`

        이건 "서버가 뜰 때마다" `classpath`에 있는 SQL 초기화 스크립트를 실행하라는 뜻이고, 실제로 이 프로젝트에는 `src/main/resources/schema.sql`이 있다.

        해당 `schema.sql`은 `posts` 테이블을 만들고(`CREATE TABLE`) 샘플 데이터를 넣는다(`INSERT INTO ...`).

        즉, `application.properties`의 `spring.sql.init.mode=always`가 있어서, 매번 실행 시 테이블/데이터 준비가 자동으로 이뤄지는 구조.


### 2.5. 시작부터 첫 설정까지의 흐름

지금까지의 흐름을 정리하면, Spring Initializr로 기본 뼈대를 만들고(pom/의존성) → 처음으로 실행/데이터 환경을 잡는 핵심 설정을 `application.properties`에 넣어서 → 서버가 뜰 때 H2(인메모리 DB)를 만들고 `schema.sql`을 실행해 테이블/샘플 데이터를 준비하는 단계이다.

> 전체 흐름 도식(지금까지 단계 중심)

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  A["Spring Initializr로<br>프로젝트 생성"] --> B["pom.xml 의존성 생성됨"]
  B --> C["서버 시작: PostApplication.main"]
  C --> D["Spring이 application.properties 로딩"]
  D --> E["H2 DataSource 생성 (jdbc:h2:mem:testdb)"]
  D --> F["SQL 초기화 실행 (spring.sql.init.mode=always)"]
  F --> G["schema.sql 실행: <br>posts 테이블/샘플 데이터 준비"]

linkStyle default stroke:#1AAAC7

</pre>

### 3. 서버 연결 테스트

> 파일 경로: `src/test/java/com/example/post/PostApplicationTests.java`

`PostApplicationTests.java` 파일에 작성됨. 서버 연결(정확히는 스프링 컨텍스트 및 DB 연결) 확인을 목적으로 하며, 전체 구현(컨트롤러/서비스/리포지토리 로직)에는 영향이 없는 범위의 점검용 통합 테스트.

- 검증하는 것
    1. `@SpringBootTest`
        - 테스트 실행 시 스프링 부트 애플리케이션 컨텍스트를 실제로 띄움(`PostApplication` 기준 설정을 포함해서 bean들을 로딩).
        - 그래서 설정이 틀렸거나(의존성/빈 충돌/설정 오류) 애플리케이션이 뜨지 못하면 `contextLoads()`에서 바로 실패.
        - `contextLoads()` 는 "컨텍스트 로딩 여부"만 확인한다.
    2. `DataSource` 주입 후 H2 연결 확인
        - `application.properties`에 들어있는 `spring.datasource.*` 설정을 기반으로, 스프링이 만든 `DataSource` 빈이 주입됨.
        - 이후 `dataSource.getConnection()`으로 실제 JDBC 커넥션을 열 수 있는지 확인.
        - `try-with-resources`로 커넥션을 자동으로 닫아서 누수 가능성을 줄이고,
        - `connection.getMetaData().getURL()`을 출력해서 "지금 H2에 붙었는지"를 확인하는 용도. (콘솔 출력으로 확인)
- 이 파일에 대한 수정 및 구현 등은 전체 구현에는 영향을 주지 않음
    - 이 파일은 `src/test/java/...` 아래라서 Maven의 테스트 단계에서만 실행됨.
    - 즉, 운영/실행 시(서버 기동 시) 실제 요청 처리 코드 경로에 끼어들지 않음.
    - 따라서 서버 연결 이슈를 확인하려고 추가한 "진단용 테스트" 성격이고, 기능 구현 자체를 바꾸는 게 아님.

### 4. 객체 규격화

> 파일 경로: `src/main/java/com/example/post/model/Post.java`

`Post.java`는 이 프로젝트에서 "게시글 1개를 자바 객체로 표현하는 규격(모양)"을 먼저 잡아두는 단계이다. 나중에 DB 테이블을 만들든(h2 console로 임시 테이블을 만들었든), `schema.sql`로 자동 생성하든, 결국 DB의 한 행(row) ↔ 자바 객체(Post) ↔ API 응답/요청 JSON 이 서로 같은 필드 구조로 이어져야 동작한다. 이 파일에서 단위 객체의 이름을 공식적으로 정했다는 말이다.

- 단어 먼저 알기
    - POJO: Plain Old Java Object. 순수하게 자바 언어만으로 구성된 일반적인 객체
    - JPA: Java Persistence API. 자바 애플리케이션에서 관계형 데이터베이스를 사용하는 방식을 정의한 ORM(Object-Relational Mapping) 기술 표준
    - JDBC: Java Database Connectivity. 자바 애플리케이션에서 오라클, MySQL 등 다양한 데이터베이스에 접속하여 데이터를 쿼리하거나 업데이트(CRUD)할 수 있도록 도와주는 표준 자바 API
    - JPA와 JDBC 차이: 객체지향(JPA) vs SQL 직접 제어(JDBC). JPA가 JDBC를 내부적으로 사용하여 SQL 쿼리를 자동으로 생성한다.
- `Post.java`가 하는 일
    - 이 클래스는 JPA Entity가 아니라 단순 POJO(데이터 담는 그릇)다.
    - 이 프로젝트는 JPA가 아니라 JDBC 방식이라서, DB와 직접 매핑하는 주체는 `PostRepository` 쪽이고(`JdbcTemplate`, `RowMapper` 사용),
    - `Post`는 그 매핑 결과를 담고, 컨트롤러에서 요청/응답 바디로도 쓸 수 있는 "데이터 형태" 역할을 한다.
- 필드들이 의미하는 것

    `Post` 클래스의 필드는 게시글 테이블의 컬럼들과 "의미/타입"을 맞추도록 구성되어 있다.

    - `id: Long`: DB의 기본키 값(등록 후 DB가 주는 값이 들어오는 용도)
    - `title: String`: 게시글 제목
    - `content: String`: 게시글 본문
    - `createdAt: LocalDateTime`: 생성 시각
    - `updatedAt: LocalDateTime`: 마지막 수정 시각
- 네이밍 규칙에 주의
    - DB에서는 보통 `created_at`, `updated_at`처럼 `snake_case`가 쓰이고,
    - 자바 필드는 `createdAt`, `updatedAt`처럼 `camelCase`가 쓰이는 경우가 많아서,
    - 중간에서 변환/매핑이 필요함(이 변환은 `PostRepository`의 `RowMapper`가 담당).
- getter/setter가 필요한 이유

    `Post`의 `getXxx()/setXxx()`는 "값을 밖에서 읽고/넣을 수 있게" 해주는 JavaBeans 형태이다.

    쉽게 설명하면 역할은 두 가지이다.

    1. `PostRepository`가 DB에서 읽어온 값을 `post.setTitle(...)` 같은 식으로 주입하기 쉽게 함
    2. 컨트롤러 계층에서 요청 JSON을 `Post` 객체로 받거나, 응답할 때 `Post` 객체의 값을 JSON으로 만들 수 있게 함
- 그림을 보자 ("Post가 어디에 쓰이는지" 관점)

    지금 단계에서 `Post.java`만 중심으로 보면, 이 객체는 계층 사이에서 "데이터 운반"을 담당함.


<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TB
    A["Client (HTTP/JSON)"] --> B["Controller 계층"]
    B -- 요청 바디/응답 바디 --> C["Post 객체 (src/main/java/.../model/Post.java)"]
    C -- 값 전달 --> D["Service/Repository 계층"]
    D -- DB 행 ↔ Post 변환 --> E["posts 테이블 (H2)"]

linkStyle default stroke:#1AAAC7

</pre>

### 5. 자바로 SQL 작성하기

> 파일 경로: `src/main/java/com/example/post/repository/PostRepository.java`

> 이 자바 프로젝트 폴더는 DB를 읽고 쓰기 위한 중간 브로커 같은 거임

- `PostRepository` 역할 요약

    JDBC로 SQL을 직접 실행해서 `posts` 테이블과 `Post`(모델) 객체를 오가게 만드는 계층이다.

    핵심 구성요소는 2개

    - `JdbcTemplate jdbcTemplate`: 스프링이 만들어주는 "JDBC 실행 도구"
    - `RowMapper<Post> postRowMapper`: `ResultSet`의 한 행을 `Post` 객체로 바꾸는 규칙
- `postRowMapper`가 하는 매핑

    `RowMapper`에서는 DB 컬럼명을 그대로 써서(`id`, `title`, `content`, `created_at`, `updated_at`) `Post`의 필드로 채운다. 특히 시각 컬럼은 `rs.getTimestamp("created_at").toLocalDateTime()` , `rs.getTimestamp("updated_at").toLocalDateTime()`처럼 변환함.

    DB 스키마의 컬럼명/타입이 `schema.sql`(혹은 h2 console에서 만든 임시 테이블)과 맞아야 바로 동작한다.

- CRUD 메서드가 DB에 날리는 작업

    `PostRepository`의 메서드들은 각각 `posts` 테이블에 대해 아래를 수행한다.

    - `findAll()`
        - SQL: `SELECT * FROM posts`
        - 결과는 `postRowMapper`를 통해 `List<Post>`로 변환
    - `findById(Long id)`
        - SQL: `SELECT * FROM posts WHERE id = ?`
        - `?`에 `id`가 바인딩된다(쿼리 인젝션 방지 목적)
        - 해당 row가 없으면 JDBC 예외가 발생할 수 있는 형태이다.
    - `save(Post post)`
        - SQL: `INSERT INTO posts (title, content, created_at, updated_at) ...`
        - `created_at`, `updated_at`은 DB의 `CURRENT_TIMESTAMP`로 채워서 넣는다.
        - 참고: 이 구현은 INSERT 후 생성된 `id`를 다시 읽어 `post.setId(...)`까지 해주지는 않는다(그래서 컨트롤러가 반환하는 `post`에 id가 없을 수 있음).
    - `update(Long id, Post post)`
        - SQL: `UPDATE posts SET title=?, content=?, updated_at=CURRENT_TIMESTAMP WHERE id=?`
        - 영향받은 행 수(int)를 반환하지만, 상위 계층에서 보통 "성공/실패"만 판단하는 식이다.
    - `delete(Long id)`
        - SQL: `DELETE FROM posts WHERE id=?`
        - 역시 영향받은 행 수(int)를 반환함.
- 요청 흐름(Controller → Service → Repository)

    실제 동작은 `PostController`/`PostService`가 `PostRepository`를 호출하면서 완성된다.

    - `PostController.java`
        - `@RequestMapping("/posts")` 아래에서 REST 엔드포인트를 정의
        - 각 엔드포인트가 `PostService`로 위임
    - `PostService.java`
        - 입력 검증(예: `title`, `content` 필수) 같은 "유스케이스 규칙"을 담당
        - 검증이 통과되면 `PostRepository`의 CRUD 메서드를 호출
- 그림으로 보자

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  A[Client] --> B[HTTP Request]
  B --> C["PostController (/posts)"]
  C --> D[PostService]
  D --> E[PostRepository]
  E --> F[JdbcTemplate executes SQL]
  F --> G[H2 database: posts table]
  G --> F --> E --> D --> C --> H[HTTP Response JSON]

linkStyle default stroke:#1AAAC7

</pre>

### 6. 서비스 만들기

> 파일 경로: `src/main/java/com/example/post/service/PostService.java`

이 프로젝트에서 "비즈니스 규칙(검증) + 저장소 호출(위임)" 담당하는 계층이다. 컨트롤러가 HTTP 요청을 받으면, 서비스가 그 요청을 처리하기 위한 규칙을 먼저 적용하고 마지막에 `PostRepository`로 DB 작업을 넘기는 구조.

- `PostService`가 하는 일(메서드별)

    `@Service` bean으로 등록되고, 생성자에서 `PostRepository`를 주입받는다. 그래서 `PostService`는 SQL/JDBC를 직접 알지 않고 저장소만 호출한다.

    - `getAllPosts()`
        - "전체 조회"는 검증 없이 바로 `postRepository.findAll()`에 위임한다.
        - 결과는 `List<Post>`를 그대로 반환.
    - `getPostById(Long id)`
        - `id == null`이면 즉시 `IllegalArgumentException("ID is required")`를 던진다.
        - null이 아니면 `postRepository.findById(id)` 호출.
    - `createPost(Post post)`
        - 생성 전에 검증한다.
            - `post.getTitle()`이 `null`이거나 빈 문자열이면 예외
            - `post.getContent()`가 `null`이거나 빈 문자열이면 예외
        - 검증 통과 시 `postRepository.save(post)`로 INSERT 위임.
    - `updatePost(Long id, Post post)`
        - 수정도 동일하게 `title/content` 필수 검증 후 `postRepository.update(id, post)` 호출.
    - `deletePost(Long id)`
        - `id == null`이면 예외
        - 아니면 `postRepository.delete(id)` 호출.
- 이 서비스 계층이 "전체 구현"에 주는 의미
    - 검증/규칙은 서비스에서, DB 접근은 레포지토리에서 역할이 나뉘어 있다.
    - 현재 `PostService`에는 `@Transactional`이 없다. 이번 데모에서는 "DB 한 번 호출" 정도라 트랜잭션 경계 설정이 필수는 아니지만, 여러 DB 작업을 한 유스케이스로 묶어야 할 때는 서비스에서 `@Transactional`을 쓰는 방향이 일반적이다.
        - 트랜잭션: 데이터베이스 상태를 변화시키는 하나 이상의 작업 단위. 특히 데이터베이스에서 더 나눌 수 없는 최소 작업 단위로, 성공하면 모두 반영되고 실패하면 모두 취소(Rollback)되는 특징을 가짐. 금전 거래와 같이 중복하여 업데이트되면 치명적인 경우 특히나 주의할 것이 요구됨.
- 예외가 HTTP 응답으로 어떻게 이어질까

    이 프로젝트에는 전역 예외 처리(`@ControllerAdvice`) 코드가 따로 없다. 서비스에서 던진 `IllegalArgumentException` 같은 런타임 예외는 보통 기본적으로 500 응답 흐름이 됨.

- 요청 흐름을 그림으로 보자

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  A[Client] --> B["PostController (/posts)"]
  B --> C[PostService]
  C --> D[PostRepository]
  D --> E[JdbcTemplate]
  E --> F["H2 / posts 테이블"]
  F --> E --> D --> C --> B --> G["HTTP Response(JSON)"]

linkStyle default stroke:#1AAAC7

</pre>

### 7. 컨트롤러 만들기

> 파일 경로: `src/main/java/com/example/post/controller/PostController.java`

`PostController`는 이 프로젝트에서 HTTP 요청이 들어오는 "입구(API 라우팅)" 역할을 한다. `/posts` 아래로 들어온 요청을 각각 자바 메서드로 연결하고, 결과를 `ResponseEntity`로 HTTP 응답(주로 JSON)으로 만들어 `PostService`에 위임한다.

- `PostController`의 핵심 포인트
    - `@RestController` + `@RequestMapping("/posts")`
        - 클래스의 요청 매핑은 전부 `/posts` 접두 경로를 기준으로 동작한다.
        - `@RestController`라서 메서드가 반환하는 객체(`Post`, `List<Post]`)가 응답 바디로 직렬화(JSON) 된다.
    - `PostService`를 생성자로 주입받음
        - 컨트롤러는 비즈니스 규칙/DB 처리를 직접 하지 않고, 전부 `postService`에 위임한다.
- 엔드포인트별 동작(HTTP → 서비스 위임 → 응답)
    1. `@GetMapping` (요청: `GET /posts`)
        - `postService.getAllPosts()` 호출
        - 결과를 `ResponseEntity.ok(...)`로 반환 (성공이면 HTTP 200, 리스트면 JSON 배열)
    2. `@GetMapping("{id}")` (요청: `GET /posts/{id}`)
        - `postService.getPostById(id)` 호출
        - 만약 `post == null`이면 `ResponseEntity.notFound().build()`로 HTTP 404
        - 아니면 `ResponseEntity.ok(post)`로 HTTP 200 + Post JSON
    3. `@PostMapping` (요청: `POST /posts`)
        - `@RequestBody Post post`로 요청 JSON을 `Post` 객체로 받음(여기서 `title`, `content`가 바인딩됨)
        - `postService.createPost(post)` 호출
        - `ResponseEntity.ok(post)` 반환 (구현에 따라 DB에서 생성된 `id/시각`이 응답 `post`에 바로 들어오지 않을 수 있음)
    4. `@PutMapping("{id}")` (요청: `PUT /posts/{id}`)
        - `@PathVariable Long id` + `@RequestBody Post post`
        - `postService.updatePost(id, post)` 호출
        - `ResponseEntity.ok(post)` 반환
    5. `@DeleteMapping("{id}")` (요청: `DELETE /posts/{id}`)
        - `postService.deletePost(id)` 호출
        - 본문 없이 `ResponseEntity.noContent().build()`로 HTTP 204
- 컨트롤러가 요청을 받은 후 일어나는 일

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  A[Client] -->|HTTP 요청| B["PostController (/posts)"]
  B --> C[PostService]
  C --> D[PostRepository]
  D --> E[JdbcTemplate]
  E --> F[H2 posts 테이블]
  F --> E --> D --> C -->|"응답 바디(JSON)"| B -->|HTTP Response| A

linkStyle default stroke:#1AAAC7

</pre>

### 8. UI 만들기

> 백엔드에서는 약간 벗어나는 내용이긴 함 근데 뭐 화면까지 보려면 해야지 어쩌겠어요 그냥 보세요

> 파일 경로
>
> - `src/main/resources/templates/board.html`
> - `src/main/java/com/example/post/controller/BoardViewController.java`

`BoardViewController`와 `board.html`은 이 프로젝트에서 "브라우저 화면(서버 렌더링 페이지)"과 "게시글 API(`PostController`의 `/posts`)"를 이어주는 역할을 한다. 이게 마지막임.

- `BoardViewController` (`/board` 화면을 띄우는 컨트롤러)
    - `@Controller`
    - `@GetMapping("/board")`
    - `return "board";`

    사용자가 `GET /board`로 접속하면 Spring MVC가 `src/main/resources/templates/board.html`을 찾아서 브라우저에 렌더링한다.

    여기서 중요한 건 `PostController`처럼 JSON API를 만드는 게 아니라, HTML 페이지 자체를 제공한다는 점.

- `board.html`이 하는 일 (화면 + axios로 `/posts` 호출)

    중요한 부분은 마지막 `<script>` 부분(엄밀하게 수업 내용은 아니었음). 이 페이지는 "게시판 UI"를 그리고, 버튼/폼 이벤트에서 `axios`로 백엔드 API를 호출한다.

    1. 목록 로딩: `GET /posts`
        - `loadPost()` 함수에서 `axios.get('/posts')` 실행
        - 응답 `res.data`(= `PostController`의 `GET /posts` 응답 JSON 배열)를 순회하며 테이블에 행을 그린다.

        호출 흐름:

        - `board.html`의 `axios.get('/posts')`
        - → `PostController`의 `@GetMapping` (`GET /posts`)
        - → `PostService.getAllPosts()`
        - → `PostRepository.findAll()`
        - → H2의 `posts`에서 읽어온 데이터가 JSON으로 응답
    2. 상세보기: `GET /posts/{id}`
        - `viewPost(id)`에서 `axios.get('/posts/' + id)`
        - 상세는 `alert`로 보여주는 방식.
    3. 저장(생성/수정): `POST /posts` 또는 `PUT /posts/{id}`
        - 폼 `onsubmit`에서 id 값이 있으면 수정:
            - `axios.put('/posts/' + id, { title: ..., content: ... })`
        - id가 없으면 생성:
            - `axios.post('/posts', { title: ..., content: ... })`
        - 완료 후 `loadPost()`로 목록을 다시 불러오고 폼을 초기화한다.

        이 화면은 "등록/수정" 로직을 스스로 들고 있지 않고, 백엔드 API에 그대로 위임한다. *→ 딱 프론트가 하는 일임*

    4. 삭제: `DELETE /posts/{id}`
        - `deletePost(id)`에서 `axios.delete('/posts/' + id)`
        - 성공 후 목록을 다시 로딩함.
- 마지막 그림 보자

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  A[사용자 브라우저] -->|"GET /board"| B[BoardViewController]
  B --> C["board.html 렌더링"]

  C -->|"axios.get('/posts')"| D["PostController GET /posts"]
  D --> E[PostService getAllPosts]
  E --> F[PostRepository findAll]
  F --> G[H2 posts 테이블]
  G --> F --> E --> D -->|posts JSON| C

  C -->|"axios.post('/posts') 또는 axios.put('/posts/{id}')"| D2["PostController POST/PUT"]
  C -->|"axios.delete('/posts/{id}')"| D3[PostController DELETE]

linkStyle default stroke:#1AAAC7

</pre>

### 자 이게 요점이야

이 프로젝트는 "설정(환경) → 데이터 구조(모델/테이블) → 데이터 접근 → 비즈니스 로직 → API 입구 → 화면 연결" 순서로 쌓아 올린 전형적인 백엔드 구조이다.

1. 프로젝트 생성 (Spring Initializr)
    - 생성 시점에서 `pom.xml`로 기술 스택이 결정됨
        - `spring-boot-starter-web` (HTTP API)
        - `spring-boot-starter-data-jdbc` + `h2` (JDBC + 인메모리 DB)
        - `thymeleaf` (서버 렌더링 HTML)
    - 의존 관계 시작점: 모든 코드가 이 의존성 위에서 동작
2. `application.properties` 설정
    - H2 연결, 콘솔 경로, SQL 초기화 정책을 정의
    - 특히 `spring.datasource.*`, `spring.h2.console.*`, `spring.sql.init.mode=always`
    - 의존 관계
        - `PostRepository`가 쓰는 `JdbcTemplate`는 결국 여기 DB 설정(`DataSource`)에 의존
        - `schema.sql` 자동 실행 여부도 여기 설정에 의존
3. 연결 확인용 테스트 `PostApplicationTests`
    - 컨텍스트 기동 여부 + `DataSource` 연결 확인
    - 기능 구현 코드가 아니라 "환경 진단"
    - 의존 관계: 테스트는 메인 코드에 의존해서 검증하지만, 런타임 기능에는 직접 영향 없음
4. 임시 테이블 생성(H2 콘솔) + `Post.java` 작성
    - 당시 `schema.sql`이 없었으니 H2 콘솔에서 테이블을 먼저 만든 것
    - `Post.java`는 게시글 1건의 데이터 구조(필드 규약) 정의
    - 의존 관계
        - `PostRepository`의 RowMapper는 `Post` 필드 구조에 의존
        - `PostController`의 `@RequestBody`/응답 JSON도 `Post` 구조에 의존
5. `PostRepository` 작성 (DB 접근 계층)
    - `JdbcTemplate`로 SQL 직접 실행: `findAll/findById/save/update/delete`
    - `RowMapper`로 DB row → `Post` 변환
    - 의존 관계
        - `PostRepository` → `JdbcTemplate` → `DataSource`(`application.properties`)
        - SQL 컬럼명은 실제 `posts` 테이블 구조에 의존 (`created_at` 등)
6. `PostService` 작성 (비즈니스 계층)
    - 제목/본문/ID 검증 후 저장소 호출
    - 즉, 규칙은 서비스, DB 작업은 리포지토리
    - 의존 관계
        - `PostService` → `PostRepository` (단방향 의존)
        - 컨트롤러는 서비스에만 의존하고 저장소를 직접 만지지 않음
7. `PostController` 작성 (REST API 계층)
    - `/posts` CRUD 엔드포인트 제공
    - HTTP 요청을 `PostService` 유스케이스로 연결
    - 의존 관계
        - `PostController` → `PostService` → `PostRepository` → DB
        - JSON 직렬화/역직렬화는 `spring-boot-starter-web`(Jackson)에 의존
8. `board.html` + `BoardViewController` 작성 (화면 연결)
    - `GET /board`로 페이지 렌더링 (`BoardViewController`)
    - 페이지 내부 JS(axios)가 `/posts` API 호출 (`board.html`)
    - 의존 관계
        - `BoardViewController`는 템플릿 이름 `board`에 의존
        - `board.html`은 API 경로 `/posts`에 의존
        - 즉 화면은 DB를 직접 모르고, 오직 API 계층에 의존
9. `schema.sql` 추가 (최종 자동화)
    - 테이블/초기데이터를 코드화해서 재현 가능하게 만듦
    - 이제 수동 H2 콘솔 작업 없이도 서버 시작 시 준비됨
    - 의존 관계
        - `schema.sql` 실행은 `application.properties`의 SQL init 설정에 의존
        - `PostRepository` SQL은 이 스키마와 컬럼 규약 일치에 의존
- 계층 의존 방향 (중요)

    의존은 항상 위에서 아래로만 흐른다.

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart TD
  UI["board.html (axios)"] --> API[PostController]
  PAGE[BoardViewController] --> TEMPLATE['board.html']
  API --> SERVICE[PostService]
  SERVICE --> REPO[PostRepository]
  REPO --> JDBC[JdbcTemplate]
  JDBC --> DB[(H2 posts)]
  CONFIG['application.properties'] --> JDBC
  CONFIG --> INIT['schema.sql 실행']
  INIT --> DB
  MODEL['Post.java'] -.공통 데이터 구조.- API
  MODEL -.공통 데이터 구조.- SERVICE
  MODEL -.공통 데이터 구조.- REPO

linkStyle default stroke:#1AAAC7

</pre>

- 그래서 이게 뭘 한 거냐면

    이 실습은 "DB를 다루는 코드(Repository), 규칙 코드(Service), HTTP 입구(Controller), 화면 연결(Thymeleaf+axios)"를 계층으로 분리하고, 설정(`application.properties`)과 스키마(`schema.sql`)로 실행 환경을 고정하는 방법을 단계적으로 익힌 과정이다.

---

## SQL 연동 백엔드 데모 구현하기

1. `src/main/resources/application.properties` : SQL 연동 설정
2. `src/main/java/com/example/mysql/model/User.java` : 데이터 형식 정의
3. `src/main/java/com/example/mysql/mapper/UserMapper.java` : Mapper 인터페이스 추가
4. `src/main/resources/mapper/UserMapper.xml` : SQL CRUD문 매핑됨
5. `src/main/java/com/example/mysql/service/UserService.java` : 서비스
6. `src/main/java/com/example/mysql/controller/UserController.java` : 컨트롤러
7. `src/main/resources/application.properties` : mybatis 관련 설정 업데이트

### 큰 그림: 스프링부트가 하는 일

스프링부트는 웹 서버를 띄우고, 설정을 읽어서, 요청이 오면 적절한 코드를 실행하는 프레임워크다.

지금 프로젝트는 MySQL + MyBatis로 DB에 접속하고, REST API(`UserController`)로 JSON을 주고받는 구조. 나중에 추가한 `/dashboard`는 화면(HTML)을 보여 주는 전통적인 MVC의 구성요소임.

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: dagre

---

flowchart LR
  subgraph client [클라이언트]
    B[브라우저 또는 Postman]
  end
  subgraph spring [스프링부트 앱]
    C[Controller]
    S[Service]
    M[Mapper + MyBatis]
    DB[(MySQL)]
  end
  B -->|HTTP 요청| C
  C --> S
  S --> M
  M --> DB
  DB --> M
  M --> S
  S --> C
  C -->|HTTP 응답| B

linkStyle default stroke:#1AAAC7

</pre>

### 1. 스타터 프로젝트 + `application.properties` (MyBatis 제외)

스타터는 이미 "웹 + JDBC + MyBatis" 같은 의존성 묶음을 넣어 둔 템플릿이라, 직접 `pom.xml`을 처음부터 다 짤 필요를 줄여 준다.

가장 먼저 수정한 `application.properties`의 역할:

- `spring.datasource.*`: "어떤 MySQL에 붙을지" (URL, DB 이름 `autoever`, 포트 `3306`, 사용자/비밀번호 등).
- `spring.sql.init.*`: 스키마/데이터 초기화와 관련된 옵션(지금은 `#spring.sql.init.mode=always`는 주석).

이 단계까지는 "DB 연결 정보만 준비"한 상태다. MyBatis용 설정이 없으면, 나중에 매퍼 XML을 아무리 만들어도 스프링이 그 파일을 어디서 찾을지 모름 *→ 그래서 나중에 매퍼 xml 추가 후 오류가 생겼을 수 있음.*

### 2. `User.java` (모델 / 도메인)

DB의 `users` 테이블 한 행(row)을 자바 객체로 표현한 것.

- `id`, `name`, `email` 필드 + getter/setter

    MyBatis가 SQL 결과를 이 클래스에 자동으로 채워 넣을 때 필드 이름, 컬럼 이름 매핑 규칙을 쓴다(프로젝트 설정에 따라 camelCase ↔ snake_case 처리 등).


⇒ "데이터의 모양"을 자바 쪽에 정의한 단계

### 3. `UserMapper.java` + `UserMapper.xml` (DB 접근 계층)

여기서 MyBatis 패턴이 사용됨.

- `UserMapper.java`: 자바 인터페이스만 있음. 메서드 이름이 곧 "운영할 SQL 작업"의 이름 (`findAll`, `insert` 등). `@Mapper`로 스프링이 구현체를 만들어 줌.
- `UserMapper.xml`: 실제 SQL이 들어 있는 XML.
    - `namespace`가 인터페이스 풀 패키지명과 일치해야 인터페이스 메서드와 `<select id="findAll">` 같은 태그가 연결됨.

흐름 요약: 자바에서 "무슨 일을 할지" 선언 → XML에 "그 일을 SQL로 어떻게 할지" 작성.

### 4. `UserService.java` (비즈니스 로직)

컨트롤러가 바로 매퍼를 부르도록 할 수도 있지만, 보통 Service를 둔다.

- 역할: "이름/이메일 비었으면 거절" 같은 규칙을 한곳에 모음.
- 구현: 생성자로 `UserMapper`를 받아서(`UserService` → `UserMapper`) CRUD를 위임.

나중에 로그인, 권한, 트랜잭션 같은 걸 넣을 때도 보통 Service에 붙인다.

### 5. `UserController.java` + 서버 첫 실행

`@RestController` + `@RequestMapping("/users")`는 HTTP 요청을 자바 메서드에 연결한다.

- `GET /users` → 전체 목록
- `GET /users/{id}` → 한 명
- `POST /users` → 생성 (JSON body → `User` 객체)
- `PUT /users/{id}` → 수정
- `DELETE /users/{id}` → 삭제
- "밖에서 보이는 입구"가 Controller이고, 안쪽은 Service → Mapper → DB 순서.

### 6. `application.properties`에 MyBatis 설정 추가

지금 파일에는 예를 들면 다음의 코드가 있음.

- `mybatis.mapper-locations=classpath:mapper/*.xml`

    → `src/main/resources/mapper/` 아래 XML을 매퍼 파일로 로드하라는 뜻.

- `mybatis.type-aliases-package=com.example.mysql.model`

    → XML에서 `resultType` 등에 긴 클래스명 대신 별칭을 쓰기 쉬워짐(지금 XML은 풀 패키지를 쓰고 있어도 동작에는 문제 없음).


이 수정 사항이 중요한 점: MyBatis는 이 설정이 없으면 `UserMapper.xml`을 못 찾거나 매핑을 완성하지 못해 기동 단계에서 깨지는 경우가 많다. (에러 메시지에 `mapper-locations`, `BindingException`, `Invalid bound statement` 같은 말이 자주 나온다.)

### 7. `DashboardViewController` + `dashboard.html` (UI)

백엔드 수업 외의 내용이지만 구조만 짚으면:

- `@Controller`: JSON이 아니라 뷰 이름을 반환 (`return "dashboard"`).
- 스프링은 보통 Thymeleaf 등으로 `templates/dashboard.html`을 찾아 HTML 페이지를 만든 뒤 브라우저에 보낸다.
- `UserController`는 `@RestController`라서 주로 JSON API용이고, `DashboardViewController`는 페이지 라우트용 → 역할이 다름.

<pre class="mermaid">

---
config:
  theme: default
  look: neo
  layout: elk

---

flowchart TB
 subgraph api["REST API"]
        UC["UserController"]
        US["UserService"]
        UM["UserMapper"]
  end
 subgraph page["화면"]
        DC["DashboardViewController"]
        T["dashboard.html"]
  end
    UC --> US
    US --> UM
    DC --> T

</pre>

### 요약

| 순서 | 파일                               | 한 줄 요약                                       |
| ---- | ---------------------------------- | ------------------------------------------------ |
| 1    | `application.properties` (초기)    | MySQL에 어떻게 붙을지 설정                       |
| 2    | `User.java`                        | DB 한 행과 같은 모양의 자바 객체                 |
| 3    | `UserMapper.java` + `.xml`         | "어떤 SQL로 DB에 접근할지" 선언 + 구현           |
| 4    | `UserService.java`                 | 규칙·검증·흐름을 담는 중간층                     |
| 5    | `UserController.java`              | HTTP URL과 메서드를 자바에 연결 (API 입구)       |
| 6    | `application.properties` (MyBatis) | XML 매퍼 위치 등 MyBatis가 동작하도록 연결       |
| 7    | 대시보드                           | `/dashboard` 요청 시 HTML 화면 반환 (API와 별도) |

이렇게 보면 설정 → 데이터 모양 → DB접근 → 규칙 → HTTP 입구 → MyBatis 연결 마무리 → (선택) 화면 순으로 층이 쌓인 것이고, 코드를 "위에서 아래로" 읽으면 요청이 어디로 흘러가는지 따라가기 쉽다.