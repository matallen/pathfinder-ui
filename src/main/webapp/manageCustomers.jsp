<!DOCTYPE HTML>
<html>
  <%@include file="head.jsp"%>
  <!--
  <link rel="import" href="head.jsp">
  <link rel="import" href="nav.jsp">
  -->
	
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
				<h1>Pathfinder Admin</h1>
				<p>Create customers and applications.</div>
		</section>
			
		<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
			</ul>
		</div>
		
		
		<!-- #### DATATABLES ### -->
		<script>

			function deleteItem(id){
			  delete(Utils.SERVER+"/api/pathfinder/customers/"+id);
			}
			// mat - move this to the edit form script, this is not datatable code
			function load(id){
			  document.getElementById("edit-ok").innerHTML="Update";
			  document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("New", "Update");
			  var xhr = new XMLHttpRequest();
			  var ctx = "${pageContext.request.contextPath}";
			  xhr.open("GET", getLoadUrl(id), true);
			  //xhr.open("GET", Utils.SERVER+"/api/pathfinder/customers/"+id+"/", true);
			  xhr.send();
			  xhr.onloadend = function () {
			    var json=JSON.parse(xhr.responseText);
			    var form=document.getElementById("form");
			    for (var i = 0, ii = form.length; i < ii; ++i) {
			      if (typeof json[form[i].name] == "undefined"){
			        form[i].value="";
			      }else{
			        form[i].value=json[form[i].name];
			      }
			    }
			  }
			}
			$(document).ready(function() {
			    $('#example').DataTable( {
			        "ajax": {
			            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/',
			            "url": Utils.SERVER+'/api/pathfinder/customers/',
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
			            { "data": "CustomerId" },
				        ]
			        ,"columnDefs": [
			           { "targets": 0, "orderable": true, "render": function (data,type,row){
			              return "<a href='#' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>"+row["CustomerName"]+"</a>";
									}}
			           ,{ "targets": 2, "orderable": false, "render": function (data,type,row){
										return "<a href='results.jsp?customerId="+row["CustomerId"]+"'>View Results</a>";
									}}
			           ,{ "targets": 3, "orderable": false, "render": function (data,type,row){
										return "<a href='manageCustomerApplications.jsp?customerId="+row["CustomerId"]+"'>Manage Applications</a>";
									}}
				         ,{ "targets": 4, "orderable": false, "render": function (data,type,row){
										return "<div class='btn btn-image' title='Edit' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Wrench-32.png); background-repeat: no-repeat'></div>";
									}}
				         ,{ "targets": 5, "orderable": false, "render": function (data,type,row){
										return "<div class='btn btn-image' title='Delete' onclick='deleteItem(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Trash_Can-32.png);  background-repeat: no-repeat'></div>";
									}}
			        ]
			    } );
			} );
		</script>
  	<div id="wrapper">
	    <div id="buttonbar">
	        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"   class="btn btn-primary" name="New"    onclick="reset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
	        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"   class="btn btn-primary" name="New"    onclick="reset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new" disabled>Export</button>
	    </div>
	    <div id="tableDiv">
		    <table id="example" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		                <th align="left">Customer Name</th>
		                <th align="left">Customer Details</th>
		                <th align="left"></th>
		                <th align="left"></th>
		                <th align="left">Edit</th>
		                <th align="left">Delete</th>

		            </tr>
		        </thead>
		    </table>
		  </div>
  	</div>
    



<!--#################-->
<!-- EDIT MODAL FORM -->
<!--#################-->

<script>
	function getLoadUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/"+id+"/";
	}
	function getSaveUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/";
	}
	function getIdFieldName(){
		return "CustomerId";
	}
</script>



<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document"> <!-- make wider by adding " modal-lg" to class -->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">New Customer</h4>
      </div>
      <div class="modal-body">
        <form id="form">
          <div id="form-id" class="form-group">
            <label for="CustomerName" class="control-label">Customer Name:</label>
            <input id="CustomerName" name="CustomerName" type="text" class="form-control"/>
          </div>
          <div class="form-group">
            <label for="CustomerDescription" class="control-label">Customer Description:</label>
            <input id="CustomerDescription" name="CustomerDescription" type="text" class="form-control">
          </div>
          <div class="form-group">
            <label for="CustomerVertical" class="control-label">Customer Vertical:</label>
            <select name="CustomerVertical" id="CustomerVertical" class="form-control">
							<option value="Agriculture">Agriculture</option>
							<option value="Business Services">Business Services</option>
							<option value="Construction & Real Estate">Construction & Real Estate</option>
							<option value="Education">Education</option>
							<option value="Energy, Raw Materials & Utilities">Energy, Raw Materials & Utilities</option>
							<option value="Finance">Finance</option>
							<option value="Government">Government</option>
							<option value="Healthcare">Healthcare</option>
							<option value="IT">IT</option>
							<option value="Leisure & Hospitality">Leisure & Hospitality</option>
							<option value="Libraries">Libraries</option>
							<option value="Manufacturing">Manufacturing</option>
							<option value="Media & Internet">Media & Internet</option>
							<option value="Non-Profit & Professional Orgs.">Non-Profit & Professional Orgs.</option>
							<option value="Retail">Retail</option>
							<option value="Software">Software</option>
							<option value="Telecommunications">Telecommunications</option>
							<option value="Transportation">Transportation</option>
						</select>
          </div>
          <div class="form-group">
            <label for="CustomerAssessor" class="control-label">Customer Assessor:</label>
            <input id="CustomerAssessor" name="CustomerAssessor" type="text" class="form-control">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button id="edit-ok" type="button" data-dismiss="modal" onclick="save('form'); return false;">Create</button>
      </div>
    </div>
  </div>
</div>

	</body>
</html>