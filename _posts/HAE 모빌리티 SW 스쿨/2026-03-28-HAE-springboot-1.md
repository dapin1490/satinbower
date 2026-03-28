---
title: "스프링부트 (1)"
author: dapin1490
date: 2026-03-28 17:22:00 +09:00
categories: [HAE, 스프링부트]
tags: [현대오토에버, 모빌리티, 스프링부트, MVC, REST API, Thymeleaf, FastAPI]
render_with_liquid: false
use_math: true
---

> Gemini가 정리해준 내용이 일부 포함됨
{: .prompt-info }

> table of contents
{: .prompt-tip }
- [스프링부트](#스프링부트)
- [Controller 만들기](#controller-만들기)
  - [기본적인 Controller](#기본적인-controller)
- [REST API](#rest-api)
  - [REST API의 핵심 제약 조건](#rest-api의-핵심-제약-조건)
  - [주요 HTTP 메서드 활용](#주요-http-메서드-활용)
  - [REST API Controller](#rest-api-controller)
- [MVC 기초 - 모델](#mvc-기초---모델)
- [Thymeleaf가 뭐죠](#thymeleaf가-뭐죠)
  - [1. 핵심 개념: 내추럴 템플릿 (Natural Templates)](#1-핵심-개념-내추럴-템플릿-natural-templates)
  - [2. 주요 기능 및 특징](#2-주요-기능-및-특징)
  - [3. JSP와의 비교](#3-jsp와의-비교)
- [덤](#덤)
- [FAST API가 뭐야](#fast-api가-뭐야)
  - [FastAPI의 정의 및 구성 요소](#fastapi의-정의-및-구성-요소)
  - [주요 차별점 및 특징](#주요-차별점-및-특징)
- [그 외의 API](#그-외의-api)
  - [1. SOAP (Simple Object Access Protocol)](#1-soap-simple-object-access-protocol)
  - [2. GraphQL](#2-graphql)
  - [3. gRPC (Google Remote Procedure Call)](#3-grpc-google-remote-procedure-call)
  - [4. WebSocket 및 Webhook (이벤트 기반)](#4-websocket-및-webhook-이벤트-기반)
- [참고문헌](#참고문헌)

## 스프링부트

- 바닐라 자바로 웹 개발이 불가능할까? → 그건 아님. 하지만 얼마나 번거롭고 어렵습니까? 그걸 위해 프레임워크라는 게 있는 거예요
- 스프링은 웹 개발 프레임워크다. IOC(제어의 역전), DI(의존성)을 대신 해결해준다.
- 스프링부트는요? → 스프링을 좀 더 쉽게 만들기 위해 한 겹 더 씌운 프레임워크
- 프로젝트 세팅만 직접 좀 하시고 나머지는 AI 시키세요
    - 마이너 버전까지는 상관 없고 메이저 3번이기만 하면 됨
    - H2와 타임리프는 임시로 넣은 것. 오늘은 데베 없이 백엔드만으로 할 거니까.

    ![260328-HAE-1-springboot-1.png](/assets/img/category-HAE/260328-HAE-1-springboot-1.png)

- 다운받은 스프링부트 프로젝트 압축파일을 원하는 곳에 압축해제하고, 인텔리제이로 폴더를 연다.
    - 프로젝트 설정에서 SDK를 사용하던 것으로 지정한다 → 이거 하면 다른 곳에도 이 SDK 설정이 적용됨.
    - 언어 수준은 SDK와 동일한 번호로 하기
    - pom.xml 새로고침하기

        ![image.png](/assets/img/category-HAE/260328-HAE-2-springboot-1.png)

- src/main 타고들어가서 나오는 기본 코드 실행하면 서버 실행되고, localhost:8080에서 확인 가능. 아직 뭐 아무것도 만든 거 없어서 오류 페이지 나온다.

## Controller 만들기

- src/main/com.example.demo에 Controller 패키지를 추가하고 그 안에 {name}Controller.java 클래스를 추가한다. 예를 들어 NewbieController.java라고 치자고요.
- 생성된 클래스에 메소드를 작성한다. 내용은 상관 없다. 뭐 헬로 월드 문자열을 반환하든가.
- 작성된 메소드에 어노테이션을 붙인다. 이게 웹사이트의 링크를 구성하게 된다.
- 메소드가 인자를 받으려면 두 가지 방식이 있다. 슬래시 링크로 받거나 물음표 파라미터로 받거나. 의도와 목적에 따라 잘 구분해서 쓰면 된다.

---

### 기본적인 Controller

- 기본적인 2가지 파라미터 활용. `PathVariable`은 링크에 슬래시로 추가되는 인자이고, `RequestParam`은 물음표 뒤에 들어가는 쿼리가 됨. 자세한 설명은 주석으로 보자

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/*
* 스프링 MVC의 핵심 입력 방식(@RequestParam, @PathVariable)을 연습하기 위한 컨트롤러입니다.

* 이 클래스는 @Controller를 사용하므로 기본적으로는 "뷰 이름 반환"이 동작입니다.
* 다만 각 메서드에 @ResponseBody를 붙여, 반환 문자열을 뷰 해석 없이 HTTP 응답 본문에
* 그대로 내려보내도록 설정했습니다.
*/
@Controller
public class NewbieController {
    /*
    * 경로 변수(Path Variable)를 받아 문자열 응답을 반환합니다.
    * 예: GET /old-timer/3  -> num = 3

    * @param num URL 경로의 {num} 위치에서 추출된 정수 값
    * @return HTML 문자열 본문
    */
    @ResponseBody
    @GetMapping("/old-timer/{num}")
    public String OldTimerWorld(@PathVariable int num) {
        return String.format("<h1>bye Old-timer</h1>you were the %dth old-timer", num);
    }

    /*
    * 두 개의 쿼리 파라미터를 받아 덧셈 결과를 반환합니다.
    * 예: GET /addtwo?num1=10&num2=20

    * @RequestParam 기본값은 required=true 이므로, 두 파라미터 중 하나라도 빠지면 400 Bad Request가 발생할 수 있습니다.

    * @param num1 첫 번째 피연산자
    * @param num2 두 번째 피연산자
    * @return HTML 문자열 본문
    */
    @ResponseBody
    @GetMapping("/addtwo")
    public String AddTwo(@RequestParam int num1, @RequestParam int num2) {
        return String.format("<h1>%d + %d = %d</h1>", num1, num2, num1 + num2);
    }
}
```

- 위의 코드를 좀 더 응용하면 아래와 같이 만들 수 있다.
    - 패스 변수로 계산 모드를 지정하고, 요청 파라미터로 계산할 숫자들을 전달한다.
    - 이때 요청 파라미터에는 자바 기본 문법 중 하나인 `...`으로 하나의 변수에 여러 값을 받을 수 있게 했다. 겨우 숫자 2개만 연산 가능한 계산기는 재미 없잖아.
    - 요청 파라미터 옆에 있는 `required = false` 는 이 값을 필수적으로 전달하지 않아도 일단 오류 없이 실행은 된다는 거임. 이거 없이 파라미터 전달 안하고 링크 들어가면 오류난다.
    - 반환되는 값은 html의 body가 되기 때문에 서식을 추가하면 그대로 적용된다.

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/*
* 스프링 MVC의 핵심 입력 방식(@RequestParam, @PathVariable)을 연습하기 위한 컨트롤러입니다.

* 이 클래스는 @Controller를 사용하므로 기본적으로는 "뷰 이름 반환"이 동작입니다.
* 다만 각 메서드에 @ResponseBody를 붙여, 반환 문자열을 뷰 해석 없이 HTTP 응답 본문에
* 그대로 내려보내도록 설정했습니다.
*/
@Controller
public class NewbieController {
    /*
    * 연산 모드와 숫자 목록을 받아 계산한 결과를 반환합니다.
    * 예: GET /calc/div?nums=1&nums=2&nums=3

    * mode는 URL 경로로 받고(@PathVariable), nums는 쿼리 파라미터 배열로 받습니다.
    * double... nums는 가변 인자 문법으로, 전달된 nums 값들이 배열처럼 수집됩니다.

    * @param mode 연산 종류(plus, minus, mult, div)
    * @param nums 연산 대상 숫자들(가변 인자)
    * @return 연산 결과 또는 오류 안내를 담은 HTML 문자열 본문
    */
    @ResponseBody
    @GetMapping("/calc/{mode}")
    public String AddTwo(@PathVariable String mode, @RequestParam(required = false) double... nums) {
        double ans = 0;
        String page = "";

        // nums 파라미터가 전달되지 않은 경우 사용자에게 안내 문구를 반환합니다.
        if (nums == null)
            return "<h1 style='color: #ff0000'>YOU SEND NO PARAMS</h1>";

        // mode 값에 따라 분기하여 누적 계산을 수행합니다.
        switch (mode) {
            case "plus": for (double i : nums) { ans += i; } break;
            case "minus": ans = nums[0]* 2; for (double i : nums) { ans -= i; } break;
            case "mult": ans = 1; for (double i : nums) { ans*= i; } break;
            case "div":
                ans = nums[0]* nums[0];
                // 0으로 나누는 상황을 안내하기 위한 예외 처리 구간입니다.
                try { for (double i : nums) { ans /= i; } }
                catch (ArithmeticException e) { page += "<h1 style='color=#ff0000'>You divided by zero</h1>"; }
                break;
            default: page += "<h1 style='color=#ff0000'>You selected wrong mode. You can only choose in ['plus', 'minus', 'mult', 'div'].</h1>";
        }

        // 최종적으로 화면에 표시할 mode와 answer 정보를 문자열로 조합합니다.
        page += String.format("""
                <h3>mode: %s</h3>
                <h3>answer = %f</h3>
                """, mode, ans);

        return page;
    }
}
```

- 요청 파라미터에 넣을 config는 대충 이정도 알면 일단 내가 원하는 만큼 꾸미는 데에는 지장이 없을 것 같음
    - `value`: url에 요청 파라미터로 넣을 이름. 예를 들어 아래의 코드는 `http://localhost:8080/newbie?query=write%20my%20message` 라고 써야 파라미터가 전달된다. value를 쓰지 않을 경우 변수명인 msg가 대신 사용된다.
    - `required = false` : 파라미터가 없어도 요청을 허용 ← 이게 없으면 파라미터가 없을 때 아예 오류가 나버림
    - `defaultValue` : 파라미터 미전달 시 사용할 기본 문구. 지금 구현된 코드에는 CSS를 같이 쓰다보니 좀 길어졌는데 보통은 html 파일명을 반환하니까 html로 따로 써두면 저렇게 길게 쓸 일이 없긴 하다.

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NewbieController {
    /*
    * 쿼리스트링 파라미터를 받아 문자열 응답을 반환합니다.
    * 예: GET /newbie?query=hello

    * @param msg URL의 query 파라미터 값
    *    - value = "query" : URL 키 이름(query)과 매핑
    *    - required = false : 파라미터가 없어도 요청을 허용
    *    - defaultValue : 파라미터 미전달 시 사용할 기본 문구
    * @return HTML 문자열 본문
    */
    @ResponseBody
    @GetMapping("/newbie")
    public String NewbieWorld(@RequestParam(
            value = "query",
            required = false,
            defaultValue="<span style='color: #ff0000'><i>YOU SEND NO MESSAGES</i></span><br><span style='color: #999999'><i>if you want to send messages, add \"?msg={your_message}\" on your link</i></span>"
            ) String msg) {
        return String.format("""
                <h1>welcome newbie</h1>
                <p>your message: %s</p>""", msg);
    }
}
```

## REST API

> 웬만하면 API는 REST API를 쓰자. 그게 뭐냐면요 ↓

REST(Representational State Transfer) API는 분산 하이퍼미디어 시스템을 위한 소프트웨어 아키텍처 스타일인 REST의 제약 조건을 준수하는 애플리케이션 프로그래밍 인터페이스를 의미합니다[1]. 이는 2000년 로이 필딩(Roy Fielding)의 박사 학위 논문에서 처음 정의되었습니다[2].

### REST API의 핵심 제약 조건

REST 아키텍처를 구성하는 주요 원칙은 다음과 같습니다[1], [2], [3]:

1. 클라이언트-서버 구조 (Client-Server): 사용자 인터페이스를 담당하는 클라이언트와 데이터 저장 및 처리를 담당하는 서버가 서로 독립적으로 분리되어 있어야 합니다.
2. 무상태성 (Stateless): 서버는 클라이언트의 이전 상태를 저장하지 않습니다. 각 요청은 해당 요청을 이해하는 데 필요한 모든 정보를 포함해야 합니다.
3. 캐시 가능성 (Cacheable): 응답 데이터는 캐싱 가능 여부가 명시되어야 하며, 클라이언트는 효율성을 위해 응답을 캐싱할 수 있습니다.
4. 계층화 시스템 (Layered System): 클라이언트는 중간 서버(로드 밸런서, 공유 캐시 등)를 거쳐 최종 서버에 연결될 수 있으며, 이 과정은 클라이언트에게 투명해야 합니다.
5. 인터페이스 일관성 (Uniform Interface): 자원(Resource)은 URI로 식별되며, HTTP 표준 메서드(GET, POST, PUT, DELETE 등)를 통해 조작됩니다. 응답은 자기 서술적(Self-descriptive) 메시지여야 하며, 하이퍼미디어를 통해 다음 상태로 전이할 수 있어야 합니다(HATEOAS).

### 주요 HTTP 메서드 활용

REST API는 일반적으로 HTTP 프로토콜 위에서 다음과 같이 동작합니다[3]:

- GET: 특정 자원의 정보를 조회합니다.
- POST: 새로운 자원을 생성합니다.
- PUT: 기존 자원을 전체적으로 업데이트합니다.
- PATCH: 자원의 일부를 수정합니다.
- DELETE: 특정 자원을 삭제합니다.

![](/assets/img/category-HAE/260328-HAE-3-springboot-1.jpg)

### REST API Controller

- 이전의 컨트롤러랑 사실 같은 건데, 어노테이션의 구조만 약간 달라짐.
    - 클래스 자체에 링크 매핑이 생겼고, 이 매핑은 하위 메소드에 모두 기본으로 적용됨

```java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/*
* REST 방식 응답을 제공하는 테스트용 컨트롤러입니다.

* @RestController는 @Controller + @ResponseBody의 조합과 동일한 의미입니다.
* 즉, 메서드 반환값을 뷰 이름으로 해석하지 않고 HTTP 응답 본문에 그대로 반환합니다.
*/
@RestController
@RequestMapping("/api/v1") // 이 클래스의 공통 URL 시작 경로(베이스 경로)
public class TestController {
    /*
    * GET /api/v1/test 요청에 대한 간단한 문자열 응답을 반환합니다.

    * REST API에서는 이런 방식으로 JSON/문자열/객체를 직접 응답 본문으로 내려보냅니다.

    * @return HTML 문자열 본문
    */
    @GetMapping("/test")
    public String test() {
        return "<h1>hello spring this is test API</h1>";
    }
}

```

- 이건 그냥 내가 이런저런 기능을 추가하다보니 사이트맵 겸 localhost에 그냥 접속했을 때 볼 랜딩 페이지가 필요해서 만들었음
    - 이번엔 반환값으로 html body를 직접 주는 대신 템플릿 파일을 따로 두고 그 파일 이름을 반환하게 했음.

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/*
* 애플리케이션의 기본(루트) 페이지 요청을 처리하는 컨트롤러입니다.

* @Controller는 "뷰(html 템플릿)를 반환하는 역할"이라는 의미입니다.
* 따라서 메서드에서 문자열을 반환하면, 그 문자열을 뷰 이름으로 해석하여
* templates 폴더에서 해당 파일을 찾아 렌더링합니다.
*/
@Controller
@RequestMapping("/") // 이 클래스의 공통 URL 시작 경로(베이스 경로)
public class HomeController {
    /*
    * GET / 요청을 처리합니다.

    * 클래스의 베이스 경로가 "/"이고, 여기서는 추가 경로를 지정하지 않았으므로
    * 최종 매핑 경로는 루트("/")가 됩니다.
    */
    @GetMapping
    public String HomeMap() {
        return "home"; // 뷰 이름. 뷰 파일명과 동일해야 함.
        // Spring Boot + Thymeleaf 환경에서는 일반적으로 templates/home.html을 찾아 화면으로 응답합니다.
    }
}
```

```html
<ul>
    <li><a href="/newbie">/newbie</a></li>
    <li><a href="/old-timer/1">/old-timer/{num}</a></li>
    <li><a href="/addtwo?num1=1&num2=2">/addtwo?num1={num1}&num2={num2}</a></li>
    <li><a href="/calc/plus?nums=1&nums=2&nums=3&nums=4&nums=5">/calc/{mode}?nums={num1}&nums={num2}&...</a></li>
    <li><a href="/api/v1/test">/api/v1/test</a></li>
    <li><a href="/modelnameinput?name=John%20Doe">/modelnameinput?name={name}</a></li>
</ul>
```

## MVC 기초 - 모델

- MVC가 뭐냐? 모델 + 뷰 + 컨트롤러
    - 아까까지는 컨트롤러만 만들고 있었는데
    - 이번엔 모델을 추가하겠다.
    - 모델은 데이터 조회 저장 수정 삭제 등 SQL이 하는 CRUD를 담당하고
    - 뷰는 그냥 뷰(보여줌)
    - 컨트롤러는 뷰와 모델 사이에서 전화 교환해주는 교환원 같은 거임. 요즘 사람이 좀 알만한 개념이라면 라우터,, 전령(메신저),, 정도가 그나마 비슷할 것 같음.
    - 컨트롤러가 모델한테 야 뷰가 이거 해달래 하고 전달하고 → 모델이 이거 뷰한테 보내 응답하면 → 컨트롤러가 뷰한테 모델이 이거 줬어 하고 응답 완료하기
- 아래 코드는 아주 기본적인 모델 컨트롤러.
    - 모델에게 name이라는 속성을 추가해준 거임
    - name이라는 속성은 `modelnameinput` 이라는 html 파일에서 `name` 이라는 변수에 대입됨.

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/*
* 요청 파라미터 값을 템플릿(뷰)로 전달하는 Model 사용 예제 컨트롤러입니다.

* @Controller를 사용하므로, 메서드 반환 문자열은 "뷰 이름"으로 해석됩니다.
* 또한 Model 객체에 담은 값은 템플릿 엔진(예: Thymeleaf)에서 화면 데이터로 사용할 수 있습니다.
*/
@Controller
public class ModelController {
    /*
    * 이름(name) 파라미터를 받아 템플릿으로 전달한 뒤 화면을 반환합니다.
    * 예: GET /modelnameinput?name=Spring

    * @param name URL 쿼리 파라미터 "name" 값
    *             - required = false: 파라미터가 없어도 요청 허용
    *             - defaultValue = "Guest": 미전달 시 기본값 사용
    * @param model 컨트롤러에서 뷰로 데이터를 전달할 때 사용하는 객체
    * @return "modelnameinput" 뷰 이름
    */
    @GetMapping("/modelnameinput")
    public String ModelHome(
        @RequestParam(value = "name",
        required = false,
        defaultValue = "Guest") String name,
        Model model) {
        // 템플릿에서 ${name} 형태로 접근할 수 있도록 모델에 데이터 등록
        model.addAttribute("name", name);
        return "modelnameinput";
    }
}

```

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="www.thymeleaf.org">

<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>

<body>
    <p>제 이름은 <span th:text="${name}">OOO</span>입니다.</p>
</body>

</html>
```

## Thymeleaf가 뭐죠

Thymeleaf는 웹 및 독립 실행형 환경 모두를 위한 현대적인 서버 사이드 자바 템플릿 엔진입니다[4]. 주로 HTML, XML, JavaScript, CSS 및 일반 텍스트를 처리하는 데 사용되며, Spring Framework와의 강력한 통합 기능 덕분에 Spring Boot 프로젝트에서 표준 템플릿 엔진으로 널리 채택되고 있습니다[7], [8].

### 1. 핵심 개념: 내추럴 템플릿 (Natural Templates)

Thymeleaf의 가장 큰 특징은 내추럴 템플릿 구조입니다. 기존의 JSP(JavaServer Pages)와 달리, Thymeleaf로 작성된 HTML 파일은 서버를 실행하지 않고 브라우저에서 직접 열어도 정상적인 HTML 구조로 표시됩니다[4], [5].

- 동작 방식: HTML 태그 내에 `th:`로 시작하는 속성을 추가하여 로직을 주입합니다. 브라우저는 이 속성을 무시하므로 디자인 원형(Prototype)을 그대로 유지할 수 있으며, 서버 실행 시에는 Thymeleaf 엔진이 이 속성을 해석하여 동적 콘텐츠로 치환합니다[5], [6].

### 2. 주요 기능 및 특징

- 다양한 템플릿 모드: HTML5뿐만 아니라 XML, TEXT, JAVASCRIPT, CSS 모드를 지원하여 웹 페이지 외의 문서 생성에도 활용 가능합니다[4], [5].
- Spring 통합: Spring MVC와의 연동이 매우 쉽고, Spring Security와 결합하여 권한에 따른 화면 제어(메뉴 노출 여부 등)를 효율적으로 처리할 수 있습니다[7], [8].
- 표준 표현식 구조:
    - `${...}`: 변수 표현식 (컨트롤러에서 전달된 데이터 접근)
    - `{...}`: 선택 변수 표현식 (특정 객체 기준 데이터 접근)
    - `#{...}`: 메시지 표현식 (다국어 설정 파일의 메시지 접근)
    - `@{...}`: 링크 URL 표현식 (서버 상대 경로 계산)
    - `~{...}`: 프래그먼트 표현식 (코드 재사용을 위한 템플릿 조각 삽입)[4], [9].

### 3. JSP와의 비교

| 구분          | JSP (JavaServer Pages)                              | Thymeleaf                                                |
| ------------- | --------------------------------------------------- | -------------------------------------------------------- |
| 파일 성격     | 서버 사이드 스크립트 (파일 확장자 .jsp)             | 순수 HTML 기반 (파일 확장자 .html)                       |
| 브라우저 확인 | 서버 없이 브라우저에서 직접 확인 불가               | 서버 없이 정적 레이아웃 확인 가능 (내추럴 템플릿)        |
| 구조          | HTML 내에 자바 코드가 혼용될 수 있음                | HTML 속성을 통해 로직을 분리하여 마크업 유지             |
| 성능          | 런타임 시 서블릿으로 변환되어 실행 속도가 매우 빠름 | 처리 과정이 복잡하여 JSP보다 다소 느릴 수 있음[6], [10]. |

## 덤

## FAST API가 뭐야

FastAPI는 Python 3.8 이상의 표준 타입 힌트를 바탕으로 고성능 API를 빌드하기 위한 현대적인 웹 프레임워크입니다[11].

### FastAPI의 정의 및 구성 요소

FastAPI는 다음과 같은 핵심 기술을 결합하여 설계되었습니다[11], [12]:

- Starlette: 웹 서버 기능을 담당하는 경량 ASGI(Asynchronous Server Gateway Interface) 프레임워크로, 비동기 처리를 지원합니다.
- Pydantic: 데이터 검증 및 설정을 위한 라이브러리로, Python 타입 힌트를 사용하여 데이터 구조를 정의하고 유효성을 검사합니다.

### 주요 차별점 및 특징

기존의 Python 웹 프레임워크(Flask, Django 등)와 비교했을 때 FastAPI의 주요 차이점은 다음과 같습니다[11], [12], [13]:

1. 고성능 (High Performance): NodeJS 및 Go와 대등한 수준의 성능을 제공합니다. 이는 Python 프레임워크 중 가장 빠른 수준 중 하나로 평가받습니다.
2. 비동기 지원 (Asynchronous): `async`와 `await` 키워드를 기본적으로 지원하여 비동기 프로그래밍을 쉽게 구현할 수 있습니다.
3. 자동 문서화 (Automatic Documentation): OpenAPI(이전의 Swagger) 및 JSON Schema 표준을 기반으로 하며, 서버 실행 시 `/docs`(Swagger UI) 또는 `/redoc`(ReDoc) 경로를 통해 대화형 API 문서를 자동으로 생성합니다.
4. 타입 안전성 및 검증: Python 타입 힌트를 사용하여 요청 본문, 쿼리 매개변수 등을 자동으로 검증하며, 잘못된 데이터 입력 시 상세한 오류 메시지를 반환합니다. 이를 통해 개발 중 발생할 수 있는 버그를 약 40% 감소시킨다는 통계가 있습니다.

## 그 외의 API

REST API와 FastAPI 외에도 통신 방식, 데이터 구조, 목적에 따라 다양한 API 아키텍처 스타일이 존재합니다[14]. 주요 유형은 다음과 같습니다.

### 1. SOAP (Simple Object Access Protocol)

SOAP은 XML 기반의 메시지 프로토콜로, 엄격한 표준과 보안 규정을 준수해야 하는 기업 환경(금융, 의료 등)에서 주로 사용됩니다[14], [15].

- 특징: 통신 규약이 매우 엄격하며, 데이터 포맷으로 XML만 사용합니다.
- 장점: WS-Security 등 자체 보안 표준을 내장하여 보안성이 높고, 트랜잭션의 원자성을 보장합니다.
- 단점: 메시지 크기가 크고 파싱이 복잡하여 REST에 비해 속도가 느립니다[15].

### 2. GraphQL

Meta(구 Facebook)에서 개발한 API용 쿼리 언어로, 클라이언트가 필요한 데이터의 구조를 직접 정의하여 요청할 수 있습니다[14], [16].

- 특징: 단일 엔드포인트(`/graphql`)를 사용하며, 클라이언트가 쿼리를 통해 응답 데이터의 필드를 선택합니다.
- 차이점: REST API에서 발생하는 오버페칭(Over-fetching, 필요 이상의 데이터 수신)과 언더페칭(Under-fetching, 데이터 부족으로 인한 추가 요청) 문제를 해결합니다[16].

### 3. gRPC (Google Remote Procedure Call)

Google에서 개발한 오픈 소스 RPC 프레임워크로, 고성능 마이크로서비스 간 통신에 최적화되어 있습니다[14], [17].

- 특징: HTTP/2 프로토콜을 기반으로 하며, 데이터 직렬화를 위해 JSON 대신 이진 형식인 Protocol Buffers(Protobuf)를 사용합니다.
- 장점: 텍스트 기반인 JSON보다 데이터 크기가 작고 처리 속도가 빨라 저지연(Low-latency) 통신에 유리합니다[17].

### 4. WebSocket 및 Webhook (이벤트 기반)

전통적인 요청-응답 방식이 아닌, 실시간성이나 이벤트 발생 여부에 따라 동작하는 방식입니다[14], [18].

- WebSocket: 클라이언트와 서버 간의 양방향(Full-duplex) 연결을 유지하여 실시간 데이터를 주고받습니다(예: 채팅, 주식 차트).
- Webhook: 특정 이벤트(예: 결제 완료, 코드 푸시)가 발생했을 때 서버가 클라이언트에게 데이터를 전송하는 역방향 API(Push) 방식입니다[18].

---

## 참고문헌

[1] Red Hat. (2020, May 14). *What is a REST API?*. <https://www.redhat.com/en/topics/api/what-is-a-rest-api>

[2] Fielding, R. T. (2000). *Architectural Styles and the Design of Network-based Software Architectures* (Doctoral dissertation). University of California, Irvine. <https://roy.gbiv.com/pubs/dissertation/fielding_dissertation.pdf>

[3] IBM. (n.d.). *What is a REST API?*. <https://www.ibm.com/think/topics/rest-apis>

[4] Thymeleaf. (n.d.). *Tutorial: Using Thymeleaf*. <https://www.thymeleaf.org/doc/tutorials/3.1/usingthymeleaf.html>

[5] JetBrains. (2025, November 26). *Thymeleaf \| IntelliJ IDEA Documentation*. <https://www.jetbrains.com/help/idea/thymeleaf.html>

[6] Today Software Magazine. (n.d.). *Template Engines for Java Web Development*. <https://www.todaysoftmag.com/article/907/template-engines-for-java-web-development>

[7] Spring.io. (2020, February 24). *Thymeleaf :: Spring Framework*. <https://docs.spring.io/spring-framework/reference/web/webmvc-view/mvc-thymeleaf.html>

[8] Obregon, A. (2024, June 2). *Exploring the Thymeleaf Dependency — A Beginner's Overview*. Medium. <https://medium.com/@AlexanderObregon/exploring-the-thymeleaf-dependency-a-beginners-overview-aa44007a7ba6>

[9] Tistory. (2024, December 3). *\[Spring] 타임리프(Thymeleaf) 5가지 기본 표현식/자주 쓰는 구문 정리*. <https://bnzn2426.tistory.com/140>

[10] ITM Web of Conferences. (2021). *Survey on Template Engines in Java*. <https://www.itm-conferences.org/articles/itmconf/pdf/2021/02/itmconf_icitsd2021_01007.pdf>

[11] FastAPI. (n.d.). *FastAPI - Introduction*. <https://fastapi.tiangolo.com/>

[12] Microsoft. (2024, February 21). *Overview of Python web frameworks for Azure*. <https://learn.microsoft.com/en-us/azure/developer/python/sdk/azure-sdk-overview>

[13] Ramirez, S. (2020). *Modern APIs with FastAPI and Python*. <https://tiangolo.medium.com/introducing-fastapi-fdc1206d453f>

[14] Postman. (2025, November 9). *Types of APIs: A Complete Guide to API Architectures*. <https://blog.postman.com/different-types-of-apis/>

[15] freeCodeCamp. (2023, March 7). *Different Types of APIs – SOAP vs REST vs GraphQL*. <https://www.freecodecamp.org/news/rest-vs-graphql-apis/>

[16] GraphQL Foundation. (n.d.). *Introduction to GraphQL*. <https://graphql.org/learn/>

[17] gRPC Authors. (n.d.). *What is gRPC?*. <https://grpc.io/docs/what-is-grpc/introduction/>

[18] Red Hat. (2023, May 4). *What is a webhook?*. <https://www.redhat.com/en/topics/automation/what-is-a-webhook>