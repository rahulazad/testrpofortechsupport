<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="cache"%><%@page import="com.itgd.dto.StoryDTO" %>
<%@page import="com.itgd.utils.Constants, com.itgd.conn.Dbconnection" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%
String px="305";
String contentId="0";
String tweetCode="#mindrocks";
if(request.getParameter("id")!=null && !request.getParameter("id").equals("")){
	contentId=request.getParameter("id");
}
if(request.getParameter("px")!=null && !request.getParameter("px").equals("")){ 
	px=request.getParameter("px");
}
if(request.getParameter("code")!=null && !request.getParameter("code").equals("")){ 
	tweetCode="#"+request.getParameter("code");
}

%>



<cache:cache key="<%=Constants.SITE_URL+"highlight_chunk.jsp?px="+px+"&id="+contentId+"&code="+tweetCode%>" scope="application" time="60" refresh="t">

<%
if(!contentId.equals("0")) {

	StoryDTO topobj = getHighlightsData(contentId);
	int counter=0;
	int articleId=0;
	String completeNews="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Highlights : India Today</title>
<meta name="keywords" content="" /> 
<meta name="description" content="" />
<meta http-equiv="refresh" content="300; URL=<%="http://indiatoday.intoday.in/highlight_chunk.jsp?px="+px+"&id="+contentId+"&code="+tweetCode%>">
<style>
body {margin:0; padding:0;}
.bdhheadline {font:normal 12px arial; color:#6a6a6a; line-height:18px; width:<%=px%>px; float:left;}
.bdhheadline a {font:normal 12px arial; color:#6a6a6a; line-height:18px; text-decoration:none;}
.bdhheadline a:hover {font:normal 12px arial; color:#6a6a6a; line-height:18px; text-decoration:underline;}
.bdhheadline ul{list-style:none; float:left; margin:0; padding:0;}
.bdhheadline ul li {border-bottom:1px solid #e2e2e2; list-style:none; color:#6a6a6a; font:normal 12px arial; margin:0px; padding:0px 2px 2px 0px;line-height:18px;}
.budghiglit {width:100%; padding-top:3px; padding-bottom:5px; text-align:right;}
.rightdiv{float:right;}
</style>
</head>

<body>
<div class="bdhheadline">
  <ul>
 
	<%
	int count=0;
	if (topobj!= null) {	
	articleId = topobj.getId();	
	System.out.println(articleId);
	String words[]=topobj.getLongDescription().replaceAll("\\<.*?>","").split(" ");	
	 for (int ii=0 ; ii < words.length ; ii++){ 
	       if (words[ii].contains("Highlight")) 
	          count += 1; 
	    } 
	
for (int j=count ; j >0 ; j--){ 
	String str=topobj.getLongDescription();    	
	int a1 = str.indexOf("Highlight"+j+":");		
	String aa = str.substring(a1, str.length());
	int a2 = aa.indexOf("#");
	String ab = aa.substring(0, a2);
	String tempStr = "Highlight"+j+":";		
	if (tempStr.equals("Highlight"+j+":")) {
		completeNews = ab.substring(ab.indexOf(tempStr)+ tempStr.length());	
		out.println("<li>"+completeNews);
		if(j>count-10) {
%>
		<div class="budghiglit">
		<span class="rightdiv">
		<a href="http://twitter.com/share" class="twitter-share-button" data-url="http://bit.ly/mindrocks" data-counturl="http://bit.ly/mindrocks" data-text="<%=completeNews+tweetCode%>" data-related="india_today" data-count="none" data-via="MyMindRocks" target="_blank"></a>
		</span>
		<div style="clear:both;"></div>
		</div>
<%
		}
		out.println("</li>");
	}	
	} 
} %>	
</ul>
</div>
<script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
</body>
</html>
<% } %>

 
<%!
public StoryDTO getHighlightsData(String articleId) throws Exception{
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement stmt = null;
	String selectQuery = "";
	StoryDTO fulltextcontentDTO=null;
	try{
		Dbconnection adminConn = Dbconnection.getInstance();
		conn = adminConn.getConnection();
		selectQuery = "select c.id, c.`fulltext` from jos_content c where c.id="+articleId+""; 	
		System.out.println(selectQuery);
		stmt = conn.prepareStatement(selectQuery);
		rs = stmt.executeQuery();
		while(rs.next()) {
			fulltextcontentDTO = new StoryDTO();
			fulltextcontentDTO.setId(rs.getInt("id"));
			fulltextcontentDTO.setLongDescription(rs.getString("fulltext"));
		}
	} catch (Exception e) {
		System.err.println(e.getMessage());
	} finally {
		if (rs != null) 
			rs.close();
		if (stmt != null) 
			stmt.close();
		if (conn != null) 
			conn.close();
	}
	return fulltextcontentDTO;
}
 %>
</cache:cache>
**********CHNAGES***************
