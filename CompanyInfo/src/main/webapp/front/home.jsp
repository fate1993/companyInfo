<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CompanyInfo</title>
<link rel="stylesheet" href="style.css">
<link rel="shortcut icon" href="#">
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.4.0/chart.min.js"></script>


	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<nav>
		<ul>
			<li><a href="home.jsp">홈</a></li>
			<li><a href="intro.jsp">소개</a></li>
			<li><a href="howtouse.jsp">사용법</a></li>
			<li><a href="list.jsp">기업목록</a></li>
		</ul>
	</nav>
	<div id="logo">
		<img src="logo.png">
	</div>
	<div id="test">
		<input id="searchBar" value="" type="text">
		<button id="search">검색</button>
	</div>
	<script>
	function year() {
		return new Date().getFullYear() - 1;
	}
		$(function() {
			$("#search").click(function() {
				// 기업개황
				$.ajax({
					method : "GET",
					url : "https://opendart.fss.or.kr/api/company.json",
					data : {
						crtfc_key : "05b445d8c91586ba7a5a77367a090d27b9780ab5",
						corp_code : $("#searchBar").val()
					}
				}).done(function(msg) {
					console.log(msg);
					$("#intro").append("<br>"+"결산월: "+year()+"년 "+msg.acc_mt+"월<br>");
					$("#intro").append("기업명: "+msg.stock_name+"<br>");
					$("#intro").append("설립일: "+msg.est_dt+"<br>"); // 설립일 yyyy/mm/mm 형태로 변경 필요
					$("#intro").append("대표: "+msg.ceo_nm+"<br>");
                    $("#intro").append("주소: "+msg.adres+"<br>");
                    $("#intro").append("홈페이지: "+msg.hm_url+"<br>");
				});
				
				// 배당에 관한 사항
				$.ajax({
					method : "GET",
					url : "https://opendart.fss.or.kr/api/alotMatter.json",
					data : {
						crtfc_key : "05b445d8c91586ba7a5a77367a090d27b9780ab5",
						corp_code : $("#searchBar").val(),
						bsns_year : "2020", // 연도 최신화 필요
						reprt_code : "11011" // 최신 보고서 필요
					}
				}).done(function(msg) {
					console.log(msg);
					$("#dividend").append("<br>"+"보통주 배당수익률: "+ msg.list[7].thstrm + "%<br>");
					$("#dividend").append("보통주 현금배당금: "+ msg.list[11].thstrm + "원<br>");
					$("#dividend").append("우선주 배당수익률: "+ msg.list[8].thstrm + "%<br>");
					$("#dividend").append("우선주 현금배당금: "+ msg.list[12].thstrm + "원<br>");
				});
				
				// 최대주주 현황
				
				$.ajax({
					method : "GET",
					url : "https://opendart.fss.or.kr/api/hyslrSttus.json",
					data : {
						crtfc_key : "05b445d8c91586ba7a5a77367a090d27b9780ab5",
						corp_code : $("#searchBar").val(),
						bsns_year : "2020", // 연도 최신화 필요
						reprt_code : "11011" // 최신 보고서 필요
					}
				}).done(function(msg) {
					var arrayList = [];
					var shareList = [];
					for(var i=0; i < msg.list.length; i++) {
						arrayList.push(msg.list[i].nm);
						shareList.push(msg.list[i].trmend_posesn_stock_qota_rt);
						console.log(arrayList);
						console.log(shareList);
						
						$("#shareholders").append("<br>"+"성명: "+ msg.list[i].nm + "<br>");
						$("#shareholders").append("관계: "+ msg.list[i].relate + "<br>");
						$("#shareholders").append("주식 종류: "+ msg.list[i].stock_knd + "<br>");
						$("#shareholders").append("기초 소유 주식수: "+ msg.list[i].bsis_posesn_stock_co + "주<br>");
						$("#shareholders").append("기초 소유 주식 지분율: "+ msg.list[i].bsis_posesn_stock_qota_rt + "%<br>");
						$("#shareholders").append("기말 소유 주식수: "+ msg.list[i].trmend_posesn_stock_co + "주<br>");
						$("#shareholders").append("기말 소유 주식 지분율: "+ msg.list[i].trmend_posesn_stock_qota_rt + "%<br>");
						
						 
						
						const data = {
								  labels: [
								    '김택진',
								    '심마로',
								    '정진수'
								  ],
								  datasets: [{
								    label: 'My First Dataset',
								    data: [11.97, 0.00, 0.00],
								    backgroundColor: [
								      'rgb(255, 99, 132)',
								      'rgb(54, 162, 235)',
								      'rgb(255, 205, 86)'
								    ],
								    hoverOffset: 4
								  }]
								};
						var myChart = new Chart(
							    document.getElementById('myChart'),
							    config
							  );
					} // for 반복문
				});
				
				// 재무정보
				$.ajax({
					method : "GET",
					url : "https://opendart.fss.or.kr/api/fnlttSinglAcnt.json",
					data : {
						crtfc_key : "05b445d8c91586ba7a5a77367a090d27b9780ab5",
						corp_code : $("#searchBar").val(),
						bsns_year : "2020", // 연도 최신화 필요
						reprt_code : "11011" // 최신 보고서 필요
					}
				}).done(function(msg) {
					console.log(msg);
					$("#finance").append("자산총계(2018): " + msg.list[2].bfefrmtrm_amount + "원<br>");
					$("#finance").append("부채총계(2018): " + msg.list[5].bfefrmtrm_amount + "원<br>");
					$("#finance").append("자산총계(2019): " + msg.list[2].frmtrm_amount + "원<br>");
					$("#finance").append("부채총계(2019): " + msg.list[5].frmtrm_amount + "원<br>");
					$("#finance").append("자산총계(2020): " + msg.list[2].thstrm_amount + "원<br>");
					$("#finance").append("부채총계(2020): " + msg.list[5].thstrm_amount + "원<br>");
					
					$("#finance").append("자본총계(2018): " + msg.list[8].bfefrmtrm_amount + "원<br>");
					$("#finance").append("자본총계(2019): " + msg.list[8].bfefrmtrm_amount + "원<br>");
					$("#finance").append("자본총계(2020): " + msg.list[8].bfefrmtrm_amount + "원<br>");
					
					// 매출액
					$("#finance").append(msg.list[9].account_nm + msg.list[9].bfefrmtrm_dt + msg.list[9].bfefrmtrm_amount + "원<br>");
					$("#finance").append(msg.list[9].account_nm + msg.list[9].frmtrm_dt + msg.list[9].frmtrm_amount + "원<br>");
					$("#finance").append(msg.list[9].account_nm + msg.list[9].thstrm_dt + msg.list[9].thstrm_amount + "원<br>");
					
					// 영업이익
					$("#finance").append(msg.list[10].account_nm + msg.list[10].bfefrmtrm_dt + msg.list[10].bfefrmtrm_amount + "원<br>");
					$("#finance").append(msg.list[10].account_nm + msg.list[10].frmtrm_dt + msg.list[10].frmtrm_amount + "원<br>");
					$("#finance").append(msg.list[10].account_nm + msg.list[10].thstrm_dt + msg.list[10].thstrm_amount + "원<br>");
					
					// 당기순이익
					$("#finance").append(msg.list[12].account_nm + msg.list[12].bfefrmtrm_dt + msg.list[12].bfefrmtrm_amount + "원<br>");
					$("#finance").append(msg.list[12].account_nm + msg.list[12].frmtrm_dt + msg.list[12].frmtrm_amount + "원<br>");
					$("#finance").append(msg.list[12].account_nm + msg.list[12].thstrm_dt + msg.list[12].thstrm_amount + "원<br>");
				
				});
			}) // click
		}) // ready
		
	</script>
	

	
	<h1>기업개요</h1>
	<p id="intro"></p>
	
	<h1>배당에 관한 사항</h1>
	<p id="dividend"></p>
	
	<h1>최대주주 현황</h1>
	<p id="shareholders"></p>
	<div>
  <canvas id="myChart"></canvas>
</div>

	<h1>재무 현황</h1>
	<p id="finance"></p>
	
	
</body>
</html>