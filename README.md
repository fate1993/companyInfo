# 컴퍼니인포 소개
컴퍼니인포는 국내 상장사의 정보를 제공하는 웹사이트 입니다. 사업보고서를 제출할 의무가 있는 국내 모든 법인의 기업 정보는 전자공시시스템(DART)을 통해 공개되고 있습니다. 컴퍼니인포는 DART의 데이터를 검색할 수 있고 결과에 맞는 데이터를 시각화해서 제공합니다.
## 시연 모습
![companyInfo](https://user-images.githubusercontent.com/77215614/130646924-a52841eb-e479-487d-b11e-17aa3920fcd8.gif)
## 사용된 주요 기술 및 내용
- RESTful API
- Ajax
- HTTP 통신으로 외부에서 가져온 JSON 데이터를 화면에 출력
- xml 데이터 기반(50만줄 이상 분량) 검색어 자동완성
- JSON 타입으로 가져온 데이터를 차트 라이브러리를 이용해 시각화
- 오픈 API를 제공하는 DART 측이 정해 놓은 요청인자가 종목코드로 되어있어 검색을 기업명이 아닌 종목코드로 해야하는 문제가 있었으나 별도의 xml 파일에서 종목명에 맞는 종목코드를 추출하는 방법으로 해결
## 사용된 오픈 API
- [OPEN DART](https://opendart.fss.or.kr/)
- [chart.js](https://www.chartjs.org/)
- jQuery
