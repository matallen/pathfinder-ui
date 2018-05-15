<!DOCTYPE HTML>
<!--
	Industrious by TEMPLATED
	templated.co @templatedco
	Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>
	<head>
		<title>Pathfinder</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<link rel="stylesheet" href="assets/css/main.css" />
    <!--
    <link rel="stylesheet" type="text/css" href="assets/css/overpass.css"/>
		<script src="assets/js/jquery.min-1.3.1.js"></script>
		<script src="assets/js/jquery-3.3.1.min.js"></script>
    -->
	</head>
	<body class="is-preload">

		<!-- Header -->
		<header id="header">
			<a class="logo" href="index.php">Pathfinder</a>
			<nav>
				<a href="#menu">Menu</a>
			</nav>
		</header>

		<!-- Nav -->
		<nav id="menu">
			<ul class="links">
				<li><a href="index.php">Home</a></liadmin>
				<li><a href="http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com/" target=_blank>Assessment</a></li>
				<li><a href="results.php">Results</a></li>
				<li><a href="admin.php">Admin</a></li>
				<li><a href="workflow.php">Workflow</a></li>
				<li><a href="credits.php">Credits</a></li>
			</ul>
		</nav>
			

		<!-- Banner -->
		<section id="banner2">
			<div class="inner">
				<h1>Pathfinder Admin</h1>
				<p>Create customers and applications.</div>
		</section>

		<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Admin</a></li>
			</ul>
		</div>

		<!-- Highlights -->
			<section class="wrapper">
				<div class="inner">
					<div class="highlights">



					</div>
					
					<!-- ####################### -->
					<!-- data-table goes here!!! -->
					<!-- ####################### -->
					
					<!--
					<script src="assets/js/jquery.min-1.3.1.js"></script>
					<link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.css" rel="stylesheet">
					<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" >
					<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
					<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.js"></script>
					<script src="assets/js/jquery-3.3.1.min.js"></script>
					-->
					
					<link href="assets/css/jquery.dataTables.min.css" rel="stylesheet">
					<link href="assets/css/bootstrap.min-3.3.7.css" rel="stylesheet" >
					<link href="assets/css/breadcrumbs.css" rel="stylesheet" >
					
					<script src="assets/js/jquery-1.11.3.min.js"></script>
					<script src="assets/js/jquery.dataTables-1.10.16.js"></script>
					<script src="assets/js/bootstrap.min-3.3.7.js"></script>
					
					<script src="datatables-plugins.js"></script>
					<script src="datatables-functions.js"></script>
					
					<script>
						var SERVER="http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com";
						function deleteItem(id){
						  delete(SERVER+"/api/pathfinder/customers/"+id);
						}
						$(document).ready(function() {
						    $('#example').DataTable( {
						        "ajax": {
						            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/',
						            "url": SERVER+'/api/pathfinder/customers/',
						            "dataSrc": "",
						            "dataType": "json"
						        },
						        "scrollCollapse": true,
						        "paging":         false,
						        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
						        "pageLength" : 10, // default page entries
						        "columns": [
						            { "data": "CustomerName" },
						            { "data": "CustomerDescription" },
						            { "data": "CustomerId" },
						            { "data": "CustomerId" },
						            { "data": "CustomerId" },
						        ]
						        ,"columnDefs": [
						           { "targets": 0, "orderable": true, "render": function (data,type,row){
						              return "<a href='#' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>"+row["CustomerName"]+"</a>";
												}}
						           ,{ "targets": 2, "orderable": false, "render": function (data,type,row){
													return "<a href='manageCustomerApplications.jsp?customerId="+row["CustomerId"]+"'>Manage Applications</a>";
												}}
							         ,{ "targets": 3, "orderable": false, "render": function (data,type,row){
													return "<div class='btn btn-image' title='Edit' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Wrench-32.png)'></div>";
												}}
							         ,{ "targets": 4, "orderable": false, "render": function (data,type,row){
													return "<div class='btn btn-image' title='Delete' onclick='deleteItem(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Trash_Can-32.png)'></div>";
												}}
						        ]
						    } );
						} );
					
					</script>

					<div id="wrapper">
				    <div id="buttonbar">
				        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"   class="btn btn-primary" name="new"    onclick="reset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
				        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"   class="btn btn-primary" name="export" onclick="reset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new" disabled>Export</button>
				    </div>
				    <div id="tableDiv">
					    <table id="example" class="display" cellspacing="0" width="100%">
					        <thead>
					            <tr>
					                <th align="left">Customer Name</th>
					                <th align="left">Customer Details</th>
					                <th align="left"></th>
					                <th align="left"></th>
					                <th align="left"></th>
					            </tr>
					        </thead>
					    </table>
					  </div>
		    	</div>
					
		    <!-- ####################### -->
		    <!--  data-table ends here   -->
		    <!-- ####################### -->


				</div>
			</section>


			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>
			<!--
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
			-->

<script>
$(document).ready(function(){
	
	$('#message').fadeIn('slow', function(){
               $('#message').delay(5000).fadeOut(); 
            });
            
    $("button").click(function(){
        $("#aaa").toggle();
    });
});
</script>
  <script>
//  $( function() {
//    $( "#dialog-confirm" ).dialog({
//      resizable: false,
//      height: "auto",
//      width: 400,
//      modal: true,
//      buttons: {
//        "Delete all items": function() {
//          $( this ).dialog( "close" );
//        },
//        Cancel: function() {
//          $( this ).dialog( "close" );
//        }
//      }
//    });
//  } );
  </script>

	</body>
</html>