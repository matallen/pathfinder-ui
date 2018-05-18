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
	
	<!-- for pie/line/bubble graphing -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
		
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1>Report for <span id="customerName"></span></h1>
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
				
				$(document).ready(function() {
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
						//document.getElementById("breadcrumb1").innerHTML="<a href='results.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";

					});
					
				});
				</script>
				
				
				<div class="row">
					<div class="col-sm-4">
					

					</div>
					<div class="col-sm-8">
						
				  	
					</div>
				</div>
				
				<div class="highlights">
				</div>
			</div>
		</section>


		
	</body>
</html>



