<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
  
  <link href="assets/css/main.css" rel="stylesheet" />
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
	
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.css" rel="stylesheet">
  <link href="assets/css/bootstrap-3.3.7.min.css" rel="stylesheet" />
	<link href="assets/css/datatables-addendum.css" rel="stylesheet" />
	<!--
  <script src="assets/js/jquery-3.3.1.min.js"></script>
	-->
  <script src="assets/js/bootstrap-3.3.7.min.js"></script>
  <script src="assets/js/jquery.dataTables-1.10.16.js"></script>
  <script src="datatables-functions.js"></script>
	<script src="datatables-plugins.js"></script>
	
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1>Assessment View for <span id="customerName"></span></h1>
				<!--
				<p>View the results of an assessment and review output.</p>
				-->
			</div>
		</section>
		
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
				<li><span id="breadcrumb1"></span></li>
				<li><span id="breadcrumb2"></span></li>
			</ul>
		</div>
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<script>
				var customerId=Utils.getParameterByName("customer");
				var appsCount=assessed=unassessed=notReviewed=reviewed=0;
				
				$(document).ready(function() {
					var done=false;
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
						document.getElementById("breadcrumb1").innerHTML="<a href='results.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";
						document.getElementById("breadcrumb2").innerHTML="Name App Assessment Here";
					});
					
					// ### Populate the progress bar
					httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentProgress", function(progress){
					  //console.log("app.count="+progress.Appcount+", assessed="+progress.Assessed+", reviewed="+progress.Reviewed);
					});
					
					
				});
				
				</script>
				<script src="http://www.chartjs.org/dist/2.7.2/Chart.bundle.js"></script>
				<script>
					$(document).ready(function() {
					  var xhr = new XMLHttpRequest();
					  xhr.open("GET", ctx+uri, true);
					  xhr.send();
					  xhr.onloadend = function () {
					    var data=JSON.parse(xhr.responseText);
					    var ctx = document.getElementById("chartjs-4").getContext("2d");
					    var myDoughnutChart = new Chart(ctx, {
							    type: 'doughnut',
							    data: data,
							    options: pieOptions
							});
					  }
					});
				</script>
				<div class="chartjs-wrapper">
					<canvas id="chartjs-4" class="chartjs" width="undefined" height="undefined"></canvas>
				</div>
				
				
				<div class="row">
					<div class="col-sm-4">
						<div class="bubbleChart"/></div>
						<script type="text/javascript" >
							$(document).ready(function () {
							  var bubbleChart = new d3.svg.BubbleChart({
							    supportResponsive: true,
							    size: 600,
							    innerRadius: 600 / 3.5,
							    radiusMin: 50,
							    data: {
							      items: [
							        <?php echo $bubbleData;  ?>
							      ],
							      eval: function (item) {return item.count;},
							      classed: function (item) {return item.text.split(" ").join("");}
							    },
							    plugins: [
							      {
							        name: "lines",
							        options: {
							          format: [
							            {// Line #0
							              textField: "count",
							              classed: {count: true},
							              style: {
							                "font-size": "28px",
							                "font-family": "Source Sans Pro, sans-serif",
							                "text-anchor": "middle",
							                fill: "white"
							              },
							              attr: {
							                dy: "0px",
							                x: function (d) {return d.cx;},
							                y: function (d) {return d.cy;}
							              }
							            },
							            {// Line #1
							              textField: "text",
							              classed: {text: true},
							              style: {
							                "font-size": "14px",
							                "font-family": "Source Sans Pro, sans-serif",
							                "text-anchor": "middle",
							                fill: "white"
							              },
							              attr: {
							                dy: "20px",
							                x: function (d) {return d.cx;},
							                y: function (d) {return d.cy;}
							              }
							            }
							          ],
							          centralFormat: [
							            {// Line #0
							              style: {"font-size": "50px"},
							              attr: {}
							            },
							            {// Line #1
							              style: {"font-size": "30px"},
							              attr: {dy: "40px"},
							            }
							          ]
							        }
							      }]
							  });
							});
						</script>  
						
						<script src="http://phuonghuynh.github.io/js/bower_components/d3/d3.min.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/d3-transform/src/d3-transform.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/cafej/src/extarray.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/cafej/src/misc.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/cafej/src/micro-observer.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/microplugin/src/microplugin.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/bubble-chart/src/bubble-chart.js"></script>
						<script src="assets/js/central-click.js"></script>
						<script src="http://phuonghuynh.github.io/js/bower_components/bubble-chart/src/plugins/lines/lines.js"></script>

					</div>
					<div class="col-sm-8">
						<!-- ### DATATABLE GOES HERE -->
					</div>
				</div>
				
				
				
				<div class="highlights">
				</div>
			</div>
		</section>
		
	</body>
</html>



