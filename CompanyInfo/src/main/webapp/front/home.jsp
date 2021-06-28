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
	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<nav>
		<ul>
			<li><a href="home.html">홈</a></li>
			<li><a href="intro.html">소개</a></li>
			<li><a href="howtouse.html">사용법</a></li>
			<li><a href="list.html">기업목록</a></li>
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
		$(document).ready(function() {
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
					console.log(msg);
					for(var i=0; i < msg.list.length; i++) {
						$("#shareholders").append("<br>"+"성명: "+ msg.list[i].nm + "<br>");
						$("#shareholders").append("관계: "+ msg.list[i].relate + "<br>");
						$("#shareholders").append("주식 종류: "+ msg.list[i].stock_knd + "<br>");
						$("#shareholders").append("기초 소유 주식수: "+ msg.list[i].bsis_posesn_stock_co + "주<br>");
						$("#shareholders").append("기초 소유 주식 지분율: "+ msg.list[i].bsis_posesn_stock_qota_rt + "%<br>");
						$("#shareholders").append("기말 소유 주식수: "+ msg.list[i].trmend_posesn_stock_co + "주<br>");
						$("#shareholders").append("기말 소유 주식 지분율: "+ msg.list[i].trmend_posesn_stock_qota_rt + "%<br>");
					}
				});
				
				// 재무정보
				
			})
		})
		
	</script>
	<h1>기업개요</h1>
	<p id="intro"></p>
	
	<h1>배당에 관한 사항</h1>
	<p id="dividend"></p>
	
	<h1>최대주주 현황</h1>
	<p id="shareholders"></p>
	
	<h1>직원 현황</h1>
	<p id="workers"></p>
</body>
</html>