<%@ page contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>CompanyInfo</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<!-- chart -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.4.0/chart.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
	var corp_code = "";
	var myXML;
	var key = "05b445d8c91586ba7a5a77367a090d27b9780ab5";
		$(function() {
	            	var myArr = [];
	            	 $.ajax({
	            	   type: "GET",
	            	   url: "CORPCODE.xml",
	            	   dataType: "xml",
	            	   success: parseXml,
	            	   complete: setup,
	            	   failure: function(data) {
	            	     alert("XML File could not be found");
	            	   }
	            	 });
	            	 
	            	 function parseXml(xml)
	            	 {
	            	   $(xml).find("corp_name").each(function()
	            	   {
	            	     myArr.push($(this).text());
	            	   });
	            	 }
	            	 
	            	 function setup() {
	            	   $("#searchBar").autocomplete({
	            	   source: myArr,
	            	   minLength: 1,
	            	   select: function(event, ui) {
	            		   $(this).val(ui.item.value);
	            	   },
	            	   focus : function(event, ui) {
	                       return false;
	                   }
	            	  });
	            	 }
			
			$('#searchBar').keypress(function(e){
            	$('#search').click();
    		});
			
			$("#search").click(function() {
				$("p").empty();
				var Value = $("#searchBar").val()
				
				// XML 파일의 corp_name 입력시 corp_code 꺼내오기
				$.ajax({
					url: "./CORPCODE.xml",						
					type: "get",
					success: function(xml) {
						myXML = $(xml).find("list").filter(function() {
			                return $(this).find('corp_name').text() == Value;
			            });
						corp_code = myXML[0].childNodes[1].innerHTML;
							
						// 기업개황
						$.ajax({
							method : "GET",
							url : "https://opendart.fss.or.kr/api/company.json",
							data : {
								crtfc_key : key,
								corp_code : corp_code //$("#searchBar").val()
							}
						}).done(function(msg) {
							$(".list").show();
							$("#intro").append("기업명: "+msg.stock_name+"<br>");
							$("#intro").append("설립일: "+(msg.est_dt).replace(/(\d{4})(\d{2})(\d{2})/g, '$1-$2-$3')+"<br>"); // 설립일 yyyy/mm/mm 형태로 변경 필요
							$("#intro").append("대표: "+msg.ceo_nm+"<br>");
		                    $("#intro").append("주소: "+msg.adres+"<br>");
		                    $("#intro").append("홈페이지: "+msg.hm_url+"<br>");
						});
						
						// 배당에 관한 사항
						$.ajax({
							method : "GET",
							url : "https://opendart.fss.or.kr/api/alotMatter.json",
							data : {
								crtfc_key : key,
								corp_code : corp_code,
								bsns_year : "2020",
								reprt_code : "11011"
							}
						}).done(function(msg) {
							$("#dividend").append("보통주 배당수익률: "+ msg.list[7].thstrm + "%<br>");
							$("#dividend").append("보통주 현금배당금: "+ msg.list[11].thstrm + "원<br>");
							$("#dividend").append("우선주 배당수익률: "+ msg.list[8].thstrm + "%<br>");
							$("#dividend").append("우선주 현금배당금: "+ msg.list[12].thstrm + "원<br>");
						});
						
						// 최대주주 현황
						$.ajax({
							method : "GET",
							url : "https://opendart.fss.or.kr/api/hyslrSttus.json",
							data : {
								crtfc_key : key,
								corp_code : corp_code,
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
							}
							
							var ctx = document.getElementById("myChart").getContext('2d');
							var myChart = new Chart(ctx, {
							  type: 'pie',
							  data: {
							    labels: arrayList,
							    maintainAspectRatio: false,
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
							});
						});
						
						// 재무정보
						$.ajax({
							method : "GET",
							url : "https://opendart.fss.or.kr/api/fnlttSinglAcnt.json",
							data : {
								crtfc_key : key,
								corp_code : corp_code,
								bsns_year : "2020", 
								reprt_code : "11011"
							}
						}).done(function(msg) {
							var list = msg.list
							
							//자산총계
							var totalAssets2020 = parseInt(list[2].thstrm_amount.replace(/,/g, ""));
							var totalAssets2019 = parseInt(list[2].frmtrm_amount.replace(/,/g, ""));
							var totalAssets2018 = parseInt(list[2].bfefrmtrm_amount.replace(/,/g, ""));
							//부채총계
							var totalLiabilities2020 = parseInt(list[5].thstrm_amount.replace(/,/g, ""));
							var totalLiabilities2019 = parseInt(list[5].frmtrm_amount.replace(/,/g, ""));
							var totalLiabilities2018 = parseInt(list[5].bfefrmtrm_amount.replace(/,/g, ""));
							// 자본총계
							var totalEquity2020 = parseInt(list[8].thstrm_amount.replace(/,/g, ""));
							var totalEquity2019 = parseInt(list[8].frmtrm_amount.replace(/,/g, ""));
							var totalEquity2018 = parseInt(list[8].bfefrmtrm_amount.replace(/,/g, ""));
							
							// 재무상태표 테이블 표
							$("#totalAssets2018").html((String)(totalAssets2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalAssets2019").html((String)(totalAssets2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalAssets2020").html((String)(totalAssets2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							$("#totalLiabilities2018").html((String)(totalLiabilities2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalLiabilities2019").html((String)(totalLiabilities2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalLiabilities2020").html((String)(totalLiabilities2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							$("#totalEquity2018").html((String)(totalEquity2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalEquity2019").html((String)(totalEquity2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#totalEquity2020").html((String)(totalEquity2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							// 재무상태표 그래프
							const labels1 = [2018,2019,2020];
							const data = {
							  labels: labels1,
							  datasets: [
							    {
							      label: '자산총계',
							      data: [totalAssets2018, totalAssets2019, totalAssets2020],
							      borderColor: "none",
							      backgroundColor: "#ecf0f1",
							      type: 'bar',
							      order: 0
							    },
							    {
							      label: '부채총계',
							      data: [totalLiabilities2018, totalLiabilities2019, totalLiabilities2020],
							      borderColor: "none",
							      backgroundColor: "#bdc3c7",
							      type: 'bar',
							      order: 1
							    },
							    {
							      label: '자본총계',
							      data: [totalEquity2018, totalEquity2019, totalEquity2018],
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
									        font: {
									        	size: 20
									        },
									        text: '재무상태표(단위: 원)'
									      }
									    }
									  },
									};
							
							var ctx = document.getElementById('myChart3');
							var myChart = new Chart(ctx, config);
							
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
							
							// 실적 테이블 표
							$("#revenue2018").html((String)(revenue2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#revenue2019").html((String)(revenue2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#revenue2020").html((String)(revenue2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							$("#profit2018").html((String)(profit2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#profit2019").html((String)(profit2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#profit2020").html((String)(profit2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							$("#net2018").html((String)(net2018).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#net2019").html((String)(net2019).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							$("#net2020").html((String)(net2020).replace(/\B(?=(\d{3})+(?!\d))/g, ','));
							
							// 실적 그래프
							const labels = [2018,2019,2020];
							const data2 = {
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
							
							const config2 = {
									  type: 'bar',
									  data: data2,
									  options: {
									    responsive: true,
									    plugins: {
									      legend: {
									        position: 'top',
									      },
									      title: {
									        display: true,
									        font: {
									        	size: 20
									        },
									        text: '실적 추이(단위: 원)'
									      }
									    }
									  },
									};
							
							var ctx = document.getElementById('myChart2');
							var myChart = new Chart(ctx, config2);
						});
					},
					error: function(xhr, textStatus, errorThrown) {
						$("div").html("<div>" + textStatus + " (HTTP-" + xhr.status + " / " + errorThrown + ")</div>" );
					}
				});
			}) // click
		}) // ready
		</script>	
		
	<!-- 홈 UI -->
	<nav>
		<ul>
			<li><a href="home.jsp">홈</a></li>
			<li><a href="intro.jsp">사이트 소개</a></li>
		</ul>
	</nav>
	<div id="logo" >
		<img src="logo.png">
	</div>
	<div id="test">
		<input id="searchBar" value="" type="text" placeholder="종목명을 입력하세요">
		<button id="search">검색</button>
	</div>
	
	<!-- 본문 -->
	<br><br>
	<p class="list" style="display: none; border-bottom: 1px solid gray;"></p>
	<h1 class="list" style="margin: 30px 0 30px 30px; display: none; text-align: center;">기업개요</h1>
	<p id="intro" style="margin: 30px 0 30px 30px; text-align: center;"></p>
	
	<p class="list" style="display: none; border-bottom: 1px solid gray;"></p>
	
	<h1 class="list" style="display: none; margin: 30px 0 30px 30px; text-align: center;">배당 현황</h1>
	<p id="dividend" style="margin: 30px 0 30px 30px; text-align: center;"></p>
	
	<p class="list" style="display: none; border-bottom: 1px solid gray;"></p>
	
  <h1 class="list" style="display: none; margin: 30px 0 30px 30px; text-align: center;">최대주주 현황</h1>
  
 <div class="chart-container" style="position: relative; margin: auto; height:20vh; width:40vw">
    <canvas id="myChart"></canvas>
</div>
	
	<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	<p class="list" style="display: none; border-bottom: 1px solid gray;"></p>
	<h1 class="list" style="display: none; margin: 30px 0 30px 30px; text-align: center;">재무 현황</h1>
	<!-- <p id="finance"></p> -->
	
	<!-- 
	<div id="chartDiv" style="position: relative; max-width: 740px;height: 400px;margin: 0px auto">
    </div>
     -->
     <div style="position: relative; margin: auto; height:20vh; width:40vw">
    <canvas id="myChart3"></canvas>
  	</div>
  	<br><br><br><br><br><br><br><br><br><br><br>
     <table class="list" style="display:none;">
  	<tbody>
        <tr>
        	<td></td>
            <td>2018.12</td>
            <td>2019.12</td>
            <td>2020.12</td>
        </tr>
        <tr >
        	<td>자산총계</td>
        	<td id="totalAssets2018"></td>
        	<td id="totalAssets2019"></td>
        	<td id="totalAssets2020"></td>
        </tr>
        <tr>
			<td>부채총계</td>
			<td id="totalLiabilities2018"></td>
			<td id="totalLiabilities2019"></td>
			<td id="totalLiabilities2020"></td>
        </tr>
        <tr>
	        <td>자본총계</td>
	        <td id="totalEquity2018"></td>
	        <td id="totalEquity2019"></td>
	        <td id="totalEquity2020"></td>
        </tr>
        </tbody>
  	</table>
  	<br><br><br><br>
     
    <div style="position: relative; margin: auto; height:20vh; width:40vw">
    <canvas id="myChart2"></canvas>
  	</div>
  	<br><br><br><br><br><br><br><br><br><br><br>
  	<table class="list" style="display:none;">
  	<tbody>
        <tr>
        	<td></td>
            <td>2018.12</td>
            <td>2019.12</td>
            <td>2020.12</td>
        </tr>
        <tr >
        	<td>매출액</td>
        	<td id="revenue2018"></td>
        	<td id="revenue2019"></td>
        	<td id="revenue2020"></td>
        </tr>
        <tr>
			<td>영업이익</td>
			<td id="profit2018"></td>
			<td id="profit2019"></td>
			<td id="profit2020"></td>
        </tr>
        <tr>
	        <td>당기순이익</td>
	        <td id="net2018"></td>
	        <td id="net2019"></td>
	        <td id="net2020"></td>
        </tr>
        </tbody>
  	</table>
</body>
</html>