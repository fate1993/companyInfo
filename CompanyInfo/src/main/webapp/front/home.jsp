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
		$(document).ready(function() {
			$("#search").click(function() {
				$.ajax({
					method : "GET",
					url : "https://opendart.fss.or.kr/api/company.json",
					data : {
						crtfc_key : "05b445d8c91586ba7a5a77367a090d27b9780ab5",
						corp_code : $("#searchBar").val()
					}
				}).done(function(msg) {
					console.log(msg);
					$("p").append("<br>"+"기업명: "+msg.stock_name+"<br>");
					$("p").append("대표: "+msg.ceo_nm+"<br>");
                    $("p").append("주소: "+msg.adres+"<br>");
                    $("p").append("전화번호: "+msg.phn_no+"<br>");
				});
			})
		})
	</script>
	<p></p>
</body>
</html>