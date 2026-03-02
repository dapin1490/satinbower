---
title: "스마트팩토리 품질관리 (3)"
author: dapin1490
date: 2026-01-07 18:00:00 +09:00
categories: [HAE, note]
tags: [현대오토에버, 모빌리티, 스마트팩토리, 품질, 품질관리]
render_with_liquid: false
use_math: true
---

# 덤

- 6시그마가 뭔지 또 모르겠어서 다시 정리함 (Gemini)  
    > 6시그마(Six Sigma) 개념 및 스마트 팩토리 적용 요약

    1. 6시그마의 정의 및 목표  
        6시그마는 통계학적 기법을 활용하여 제품 생산 과정에서 발생하는 변동(Variation)을 최소화하고 불량을 획기적으로 줄이는 품질 경영 방법론입니다.  
        - **'시그마($\sigma$)'의 의미:** 통계학 용어로 '표준편차'를 뜻하며, 데이터가 평균을 중심으로 얼마나 흩어져 있는지를 나타냅니다.
        - **수치적 목표:** '6시그마 수준'은 100만 개의 제품을 생산했을 때 불량이 3.4개 이하로 발생하는 상태(**3.4 DPMO**)를 의미합니다 [1]. 이는 통계적으로 99.99966%의 수율(양품률)을 뜻합니다.
        - **1.5 시그마 이동:** 이론적인 통계 수치와 달리, 실제 공정에서는 장기적으로 평균이 약 1.5$\sigma$ 변동할 수 있음을 감안하여 보정한 목표치가 3.4 DPMO입니다 [2].

        ![Six Sigma Normal Distribution Graph 이미지](https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcSIzGp4dFZX0XYpvLdYZyB2bKwNekTE_VgSAFO6C8XmtC8hZ9-hMzHsrtOB4mUi2bww0ZVrMK4jt3BPWNX0ZXzNvpr5VTWZLMEmWwatXIgNxrlZEv8)

    2. 품질 수준 비교 (시그마 레벨별)  
        시그마 레벨이 높을수록 공정의 변동이 적고 품질이 완벽에 가까워짐을 의미합니다 [1].

        | **시그마 수준** | **불량률 (DPMO)** | **수율 (양품률)** | **수준 설명**                 |
        | --------------- | ----------------- | ----------------- | ----------------------------- |
        | 3$\sigma$       | 66,807            | 93.32%            | 일반적인 산업 평균            |
        | 4$\sigma$       | 6,210             | 99.38%            | 품질 관리 도입 단계           |
        | **6$\sigma$**   | **3.4**           | **99.99966%**     | **세계적 수준 (World Class)** |

    3. 스마트 팩토리에서의 6시그마 (Smart Six Sigma)  
        4차 산업혁명 기술(IoT, 빅데이터, AI)이 도입되면서 6시그마는 실시간 데이터 기반의 자동화된 품질 관리 시스템으로 진화했습니다. 이를 학계에서는 'Quality 4.0' 또는 'Smart Six Sigma'라고 칭합니다 [3].  
        1. 데이터 수집 및 분석의 변화
            - **기존 방식:** 일부 제품만 뽑아서 검사하는 '샘플링(Sampling)' 방식에 의존하며, 과거 데이터를 사후에 분석함.
            - **스마트 팩토리:** IoT 센서를 통해 모든 제품을 검사하는 '전수 검사(Census)'가 가능하며, 실시간(Real-time) 데이터를 수집함 [4].
        2. 문제 해결 방식의 진화 (DMAIC 고도화)  
            6시그마의 기본 실행 절차인 DMAIC(정의-측정-분석-개선-관리) 단계가 기술적으로 강화되었습니다 [5].  
            1. **예측 및 예방:** AI가 공정의 이상 징후를 미리 포착하여 불량이 발생하기 전에 설비를 제어하는 '예지 보전(Predictive Maintenance)'을 수행합니다.
            2. **디지털 트윈(Digital Twin):** 가상 공간에 실제 공정을 복제하여, 물리적인 실험 없이 개선안을 시뮬레이션하고 최적의 결과를 도출합니다.
            3. **자동화된 피드백:** 공정 변수가 오차 범위를 벗어나면 시스템이 즉시 자동으로 보정하여 품질을 일정하게 유지합니다.
    4. 결론  
        전통적인 6시그마가 통계적 분석을 통해 불량의 원인을 '사후'에 찾아내는 방법론이라면, 스마트 팩토리의 6시그마는 실시간 데이터와 AI를 활용하여 불량을 '사전'에 예측하고 차단하는 예방 중심의 시스템입니다.

    ---

    **참고문헌**

    [1] Pyzdek, T., & Keller, P. A. (2018). The Six Sigma Handbook (5th ed.). McGraw-Hill Education.

    [2] Bothe, D. R. (2002). Statistical reason for the 1.5 sigma shift. Quality Engineering, 14(3), 479-487.

    [3] Sony, M., & Naik, S. (2019). Key ingredients for integrating Industry 4.0 with Lean Six Sigma: a systematic review. International Journal of Quality & Reliability Management, 36(8), 1-27.

    [4] Arcidiacono, G., & Pieroni, A. (2018). The Revolution Lean Six Sigma 4.0. International Journal on Advanced Science, Engineering and Information Technology, 8(1), 141-149.

    [5] Lee, J., et al. (2014). A Cyber-Physical Systems architecture for Industry 4.0-based manufacturing systems. Manufacturing Letters, 3, 18-23.

# 스마트 공장 사례

> 강의자료 기준 “기업 생존 부등식” 파트 내용임

- 할리 데이비슨(미국)과 야마하(일본) 오토바이
    - 간지나는 할리 데이비슨과 고장이 안 나는 야마하 중 무엇을 살 것인가?
    - 2000년 기준으로 품질 원가 관점에서 보면 할리 데이비슨이 더 비쌈.
    - 할리 데이비슨의 SAP 플랫폼(스마트 공장 사례) 영상 봤음

        <a href="https://www.industrynews.co.kr/news/articleView.html?idxno=4560" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-1-SF-quality-3.png"/></a>

        SAP의 커넥티드 매뉴팩처링 도입 전(왼쪽)과 후(오른쪽)의 할리 데이비슨 공장 전경

        > SAP의 커넥티드 매뉴팩처링이 가장 잘 구현된 곳은 할리 데이비슨(Harley Davidson) 공장이다. ERP의 전체 생산계획부터 생산실행까지 전부 SAP 시스템이 적용됐다. 할리데이비슨은 2009~2011년에 5개 공장 운영시스템을 재구축했으며 커넥티드 메뉴팩처링 도입 후 생산 계획은 21일에서 6시간으로 줄었으며, 제품 생산에서도 표준모델만 생산하던 것에서 고객이 직접 커스터마이징 한 모델까지 생산하게 됐다. 더불어 생산량도 25% 늘었으며 순익도 19% 상승한 반면 생산원가는 -7%로 절감하는 효과를 봤다.  
        > 출처 : 인더스트리뉴스([https://www.industrynews.co.kr/news/articleView.html?idxno=4560](https://www.industrynews.co.kr/news/articleView.html?idxno=4560))

- 쿠트 스마트(중국)
    - 양산형과 고가 맞춤 양복의 중간 정도의 가격을 취하는 맞춤 양복

        <a href="https://www.industrynews.co.kr/news/articleView.html?idxno=22853" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-2-SF-quality-3.png"/></a>

    - 쿠트스마트그룹 스마트 팩토리 운영 방식 (2018년)
        1. C2M(Customer to Manufacture) 기반 생산 시스템
            - 공정 방식: 소비자와 생산자를 직접 연결하여 7일 이내 맞춤 정장 생산.
            - 데이터 활용: ‘Cotte Yolan’ 앱을 통해 주문 정보를 클라우드에 저장하고, 빅데이터 분석으로 최적 생산 경로 도출.
            - 기술 적용: 수천만 개의 데이터 유형 및 3D 프린터를 활용하여 3천여 가지 맞춤형 제품 제작 가능.
        2. 플랫폼 기술 (SDE 시스템)
            - 시스템 개요: SDE(Source Data Engineering) 기반의 플랫폼으로 2003년부터 개발되어 높은 완성도 확보.
            - 기능: 생산 비효율을 제거하고 소비자, 생산자, 전문가를 연결하여 니즈를 실시간 반영.
        3. 경영 전략: 대량 맞춤화 (Mass Customization)
            - 핵심 철학: 소비자의 개별 욕구 충족(Customization)과 대량 생산(Mass)의 효율성을 동시에 추구.
            - 운영 목표: 주문형 맞춤 제작을 통한 '재고 제로(Zero)' 달성 및 제조업자가 고객과 직접 소통하는 공정 구축.
        4. 주요 성과 및 성공 요인
            - 생산 역량: 연간 셔츠 100만 벌, 바지/재킷/조끼 각 40만 벌 생산 가능.
            - 매출 비중: 자국 내 40%, 북미 30%, 북유럽 15% 등 수출 확대 성공.
            - 성공 요인: 데이터 기반 생산을 통한 비용 절감, 임직원의 단결력, 정부 및 연구기관의 전폭적인 기술 지원.
    - 말만 들어도 수요가 썩 있을 것 같죠?
    - 고객이 한번쯤은 직접 매장에 가서 치수를 잴 필요가 있다는 불편함이 있지만, 구매 후 옷이 안맞아 문제가 생길 일이 없다.
    - 이 공장은 사람을 완전히 없앨 수 없을 것이다. 아직까지 자동으로 재봉을 하는 로봇은 본 적이 없다.
        - 근데 내가 생각해봐도 그럼. 낱낱이 분해된 옷의 파츠들을 적절히 구분하고 위치를 맞추고 딱 잡아서 재봉하기? 일단 구불거리는 옷감부터가 문제임. 기계가 적절한 힘으로 옷감을 예쁘게 펼 수 있을까? 할 수 있다 쳐. 그 로봇이 공장 전체에 바를 수 있을 정도로 싸겠냐? 현재 기술력으로는 아직 로봇은 사람만큼 손을 섬세하게 쓰지 못한다. 로봇 재봉은 시작부터 안되는 거임.
- HMGICS
    - 링크 자료로 정리 대체하겠음. 전부 복붙하는 건 그닥 의미 없을 것 같으니 읽어보기.
    - [HMG 저널 운영팀 데이터가 쌓여서 스마트 팩토리가 되는 과정](https://hyundaimotorgroup.com/ko/story/CONT0000000000122310)
    - [임성호 \[르포] 컨베이어벨트 사라진 車공장…현대차그룹 싱가포르 혁신센터 \| 연합뉴스](https://www.yna.co.kr/view/AKR20231120152500003)

# 설계 단계의 품질 결정 요인

> 이거 다 예방비용이에요

- 설계 엔지니어의 실수에 의한 부품 조립 시 간섭 문제는 어떤 의미가 있는가? → 조립할 때 작업자가 별도의 정성을 들여야 겨우 조립된다면?
    - 그렇다면 사람에게도 작업 시간이 더 필요하고 로봇은 더 힘들게 조립할 것
    - ‘검사를 안 해도 되는 공정’이라 함은 끝까지 조인 후 토크까지 확인해야 하는 볼트+너트와 달리 똑딱 하고 누르면 끝나는 조립으로 바꾸는 것과 같은 방식을 말하는 것.
- 설계 엔지니어의 실수에 의한 부품의 부적절한 사양 선정
    - 부적합 사양으로 인해 발생하는 문제는 수없이 많음
    - 작업을 할 때 잘 부러지는 사양
    - 너무 작아서 바닥에 잘 떨어지는 부품
    - 너무 커서 다루기 어려운 부품
    - 너무 약해서 잘 찢어지는 부품
    - 예시 - BIC 볼펜: 볼펜심 안에 쬐만한 스프링이 들어감. 잃어버리기 쉬움. 볼펜 상하 케이스 사이에 얄팍한 금속 링 추가됨. 간지 용도였으나 잃어버리기 쉬움. 그 외에도 그냥 전체적으로 부품들이 다 작음. → 이제 문제라고요.
    - 예시 2 - 계수기 업체: 볼트가 너무 많아. 고치라 했거든요. 고쳤을까요? 안고쳐요. 아이 그냥 해~ 하면서 그냥 쓰더랍니다. 왤까? 이거 바꾸려면 설계부터 다 뜯어고쳐야 하거든. 귀찮거든. 신제품 개발도 해야 하는데 여기에 투자하는 거 아깝거든. 왜냐면 그냥 팔아도 돈은 계속 되니까. 알아도 못하는 게 혁신이에요.
- 설계 엔지니어의 무관심에 의한 가공, 물류 타당성 미 검토
    - 가공 어려운 설계 → 3D 프린팅으로 해결? → 대량 생산은? 금속 사용 가능?
    - 조립이 복잡하고 어려운 형상의 설계 → 3D 프린팅으로 되겠냐고요
    - 사내에서 공장의 물류 흐름에 적합하지 않은 설계
        - 공장의 공간이 작은 생산라인에 부품 크기가 큰 제품
        - 어떻게 해야 내부 물류가 더 효과적으로 처리될 수 있을까?
        - LG 전자의 ‘하늘과 땅의 공간’ 활용법: 원래 반도체 공장에서 쓰던 방식으로, 공장의 천장까지 이용하는 방식
    - 사외 물류 타당성을 고려하지 않은 설계
        - 외부에서 부품을 공급하려면 비용이 많이 드는 구조의 설계
        - 어떻게 해야 외부 물류가 간단하고 비용도 적게 들까?
- 설계 엔지니어의 무관심에 의한 많은 부품 수의 설계
    - 부품의 수가 너무 많고 복잡한 설계
    - 작업 공수 ↑ 품질 불량 확률 ↑
    - 구매 부서 등의 일이 늘어남 → 종류, BOM 많아짐 → 도면 증가 → 거래처 증가
    - 창고 차지 공간 ↑

# 상류화 혁신 APQP

- 제품의 품질을 사전 계획 하는 방법론 Advanced Product Quality Planning (APQP)
    - APQP는 제품 품질을 사전에 계획하고 품질 문제를 예방하기 위한 구조화된 방법론
    - 주로 자동차 산업에서 제품 개발 프로세스의 품질을 보장하기 위해 사용 중
    - 고객 요구사항을 만족시키는 제품을 일관되게 생산할 수 있도록 지원
    - 상류단계(설계)에서의 품질 기획에 초점, 더 체계적으로 지원하는 활동으로서 일본 자동차 기업의 품질 혁신 성과에 미국 자동차 기업들이 자극을 받아 활동한 결과
- 개발 배경
    - 1980년대 후반, 미국 자동차 빅3(포드, GM, 크라이슬러)가 공급업체 품질 일관성 부족 문제 해결을 위해 개발
    - AIAG(Automotive Industry Action Group)에 의해 표준화
    - 품질 문제를 사후 처리에서 사전 예방으로 전환
    - PPAP(Process Approval), FMEA, Control Plan, MSA 등의 품질 도구들과 연계되어 사용됨
- APQP 주요 적용 사례
    - 자동차 산업(GM, 포드, 스텔란티스 등)
        - 모든 신규 부품 개발 시 APQP 필수 적용
        - 공급업체는 APQP 문서화와 검증 절차를 따라야 함
    - 항공우주 산업
        - 보잉, 에어버스 등은 AS9145 표준을 기반으로 APQP 활용
        - 고신뢰 부품 개발 시 품질 계획 필수화
    - 가전 및 전자제품 분야(LG, 삼전 등)
        - 신제품 출시 전 공급망 품질 확보를 위해 APQP 적용
        - 부품 신뢰성 확보와 양산 이전 문제 예방에 사용
    - 타 산업은 아직 개선할 부분이 많다. 열심히들 하셔라.

## APQP 단계별 내용

1. 계획 및 정의
    - 고객 요구사항 및 기대 사항 분석
    - 프로젝트 목표, 일정, 자원 계획 수립
    - 품질 목표 및 주요 제품 특성 정의 - 주요 산출물: 품질 목표, 신제품 소개 계획(NPIP), 고객 요구사항 분석
2. 제품 설계 및 개발
    - 제품 설계 검토 및 DFMEA 수행
    - 제품 사양 정의 및 시제품 제작
    - 설계 검증 및 제품 승인 → 주요 산출물: DFMEA, 설계도면, 기술 사양서, 디자인 검증 결과
3. 공정 설계 및 개발 (Process Design and Development)
    - 생산 공정 흐름도 작성
    - 공정 FMEA(PFMEA), 제어계획 수립
    - 설비, 도구, 측정 시스템 준비 → 주요 산출물: 공정 흐름도, PFMEA, 작업표준서, 측정 시스템 분석(MSA)
4. 제품 및 공정 유효성 검증 (Product and Process Validation)
    - 시생산(Pilot Run) 및 초기 흐름 검증
    - 초기 공정능력(Cp, Cpk) 분석
    - PPAP 제출 및 승인 → 주요 산출물: 시생산 결과, SPC 분석, PPAP 패키지
5. 피드백, 평가 및 개선 (Feedback, Assessment and Corrective Action)
    - 양산 후 품질 모니터링
    - 고객 클레임 대응 및 개선활동
    - 지속적인 품질개선과 재발 방지 → 주요 산출물: 품질지표 분석, 개선보고서, 교훈(Lessons Learned)

## APQP 적용 사례

> 가상의 내용을 기반으로 작성됨 / 사실 자세한 설명은 생략했음

- 목적: 현차의 신규 엔진 개발
1. 시장 요구를 반영해 연비와 출력 목표 수립
2. 설계팀이 DFMEA 통해 내구성 우려 요소 사전 제거
    - DFMEA는 설계 단계에서 발생할 수 있는 잠재적인 실패 항목을 사전에 분석하고, 그 원인과 영향을 파악하여 이를 예방하거나 완화하기 위한 체계적 기법
    - 고장 유형, 영향 등을 정의하고, 심각도/발생도/검출도를 수치화해 위험 우선 순위(RPN) 계산 → 일정 수치 이하로 개선
3. 공정 설계를 통해 실린더 가공 정확도 향상
    - 2단계와 같은 방식으로 잠재적 실패 개선
    - 제품 설계 이후 실제 생산 공정에 적용되며, 공정 품질 확보를 위한 핵심 도구로 사용
4. 시생산 후 Cpk > 1.33 확보, PPAP 승인
5. 출시 후 문제 발생 시 R&R 분석 및 개선 반영

# DfQ

## DfQ(Design for Quality)에 의한 상류화

- DfQ(Design for Quality): lean design 원칙을 활용하여 품질의 문제를 근본적으로 생각하는 설계 기법을 말함. 단순화, 표준화, 모듈화가 기본 원리.
- RFT(right first time)를 높이는 설계
    - 통계적으로 99% 수준을 갖는 부품 21개를 조립한다고 치자. 완성품이 한번에 통과할 확률은? $0.99^{21}=0.81 = 81\%$ → 19%는 다시 작업해야 함.
    - 동일한 부품을 1000개 조립한다고 치면 한번에 통과하는 완성품은 1도 없게 된다.
    - 이번엔 99.9% 품질의 부품을 1000개 조립한다 치자. 완성품의 통과율은 36.8% 정도 된다.
    - 결론: 각 부품의 품질이 높으면 수가 많아도 최종 제품의 RFT 품질 수준이 올라감 → 제로 defect를 요구함
- 6시그마를 달성하면 RFT 품질 수준이 올라간다.

## AI 시대 데이터 응용 품질 관리

- 요즘은 품질관리를 어떻게 하나? → 디지털화, 스마트화 + 빅데이터
    - 전수검사
    - 제로 defect
    - 품질 정보 실시간 공유
- 비정형 데이터 활용 증가: 센서 데이터, 품질 정보, 검사 정보 등
- 제조 생산 분야의 전통적인 데이터는 CRM, ERP, MES, SCM에서 수집하는 운영 관련 데이터
    - 스마트 공장의 수준이 기초를 지나 중급~고도화로 올라가는 과정은 비정형 데이터를 활용하는 능력과 관련됨
    - 점차 4M에서 발생하는 더 많은 정형 데이터는 물론이고 비정형 데이터의 중요도에 주목 중
- 데이터의 발생 소스와 규모 증가
- 생산 제조 영역에서 발생하는 품질 관련 빅데이터 유형: 생산 설비 데이터, 제조 공정 데이터, 제품 품질 데이터
- ISA-95 기준에 근거한 데이터 수집 영역
    1. 실제 생산 공정
    2. 생산 공정 센싱 및 컨트롤
    3. 생산 공정을 관리 감독하며 자동화 설비를 이용
    4. 제품을 생산하기 위하여 작업 흐름을 단계별로 제어하며 생산공정을 최적화하고 기록을 유지
    5. 기본적인 공장 스케줄 생성(생산, 자재사용, 배송), 적정 재고 수준 결정
- 제조 부문 빅데이터 적용 영역

    ![](/assets/img/category-HAE/260107-HAE-3-SF-quality-3.png)

# 4M 관점 품질 관리 분석

## Man

- 작업자의 신체 컨디션은 가변적임
- 작업자의 보유 기술 수준은 사바사
- 개별 작업자 간의 차이를 무시한 시스템이라면 문제가 발생하는 것이 당연
    - 작업자 간 조건과 차이점을 극복하고 문제 발생을 방지하는 시스템이나 설비가 필요하겠지
    - 일본 기업은 품질혁신 시대를 거치면서 이런 사람의 조건과 관계없이 일정한 최소 조건을 구축하는 노력을 시행한 바 있으며 이를 ‘Fool Proof’ 또는 ‘포카요카 조건’이라고 부르고 있음
- 화장품 용기 측정 사례 (영상 30분 다 보라고 올린 건 아님)

    <iframe width="560" height="315" src="https://www.youtube.com/embed/k_ANEHC02BE?si=0kqBiQ6RkUejyhBr" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

    <iframe width="560" height="315" src="https://www.youtube.com/embed/6AAgAuYuqOQ?si=PTibeLeBN5ho0YL6" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

- 자동차 외관 검사 사례
    - 기존에는 조명을 빽빽하게 배치하고 사람이 눈으로 검사했음
    - 카메라 비전 기반 검사 기술 추진 중 → 전체 차량 외관 검사 영역을 모두 커버하는 검사 방법으로 추진 중. 50대 이상의 카메라가 영상을 찍어 실시간으로 AI가 연산처리하고 판정하는 방식
- LS 일렉트릭의 Fool Proof 방지 사례
    - 환경: 다품종 소량 생산 수작업 환경
    - 문제: 초보 직원의 실수, 유사 부품 주의, 피곤함
    - 해결 방안: 스마트 워크스테이션
    - 성과: 조립 관련 품질 문제 발생 98% 축소
    - 영상은 비공개 자료라 내가 뭐 따로 수집해둘 수 있는 건 없고
    - 복잡한 파츠에 나사를 체결해야 하는데, 어디에 어느 나사를 박으면 되는지 실제 이미지와 나사 박스 LED, 텍스트 지시 등 복합적으로 안내하여 작업자가 어렵지 않게 조립하는 영상이었음
- 일본 야스카와 전기 기술 전시 사례: 스마트 워크스테이션
- AR 활용 사례
    - 신입 사원 조립 훈련
    - 구글이 포기한 구글 글래스가 일본에서 다양하게 쓰이고 있음
    - 부품 창고에서 부품 가져올 때, 어느 박스에서 얼마나 꺼내면 되는지 AR로 보여줌 (이미지는 대충 비스무리한거 가져옴)

        <a href="https://www.itbiznews.com/news/articleView.html?idxno=166392" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-4-SF-quality-3.png"/></a>

- 일본 원격 작업 지원 시스템
    - 이거 그 약간 메카물에서 파일럿이랑 오퍼레이터 짝지어주는 거랑 비슷함. 작업자는 현장에서 작업을 하고, 기술자는 원격으로 작업자의 시야를 공유하면서 지시함. 한국에서는 버넥트가 유사 서비스를 제공함.
- GE 헬스케어 히노 공장 스마트 글라스: 대형 의료 스캐너용 부품과 소형 정밀기기용 부품 생산

    <a href="https://blog.naver.com/moons4ir/222457658237" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-5-SF-quality-3.png"/></a>

- 품질 개선 실습 - 6가지 <실전 사례>에 대한 문제 해결 방안 찾기
    - 사례 1. 신규 작업자의 표준작업 미숙지(잘 이해하지 못한 상태)로 인한 조립 불량 발생
        - 한 전자제품 조립 공장에서 신규 작업자가 투입되었는데, 교육 기간이 짧아서 표준작업서(SOP)의 세부 조립 순서를 충분히 숙지하지 못한 상태였다. 특히 나사 체결 순서와 체결 토크 기준이 중요한 공정이었으나, 신규 작업자는 이를 제대로 인지하지 못한 채 눈대중으로 작업을 반복했다.
        - 이로 인해 제품 간 체결 강도 편차가 발생했으며, 일부 제품은 정상작동 테스트에서 진동에 의해 부품이 풀리는 문제가 발생했다. QC 검사에서 불량률이 비정상적으로 증가했고, 원인을 추적하던 중 작업자 교육 미흡이 직접적 원인으로 확인되었다.

        ![](/assets/img/category-HAE/260107-HAE-6-SF-quality-3.png)
        ![](/assets/img/category-HAE/260107-HAE-7-SF-quality-3.png)
        ![](/assets/img/category-HAE/260107-HAE-8-SF-quality-3.png)
        ![](/assets/img/category-HAE/260107-HAE-9-SF-quality-3.png)

    - 사례 2. 교대조 인수인계 누락으로 공정 조건이 변한 채 생산 지속
        - 주·야간 교대가 있는 금형가공 업체에서 한 교대조 작업자가 공정 조건(스핀들 속도, 냉각수 압력)을 임시로 변경하고 퇴근했지만, 이를 인수인계장에 기록하지 않았다. 다음 교대조는 변경된 조건을 정상값으로 인지하고 생산을 그대로 진행했다.
        - 그 결과, 치수 편차가 공정능력 범위를 벗어나기 시작했고, 4시간 동안 생산된 모든 제품이 불량 처리되는 상황이 발생했다. 뒤늦게 설비 로그를 확인한 결과 조건 변경 이력이 발견되어 원인을 파악할 수 있었다.
        - 이 사례는 인수인계의 중요성, 표준화된 커뮤니케이션 부재, 로그 기반 스마트 모니터링 부재가 결합된 대표적 휴먼 에러다. 이는 스마트공장에서 MES 기반 조건변경 알림 기능만 있었어도 예방 가능했던 유형이다.

        ![](/assets/img/category-HAE/260107-HAE-10-SF-quality-3.png)
        ![](/assets/img/category-HAE/260107-HAE-11-SF-quality-3.png)
        ![](/assets/img/category-HAE/260107-HAE-12-SF-quality-3.png)

    - 사례 3. 반복 검사 중 집중력 저하로 불량 판정 누락
        - 한 금속 가공 공장에서 외관 검사는 대부분 사람이 육안으로 수행하고 있었고, 하루 8시간 동안 동일한 형태의 제품을 검사해야 했다. 검사자가 중반 이후 피로와 집중력 저하를 느끼면서 작은 흠집이나 스크래치를 놓치는 일이 점차 늘어났다.
        - 며칠 후 고객사에서 받은 클레임을 통해 불량 누락이 다수 발견되었고, 추적 결과 특정 시간대와 특정 검사자에게서 누락 빈도가 높게 나타났다. 이는 인간이 반복 작업에서 겪는 자연스러운 피로도가 품질 문제로 이어진 사례다.
        - 근본 원인은 검사자에게 과도하게 의존하는 검사 방식, 작업의 단조로움에 따른 집중력 저하, 자동검사 장비 도입 지연 등이었다. 스마트 공정에서는 머신비전이나 이미지 검사 시스템이 필요한 이유가 명확히 드러난다.
    - 사례 4. 작업자의 잘못된 공구 선택으로 표면 스크래치 발생
        - 한 사출 공정 후 제품을 다듬는 Deburring(버 제거) 작업에서 작업자가 일반 금속 스크래퍼 대신 연마 강도가 높은 공구를 잘못 선택하는 실수를 했다. 두 공구의 외형이 비슷해 혼동하기 쉬운 환경이었던 것이 문제의 배경이다.
        - 그 결과, 제품 표면에 미세한 선 긋힘 자국이 생기기 시작했고, 육안으로 보기 어려워 불량은 출하 후까지 발견되지 못했다. 고객사에서는 외관 품질 기준에 위배된다며 반품과 보증 클레임을 제기했다.
    - 사례 5. 작업자 피로 누적으로 인해 실수 잦아짐
        - 바쁜 납기 일정으로 인해 작업자들은 연속 초과근무를 수행했고, 특히 야간 근무자는 수면 부족으로 피로가 누적된 상태였다. 피로는 판단력 저하와 작업 속도 변화로 나타났고, 부품 정렬이나 방향성 체크에서 실수가 빈번하게 발생했다.
        - 품질팀이 조사한 결과, 특정 기간 동안 동일 작업자에게서 반복되는 불량이 다수 발견되었다. 작업자의 의지나 능력의 문제가 아니라, 과로 환경 그 자체가 품질 리스크였던 것이다.
    - 사례 6. BOM/지시서 오해석으로 잘못된 부품 사용
        - 조립 공장에서 작업자가 생산지시서와 BOM을 잘못 해석해 유사한 규격의 부품(예: M4 × 20 vs M4 × 25)을 착각하여 사용한 사례가 있었다. 두 부품은 외관이 거의 동일해 육안으로 구별하기 어려웠고, 작업자는 지시서의 작은 표기를 놓치고 생산을 계속했다.
        - 완제품 테스트 단계에서 조립간 간섭 발생이 발견되었고, 최종적으로 작업자가 사용한 부품이 지시서와 다르다는 사실이 확인되었다. 이로 인해 이미 생산된 수백 개의 제품을 재작업해야 했다.

## Machine

- 설비 관련 품질관리의 중요성
    - 공구, 설비, 장비, 라인에 고장이 발생하기 전에 알람해주는 예지적인 솔루션 적용
    - 근본적으로 공구, 설비, 장비, 라인에서 생산 제조 품질 문제가 발생하는 것을 회피
    - 공구의 마모나 파손으로 품질 문제가 발생하는 현상을 사전에 감지하고 조치하는 활동
- 예지 감시 시점
    - 예를 들면 이상 발생 → 초음파 변화 → 이상진동 발생 → 온도 분포 변화 → 가청 소음 발생 → 발열 → 완전 고장 순서로 문제가 진행된다고 할 때, 초음파가 발생하는 순간부터 온도 분포가 변화하기 전까지 그 사이 구간에서 예지보전을 하면 좋다
- 플랜트나 공장의 설비의 모니터링을 위한 빅데이터 수집과 고장 예지 진단의 인프라 - 한프리즘 사례 예시

    <a href="https://blog.naver.com/bnftechnology/222420660051" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-13-SF-quality-3.png"/></a>

- 전체 장비의 상태 예지 사례: 기초 원인 분석 → 장비 상태 모니터링 → 결함 예측
- 설비 고장 패턴과 보전 방식
    - 설비 관리가 생산성은 물론 품질 관리 관점에서 중요해짐에 따라 설비를 효율적으로 유지보수하기 위해 고장을 사전에 진단하는 기술이 점차 필수적이 되고 있음
    - 설비는 사용 시간과 별개로 문제가 발생함
    - 보전 방식의 종류: 예지보전, 예방보전, 사후보전

    <a href="https://www.dbpia.co.kr/journal/articleDetail?nodeId=NODE12192115" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-14-SF-quality-3.png"/></a>

- 데이터 분석법의 발전

    <a href="https://www.dbpia.co.kr/journal/articleDetail?nodeId=NODE12192115" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-15-SF-quality-3.png"/></a>

- 보전과 비용
    - 사후보전 > 정기점검(예방보전) > 상태기반 보전 > 예지보전
    - 국내 대부분 대기업은 사후보전, 예방보전 수준
- 모터 작동 이상 예지 분석 사례: <https://ko.onepredict.ai/?q=YToyOntzOjEyOiJrZXl3b3JkX3R5cGUiO3M6MzoiYWxsIjtzOjQ6InBhZ2UiO2k6Nzt9&bmode=view&idx=16821980&t=board>

<iframe width="560" height="315" src="https://www.youtube.com/embed/PLpW89p81P4?si=pNTfRB2hhzspUqAU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 공법(Method) 중심 품질 관리

- 기업은 누구나 자신을 위한 공법을 보유하고 이를 공정에서 활용함: 타 기업에 대한 이 공법의 차별점이 경쟁력
- 기업 오리지널 공법을디지털화, 스마트화, 연결화 기술로 융합, 적용하여 개선하는 것이 핵심
    1. 품질 개선
    2. 품질 관리 효율 증가
    3. 더 업그레이드된 공법 개발
- 포스코 AI 용광로 사례: [이 고로(2고로)가 ‘AI용광로’라고?](https://newsroom.posco.com/kr/%EC%9D%B4-%EA%B3%A0%EB%A1%9C2%EA%B3%A0%EB%A1%9C%EA%B0%80-ai%EC%9A%A9%EA%B4%91%EB%A1%9C%EB%9D%BC%EA%B3%A0/)

    <a href="https://newsroom.posco.com/kr/%EC%9D%B4-%EA%B3%A0%EB%A1%9C2%EA%B3%A0%EB%A1%9C%EA%B0%80-ai%EC%9A%A9%EA%B4%91%EB%A1%9C%EB%9D%BC%EA%B3%A0/" target="_blank"><img src="/assets/img/category-HAE/260107-HAE-16-SF-quality-3.png"/></a>

<iframe width="560" height="315" src="https://www.youtube.com/embed/JtOileoUA1Y?si=42YDx8X3KWjW0oNp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 재료(Material) 중심 품질 관리

- 배추 품질 분류

    <iframe width="560" height="315" src="https://www.youtube.com/embed/mj4cM2WtG1Q?si=9AtH9ky4mq5EiBmC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>