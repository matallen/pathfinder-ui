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
				<h1><span id="customerName"></span> Assessment Summary</h1>
				<p>View the results of an assessment and review output.</div>
		</section>
		
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="#">Assessments</a></li>
			</ul>
		</div>
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<!-- ### Pie Chart Dependencies-->
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript" src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
        
				<script>
				var customerId=Utils.getParameterByName("customerId");
				var processedApps=assessed=unassessed=notReviewed=reviewed=0;
				
				$(document).ready(function() {
					var done=false;
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
					});
					
					// ### Get Application & Results
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applications/", function(applications){
						
						for (i=0;i<applications.length;i++){
							// ### Get Application Assessments
							httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applications/"+applications[i].Id+"/assessments/", function(assessments){
								assessed+=assessments.length>0;
								unassessed+=assessments.length==0;
								processedApps+=1;
								done=applications.length==processedApps;
							});
							
							if (applications[i].Review==null){
								notReviewed+=1;
							}else{
								reviewed+=1;
							}
							
						};
						
						setTimeout(loadProgress, 500);
						
					});					
					
					function loadProgress(){
					  //console.log("Assessed progress="+assessed+"/"+processedApps+" (Done? = "+done+")");
					  if (done>0){
					  	
					    processedApps=processedApps.toString();
					    assessed=assessed.toString();
					    reviewed=reviewed.toString();
					  	console.log("processedApps="+processedApps+", assessed="+assessed+", reviewed="+reviewed);
					    
						  $('#jqmeter-assessed').jQMeter({goal:processedApps,raised:assessed,width:'290px',height:'40px',bgColor:'#dadada',barColor:'#9b9793',animationSpeed:100,displayTotal:true});
						  $('#jqmeter-reviewed').jQMeter({goal:processedApps,raised:reviewed,width:'290px',height:'40px',bgColor:'#dadada',barColor:'#9b9793',animationSpeed:100,displayTotal:true});
					  }else{
					  	setTimeout(loadProgress, 500);
					  }
					}
					
					//function loadAssessmentChart(){
					//  console.log("Apps Processed="+processedApps +" (Done? = "+done+")");
					//  if (done>0){
					//		// ### Pie Chart
					//		google.charts.load('current', {'packages':['corechart']});
					//		google.charts.setOnLoadCallback(drawChart);
					//		function drawChart() {
					//		  var data = google.visualization.arrayToDataTable([
					//		    ['Task', 'Hours per Day'],
					//		    ['Assessed',     assessed],
					//		    ['Not Assessed', unassessed]
					//		  ]);
					//		  var options = {
					//		    backgroundColor: 'transparent',
					//		    title: 'Assessment Status',
					//		    pieHole: 0.2,
					//		    is3D: true,
					//		  };
					//		  var chart = new google.visualization.PieChart(document.getElementById('piechartAss'));
					//		  chart.draw(data, options);
					//		}
					//	}else{
					//		setTimeout(loadAssessmentChart, 500);
					//	}
					//}
					
					});
				
				</script>
				
				<div class="row">
					<div class="col-sm-4">
						
						<!-- ### Progress -->
						
						<script src="assets/js/jqmeter.min.js"></script>
						Assessed:
						<div id="jqmeter-assessed"></div>
						Reviewed:
						<div id="jqmeter-reviewed"></div>
						<style>
						.therm{height:30px;border-radius:5px;}
						.outer-therm{margin:20px 0;}
						.inner-therm span {color: #fff;display: inline-block;float: right;font-family: Overpass;font-size: 14px;font-weight: bold;}
						.vertical.inner-therm span{width:100%;text-align:center;}
						.vertical.outer-therm{position:relative;}
						.vertical.inner-therm{position:absolute;bottom:0;}
						</style>
						
						
						
						<!-- ### Pie Chart Canvas -->
						<div id="piechartAss" style="width: 500px; height: 500px; float: left;"></div>
					</div>
					<div class="col-sm-8">
						<!-- #### DATATABLE ### -->
						<script>
							function deleteItem(id){
							  delete(Utils.SERVER+"/api/pathfinder/notimplemented/"+id);
							}
							$(document).ready(function() {
							    $('#example').DataTable( {
							        "ajax": {
							            //"url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/",
							            "url": 'http://localhost:8083/pathfinder-ui/api/pathfinder/customers/'+customerId+"/assessmentSummary",
							            "dataSrc": "",
							            "dataType": "json"
							        },
							        "scrollCollapse": true,
							        "paging":         false,
							        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" : 10, // default page entries
							        "searching" : false,
							        "order" : [[2,"desc"],[1,"desc"],[0,"asc"]],  //reviewed, assessed then app name
							        "columns": [
							            { "data": "applicationName" },
							            { "data": "assessed" },
							            { "data": "reviewed" },
							            { "data": "priority" },
							            { "data": "decision" },
							            { "data": "effort" },
							            { "data": "reviewDate" },
							            { "data": "lastAssessmentId" }
							        ]
							        ,"columnDefs": [
							        		{ "targets": 1, "orderable": true, "render": function (data,type,row){
							              return "<span class='"+(row["assessed"]==="Yes"?"messageGreen'>Yes":"messageRed'><a href='"+Utils.SERVER+"'>No</a>")+"</span>";
													}},
													{ "targets": 2, "orderable": true, "render": function (data,type,row){
							              return "<span class='"+(row["reviewed"]==="Yes"?"'>Yes":"'>No")+"</span>";
													}},
							            { "targets": 7, "orderable": true, "render": function (data,type,row){
							              return "<a href='viewAssessment.php?app="+row['applicationId']+"&assessment="+row['lastAssessmentId']+"&customer="+customerId+"'><img src='images/details.png'/></a>";
													}}
							          // { "targets": 0, "orderable": true, "render": function (data,type,row){
							          //    return "<a href='#' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>"+row["CustomerName"]+"</a>";
												//	}}
							          // ,{ "targets": 2, "orderable": false, "render": function (data,type,row){
												//		return "<a href='results.jsp?customerId="+row["CustomerId"]+"'>View Results</a>";
												//	}}
							          // ,{ "targets": 3, "orderable": false, "render": function (data,type,row){
												//		return "<a href='manageCustomerApplications.jsp?customerId="+row["CustomerId"]+"'>Manage Applications</a>";
												//	}}
								        // ,{ "targets": 4, "orderable": false, "render": function (data,type,row){
												//		return "<div class='btn btn-image' title='Edit' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Wrench-32.png)'></div>";
												//	}}
								        // ,{ "targets": 5, "orderable": false, "render": function (data,type,row){
												//		return "<div class='btn btn-image' title='Delete' onclick='deleteItem(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Trash_Can-32.png)'></div>";
												//	}}
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
						                <th align="left">Application</th>
						                <th align="left">Assessed</th>
						                <th align="left">Review</th>
						                <th align="left">Business Priority</th>
						                <th align="left">Decision</th>
						                <th align="left">Effort</th>
						                <th align="left">Review Date</th>
						                <th align="left"></th>
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



