package com.redhat.pathfinder;

import java.io.IOException;
import java.util.Arrays;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

@Path("/pathfinder/")
public class Controller{
  
  class AssessmentSummary{
    String applicationId;
    String applicationName;
    String assessed;
    String reviewed;
    String priority;
    String decision;
    String effort;
    String reviewDate;
    String lastAssessmentId;
    public String getApplicationId(){
      return applicationId;
    }
    public String getApplicationName(){
      return applicationName;
    }
    public String getAssessed(){
      return assessed;
    }
    public String getReviewed(){
      return reviewed;
    }
    public String getPriority(){
      return priority;
    }
    public String getDecision(){
      return decision;
    }
    public String getEffort(){
      return effort;
    }
    public String getReviewDate(){
      return reviewDate;
    }
    public String getLastAssessmentId(){
      return lastAssessmentId;
    }
  }
  
  @GET
  @Path("/customers/{customerId}/assessmentSummary")
  public Response assessmentSummary(@PathParam("customerId") String customerId) throws JsonGenerationException, JsonMappingException, IOException{
    AssessmentSummary x=new AssessmentSummary();
    x.applicationId="12345";   
    x.applicationName="Test App 1"; 
    x.assessed="Yes";
    x.reviewed="No";
    x.priority="1";
    x.decision="";
    x.effort="";
    x.reviewDate="";
    x.lastAssessmentId="";
    
    AssessmentSummary y=new AssessmentSummary();
    y.applicationId="12346";   
    y.applicationName="Test App 2"; 
    y.assessed="Yes";
    y.reviewed="Yes";
    y.priority="3";
    y.decision="Re-factor";
    y.effort="Small";
    y.reviewDate="2018-01-01";
    y.lastAssessmentId="12345";
    
    AssessmentSummary z=new AssessmentSummary();
    z.applicationId="12347";   
    z.applicationName="Test App 3"; 
    z.assessed=null;
    z.reviewed=null;
    z.priority=null;
    z.decision=null;
    z.effort=null;
    z.reviewDate=null;
    z.lastAssessmentId=null;
    
    return Response.status(200)
        .header("Access-Control-Allow-Origin",  "*")
        .header("Content-Type","application/json")
        .header("Cache-Control", "no-store, must-revalidate, no-cache, max-age=0")
        .header("Pragma", "no-cache")
        .entity(Json.newObjectMapper(true).writeValueAsString(Arrays.asList(x,y, z)))
        .build();
  }
}
