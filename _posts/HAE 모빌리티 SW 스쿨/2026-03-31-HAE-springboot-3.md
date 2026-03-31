---
title: "스프링부트 (3)"
author: dapin1490
date: 2026-03-31 17:54:00 +09:00
categories: [HAE, 스프링부트]
tags: [현대오토에버, 모빌리티, 스프링부트, MVC, REST API, Thymeleaf, MyBatis, SQL, Vue.js, HTML]
render_with_liquid: false
use_math: true
---

## post 프로젝트에 댓글을 추가하자

1. `Comment.java` 추가됨 ← `Post.java` 베끼면 됨
2. `schema.sql`에 테이블+데이터 생성 쿼리 추가 ← Posts 테이블 관련 쿼리와 유사
3. `CommentMapper.java` 작성 ← `PostMapper.java` 베끼면 됨
4. `CommentMapper.xml` 작성 ← 베끼는 건 마찬가지
5. `CommentController.java` 작성
6. `CommentService.java` 작성
7. UI 추가

### 전체 흐름 한 줄 요약

DB에 `comments` 테이블을 두고, Java 쪽에서는 `Comment` 모델 ↔ MyBatis 매퍼 ↔ 서비스 ↔ 컨트롤러로 이어지며, 화면은 게시글별 URL로 목록/등록하고, 수정/삭제는 `/comments` API를 쓴다.

### 1. `Comment.java` 추가

DB 한 행(row)과 맞추기 위한 도메인 클래스. 컬럼과 대응하는 필드(`id`, `content`, `createdAt`, `updatedAt`, `postId`)와 getter/setter만 두는 POJO 형태임.

JSON으로 API 요청, 응답할 때 Spring이 필드 이름을 camelCase(`postId`)로 주고받고, MyBatis는 컬럼(`post_id`)과 매핑 규칙(보통 설정으로 snake_case ↔ camelCase)으로 연결한다.

### 2. `schema.sql` - 테이블, 초기 데이터

`comments` 테이블에 댓글 본문, 시간, 어느 글에 달렸는지(`post_id`) 를 넣고, `posts(id)`를 외래키로 묶는다. 존재하지 않는 게시글 ID에는 댓글이 들어가지 않는다.

`INSERT`로 샘플 댓글을 넣어 두면, 앱 기동 시(H2 등에서 스크립트 실행 시) 목록/연동 테스트를 바로 해 볼 수 있음.

### 3. `CommentMapper.java` 작성

MyBatis 매퍼 인터페이스. 메서드 이름이 XML의 `id`와 연결됨.

- `findByPostId`, `insertByPostId`: 특정 게시글에 달린 댓글 조회/등록용 (게시판 UI에서 주로 사용).
- `findAll`, `findById`, `insert`, `update`, `delete`: 댓글만 대상으로 한 일반 CRUD (`/comments` REST용).

`@Mapper`로 스캔되면 구현체는 런타임에 MyBatis가 만든다.

### 4. `CommentMapper.xml` 작성

위 인터페이스의 SQL을 정의함.

- `findByPostId`: `WHERE post_id = #{postId}` 로 글별 댓글만 가져옴.
- `insertByPostId`: `content`와 `post_id`를 넣어 저장함. `useGeneratedKeys`로 삽입 후 `comment.id`에 DB가 만든 PK를 채워 줄 수 있다.
- 나머지 `insert`/`update`/`delete`는 공통 CRUD용.

### 5. `CommentController.java` 작성

`@RestController` + `@RequestMapping("/comments")` 로 댓글 리소스를 JSON API로 노출한다.

- `GET /comments`, `GET /comments/{id}`, `POST /comments`, `PUT /comments/{id}`, `DELETE /comments/{id}`

강의 순서상 여기가 Service보다 앞에 있어도, 동작 관점에서는 컨트롤러가 `CommentService`를 호출하는 구조.

### 6. `CommentService.java` 작성

`@Service`로 등록되고, `CommentMapper`만 의존해 비즈니스 호출을 한 곳에 모은다.

- `getCommentsByPostId` → `findByPostId`
- `createCommentByPostId` → `insertByPostId`

그 외 `getAllComments`, `createComment` 등은 `CommentController`의 `/comments` 엔드포인트와 짝을 이룬다.

실제 화면(`board.html`) 연동을 보면, 글별 조회/등록은 `PostController`에 붙어 있다.

- `GET /posts/{postId}/comments` → `commentService.getCommentsByPostId`
- `POST /posts/{postId}/comments` → `commentService.createCommentByPostId`

즉 REST 설계에서 "댓글이 게시글의 하위 리소스"처럼 보이게 하려고 `PostController`에 중첩 경로를 둔 것이고, 수정/삭제는 댓글 ID만 있으면 되므로 `PUT/DELETE /comments/{id}` 로 처리함.

### 7. UI 추가 (`board.html`)

- 게시글 행에 \[댓글 보기] 등으로 패널을 열고, 그 안에서 textarea + 등록 버튼, 댓글 목록을 그린다.
- 목록: `axios.get('/posts/' + postId + '/comments')`
- 새 댓글: `axios.post('/posts/' + postId + '/comments', { content: ... })`
- 수정: `axios.put('/comments/' + commentId, { content: ... })`
- 삭제: `axios.delete('/comments/' + commentId)`

열린 패널/캐시/수정 모드 상태는 `openedCommentPostId`, `commentsCacheByPostId`, `editingCommentState` 같은 변수로 관리한다.

### 이 순서로 보세요

| 순서                    | 역할                                                                             |
| ----------------------- | -------------------------------------------------------------------------------- |
| 모델                    | DB/API가 다루는 데이터 형태를 먼저 고정                                          |
| 스키마                  | 저장 구조와 제약(외래키) 확정                                                    |
| Mapper 인터페이스 + XML | DB 접근 계약과 SQL 구현                                                          |
| Controller / Service    | 수업에서는 순서가 바뀔 수 있으나, 의존 방향은 항상 Controller → Service → Mapper |
| UI                      | 정해진 URL로 위 API를 호출                                                       |

## 조회수를 추가하자

1. `Post.java` 에 조회수 속성 추가
2. `PostMapper.java` 에 조회수 증가 메소드 선언, `PostMapper.xml` 에 조회수 증가 쿼리 작성
3. `PostController.java` 에 조회수 증가 매핑 추가
4. `PostService.java` 에 조회수 증가 메소드 추가 → 여기까지 조회수 증가 메소드가 여기저기 추가되는데, 실상 진짜 내용(구현)을 갖고 있는 파일은 xml밖에 없음. 나머지는 다 이름만 돌려막기해서 부르는 거임.
5. UI에 조회수와 호출 시 조회수 증가 트리거를 추가한다. → ‘조회수 증가’ 로직 자체는 백엔드가 만들어서 갖고 있지만 그걸 실행하는 건 프론트가 하는 것. 여기 조회수 보여주고 이거 조회수 증가시켜, 라고 시키는 걸 프론트가 한다.

### 1. `Post.java`에 조회수 속성 추가

`viewCount` 필드와 getter/setter를 두어, 목록/상세 API JSON과 MyBatis 조회 결과가 같은 타입으로 다뤄지게 한다. DB 컬럼명은 보통 `view_count`이고, MyBatis에서 언더스코어 → 카멜케이스 매핑이 켜져 있으면 `SELECT *` 결과가 `viewCount`에 자동으로 들어간다.

### 2. `PostMapper.java` / `PostMapper.xml` - 조회수 증가

인터페이스에 `incrementViewCount(Long id)`를 선언하고, XML에서 그 `id`와 연결된 `UPDATE` 한 번으로 처리한다.

```xml
<update id="incrementViewCount" parameterType="long">
    UPDATE posts SET view_count = view_count + 1 WHERE id = #{id}
</update>
```

`view_count = view_count + 1`은 현재 DB 값에 1을 더하는 방식이라, 동시에 여러 요청이 와도 "읽고 다시 쓰기"보다 단순하고 일반적이다. 반환 타입 `int`는 영향을 받은 행 수(보통 1).

### 3. `PostController.java` - 조회수 증가 URL 매핑

```java
@PostMapping("/{id}/view")
public int incrementViewCount(@PathVariable Long id) {
    return postService.incrementViewCount(id);
}
```

- 실제 경로: `POST /posts/{id}/view`
- POST를 쓰는 이유: "조회" 자체는 `GET`이지만, 조회수를 올리는 것은 서버 상태를 바꾸는 동작이라 별도 `POST` 엔드포인트로 두는 패턴이 흔함. (상세 내용 읽기는 그대로 `GET /posts/{id}`)

### 4. `PostService.java` - 서비스에서 매퍼 호출

```java
public int incrementViewCount(Long id) {
    return postMapper.incrementViewCount(id);
}
```

컨트롤러는 비즈니스 규칙을 모르고 위임만 하고, 지금은 규칙이 단순해 매퍼를 그대로 호출하는 형태.

### 5. UI - 조회수 표시 + 언제 증가시킬지

- 표시
    - 테이블 헤더에 \[조회수] 열을 두고, 각 행에 `post.viewCount`를 넣는다. `null`이면 `0`으로 보이게 처리한다.
    - 셀에 `data-post-view-count-for="${post.id}"` 같은 속성을 두어, 나중에 상세 보기 후 최신 조회수 칸만 갱신할 수 있게 한다 (`syncPostViewCountCell`).
- 증가 트리거 (`viewPost`)

```jsx
function viewPost(id) {
  clearStatusMessage();

  const fetchPostDetail = () => axios.get(`/posts/${id}`).then(res => res.data);

  const detailPromise = hasRecordedPostViewInSession(id)
    ? fetchPostDetail()
    : axios.post(`/posts/${id}/view`)
        .then(() => {
          markPostViewRecordedInSession(id);
          return fetchPostDetail();
        })
        .catch(() => fetchPostDetail());

  detailPromise
    .then(post => {
      syncPostViewCountCell(id, post.viewCount);
      alert(`ID : ${post.id}\\n ${post.title}\\n ${post.content}\\n조회수: ${post.viewCount != null ? post.viewCount : 0}`);
    })
```

로직은 다음과 같다.

1. 이 브라우저 탭의 `sessionStorage`에 해당 글 ID가 아직 없으면

    → `POST /posts/{id}/view`로 조회수를 1 올리고, ID를 저장한 뒤 `GET /posts/{id}`로 상세를 다시 가져온다. (증가 직후 값을 alert/표에 반영하기 위함)

2. 이미 이 세션에서 그 글을 본 적이 있으면

    → `POST`는 보내지 않고 `GET`만 해서 상세만 보여준다.

    → 같은 탭에서 \[상세]를 여러 번 눌러도 조회수는 세션당 한 번만 오르게 하는 의도. *← 사실 원래 의도는 트리거할 때마다 조회수가 오르는 거였는데, 별도로 지정을 안했더니 cursor가 이렇게 구현해놨음. 실제 서비스 관점에서 생각하면 이게 타당하지 싶어서 그대로 둠.*

3. `POST`가 실패해도 `catch`에서 `fetchPostDetail()`로 넘어가 상세는 최대한 보여 주려는 완화 처리가 들어 있다.

`sessionStorage` 키는 `viewedPostIdsSessionStorageKey`로 고정 문자열을 쓰고, 배열 JSON으로 ID 목록을 유지한다.

### 요약

- 백엔드: `Post`에 필드 추가 → MyBatis로 `view_count` 1 증가 → `POST /posts/{id}/view`로 노출 → 서비스가 매퍼 호출.
- 프론트: 목록에 조회수 열을 그리고, 상세 버튼을 눌렀을 때만(그리고 세션에서 처음 볼 때만) `POST .../view` 후 `GET`으로 최신 글/조회수를 맞춘다.

조회수를 "세션당 1회"가 아니라 요청마다 올리고 싶다면 `sessionStorage` 분기와 `hasRecordedPostViewInSession`을 빼고, `viewPost`에서 항상 `POST` 후 `GET`만 호출하면 된다.

## Vue.js를 알기 전에 HTML을 아세요

- 그 뭐 내가 기본적인 건 대충 알아요 그거 아니까 깃허브 블로그 굴리는 거 아니겠니 예전엔 깃허브 블로그도 통째로 HTML로 썼단다
- `p`: 기본적인 문단 태그. 기능 없는 기본 텍스트가 들어간다.
- `h1` ~ `h6`: 헤더 태그. 문서 서식 상에서 제목으로 취급되는 텍스트를 쓴다. 아니 사실 `p` 태그로도 `h`처럼 보이게 만들 수 있긴 한데요 의미가 달라. 헤더는 헤더야.
- `a`: 링크 달기. 이 태그 사이에 있는 텍스트는 하이퍼링크 텍스트가 된다.
- `ul`: unordered list 태그. 불렛포인트로 구성된 리스트 영역을 지정함.
- `ol`: ordered list 태그. 숫자로 구성된 리스트 영역을 지정함.
- `li`: list 태그. `ul`과 `ol`의 구성요소로 사용됨. 실제 리스트 본문이 하나하나 들어가는 부분.
- HTML은 딱 좋은 가이드 있어 <https://developer.mozilla.org/ko/> 이거 보세요