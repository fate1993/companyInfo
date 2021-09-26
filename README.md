# **컴퍼니인포 소개**

컴퍼니인포는 국내 상장사의 기업 정보를 제공하는 웹 사이트 입니다. 사업보고서를 제출할 의무가 있는 국내 모든 법인의 기업 정보는 전자공시시스템(DART)을 통해 공개되고 있습니다. 컴퍼니인포는 DART의 데이터를 검색할 수 있고 결과에 맞는 데이터를 시각화해서 제공합니다. 

---

# 개발환경

- OS : 윈도우 10
- IDE : 이클립스
- 언어 : HTML, CSS, JavaScript
- API : [OPEN DART](https://opendart.fss.or.kr/), [chart.js](https://www.chartjs.org/) 등

---

# 개발기간

2021.06.11 ~ 2021.07.26

---

# 주요 기능

![companyInfo](https://user-images.githubusercontent.com/77215614/134815315-39539b19-e870-4d4a-838e-d2424e930f09.gif)
- RESTful API를 이용해 DART에서 가져온 기업개요, 배당현황, 최대주주 현황, 재무현황, 실적추이 등 데이터를 화면에 출력
- JSON 타입으로 가져온 데이터를 chart.js 라이브러리를 이용해 막대 그래프, 파이 차트 등으로 시각화
- Ajax를 이용해 전체 페이지 새로고침 없이 데이터 출력
- 50여만줄 분량의 xml 데이터를 기반으로 검색시 국내 기업명 자동완성
- 오픈 API를 제공하는 DART 측이 정해 놓은 요청인자가 종목코드로 되어있어 검색을 기업명이 아닌 종목코드로 해야하는 문제가 있었으나 별도의 xml 파일에서 종목명에 맞는 종목코드를 추출하는 방법으로 해결

---

# 프로젝트 관련 링크
- 후기 및 느낀점 : [https://change-words.tistory.com/117?category=902998](https://change-words.tistory.com/117?category=902998)
---
