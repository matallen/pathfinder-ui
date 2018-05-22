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
	<!--
	-->
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
				<li><span id="breadcrumb2">Report</span></li>
			</ul>
		</div>
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<script>
				var customerId=Utils.getParameterByName("customerId");
				
				$(document).ready(function() {
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
						document.getElementById("breadcrumb1").innerHTML="<a href='results.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";

					});
					
				});
				</script>
				
				
				<div class="row">
					<div class="col-sm-4">
						apps list in draggable checkboxed list
						
						<h2>Applications</h2>

						<script>
							$(document).ready(function() {
							    $('#example').DataTable( {
							        "ajax": {
							            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentSummary",
							            "dataSrc": "",
							            "dataType": "json"
							        },
							        "scrollCollapse": true,
							        "paging":         false,
							        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" : 10, // default page entries
							        "searching" : false,
							        //"order" : [[1,"desc"],[2,"desc"],[0,"asc"]],  //reviewed, assessed then app name
							        "columns": [
							            { "data": "Id" },
							            { "data": "Name" },
							            { "data": "BusinessPriority" },
							            { "data": "Decision" },
							            { "data": "WorkEffort" },
							        ]
							        ,"columnDefs": [
							        		{ "targets": 0, "orderable": true, "render": function (data,type,row){
							              return "<input type='checkbox' value='"+row['Id']+"'/>";
													}},
													{ "targets": 3, "orderable": true, "render": function (data,type,row){
							                  var randomThing = JSON.parse(row['Decision']);
													if (randomThing==null) {
														return "";													
													} else {
							              return randomThing.rank;
							              }
													}},
													{ "targets": 4, "orderable": true, "render": function (data,type,row){
							                  var randomThing = JSON.parse(row['WorkEffort']);
													if (randomThing==null) {
														return "";													
													} else {
							              return randomThing.rank;
							              }
//							              return row['WorkEffort']==null?"":row['WorkEffort'];
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
			                <th align="left"></th>
			                <th align="left">Application</th>
			                <th align="left">Business Priority</th>
			                <th align="left">Decision</th>
			                <th align="left">Effort</th>
				            </tr>
					        </thead>
						    </table>
						  </div>
				  	</div>
						
<!--
<table>
    <tbody>
        <tr id="1">
            <td><input onclick="alert('where is it!?');" type="checkbox" name="1"/></td>
            <td>Application 1</td>
        </tr>
        <tr id="2">
            <td><input type="checkbox"/></td>
            <td>Application 2</td>
        </tr>
        <tr id="3">
            <td><input type="checkbox"/></td>
            <td>Application 3</td>
        </tr>
        <tr id="4">
            <td><input type="checkbox"/></td>
            <td>Application 4</td>
        </tr>
    </tbody>
</table>
-->
<script>
$(document).ready(function(){
    $("table tbody").sortable({
         items: 'tr',
        stop : function(event, ui){
          //alert($(this).sortable('toArray'));
        }
    });
  //$("table tbody").disableSelection();
});//ready
</script>
						<!--
						-->
					  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
					  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
				<div class="row">						

						</div>
<div id="mynetwork"></div>							
					</div>
					<div class="col-sm-8">
						bubble chart
						x=importance
						y=effort
						z=judgement
						color=action
						transparency=certainty
						
						
						<div class="chartjs-wrapper">
							<canvas id="chartjs-6" class="chartjs" width="undefined" height="undefined"></canvas>
							<script>
								new Chart(document.getElementById("chartjs-6"),{
									"type":"bubble",
									"data":{
										"datasets":[{
											"label":[
												"App1"
												,"App2"
												,"App3"
												],
											"data":[
												{"x":20,"y":30,"r":15}
												,{"x":40,"y":10,"r":10}
												,{"x":32,"y":17,"r":35}
											],
											"backgroundColor":[
												"rgb(126, 210, 132)"
												,"rgb(255, 34, 132)"
												,"rgb(12, 99, 12)"
											]
										}]
									}
									//,options: options
								});
							</script>
						</div>
   					<div id="eventSpan"></div>
					</div>

				</div>

				
				<div class="row">

					<div class="col-sm-12">

					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">

				</div>
				</div>
								
				<div class="highlights">
				</div>
			</div>
		</section>


		
	</body>
	// Dependency chart stuff
<script type="text/javascript" src="assets/js/vis.js"></script>
<script type="text/javascript" src="assets/js/dependencyMap.js"></script>		

</html>



