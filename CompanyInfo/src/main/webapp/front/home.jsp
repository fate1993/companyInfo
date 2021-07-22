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
<!-- chart -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.4.0/chart.min.js"></script>
<script src="https://code.jscharting.com/latest/jscharting.js"></script>
<script type="text/javascript" src="https://code.jscharting.com/latest/modules/types.js"></script>

<!-- jquery -->
	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		
	<nav>
		<ul>
			<li><a href="home.jsp">홈</a></li>
			<li><a href="intro.jsp">소개</a></li>
			<li><a href="howtouse.jsp">사용법</a></li>
			<li><a href="list.jsp">기업목록</a></li>
		</ul>
	</nav>
	<div id="logo" >
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
	
	var corp_code = "";
	var myXML;
	var key = "05b445d8c91586ba7a5a77367a090d27b9780ab5";
		$(function() {
			$("#searchBar").autocomplete({
	            source : function( request, response ) {
	                 $.ajax({
	                        type: 'get',
	                        url: "/CORPCODE.xml",
	                        dataType: "xml",
	                        success: function(data) {
	                            //서버에서 json 데이터 response 후 목록에 추가
	                            response(
	                                $.map(data, function(item) {    //json[i] 번째 에 있는게 item 임.
	                                    return {
	                                        label: item.corp_name,    //UI 에서 보여지는 글자, 실제 검색어랑 비교 대상
	                                        value: item.corp_name,    //그냥 사용자 설정값?
	                                        test : item+"test"    //이런식으로 사용

	                                        //[
	                     //    {"name": "하늘이", "dogType": "푸들", "age": 1, "weight": 2.14},
	                         //    {"name": "콩이", "dogType": "푸들", "age": 3, "weight": 2.5},
	                         //    {"name": "람이", "dogType": "허스키", "age": 7, "weight": 3.1}
	                         //]
	                                        // json이 다음 처럼 넘어오면
	                                        // 상황 : name으로 찾고 dogType을 넘겨야 하는 상황이면 
	                                        // label : item.dogType ,    //오토컴플릿이 되고 싶은 단어 
	                                        // value : item.family ,    //넘겨야 하는 단어
	                                        // age : item.age ,
	                                        // weight : item.weight
	                                    }
	                                })
	                            );
	                        }
	                   });
	                },    // source 는 자동 완성 대상
	            select : function(event, ui) {    //아이템 선택시
	                console.log(ui);//사용자가 오토컴플릿이 만들어준 목록에서 선택을 하면 반환되는 객체
	                console.log(ui.item.label);    //김치 볶음밥label
	                console.log(ui.item.value);    //김치 볶음밥
	                console.log(ui.item.test);    //김치 볶음밥test
	                
	            },
	            focus : function(event, ui) {    //포커스 가면
	                return false;//한글 에러 잡기용도로 사용됨
	            },
	            minLength: 1,// 최소 글자수
	            autoFocus: true, //첫번째 항목 자동 포커스 기본값 false
	            classes: {    //잘 모르겠음
	                "ui-autocomplete": "highlight"
	            },
	            delay: 500,    //검색창에 글자 써지고 나서 autocomplete 창 뜰 때 까지 딜레이 시간(ms)
//	            disabled: true, //자동완성 기능 끄기
	            position: { my : "right top", at: "right bottom" },    //잘 모르겠음
	            close : function(event){    //자동완성창 닫아질때 호출
	                console.log(event);
	            }
	        });
			//
			$("#search").click(function() {
				$("p").empty();
				var Value = $("#searchBar").val()
				
				$.ajax({
					url: "./CORPCODE.xml",						
					type: "get",
					success: function(xml) {
						myXML = $(xml).find("list").filter(function() {
			                return $(this).find('corp_name').text() == Value;
			            });
						console.log(myXML);
						corp_code = myXML[0].childNodes[1].innerHTML;
						console.log(corp_code);
							
						// 기업개황
						$.ajax({
							method : "GET",
							url : "https://opendart.fss.or.kr/api/company.json",
							data : {
								crtfc_key : key,
								corp_code : corp_code
									//$("#searchBar").val()
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
								crtfc_key : key,
								corp_code : corp_code,
								bsns_year : "2020", // 연도 자동 최신화 필요
								// if문으로 2020 자료 없을시 2019로 대체 jsp니까 자바 사용 %% 가능할듯
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
								crtfc_key : key,
								corp_code : corp_code,
								bsns_year : "2021",
								reprt_code : "11013"
							}
						}).done(function(msg) {
							console.log(msg);
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
								crtfc_key : key,
								corp_code : corp_code,
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
					},
					error: function(xhr, textStatus, errorThrown) {
						$("div").html("<div>" + textStatus + " (HTTP-" + xhr.status + " / " + errorThrown + ")</div>" );
					}
				
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
	
</body>
</html>