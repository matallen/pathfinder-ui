package com.redhat.pathfinder;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

import org.apache.commons.io.IOUtils;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import com.redhat.pathfinder.charts.Chart2Json;
import com.redhat.pathfinder.charts.DataSet2;

@Path("/pathfinder/")
public class Controller{
  
//  class AssessmentSummary{
//    String applicationId;
//    String applicationName;
//    String assessed;
//    String reviewed;
//    String priority;
//    String decision;
//    String effort;
//    String reviewDate;
//    String lastAssessmentId;
//    public String getApplicationId(){
//      return applicationId;
//    }
//    public String getApplicationName(){
//      return applicationName;
//    }
//    public String getAssessed(){
//      return assessed;
//    }
//    public String getReviewed(){
//      return reviewed;
//    }
//    public String getPriority(){
//      return priority;
//    }
//    public String getDecision(){
//      return decision;
//    }
//    public String getEffort(){
//      return effort;
//    }
//    public String getReviewDate(){
//      return reviewDate;
//    }
//    public String getLastAssessmentId(){
//      return lastAssessmentId;
//    }
//  }
  
  class ApplicationAssessmentSummary{
    String question;
    String answer;
    String rating;
    public ApplicationAssessmentSummary(String q, String a, String r){
      this.question=q;
      this.answer=a;
      this.rating=r;
    }
    public String getQuestion(){return question;}
    public String getAnswer(){return answer;}
    public String getRating(){return rating;}
  }
  
  @GET
  @Path("/customers/{customerId}/applications/{appId}/assessments/{assessmentId}/viewAssessmentSummary")
  public Response viewAssessmentSummary(@PathParam("customerId") String customerId, @PathParam("appId") String appId, @PathParam("assessmentId") String assessmentId) throws JsonGenerationException, JsonMappingException, IOException{
    
    //parse the application-survey.js file into a json object structure
    //get the answers from the assessment
    //match the two as output to the databtable onscreen
    
    String raw=IOUtils.toString(new URL("http://localhost:8083/pathfinder-ui/assets/js/application-survey.js").openStream());
    
    // this is hacky, however once we drive the questions from the back-end this will change anyway
    int start=raw.indexOf("pages: [{")+7;
    int end=raw.indexOf("}],")+2;
    mjson.Json x=mjson.Json.read(raw.substring(start, end));
    
    //MOCKED CODE, when the colors are put into the surveyjs source this can be removed
    String[] ratingsCfg=new String[]{"UNKNOWN","RED","AMBER","AMBER","GREEN","GREEN","GREEN","GREEN"};
    
    Random r=new Random();
    
    List<ApplicationAssessmentSummary> result=new ArrayList<ApplicationAssessmentSummary>();
    for(mjson.Json p:x.asJsonList()){
        for(mjson.Json q:p.at("questions").asJsonList()){
          
          String answerText="";
          String answerRating="";
          
          if (q.at("type").asString().equals("radiogroup")){
            List<String> answers=new ArrayList<String>();
            for(mjson.Json a:q.at("choices").asJsonList())
              answers.add(a.asString());
            
            //fix these mocked answers
            int randomIndex=0 + r.nextInt((answers.size()-1 - 0) + 1);
            String answerIdx=answers.get(randomIndex).split("\\|")[0];
            answerText=answers.get(randomIndex).split("\\|")[1];
            //
            
            answerRating=ratingsCfg[Integer.parseInt(answerIdx)];
            
            result.add(new ApplicationAssessmentSummary(q.at("title").asString(), answerText, answerRating));
          }else if (q.at("type").asString().equals("rating")){
            
          }
          
          
        }
    }
    return Response.status(200).entity(Json.newObjectMapper(true).writeValueAsString(result)).build();
  }
  
  
  /* pie chart where the aspects are grouped by color */
  @GET
  @Path("/customers/{customerId}/applications/{appId}/assessments/{assessmentId}/chart2")
  public Response chart2(@PathParam("customerId") String customerId, @PathParam("appId") String appId, @PathParam("assessmentId") String assessmentId) throws JsonGenerationException, JsonMappingException, IOException{
    
    List<String> d=new ArrayList<String>();
    d.add("Architectural Suitability:1:GREEN");
    d.add("Clustering:4:GREEN");
    d.add("Communication:2:GREEN");
    d.add("Compliance:3:GREEN");
    d.add("Application Configuration:4:GREEN");
    d.add("Existing containerisation:0:GREEN");
    d.add("Deployment Complexity :4:GREEN");
    d.add("Dependencies - 3rd party vendor:2:GREEN");
    d.add("Dependencies - Hardware:1:GREEN");
    d.add("Dependencies - (Incoming/Northbound):4:GREEN");
    d.add("Dependencies - Operating system:2:GREEN");
    d.add("Dependencies - (Outgoing/Southbound):5:AMBER");
    d.add("Discovery:3:AMBER");
    d.add("Observability - Application Health:4:AMBER");
    d.add("Observability - Application Logs:3:AMBER");
    d.add("Observability - Application Metrics:3:AMBER");
    d.add("Level of ownership:5:AMBER");
    d.add("Runtime profile:4:RED");
    d.add("Application resiliency:4:RED");
    d.add("Application Security:3:RED");
    d.add("State Management:0:UNKNOWN");
    d.add("Application Testing:3:UNKNOWN");
        
    Map<String,Integer> labels=new HashMap<String, Integer>();
    
    for(String x:d){
      if (!labels.containsKey(x.split(":")[2])) labels.put(x.split(":")[2], 0);
      labels.put(x.split(":")[2], labels.get(x.split(":")[2])+1);
    }
    
    List<String> backgrounds=new ArrayList<String>();
    
    Chart2Json c=new Chart2Json();
    DataSet2 ds=new DataSet2();
    for(Entry<String, Integer> e:labels.entrySet()){
      c.getLabels().add(e.getKey());
      ds.getData().add(e.getValue());
      
      if (e.getKey().equals("RED")) backgrounds.add("rgb(255, 0, 0)");
      if (e.getKey().equals("AMBER")) backgrounds.add("rgb(255, 205, 86)");
      if (e.getKey().equals("GREEN")) backgrounds.add("rgb(0, 128, 0)");
      if (e.getKey().equals("UNKNOWN")) backgrounds.add("rgb(220, 220, 220)");
      
    }
    c.getDatasets().add(ds);
    ds.setBackgroundColor(backgrounds);
    return Response.status(200).entity(Json.newObjectMapper(true).writeValueAsString(c)).build();
  }
  
  
  /* pie chart where all ~20 segments are represented */
  @GET
  @Path("/customers/{customerId}/applications/{appId}/assessments/{assessmentId}/chart")
  public Response chart(@PathParam("customerId") String customerId, @PathParam("appId") String appId, @PathParam("assessmentId") String assessmentId) throws JsonGenerationException, JsonMappingException, IOException{
    
    List<String> d=new ArrayList<String>();
    d.add("Architectural Suitability:1:GREEN");
    d.add("Clustering:4:GREEN");
    d.add("Communication:2:GREEN");
    d.add("Compliance:3:GREEN");
    d.add("Application Configuration:4:GREEN");
    d.add("Existing containerisation:0:GREEN");
    d.add("Deployment Complexity :4:GREEN");
    d.add("Dependencies - 3rd party vendor:2:GREEN");
    d.add("Dependencies - Hardware:1:GREEN");
    d.add("Dependencies - (Incoming/Northbound):4:GREEN");
    d.add("Dependencies - Operating system:2:GREEN");
    d.add("Dependencies - (Outgoing/Southbound):5:AMBER");
    d.add("Discovery:3:AMBER");
    d.add("Observability - Application Health:4:AMBER");
    d.add("Observability - Application Logs:3:AMBER");
    d.add("Observability - Application Metrics:3:AMBER");
    d.add("Level of ownership:5:AMBER");
    d.add("Runtime profile:4:RED");
    d.add("Application resiliency:4:RED");
    d.add("Application Security:3:RED");
    d.add("State Management:0:UNKNOWN");
    d.add("Application Testing:3:UNKNOWN");
    
    Chart2Json c=new Chart2Json();
    for(String x:d) c.getLabels().add(x.split(":")[0]);
    
    DataSet2 ds=new DataSet2();
    List<Integer> data=new ArrayList<Integer>();
//    for(String x:d) data.add(Integer.parseInt(x.split(":")[1]));
    for(String x:d) data.add(1);
    
    ds.setData(data);
    
    List<String> backgrounds=new ArrayList<String>();
    for(String x:d){
      String color=x.split(":")[2];
      if (color.equals("RED")) backgrounds.add("rgb(255, 0, 0)");
      if (color.equals("AMBER")) backgrounds.add("rgb(255, 205, 86)");
      if (color.equals("GREEN")) backgrounds.add("rgb(0, 128, 0)");
      if (color.equals("UNKNOWN")) backgrounds.add("rgb(220, 220, 220)");
    }
    ds.setBackgroundColor(backgrounds);
//    ds.setBorderColor(backgrounds);
    ds.setHoverBorderWidth(1);
//    ds.setBorderColor(backgrounds);
    
    c.getDatasets().add(ds);
//    c.getDatasets().get(0).getBackgroundColor()
    
    return Response.status(200).entity(Json.newObjectMapper(true).writeValueAsString(c)).build();
    
  }
  
//  @GET
//  @Path("/customers/{customerId}/assessmentSummary")
//  public Response assessmentSummary(@PathParam("customerId") String customerId) throws JsonGenerationException, JsonMappingException, IOException{
//    AssessmentSummary x=new AssessmentSummary();
//    x.applicationId="12345";   
//    x.applicationName="Test App 1"; 
//    x.assessed="Yes";
//    x.reviewed="No";
//    x.priority="1";
//    x.decision="";
//    x.effort="";
//    x.reviewDate="";
//    x.lastAssessmentId="";
//    
//    AssessmentSummary y=new AssessmentSummary();
//    y.applicationId="12346";   
//    y.applicationName="Test App 2"; 
//    y.assessed="Yes";
//    y.reviewed="Yes";
//    y.priority="3";
//    y.decision="Re-factor";
//    y.effort="Small";
//    y.reviewDate="2018-01-01";
//    y.lastAssessmentId="12345";
//    
//    AssessmentSummary z=new AssessmentSummary();
//    z.applicationId="12347";   
//    z.applicationName="Test App 3"; 
//    z.assessed=null;
//    z.reviewed=null;
//    z.priority=null;
//    z.decision=null;
//    z.effort=null;
//    z.reviewDate=null;
//    z.lastAssessmentId=null;
//    
//    return Response.status(200)
//        .header("Access-Control-Allow-Origin",  "*")
//        .header("Content-Type","application/json")
//        .header("Cache-Control", "no-store, must-revalidate, no-cache, max-age=0")
//        .header("Pragma", "no-cache")
//        .entity(Json.newObjectMapper(true).writeValueAsString(Arrays.asList(x,y, z)))
//        .build();
//  }
}
