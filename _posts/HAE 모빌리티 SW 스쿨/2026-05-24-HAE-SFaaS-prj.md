---
title: "SFaaS 프로젝트 - 배터리 팩 공장 AMR 모니터링 시스템"
author: dapin1490
date: 2026-05-24 15:47:00 +09:00
categories: [HAE, 프로젝트 - SFaaS]
tags: [현대오토에버, 모빌리티, SFaaS, AMR, Vue.js, Spring Boot, MySQL, MQTT, Node-RED, Design-first, AI 보조 개발]
render_with_liquid: false
use_math: true
---


### table of contents

- [프로젝트 개요](#프로젝트-개요)
- [기술 스택 및 아키텍처 개요](#기술-스택-및-아키텍처-개요)
- [데이터 소스](#데이터-소스)
- [역할 분담](#역할-분담)
- [문서 구성](#문서-구성)
  - [요구사항 정의](#요구사항-정의)
  - [데이터 스키마](#데이터-스키마)
  - [UI/UX 스펙 정의](#uiux-스펙-정의)
- [협업 컨벤션](#협업-컨벤션)
- [AI 보조 개발](#ai-보조-개발)
- [어려움 극복 및 주요 배운 점](#어려움-극복-및-주요-배운-점)
- [향후 개선점](#향후-개선점)
- [최종 발표 기록](#최종-발표-기록)
  - [1조](#1조)
  - [2조](#2조)
  - [3조](#3조)
  - [4조](#4조)
  - [5조](#5조)
  - [6조](#6조)
  - [총평](#총평)

## 프로젝트 개요

- 주제: 고중량 배터리 팩(BSA) 조립 공장에서 운용되는 AMR(자율 이동 로봇)의 위치, 상태, 환경, 충전, 작업 이력을 실시간 통합 관제하는 웹 시스템
- 선정 배경
  - 로봇 친화(RF) 제조 확산에도 운영 효율은 정체되는 현장
  - AMR 도입 후 MES/WMS 연동 미비로 "스스로 움직이는 카트" 수준에 머무는 사례

      ![](/assets/img/category-HAE/260524-HAE-8-SFaaS-prj.png)
  - 센서 교란, 경로 이탈, 데드락 등 안전, 소프트웨어 리스크 증가
  - 분산 데이터를 통합해 의사결정, 선제 대응이 필요한 관제 수요
- 현장 페인포인트
  - 연동 미비: AMR 단독 운용, 상위 시스템(MES/WMS)과 데이터 단절
  - 안전, 효율 트레이드오프: 안전 기준 충족을 위해 속도 제한 → 생산성 저하 → 로봇 운영 포기 사례
  - 하드웨어, 소프트웨어 리스크: 센서 교란, 충돌, 데드락, 잘못된 AI 작업 지시
- 해결하고자 한 문제
  - 분산, 비연동 데이터로 인한 "보이지 않는 물류"
  - 사고, 오류 발생 시 개별 로봇에 대한 신속한 통제 부재
  - 환경, 설비 이상의 사후 대응 중심 운영
- 기획 의도
  - 단순 위치 표시를 넘어 안전(비상 정지), 환경 위험 감시, 운영 인사이트를 한 화면에 제공
  - 실제 설비 대신 Node-RED DAS로 좌표, 환경 데이터를 생성하는 통합 관제 구조
  - 설계 문서 선행(Design-first)과 AI 보조 개발로 제한된 기간 내 멀티 스택 병행
- 구현 목표
  - 관제: 공장 2D 평면도 기반 AMR 위치, 경로, 상태 색상 구분, 환경(온습도, 먼지) 통합 대시보드
  - 안전: 비상 정지 FE→BE(DB 반영)→FE→DAS(MQTT), 관리자 즉시 개입
  - 분석: 이동 거리, 작업 건수, 충전 대기열, KPI 차트로 운영 효율 시각화
- 활용 장비 및 재료
  - 물리, 시뮬레이션 대상: AMR(시뮬레이션), 충전 스테이션, 환경 센서(온도, 습도, 미세먼지), BSA 배터리 팩 조립 라인 구역(창고, 건조, 조립, 검사 등)
  - 개발, 협업 인프라: 개발 PC, Docker, Git/GitHub, Jira(WBS), Confluence, AI 도구(Gemini, ChatGPT, GitHub Copilot, Cursor)
- 진행 순서

<pre class="mermaid">

---
config:
theme: default
look: neo
layout: elk

---

flowchart LR
    A["착수<br>계획, 역할"] --> B["설계<br>요구, 화면, API, ERD"]
    B --> C["구현<br>FE, BE, DAS, DB"]
    C --> D["통합<br>REST, MQTT, WS"]
    D --> E["QA, 문서화"]
    E --> F["최종 보고"]

linkStyle default stroke:#1AAAC7

</pre>

  - 설계 단계: 프로젝트 정의서, 화면 설계서(SCR-01~05), API 정의, 데이터 스키마, ADR
  - 구현 단계: BE API, WebSocket → FE 관제 화면 → DAS MQTT → Docker 통합 스택
  - 검증: API 스모크, `compose up` 통합 기동, PR + Copilot Review
- WBS (2026-05-08 ~ 05-21)

  | 단계   | 기간          | 핵심 산출                                 |
  | ------ | ------------- | ----------------------------------------- |
  | 착수   | 05-08         | 수행계획, 역할 분담                       |
  | 설계   | 05-08 ~ 05-13 | 화면 설계서, API 정의, ERD, ADR           |
  | 구현   | 05-14 ~ 05-20 | FE 관제 UI, BE API, DAS MQTT, Docker 통합 |
  | 마무리 | 05-18 ~ 05-21 | 통합 테스트, 최종 보고                    |

- 기대 효과
  - 가동률 방어: 구간 장애 시 AMR 우회 등 유연 생산 지원 개념 반영
  - 안전: Emergency Survival Control(비상 정지, 자동 복구)
  - 데이터 기반 운영: SoH, 작업 효율, 충전 혼잡도 인사이트
  - 확장: 표준 REST, WebSocket, MQTT 경계로 이기종 통합 준비

## 기술 스택 및 아키텍처 개요

- 통합 배포: 프로젝트 루트 `compose.yml` (Mosquitto, MySQL, Node-RED, BE, FE).
- 기동 포트: FE :3000, BE :8080, Node-RED :1880

| 구분 | 사용 기술             | 프로젝트 역할                            | 연동 관계            |
| ---- | --------------------- | ---------------------------------------- | -------------------- |
| FE   | Vue.js                | 로그인, SCR-01~05 관제, 비상 정지        | → BE REST, WebSocket |
| FE   | Apache ECharts        | 충전 예측, 작업 부하 차트                | → BE REST            |
| FE   | mqtt.js               | 환경 센서, AMR 좌표, 비상 명령           | ↔ Mosquitto          |
| BE   | Spring Security + JWT | 로그인, API 보호                         | → REST, WS           |
| BE   | RESTful API           | 관제, 명령, 이력 API                     | ↔ FE, → JPA          |
| BE   | WebSocket             | AMR 상태, 요약 갱신 이벤트               | ↔ FE                 |
| BE   | 운행 + JPA            | 작업, 배터리, 자동 복구, 명령 이력       | → MySQL              |
| DAS  | Node-RED              | 좌표, 환경 발행, 비상 정지 수신          | ↔ MQTT               |
| DAS  | Mosquitto             | MQTT 브로커 (1883, 9001)                 | ↔ FE, Node-RED       |
| DB   | MySQL                 | 운행, 이력 기준 저장소 (`init.sql` 시드) | ← BE                 |

- 실시간 데이터 채널

  | 채널      | 데이터                                                    | 역할                |
  | --------- | --------------------------------------------------------- | ------------------- |
  | REST API  | 대시보드 요약, AMR 목록, 상세, 비상 명령, 충전, 작업 이력 | BE → MySQL 영속화   |
  | WebSocket | AMR 상태, 대시보드 요약 갱신 이벤트                       | BE → FE 실시간 알림 |
  | MQTT      | 구역별 환경 센서(16), AMR 평면도 좌표, 비상 정지 명령     | DAS(Node-RED) ↔ FE  |

- 아키텍처 다이어그램

<pre class="mermaid">

---
config:
theme: default
look: neo
layout: elk

---

flowchart LR
subgraph docker["docker 통합 실행 환경"]
subgraph fe["프론트엔드 FE"]
    direction TB
        fe_vue["Vue.js<br>로그인, SCR-01~05"]
        fe_echarts["ECharts<br>SCR-04/05 차트"]
        fe_mqtt["mqtt.js<br>맵 좌표, 환경 16"]
end
subgraph be["백엔드 BE"]
    direction TB
        be_auth["JWT Security"]
        be_rest["REST API<br>관제·명령"]
        be_ws["WebSocket<br>상태 푸시"]
        be_sim["운행 스케줄<br>작업, 배터리"]
        be_jpa["JPA"]
end
subgraph data["데이터, DAS"]
    direction TB
        db_mysql[("MySQL<br>init.sql 시드")]
        das_mq["Mosquitto<br>1883, 9001"]
        das_nr["Node-RED<br>좌표, 환경 발행"]
end
end
    fe_vue -- REST --> be_rest
    fe_echarts --> be_rest
    fe_vue -- 구독 --> be_ws
    fe_mqtt <-- sub, pub --> das_mq
    das_mq --> das_nr
    be_auth --> be_rest
    be_rest --> be_jpa
    be_sim --> be_jpa
    be_jpa --> db_mysql
    be_ws --> be_jpa
    das_nr --> sensor["온습도 센서"]

linkStyle default stroke:#1AAAC7

</pre>

- 핵심 시나리오: 비상 정지

<pre class="mermaid">

---
config:
theme: default
look: neo

---

sequenceDiagram
    participant U as 운영자
    participant FE as Frontend
    participant BE as Backend
    participant DB as MySQL
    participant DAS as Node-RED
    U->>FE: 비상 정지 클릭
    FE->>BE: POST emergencyStop command
    BE->>DB: EMERGENCY_STOP 반영 commit
    BE-->>FE: accepted true
    FE->>DAS: MQTT factory/amr/command
    Note over BE,DAS: BE와 DAS는 직접 연동하지 않음
    BE-->>FE: WebSocket status updated

</pre>

  1. 운영자가 FE에서 비상 정지 실행 (개별 관제 또는 대시보드)
  2. BE: DB에 `EMERGENCY_STOP` 반영 후 `accepted: true` 응답
  3. FE → DAS: MQTT로 해당 AMR 이동, 작업 중단
  4. 대시보드에 에러, 미해결 건수 반영
  5. 약 60초 후 BE 자동 복구 (운영자 resume 버튼 없음)

## 데이터 소스

- 시뮬레이션 프로젝트로써, 대부분의 데이터는 DAS에서 생성된다. 공장 구역 중 첫 번째 구역만 유일하게 실제 온습도 센서 연동이 구현되어 있다.

## 역할 분담

| 역할     | 주요 책임                                            | 대표 산출물                          |
| -------- | ---------------------------------------------------- | ------------------------------------ |
| PM       | 요구사항 정의, WBS, 일정, 진척 점검, QA, 산출물 정리 | 수행계획서, Jira WBS, 최종 보고      |
| FE       | 관제 UI(SCR-01~05), REST, MQTT, WebSocket 연동       | DashboardView, AmrListView 등        |
| BE       | REST API, JWT, WebSocket, 비상 정지, 운행 시뮬레이션 | REST API, ADR, Swagger               |
| DAS & DB | ERD, init.sql, Mosquitto, Node-RED 시뮬, MQTT        | init.sql, flows.json, MQTT 연동 명세 |
| ALL      | 설계 리뷰, 통합 테스트, AI 산출물 검증               | docs/, AGENTS.md, PR 리뷰            |


## 문서 구성

### 요구사항 정의

- 기능적 요구사항
  - SCR-01: 통합 대시보드 (평면도, 환경, 알람, 작업 로그, 상태 요약)
  - SCR-02: AMR 전체 관리 (목록, 상태 필터, 통계)
  - SCR-03: AMR 개별 관제 및 비상 정지
  - SCR-04: 충전 스테이션, 배터리, 완충 예측
  - SCR-05: 작업 이력 및 분석
  - 인증: JWT 로그인
  - 실시간: REST(운행, 집계), WebSocket(상태 갱신), MQTT(맵 좌표, 환경 센서)
- 비기능적 요구사항
  - 보안: Spring Security, JWT, 시크릿 원격 미저장
  - 확장성: 표준 REST, 표준화된 데이터 모델, BE↔DAS 비직접 연동
  - UX: 화면별 스크롤 금지, 한 화면 정보 밀도
  - 정합성: Design-first, API, ERD, 화면, ADR 교차 검증
  - 운영: 루트 Docker Compose, 호스트 npm/JDK 직접 실행 없음
  - 협업: PR 리뷰, merge commit, 영역별 AGENTS.md

### 데이터 스키마

- 모니터링 요소: 공장 환경, AMR 위치, 상태(IMU, SoH, 적재), 제조, 작업 데이터
- ER 다이어그램

<pre class="mermaid">

---
config:
theme: default
look: neo

---

erDiagram
    AREA ||--o{ ENV_SENSOR : has
    AMR_MASTER ||--o{ AMR_STATUS_LOG : logs
    AMR_MASTER ||--o{ AMR_TASK : assigns
    AMR_MASTER ||--o{ AMR_COMMAND : commands
    AMR_CHARGE_STATION ||--o{ AMR_CHARGING_LOG : records
    WORK_ORDER ||--o{ WIP_LOT : produces
    PRODUCT ||--o{ PR_ROUTING : routes

</pre>

### UI/UX 스펙 정의

- 화면별 개요

  | 화면                   | 운영 가치                                                    | 화면의 목표                  |
  | ---------------------- | ------------------------------------------------------------ | ---------------------------- |
  | SCR-01 메인 대시보드   | 전장 상황을 한 화면에서 즉시 파악, 이상 구역, 우선 조치 선별 | 짧은 시간 내 1차 상황 판단   |
  | SCR-02 AMR 전체 관리   | 전체 AMR 단위 병목, 유휴, 이상 장비 일괄 파악                | 선제적 운영 리스크 관리      |
  | SCR-03 AMR 개별 관제   | 한 대 집중 확인, 비상 정지 및 상황 공유                      | 이상 발견 후 최소 단계 대응  |
  | SCR-04 충전 현황       | 충전 병목, 대기 분산, 당일 물류 계획 조정                    | 충전으로 인한 가동 중단 방지 |
  | SCR-05 작업 이력, 분석 | 생산성, 피크 구간 측정, 운영 회의 근거                       | 객관적 보고와 의사결정 지원  |

- SCR-01 메인 대시보드

  ![](/assets/img/category-HAE/260524-HAE-9-SFaaS-prj.png)

  - 가치: 공장 전체를 한눈에 보고, 현장에서 무엇이 일어나는지 즉시 파악
  - 의도: AMR, 환경, 알람, 작업 로그가 여러 화면과 시스템에 흩어져 있으면 대응이 늦어짐. 통합 관제의 시작점으로, 운영자가 스크롤 없이 한 화면에서 현장 상황의 전체 그림을 얻도록 설계
  - 제공 기능
    - 상태 요약 카드: 운영, 대기, 충전, 에러 AMR 대수, 가동률 한눈에 표시
    - 공장 평면도: 구역별 AMR 위치, 이동 경로, 장비 ID, 배터리, 상태 색상 구분
    - 환경 모니터링: 구역당 4개 센서(온도, 습도, 미세먼지, CO) 합계 16지점 실시간 표시
    - 중요 알람: 장비 오류, 충전소 혼잡 등 심각도별 알람 목록
    - 작업 로그: 이동, 작업 이벤트를 시간순으로 스트리밍
    - 비상 트리거: 대시보드에서 비상 상황 발생, 대응 진입

- SCR-02 AMR 전체 관리

  ![](/assets/img/category-HAE/260524-HAE-10-SFaaS-prj.png)
  ![](/assets/img/category-HAE/260524-HAE-11-SFaaS-prj.png)

  - 가치: 전체 AMR을 목록과 상태 통계로 묶어, 운영 리스크를 전체 AMR 단위로 관리
  - 제공 기능
    - AMR 요약: 전체, 운행, 대기, 오류 대수 실시간 집계
    - 상태 필터, 정렬: 운행/충전/대기/비상 등으로 장비 목록 축소
    - AMR 카드 목록: ID, 배터리, 현재, 목적 구역, 상세 보기 링크
    - 상태 테이블: 위치, 목적지, 현재 작업, 이동 속도 일괄 조회
    - 빠른 상세 모달: 카드에서 배터리, 구역 확인 후 비상 정지 또는 상세 화면 이동

- SCR-03 AMR 개별 관제

  ![](/assets/img/category-HAE/260524-HAE-12-SFaaS-prj.png)

  - 가치: 특정 AMR에 집중해 상태, 이력, 비상 조치를 한 화면에서 마침
  - 제공 기능
    - 운영 KPI: 상태, 배터리, 총 주행거리, 현재 구역, 작업 건수, 정상/실패
    - 시간대별 작업 통계: 최근 1시간 작업 건수 막대 차트
    - 작업 이력: 출발, 도착, 상태(진행/정상) 테이블
    - 비상 정지: 상단 비상 정지 버튼, BE 기록 후 MQTT로 현장 정지
    - 목록 연동: AMR 전체 관리의 상세 모달에서 바로 진입

- SCR-04 배터리 / 충전 스테이션 현황

  ![](/assets/img/category-HAE/260524-HAE-13-SFaaS-prj.png)

  - 가치: 충전 자원의 점유, 대기, 완충 예상을 한 화면에서 관리
  - 제공 기능
    - 요약 카드: 가동 충전소, 충전 중 AMR, 평균 충전률, 최장 완충 예상
    - 스테이션별 현황: 점유 슬롯, 혼잡 표시, AMR별 배터리, 잔여 시간
    - 충전 중 AMR 목록: 스테이션별 충전 중 장비와 진행률
    - 충전 대기열: 대기 AMR, 대기 시간, 목표 스테이션
    - 완충 예상 도넛: 5초/10초/그 이상 구간별 완료 예측 분포

- SCR-05 작업 이력 및 분석

  ![](/assets/img/category-HAE/260524-HAE-14-SFaaS-prj.png)

  - 가치: 지나간 작업, 이동 데이터를 숫자와 추이로 돌아봄
  - 제공 기능
    - 일별 작업 건수: 당일 누적 작업 이력 건수 KPI
    - 시간대별 작업 건수: 피크 구간, 부하 패턴 막대 차트
    - AMR별 작업 비중: 장비별 작업 분담 도넛 차트
    - 세부 기록 테이블: 작업 시간, AMR, 출발, 도착, 상태(진행/정상)
    - 운영 보고: 회의, 개선안 작성용 객관적 근거 제공

## 협업 컨벤션

- 수행 방법론

<pre class="mermaid">

---
config:
theme: default
look: neo
layout: dagre

---

flowchart TB
subgraph design["설계 우선"]
        D2["docs 명세 확정"]
        D1["도메인 조사 AI 보조"]
        D3["ADR로 경계 고정"]
end
subgraph dev["구현"]
        I2["Copilot/Cursor 구현"]
        I1["영역별 TODO 1항목씩"]
        I3["Docker 스모크"]
end
subgraph qa["품질"]
        Q2["팀 approve merge"]
        Q1["PR + Copilot Review"]
end
    D1 --> D2
    D2 --> D3
    I1 --> I2
    I2 --> I3
    Q1 --> Q2
    design --> dev
    dev --> qa

linkStyle default stroke:#1AAAC7

</pre>

- Git flow: `feature/` → PR → merge commit으로 dev 병합
- 문서 원본: GitHub `docs/` (API, 스키마), Confluence는 동기화 복사본
- 커밋: `태그(영역): 설명 스페이스-키 #이슈`

## AI 보조 개발

- 원칙: AI 출력은 초안. 확정, 병합, 운영 책임은 팀이 둠. 도구 나열이 아니라 입력, 절차, 검증을 저장소에 문서화
- 3단 필터
  1. AGENTS.md + TODO.md: 범위, 순서, 금지 사항 고정. Copilot, Cursor가 동일 저장소 규칙을 공유
  2. docs/ 기준 구현 + 로컬 검증: 명세 정합 확인, API 스모크, Docker 통합 기동 후 PR
  3. Copilot PR Review + 팀 approve: 보안, 과다 변경을 코멘트로 조기 발견. merge는 팀이 최종 결정
- 도구 역할

  | 도구           | 적합한 역할                        | 하지 않는 것               |
  | -------------- | ---------------------------------- | -------------------------- |
  | Gemini         | 논문, 기사 조사, Git, 운영 힌트    | 코드 확정, 병합 판단       |
  | ChatGPT        | 문서, API, 발표 초안 문장          | 저장소 전체 정합 실행 검증 |
  | GitHub Copilot | FE/BE/DB 보일러플레이트, PR Review | 요구사항, 일정 최종 확정   |
  | Cursor         | BE 구현, 설계 교차 검토, TODO 갱신 | 단독 merge 승인            |

- AGENTS.md 구조
  - 루트 AGENTS.md: 설계 문서 경로, Git, PR 규칙, Design-first, 에이전트 행동 16항
  - FE/, BE/, DB/AGENTS.md: 스택별 패키지 구조, API, ERD 참조, 네이밍, 레이어 규칙
  - 영역별 TODO.md: 한 번에 한 태스크, Phase, 스모크 단위 분해
- AI 활용 워크플로

<pre class="mermaid">

---
config:
theme: default
look: neo
layout: dagre

---

flowchart LR
subgraph phase1["기획·설계"]
        B["설계 초안 AI"]
        A["조사 Gemini/ChatGPT"]
        C["팀 확정 docs/"]
end
subgraph phase2["환경 고정"]
        D["AGENTS.md TODO.md"]
        E["정합성 재검토 Cursor"]
end
subgraph phase3["구현·검증"]
        F["구현 Copilot/Cursor"]
        G["로컬 스모크"]
        H["PR Copilot Review"]
        I["팀 approve merge"]
end
    A --> B
    B --> C
    D --> E
    F --> G
    G --> H
    H --> I
    phase1 --> phase2
    phase2 --> phase3

linkStyle default stroke:#1AAAC7

</pre>

## 어려움 극복 및 주요 배운 점

- jwt.secret 원격 커밋 (보안)
  - BE Security 설정 구현 중 Copilot이 `application.yaml`에 `jwt.secret`을 넣었고, 로그인, 토큰 서명에 쓰는 민감 키가 원격 저장소에 push됨
  - PR 생성 후 Copilot Review가 시크릿 포함을 지적
  - 조치: `application.yaml`을 공용 설정과 분리, `jwt.secret`은 로컬, 테스트 전용 파일에만 둠. 해당 파일은 `.gitignore`에 추가
  - 교훈: 자동 생성 설정 파일은 커밋 전에 diff와 PR 리뷰로 반드시 확인
- Copilot 리뷰 거부 (711 files) (협업, 리뷰)
  - FE 작업 후 PR을 올리고 Copilot Review를 요청했으나 변경 파일이 300개 이상이라 리뷰가 거부됨
  - 진짜 원인: `node_modules`가 Git에 추적(tracked)되고 있었음. `.gitignore` 누락으로 의존성 폴더 전체가 커밋에 포함
  - 조치: `git rm -r --cached node_modules` → 커밋 후 push → PR 리뷰 재요청 시 변경 약 49개로 감소
  - 교훈: PR 변경 범위를 줄여 리뷰 가능 상태 유지
- DB 스키마와 BE API 불일치 (설계 정합)
  - DB 파트가 먼저 작성한 ERD와 BE가 구현해야 할 API, 화면 요구가 맞지 않음. 대시보드 KPI, AMR 상태 enum, 비상 정지 필드 등에서 차이
  - 판단 기준: 기능, API 명세(`docs/API 정의.md`, 화면 설계서)를 우선으로 삼고 BE가 요구하는 필드에 맞게 DB 스키마 수정
  - 조치: 테이블, 컬럼명, 자료형을 API, 엔티티에 맞게 재정합. BE 쪽 JPA 엔티티, DTO도 수정된 스키마에 다시 맞춤. 이후 설계 변경은 `docs/` 선행 수정 원칙을 팀에 공유
  - 교훈: 멀티 영역 병행 시 API, ERD, 화면을 주기적으로 교차 검토
- 온습도 센서 통신
  - 문제: 온습도 센서가 노트북과 USB 포트를 통해 Serial 통신  
    ⟶ Windows USB 포트와 Docker Container의 가상 USB 포트 연결 어려움
  - 조치:
    - 온습도 센서가 MODBUS TCP로 통신하는 것으로 설정
    - USB Serial을 통해 센서 데이터를 받아서 MODBUS TCP 프로토콜로 변환 및 송신하는 게이트웨이 개발(C#)
    - Node-RED Container에서 MODBUS TCP를 통해 온습도 센서 데이터 수신 및 다른 환경 데이터와 통합하여 MQTT Topic 발행
  - 교훈: 센서 자체의 통신 프로토콜을 고려해야 함

## 향후 개선점

- 차기 확장
  - FE WebSocket 실시간 구독 확대 (`/api/v1/stream`)
  - Analytics KPI: AMR 오류 건수, 일정 준수율 차트 (SCR-02, SCR-03)
  - 충전 대기열 실데이터 연동 (`GET /charging/queue`)
  - 환경 이력, 스냅샷 API와 MQTT 역할 정리
  - 충전 스테이션 전용 화면 네비게이션 통합
  - 개별 관제 상세 센서, 추이 UI 보강
- 중장기 비전
  - AGV, AMR 등 이기종 로봇 통합 관제
  - AI 기반 레이아웃, 작업 우선순위 최적화
  - 예지보전(SoH, 부품 수명) 및 무중단 물류 재설계
  - 디지털 트윈 기반 시나리오 검증

## 최종 발표 기록

### 1조

- 주요 피드백
    - 발표의 시작에서 프로젝트에 대해 소개하는 것이 중요하다. 청중은 이 프로젝트를 전혀 처음 보는 것이기 때문. 발표의 속도를 조절할 필요가 있다. → 맨 처음 발표 시작하겠습니다 톤으로 발표하는 거 연습해야 할듯
    - 화면의 시인성이 안좋다. 사용자를 고려한다면 글씨가 커진다거나 화면 구성이 단순해야 하는데, 그러한 고려 없이 AI에 의해 생성된 UI가 아닌가 싶다. 사용자 요구사항을 먼저 분석한 후 나온 화면이 아닐 것.
    - 이 프로젝트에서 가장 중요한 포인트가 무엇인지 잘 드러나지 않는다. 강조점 없이 모든 구간이 다 비슷한 톤으로 작성되어 청중이 무엇에 집중해야 하는지 고민하게 만든다.
- 질의응답
    - DB 트랜잭션에 대한 고려가 있었는지?
    - 위에 것 말고는 기억 안남

### 2조

- DB하이텍을 배경 공장으로 설정
- 암묵지 자산화가 목표 중 하나임
- 파이썬 시뮬레이터 → 노드레드 → 그외 등등 아키텍처
- ERD가 어려웠다고 한다
- 이게 캡쳐화면 탓인지 아닌지는 모르겠는데 이 팀도 화면 글씨는 작음
- AI 분석 리포트 기능이랑 암묵지 가시화는 좀 흥미로움
- 시연 영상에 스토리가 있었던 점 꽤 괜찮다고 봄
- 협업 컨벤션 소개하다.
- 시간 잘 지켰는지는? 잘 모르겠지만 확실히 발언자가 적어서 사운드는 매끄러웠음.
- 주요 피드백
    - 아키텍처 설명이 너무 길었다. 자료는 굿인데 시간 분배는 다듬을 필요가 있겠다.
    - 영복님 발표가 좋습니다. 듣고 이해하기도 쉽고 시연 영상도 센스있었다.
    - 김완택님은 아키텍처 설명이 좀 길었다. 내용이 길진 않았는데 말하는 습관이 그래보이게 만들었던 것 같다. 정리해서 말하기 필요. 그냥 듣는 사람이 대략적으로 이해할 수 있게 말하면 된다는 거임.

### 3조

- 이 팀이 항상 잘하던 게 프로젝트의 서론이었던 것 같음.
- 이 팀은 발표자료 디자인 누가 합니까? 보기 좋은 구도를 잘 만듦
- 배운 내용 활용도가 좋긴 함,,, 공장 레이아웃을 S-프로디스로 만들어올거라고는 생각도 못함
    - 아니 그거 라이센스 끝났는데 어떻게 한거임
- 잘하긴 했는데 발표 시간 너무 마음 놓고 쓰는 거 아니냐 15분이랬잖아
- 주요 피드백
    - 이 팀이 프로젝트 배경에 5분 썼는데, 15분 제한 시간 생각하면 배경은 1분 안에 끊어야 한다고 하셨음. 아니 그러면 그 1분 안에 어떻게 이걸 알아듣게 설명하는 거예요 난 그게 제일 어려워.
    - AI 관련 파트가 다들 중요하다고 생각했다는데 발표자는 오히려 너무 슥 넘겼다고 함.
    - 전체적인 완성도는 좋다
    - 발표자 간 시간 분배는 꽤나 불균형

### 4조

- 아틀라스 관련 주제
- 이 팀 화면을 전에 본 적이 있는데, 전체적으로 다크 톤인 게 조금 불리하다고 생각함. 다크 톤 화면은 어두운 환경에서 쓸 때 유용하지만 밝은 환경에서 쓰기엔 오히려 안보인다는 말을 듣기 쉽다.
- 화면이 꽤나 빽빽한 편인 것 같음. 시인성에 대한 지적이 예상됨.
- “10점으로 하려다가 9.9점으로 했습니다”
    - 보통 대부분 팀이 자기 프로젝트에 점수 후하게 주는 편인듯
- 주요 피드백
    - 발표물은 보기 좋긴 한데, 아키텍처 표현이나 기술적인 표현이 좀 부족한 편
    - 아이디어 소재는 좋지만 너무 국내에 없는 것을 보다보니 현장에서 쓰는 것보다는 누군가를 홀리고 싶은 시뮬레이션에 더 가까운 비주얼이 나왔다
        - 다크 톤 화면이 특히 한몫 했음. AI 느낌이 너무 진하다.
            - 어두운 배경에 폰트도 어두워서 안보여
    - 항상 사람이 적었던 것이 아쉽다. 과연 5명이 모두 기여한 게 맞는지 약간 의구심을 갖게 된다.
    - 발표자 대기 시 행동거지에 신경쓰기
    - 영상이 프로젝트를 다 담아내지 못한 것 같지만, 청중이 직접 사용할 수 있도록 한 점은 좋다
    - 시간에 신경쓰느라 전달력이 떨어진 것 같다. 할 말은 해야 한다.

### 5조

- 처음에 받은 제안서랑 비슷하게 나온 것 같음
- 무난한 발표였다
- 화면 시인성은 괜찮은 편이라고 생각함
- 화면 스크롤을 안하게 만들 방법이 있었을지? 내가 아직 글씨가 작아도 보이는 인간이라 그런지는 모르겠는데 각각의 크기가 조금 줄어들더라도 화면은 한번에 보이면 좋겠음.
- 주요 피드백
    - 전반적으로 방향이 명확해서 ㅇㅋ임
    - AI로 이런저런 기능을 시도한 것 같은데, 이 서비스의 니즈에 맞는 기능을 좀만 더 디테일하게 만들었으면 좋지 않았을까 → 아쉽다
    - 화면 자체의 UI/UX는 나쁘지 않음. 요소가 많으면서도 관리하기에 복잡하지 않았다.
    - 발표 잘했다.
    - AI 채팅 기능을 급하게 만든 것 같다. 시연 영상에서 퀄리티가 너무 안좋았기 때문에 그건 안넣는 게 나았다.
    - 지도 렌더링할 때 오버 엔지니어링을 한 느낌이 좀 있다. 굳이 거기에 구글맵을 넣을 필요는 없었을 것 같음.

### 6조

- 이 팀도 글씨 엄청 작다. 디자인은 1조와 비슷한 결임. 다만 이 팀의 UI를 보니 1조는 생김새가 썩 투박하긴 함. 1조가 받은 공격이 UI에 집중될만 했다고 생각함.
- 이메일이 온다는 점이 이 팀의 오리지널인 것 같음. 괜찮은 기능이다.
- 주요 피드백
    - 프로젝트 자체는 실제로 쓸법한 노말한 내용들이라 현실성이 있었음.
    - 다만 컨베이어 같은 건 화면 화질 탓인지 잘 드러나지 않았다
    - 웹스카다를 iframe으로 깔끔하게 합쳐넣은 것이 좋은 점
    - UI가 강사님 취향에 맞았다
    - 설계에 포함되지 않은 소스코드가 생겨서는 안된다. 설명할 수 없는 코드 안돼요.
    - AI한테 코딩을 외주 주면 검증을 해야 한다.

### 총평

- 3주 안에 하기 쉽지 않은 프로젝트를 공통적인 기준으로 만든거야. 다 똑같은 과제와 시간을 받았다. 님들 선택이고, AI 활용도 표현도 다 님들 선택입니다.
- 1조도 잘했어요 첫 순서라 피드백이 좀 많았다.
- 학생들은 지금까지의 과정을 다 알잖아요. 하지만 심사위원들은 처음 본 경우가 많다. 학생들끼리의 동료 평가는 지금까지의 과정을 같이 고려해주면 좋겠어.
- 팀장님 총평(중간 보고 예정이었던 날에 멘토링 오셨음)
    - 다들 잘하셨어요
    - 고생하긴 했는데, 앞으로 고생 좀 더 해야겠다. 도움이 되는 피드백을 주고 싶었음.
    - 모두들 완성도 평타 이상. 개인차가 있는 부분은 피드백을 줬던 부분에 대해 다같이 생각하면 좋겠다. 혼자 생각하면 자기가 아는 만큼만 생각할 수 있는데, 수용자 입장에서 생각할 수 있어야 한다.
    - 상호작용을 많이 하세요.
- 이유림 강사님 총평
    - 기획에 비해 좋은 결과물이 나온 것 같아 좋아
    - AI가 큰 힘을 썼으니 코드 공부는 좀 더 하세요
    - 원래 근본 주제는 모니터링이었는데, 다들 통계를 많이 한 것 같다. 주제를 약간 벗어난 것 같아 아쉬움.
    - 수고 굿.
- 백엔드 피드백해주신 멘토님
    - 은 마이크를 주지 않겠음 부담스러우니까^^
    - 발표할 때 이분이 해주신 피드백은 현장의 시선에서 코멘트한 거라는 점 알아주기