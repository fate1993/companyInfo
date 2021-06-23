<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="style.css">
<link rel="shortcut icon" href="#">
</head>
<body>
	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<nav>
		<ul>
			<li><a href="home.html">Ȩ</a></li>
			<li><a href="intro.html">�Ұ�</a></li>
			<li><a href="howtouse.html">����</a></li>
			<li><a href="list.html">������</a></li>
		</ul>
	</nav>
	<div id="logo">
		<img src="logo.png">
	</div>
	<input id="searchBar" value="" type="text">
    <button id="search">�˻�</button>
    
	<!--<form>
		<input id="searchBar" name="searchBar" type="text"
			placeholder="����� / �����ڵ带 �Է��ϼ���" size=100>
		<!--<input  type="button" value="�˻�" style="font: 15px">
	</form>-->
	<!--  <button id="searchButton" type="button">�˻�</button>-->
	<p></p>

	<script>
	$(document).ready(function() {
		$('#search').click(function(){
			var value = $("#searchBar").val();
			$.ajax({
		    	  method: "GET",
		    	  url: "https://opendart.fss.or.kr/api/hyslrSttus.json?"+
		    			 "crtfc_key=05b445d8c91586ba7a5a77367a090d27b9780ab5&"+
		    			 "corp_code="+
		    			 coNumber(value); +
		    			 "&bsns_year=2018&"+
		    			 "reprt_code=11011"
		    	})
		    	.done(function( msg ) {
		    		console.log(msg);
		    	  });
		})
	});
	
 	function coNumber(var v) {
 		$.ajax({
	    	  method: "GET",
	    	  url: "https://opendart.fss.or.kr/api/corpCode.xml"
	    	  data: {
	    		  crtfc_key: "05b445d8c91586ba7a5a77367a090d27b9780ab5"
	    	  }
	    	})
	    	.done(function( msg ) {
	    		console.log(msg);
	    	  });
	}
		
	
</script>
	<p></p>
</body>
</html>