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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>	
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
				var appId=Utils.getParameterByName("app");
				var assessmentId=Utils.getParameterByName("assessment");

				var appsCount=assessed=unassessed=notReviewed=reviewed=0;
				
				$(document).ready(function() {
					var done=false;
					var applicationFullName = "";
					httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/"+appId, function(applicationName){
						document.getElementById("breadcrumb2").innerHTML=applicationName.Name;
					  //console.log("app.count="+progress.Appcount+", assessed="+progress.Assessed+", reviewed="+progress.Reviewed);
					});
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
						document.getElementById("breadcrumb1").innerHTML="<a href='results.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";

					});
					console.log(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentProgress");
					// ### Populate the progress bar
					httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentProgress", function(progress){
					  //console.log("app.count="+progress.Appcount+", assessed="+progress.Assessed+", reviewed="+progress.Reviewed);
					});

					
					httpGetObject("api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/chart", function(application){
						console.log(application);
					});

					
				});
				
				</script>
				
				<div class="row">
					<div class="col-sm-4">
						<div class="bubbleChart"/></div>
					
Pie Chart
<script>
$(document).ready(function() {
var xhr = new XMLHttpRequest();
xhr.open("GET", "api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/chart", true);
xhr.send();
xhr.onloadend = function () {
var data=JSON.parse(xhr.responseText);

var ctx = document.getElementById("pieChart").getContext("2d");
var myDoughnutChart = new Chart(ctx, {
type: 'doughnut',
data: data,
    options: {
        legend: {
            display: false,
            }
        }
});
}
});
</script> 
<canvas id="pieChart"></canvas>

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



