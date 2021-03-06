<%@ page import="com.redhat.pathfinder.Controller" %>

Utils = {
//  SERVER: "http://localhost:8080", 
//  SERVER: "http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com",
//  SERVER: "${pathfinderUrl}",
  SERVER: "<%=Controller.getProperty("PATHFINDER_SERVER")%>",
  
  chartColors: {
  	"UNKNOWN": "#808080",
		"RED": "#cc0000",
		"AMBER": "#ec7a08",
		"GREEN": "#92d400"
  },
	getParameterByName: function(name, url) {
		  if (!url) url = window.location.href;
		  name = name.replace(/[\[\]]/g, "\\$&");
		  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
		      results = regex.exec(url);
		  if (!results) return null;
		  if (!results[2]) return '';
		  return decodeURIComponent(results[2].replace(/\+/g, " "));
		}
}