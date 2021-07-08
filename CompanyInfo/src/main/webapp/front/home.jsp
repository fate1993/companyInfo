<%@ page contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>CompanyInfo</title>
<link rel="stylesheet" href="style.css">
<link rel="shortcut icon" href="#">
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.4.0/chart.min.js"></script>
<script src="https://code.jscharting.com/latest/jscharting.js"></script>
<script type="text/javascript" src="https://code.jscharting.com/latest/modules/types.js"></script>

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
				$("p").empty();

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
						bsns_year : "2021",
						reprt_code : "11013"
					}
				}).done(function(msg) {
					var arrayList = [];
					var shareList = [];
					var numberofShare = [];
					for(var i=0; i < msg.list.length; i++) {
						arrayList.push(msg.list[i].nm);
						shareList.push(msg.list[i].trmend_posesn_stock_qota_rt);
						numberofShare.push(msg.list[i].trmend_posesn_stock_co);
					} // for 반복문
					
					
					var ctx = document.getElementById("myChart").getContext('2d');
					var myChart = new Chart(ctx, {
					  type: 'pie',
					  data: {
					    labels: arrayList,
					    datasets: [{
					      backgroundColor: [
					        "#2ecc71",
					        "#3498db",
					        "#95a5a6",
					        "#9b59b6",
					        "#f1c40f",
					        "#e74c3c",
					        "#34495e"
					      ],
					      data: shareList
					    }]
					  }
					}); // 구현필요: 1. 검색시 canvas 삭제후 리로드 2. json 데이터 중 '계' 부분이 이상함 3. 차트 크기 조절
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
					var list = msg.list
					
					// 유동자산
					var currentAsset = parseInt(list[0].thstrm_amount.replace(/,/g, ""));
					// 비유동자산
					var nonCurrentAsset = parseInt(list[1].thstrm_amount.replace(/,/g, ""));
					// 유동부채			
					var currentLiability = parseInt(list[3].thstrm_amount.replace(/,/g, ""));
					// 비유동부채
					var nonCurrentLiability = parseInt(list[4].thstrm_amount.replace(/,/g, ""));
					// 자본총계
					var totalEquity = parseInt(list[8].thstrm_amount.replace(/,/g, ""));
					
					var chart = JSC.chart('chartDiv', {
						  debug: true, 
						  type: 'treemap cushion', 
						  title_label_text: 
						    '재무상태표', 
						  legend_visible: false, 
						  defaultSeries_shape: { 
						    label: { 
						      text: '%name', 
						      color: '#f2f2f2', 
						      style: { fontSize: 15, fontWeight: 'bold' } 
						    } 
						  }, 
						  series: [ 
						    { 
						      name: '자산', 
						      points: [ 
						        { name: '유동자산', y: currentAsset }, 
						        { name: '비유동자산', y: nonCurrentAsset }
						      ],
						      order: 0
						    }, 
						    { 
						      name: '부채', 
						      points: [ 
						        { name: '유동부채', y: currentLiability }, 
						        { name: '비유동부채', y: nonCurrentLiability }
						      ],
						      order: 1
						    },
						    {
							      name: '자본', 
							      point: [ 
							        { name: '자본', y: totalEquity }
							      ],
							      order: 2
								 },
						  ] 
						}); 
			            
					/*
					$("#finance").append("자산총계(2018): " + msg.list[2].bfefrmtrm_amount + "원<br>");
					$("#finance").append("부채총계(2018): " + msg.list[5].bfefrmtrm_amount + "원<br>");
					$("#finance").append("자산총계(2019): " + msg.list[2].frmtrm_amount + "원<br>");
					$("#finance").append("부채총계(2019): " + msg.list[5].frmtrm_amount + "원<br>");
					$("#finance").append("자본총계(2018): " + msg.list[8].bfefrmtrm_amount + "원<br>");
					$("#finance").append("자본총계(2019): " + msg.list[8].bfefrmtrm_amount + "원<br>");
					*/
					
					// Combo bar/line
					// 매출액(2018-2020)
					var revenue2018 = parseInt(msg.list[9].bfefrmtrm_amount.replace(/,/g, ""));
					var revenue2019 = parseInt(msg.list[9].frmtrm_amount.replace(/,/g, ""));
					var revenue2020 = parseInt(msg.list[9].thstrm_amount.replace(/,/g, ""));
					// 영업이익(2018-2020)
					var profit2018 = parseInt(msg.list[10].bfefrmtrm_amount.replace(/,/g, ""));
					var profit2019 = parseInt(msg.list[10].frmtrm_amount.replace(/,/g, ""));
					var profit2020 = parseInt(msg.list[10].thstrm_amount.replace(/,/g, ""));
					// 당기순이익(2018-2020)
					var net2018 = parseInt(msg.list[12].bfefrmtrm_amount.replace(/,/g, ""));
					var net2019 = parseInt(msg.list[12].frmtrm_amount.replace(/,/g, ""));
					var net2020 = parseInt(msg.list[12].thstrm_amount.replace(/,/g, ""));
					
					//const DATA_COUNT = 3;
					//const NUMBER_CFG = {count: DATA_COUNT, min: -100, max: 100};

					const labels = [2018,2019,2020];
					const data = {
					  labels: labels,
					  datasets: [
					    {
					      label: '매출액',
					      data: [revenue2018, revenue2019, revenue2020],
					      borderColor: "none",
					      backgroundColor: "#ecf0f1",
					      type: 'bar',
					      order: 0
					    },
					    {
					      label: '영업이익',
					      data: [profit2018,profit2019,profit2020],
					      borderColor: "none",
					      backgroundColor: "#bdc3c7",
					      type: 'bar',
					      order: 1
					    },
					    {
					      label: '당기순이익',
					      data: [net2018,net2019,net2020],
					      borderColor: "none",
					      backgroundColor: "#95a5a6",
					      type: 'bar',
					      order: 2
						    }
					  ]
					};
					
					const config = {
							  type: 'bar',
							  data: data,
							  options: {
							    responsive: true,
							    plugins: {
							      legend: {
							        position: 'top',
							      },
							      title: {
							        display: true,
							        text: '실적 추이'
							      }
							    }
							  },
							};
					
					var ctx = document.getElementById('myChart2');
					var myChart = new Chart(ctx, config);
				});
			}) // click
		}) // ready
		
	</script>
	

	
	<h1>기업개요</h1>
	<p id="intro"></p>
	
	<h1>배당에 관한 사항</h1>
	<p id="dividend"></p>
	
	
	<p id="shareholders"></p>
	<div class="container">
  <h1>최대주주 현황</h1>
  <div>
    <canvas id="myChart"></canvas>
  </div>
</div>

	<h1>재무 현황</h1>
	<p id="finance"></p>
	<div id="chartDiv" style="max-width: 740px;height: 400px;margin: 0px auto">
    </div>
    
    
    <div>
    <canvas id="myChart2"></canvas>
  </div>
	
	<!-- 구현필요: 검색전 p태그hide 시키기 -->
	
	
</body>
</html>