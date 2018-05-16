<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
  <!--
  <link rel="import" href="head.jsp">
  <link rel="import" href="nav.jsp">
  -->
  
	
	<link href="assets/css/main.css" rel="stylesheet" />
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
  
  <!-- #### DATATABLES ### -->
  <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.css" rel="stylesheet">
  <link href="assets/css/bootstrap-3.3.7.min.css" rel="stylesheet" />
	<link href="assets/css/datatables-addendum.css" rel="stylesheet" />
  <script src="assets/js/jquery-3.3.1.min.js"></script>
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
				<li><span id="breadcrumb"></span> Applications</li>
			</ul>
		</div>
  	
  	<!-- #### DATATABLES ### -->
		<script>
			function deleteItem(id){
			  httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+id);
			}
			function getParameterByName(name, url) {
		    if (!url) url = window.location.href;
		    name = name.replace(/[\[\]]/g, "\\$&");
		    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
		        results = regex.exec(url);
		    if (!results) return null;
		    if (!results[2]) return '';
		    return decodeURIComponent(results[2].replace(/\+/g, " "));
			}
			$(document).ready(function() {
					// ### Populate the breadcrumb customer names
				  var xhr = new XMLHttpRequest();
				  var url=Utils.SERVER+"/api/pathfinder/customers/"+getParameterByName("customerId");
				  xhr.open("GET", url, true);
			    xhr.send();
					xhr.onloadend = function () {
					  var customer=JSON.parse(xhr.responseText);
				    document.getElementById("breadcrumb").innerHTML=customer.CustomerName;
				  };
					// ### populate the customer applications in the datatable
			    $('#example').DataTable( {
			        "ajax": {
			            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/"+request.getParameter("customerId")+"/applications/',
			            "url": Utils.SERVER+'/api/pathfinder/customers/'+getParameterByName("customerId")+'/applications/',
			            "dataSrc": "",
			            "dataType": "json"
			        },
			        "scrollCollapse": true,
			        "paging":         false,
			        
			        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
			        "pageLength" : 10, // default page entries
			        "columns": [
			            { "data": "Name" },
			            { "data": "Description" },
			            { "data": "Id" },
			            { "data": "Id" },
			        ]
			        ,"columnDefs": [
				      	 { "targets": 2, "orderable": false, "render": function (data,type,row){
									return "<div class='btn btn-image' title='Edit' onclick='load(\""+row["Id"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Wrench-32.png)'></div>";
								}}
			        	,{ "targets": 3, "orderable": false, "render": function (data,type,row){
									return "<div class='btn btn-image' title='Delete' onclick='deleteItem(\""+row["Id"]+"\");' data-toggle='modal' data-target='#exampleModal' style='width:32px;height:32px;background-image: url(https://cdn2.iconfinder.com/data/icons/web/512/Trash_Can-32.png)'></div>";
								}}
			        ]
			    } );
			} );
		</script>
    	<div id="wrapper">
		    <div id="buttonbar">
		        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"   class="btn btn-primary" name="New"    onclick="reset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
		    </div>
		    <div id="tableDiv">
			    <table id="example" class="display" cellspacing="0" width="100%">
			        <thead>
			            <tr>
			                <th align="left">Application Name</th>
			                <th align="left">Application Description</th>
			                <th align="left"></th>
			                <th align="left"></th>
			            </tr>
			        </thead>
			    </table>
			  </div>
    </div>
    



<!--#################-->
<!-- EDIT MODAL FORM -->
<!--#################-->

<script>
	var idFieldName="Id";
	function load(id){
	  document.getElementById("edit-ok").innerHTML="Update";
	  document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("New", "Update");
	  var xhr = new XMLHttpRequest();
	  var ctx = "${pageContext.request.contextPath}";
	  xhr.open("GET", Utils.SERVER+"/api/pathfinder/customers/"+getParameterByName("customerId")+"/applications/"+id, true);
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
	function save(formId){
	  var data = {};
	  var op="";
	  var form=document.getElementById(formId);
	  for (var i = 0, ii = form.length; i < ii; ++i) {
	    if (form[i].name) data[form[i].name]=form[i].value;
	  }
	  post(Utils.SERVER+"/api/pathfinder/customers/"+getParameterByName("customerId")+"/applications/"+id, data);
	  editFormReset();
	}

</script>


<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document"> <!-- make wider by adding " modal-lg" to class -->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">New Application</h4>
      </div>
      <div class="modal-body">
        <form id="form">
        	<!--
          <div id="form-id" class="form-group">
            <label for="Id" class="control-label">Application ID:</label>
            <input id="Id" name="Id" type="text" class="form-control"/>
          </div>
        	-->
          <div class="form-group">
            <label for="Name" class="control-label">Application Name:</label>
            <input id="Name" name="Name" type="text" class="form-control">
          </div>
          <!--
          <div class="form-group">
            <label for="Review" class="control-label">Review:</label>
            <input id="Review" name="Review" type="text" class="form-control">
          </div>
          -->
          <div class="form-group">
            <label for="Description" class="control-label">Application Description:</label>
            <input id="Description" name="Description" type="text" class="form-control">
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