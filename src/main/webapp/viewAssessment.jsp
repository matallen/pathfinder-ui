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
				<h1>Assessment Details for <span id="customerName"/></h1>
				<p>View the results of an assessment and review output.</p>
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

				$(document).ready(function() {
					httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/"+appId, function(application){
						document.getElementById("breadcrumb2").innerHTML=application.Name;
						//document.getElementById("applicationName").innerHTML=application.Name;
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

				});
				
				</script>
				
				
				<div class="row">
					<div class="col-sm-4">
						<!-- ### CHART GOES HERE -->
						
						Assessment Status
						<script>
							$(document).ready(function() {
								var canvas = document.getElementById("pieChart");
								var xhr = new XMLHttpRequest();
								xhr.open("GET", "api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/chart2", true);
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
							            		}}
									});
									
									// OnClick driving the table of data
									canvas.onclick=function(evt) {
							      var activePoints=myDoughnutChart.getElementsAtEvent(evt);
							      if (activePoints[0]) {
							        var chartData=activePoints[0]['_chart'].config.data;
							        var idx=activePoints[0]['_index'];
											
							        var label=chartData.labels[idx];
							        var value=chartData.datasets[0].data[idx];
											
							        var table=$('#example').DataTable();
							        table.columns(2).search(label).draw();
							      }
							    };
							    
								}
							});
					    function resetResults(){
					    	var table=$('#example').DataTable();
					      table.columns(2).search("").draw();
					    }
						</script>
						<div>
							<center>
								<div style="position:relative;left:4px;top:294px;width:200px;">
									<a href="#">
										<img onclick="resetResults(); return false;" style="width:100px;" alt="Reset" src="images/reboot.jpg"/>
									</a>
								</div>
								<canvas id="pieChart"></canvas>
							</center>
						</div>
						
						<style>
						#example_filter label{
							display:none; //hide the search box on datatables, but search has to be enabled so the chart can filter the data 
						}
						</style>
					
					</div>
					<div class="col-sm-8">
						
						<!-- ### DATATABLE GOES HERE -->
						<script>
							function deleteItem(id){
							  delete(Utils.SERVER+"/api/pathfinder/notimplemented/"+id);
							}
							var colorCfg=new Object();
							colorCfg["UNKNOWN"]="#808080";
							colorCfg["RED"]="#FF0000";
							colorCfg["AMBER"]="#FCC200";
							colorCfg["GREEN"]="#006400";
							
							$(document).ready(function() {
							    $('#example').DataTable( {
							        "ajax": {
							            //"url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary",
							            "url": '<%=request.getContextPath()%>/api/pathfinder/customers/'+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary",
							            "dataSrc": "",
							            "dataType": "json"
							        },
							        "scrollCollapse": true,
							        "paging":         false,
							        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" : 10, // default page entries
							        "searching" : true,
							        //"order" : [[1,"desc"],[2,"desc"],[0,"asc"]],
							        "columns": [
							            { "data": "question" },
							            { "data": "answer" },
							            { "data": "rating" },
							        ]
							        ,"columnDefs": [
							        		{ "targets": 2, "orderable": true, "render": function (data,type,row){
							        		  return "<span style='color:"+colorCfg[row["rating"]]+"'>"+row['rating']+"</span>";
													}}
							        ]
							    } );
							} );
						</script>
				  	<div id="wrapper">
					    <div id="buttonbar">
					    </div>
					    <div id="tableDiv">
						    <table id="example" class="display" cellspacing="0" width="100%">
					        <thead>
				            <tr>
			                <th align="left">Question</th>
			                <th align="left">Answer</th>
			                <th align="left">Rating</th>
				            </tr>
					        </thead>
						    </table>
						  </div>
				  	</div>
				  	
					</div>
				</div>
				
				<div class="highlights">
				</div>
			</div>
		</section>
		
	</body>
</html>



