<%@page import="com.zhang.javabean.Room"%>
<%@page import="com.zhang.javabean.Booking"%>
<%@page import="com.zhang.javabean.User"%>
<%@page import="com.zhang.dao.MysqlAction"%>
<%@page import="javassist.expr.NewArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="net.sf.json.JSONArray"%>

<!--
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  -->
<%@ page import="java.util.*" %>
<%@ page import ="java.text.SimpleDateFormat" %>
<%@ page import ="java.util.Date" %>
<%@ page import="java.sql.*" %>
<%@page import="com.zhang.javabean.Room"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

	<head>
	  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	  <title>会议室预定详情</title>
	  <script type="text/javascript" src="jquery-2.1.1.min.js"></script>
	  <script type="text/javascript" src="reservationInfo.js"></script>
	  <script type="text/javascript" src="meetRoomEdit.js"></script>
	  <script type="text/javascript" src="drag.js"></script>
	  <script language="javascript" type="text/javascript" src="My97DatePicker/WdatePicker.js"></script>
	</head>
	<style>
	/*         整体框架            */
	    *{
	      margin:0;
	      padding: 0;
	    }
	  body{
	    background: url('img/mainbg1.png') repeat-x;
	
	  }
	  #container{
	    height:760px;
	    width:1000px;
	    margin: 10px auto;
	    background: url('img/bg1.jpg') no-repeat;
	  
	  }
	  #header{
	    height:134px;
	    background: url('img/header.jpg') no-repeat;
	  }
	  #logo{
	    float: left;
	    width: 100px;
	    height: 100px;
	    margin-top: 10px;
	    margin-left:40px;
	    background: url('img/logo.png') no-repeat;
	  }
	  #title{
	    float: left;
	    width: 453px;
	    height:75px;
	    margin-top: 25px;
	    margin-left: 100px;
	    background: url('img/title.png') no-repeat;
	  }
	   #links{
	    margin-top: -17px;
	    width: 300px;
	    float:left;
	    margin-left: 737px;
	    font-size:16px;
	  }
	  #links a{
	    color:#000;
	    padding: 8px;
	    margin:-4px;
	    font-weight: bold;
	    text-decoration: none;
	    border:1px solid #11264f;
	    background-color: #A6D4F0;
	  }
	  #links a:hover{
	    background-color: #2585a6;
	    color:#eee;
	  }
	  #links a:nth-child(1){
	    border-top-left-radius: 20px;
	  }
	  #links a:nth-child(3){
	    border-top-right-radius: 20px;
	  }
	  #content{
	    height:560px;
	    margin:0;
	    background: url('img/content.png') repeat;
	  }
	  #bottomDivider{
	    height: 5px;
	    background: url('img/bottomDivider.jpg') no-repeat;
	  }
	  #bottom{
	    height:55px;
	    text-align: center;
	    padding-top: 10px;
	    background: url('img/bottom.jpg') no-repeat;
	  }
	  /*input、select样式*/
	  input,select{
	    border-radius: 3px;
	    border: 1px #155B6A solid;
	    border-radius: 5px;
	    background: none;
	    margin-top: 2px;
	    transition: all 0.30s ease-in-out;
	    -webkit-transition: all 0.30s ease-in-out;
	    -moz-transition: all 0.30s ease-in-out;
	    outline:none;
	  }
	  input:focus,select:focus{
	    border:#35a5e5 1px solid;
	    box-shadow: 0 0 5px rgba(81, 203, 238, 1);
	    -webkit-box-shadow: 0 0 5px rgba(81, 203, 238, 1);
	    -moz-box-shadow: 0 0 5px rgba(81, 203, 238, 1);
	  }
	  /*input、select样式end/
	  /*  ----------------整体框架end-------------------*/
	  /*           表格                      */
	  #title1{
	    height: 45px;
	    padding-top: 5px;
	    border-bottom: 8px solid #155b6a;
	  }
	  #title1 h1{
	    margin-left: 15px;
	    color: #006f86;
	  }
	  #btnContainers{
	    height: 50px;
	    text-align: right;
	    margin-right: 200px;
	  }
	  .btnDisabled{ 
	    border: 2px solid #aaa;                /*按钮禁用*/
	    background:#d8d8d8 !important ;
	  }
	  #btnContainers .btn{
	    width: 93px;
	    height: 41px;
	    border: none;
	    border-radius: 20px;
	    color:#fff;
	    font-size:22px;
	    background: #79CD40;
	  }
	  #btnContainers .btn:hover{
	    background: #8DD45E;
	  }
	  #btnContainers #chooseDate{
	    width: 140px;
	    height: 40px;
	    margin: 2px;
	    text-align: center;
	    font-size: 25px;
	  }
	  #timeLine{
	    height: 51px;
	    background: url('img/timeLine.png') no-repeat;
	  }
	  #tableContainer{
	        overflow: auto;
	        height:392px;
	        border-bottom: 8px solid #155b6a; /*权宜之计*/
	        background: url('img/tableContainer.png') no-repeat;
	    }
	    table.biao{
	        margin: auto;
	        width: 95%;
	        border-collapse:collapse;
	        border-width: 1px;
	        font-size: 25px;
	    }
	    table.biao tr{
	        border-width: 1px;
	        border:1px solid #006f86;  
	        }
	    table.biao td{
	        border-width: 1px;
	        border:1px solid #006f86;
	        }
	    table.biao tr:nth-child(2n+1){
	        background: #ddd;
	        }    
	    table.biao tr:hover{
	        background: #fbf8e9;
	        }
	    table.biao td:nth-child(1){
	        width: 120px;
	    }
	  /*  ---------------表格end--------------------*/
	
	
	
	      /*             预定弹窗                   */
	    .reservationDiv{
	        display: none;
	        position: absolute;
	        top:150px;
	 /*       left:52%;*/
	        padding-left: 20px;
	        padding-bottom: 10px;
	        background: #ddd;
	        border:10px solid #eee;
	        border-radius: 5px;
	        font-size: 20px;
	        line-height: 30px;
	        -moz-box-shadow:5px 5px 5px #999 ;              
	        -webkit-box-shadow:5px 5px 5px #999 ;           
	        box-shadow:5px 5px 5px #999 ; 
	        z-index: 999;
	    }
	    #reservationTitle{
	        width: 92%;
	        height:20px;
	        cursor: move;
	    }
	    .wClose{
	        width: 16px;
	        height: 16px;
	
	        margin-top:-18px;
	        margin-left:284px;
	        cursor: pointer;
	        background: url('img/wClose.jpg') 0 0;
	    }
	    .wClose:hover{
	         background: url('img/wClose.jpg') 0 16px;
	    }
	    .reservationInfo{
	        width: 300px;
	        height:230px;
	        margin:20px auto;
	    }
	    .reservationForm input{
	        line-height: 32px;
	        font-size: 20px;
	    }
	    .button{
	        width: 80px;
	        height:30px;
	        border:0;
	        text-align: center;
	        border-radius: 20px;
	    } 
	    .button#reservationConfirm{
	        margin-left: 50px;  
	        margin-top: 20px;
	        margin-right: 20px;
	        background: #79cd40;
	    }
	    .button#reservationConfirm:hover{
	        background: #8dd45e;
	    }
	    .button#reservationCancel{
	        background: #ed1941;
	    }
	    .button#reservationCancel:hover{
	        background: #ef4136;
	    }
	    .reservationForm #participantsChooseBtnCont1{
	        float:left;
	        margin-left:3px;
	        margin-right: 3px;
	        width: 50px;
	    }
	    .reservationForm #timeChooseBtnCont1{
	        float:left;
	        margin-left:3px;
	        margin-right: 3px;
	        width: 50px;
	    }
	    .reservationForm #participantsSelectContainer1{
	        float:left;
	        margin-left: 10px;
	    }
	    .reservationForm #timeSelectContainer1{
	        float:left;
	        margin-left: 10px;
	    }
	    .reservationForm p#multiChooseHint{
	        margin: 1px;
	        color:red;
	        font-size: 12px;
	        line-height: 14px;
	    }
	    .reservationForm #participantsSelectContainer2{
	        float:left;
	    }
	    .reservationForm #timeSelectContainer2{
	        float:left;
	    }  
	    .reservationForm .text{
	        width: 133px;
	        height: 30px;
	    }
	    .reservationForm select{
	        width: 140px;
	        height: 30px;
	    }
	    .reservationForm .participants{
	        height:100px;
	        width:100px;
	    }
	    .reservationForm .timeChoose{
	        height:100px;
	        width:100px;
	    }
	    .reservationForm .participantsChooseBtn{
	        width: 50px;
	        height: 20px;
	        border: none;
	        font-size: 15px;
	        line-height:1px;
	        background: url('img/docuDownBtn.png') no-repeat;
	    }
	    .reservationForm .timeChooseBtn{
	        width: 50px;
	        height: 20px;
	        border: none;
	        font-size: 15px;
	        line-height:1px;
	        background: url('img/docuDownBtn.png') no-repeat;
	    }
	    .reservationForm .participantsChooseBtn:hover{
	        background: url('img/docuDownBtn1.png') no-repeat;
	    }
	    .reservationForm .timeChooseBtn:hover{
	        background: url('img/docuDownBtn1.png') no-repeat;
	    }
	    .reservationForm #noUse{
	        height: 2px;
	    }
	    /*mask*/
	    #mask{
	    position: absolute;
	    top:0;
	    left:0;
	    background: #000;
	    filter:alpha(opacity=50); 
	    -moz-opacity:0.5;
	    opacity:0.5;
	    z-index: 998;
	  }
	  /*mask end*/
	    /*              预定弹窗end                    */
	
	
	
	  /*                 信息弹窗                   */
	  #divInfo{
	      display: none;
	      position: absolute;
	      top:250px;
	      left:45%;
	      padding: 5px;
	      background: #ddd;
	      border:10px solid #eee;
	      border-radius: 5px;
	      font-size: 20px;
	      line-height: 30px;
	      -moz-box-shadow:5px 5px 5px #999 ;              
	      -webkit-box-shadow:5px 5px 5px #999 ;           
	      box-shadow:5px 5px 5px #999 ;
	}
	  
	  .wClose1{
	      width: 16px;
	      height: 16px;
	      margin-top:-5px;
	      margin-right:-6px;
	      float: right;
	      background: url('img/wClose.jpg') 0 0;
	  }
	  .wClose1:hover{
	      background: url('img/wClose.jpg') 0 16px;
	  }
	  #divInfo button{
	    width:62px;
	    height:25px;
	    border:none;
	    border-radius: 20px;
	  }
	  #divInfo #detailedInfo{
	    background: #79cd40;
	  }
	  #divInfo #detailedInfo:hover{
	    background: #8dd45e;
	  }
	  #divInfo #cancelReservBtn{
	    background: #ed1941;
	  }
	  #divInfo #cancelReservBtn:hover{
	    background: #ef4136;
	  }
	  /*                 信息弹窗 end               */     
	
	  /*                   背景变红类                */
	  .backgroundRed{
	    background-color: red;
	  }
	   /*                      背景变红类end             */
	</style>

	<body>
	  <div id='container'>
	    <div id='header'>
	      <div id='logo'></div>
	      <div id="title"></div>
	      <div id="links">
	        <a onclick="window.open('choosetofutureorhistory.jsp','_parent')" alt="首页">首页</a>
	        <a onclick="window.open('reservationInfo.jsp','_parent')" alt="会议室预定">会议室预定</a>
	        <a onclick="window.open('documentSearch0.jsp','_parent')" alt="会议历史检索">会议历史检索</a>
	      </div>
	    </div>
	    
	      <div id="content">
		
		      <div id="title1">
		        <h1>会议室预定详情</h1>
		      </div>
		      <div id="btnContainers">
				   <form method="post" action="InquireServlet">
				       
				        <%        
				         String date =(String)session.getAttribute("chooseDate");
				         MysqlAction mysqlaction4 =new MysqlAction();
				         ArrayList<Booking> list = mysqlaction4.getBookingInfobyDate(date);
				         System.out.println("list长度："+list.size());  
				         System.out.println("list："+list);    
				         String jsonarray = JSONArray.fromObject(list).toString();
				         jsonarray=jsonarray.replace("\"", "\'");
				         System.out.println(jsonarray);         
				        %> 
				        
				        <input type="text" name="chooseDate" id="chooseDate" placeholder="选择日期" onclick="WdatePicker({el:'chooseDate'})"/>
				        <input type="submit" class="btn queryBtn" id="queryBtn" value="查询"/> 
				           
						<%
						int usertype=(Integer)session.getAttribute("usertype");
						String username =(String)session.getAttribute("userName");
						%>
						
				        <input type="button"  id="reservationBtn" class="btn reserBtn" value="预定"/>
				        <input type="hidden"  id="username" value="<%=username %>"/> 
				        <input type="hidden"  id="usertype" value="<%=usertype %>"/>  
				        <input type="hidden"  id="jsonarray" value="<%=jsonarray%>"/>
				        
				   </form>
		      </div>
		        
		      <div id="timeLine"></div>
		      <div id="tableContainer">
		      	<table class="biao" id="table">
			        <%
			        MysqlAction mysqlAction6 = new MysqlAction();
			        String meetRoomSel6 = mysqlAction6.getAllRooms();
			        String[] meetRoomSel2 = meetRoomSel6.split(",");
			        if(meetRoomSel2!=null)
			        for(int i=0;i<meetRoomSel2.length;i++){
			        %>  
			       <input type="hidden" id="roomNum" value="<%=meetRoomSel2[i]%>"/>   
			                    
			       <tr>
			              <td class="roomNum">会议室：<%=meetRoomSel2[i]%></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			              <td></td>
			       </tr>
			       <%}%>                  
			    </table>
		
		      </div>
	
	      </div>
	
	    <div id="bottomDivider"></div>
	    <div id='bottom'>copyright blabla版权所有</div>
	  </div>
	  
		<!--           预定弹窗                     -->
		<div class="reservationDiv" id="reservationDiv">
		    <div id="reservationTitle"></div>
		    <div class="wClose" id="wClose"></div> 
		    <form  class="reservationForm" method="post" action="BookingServlet">       
		        <label  for="chooseResevDate">选择日期:</label>
		        <input name="chooseResevDate" type="text" class="text" id="chooseResevDate" placeholder="选择日期" autocomplete="off" onclick="WdatePicker({el:'chooseResevDate'} )"/> <br />      
		        <label  for="meetRoomSel">会 议 室:</label>
		        <select name="meetRoomSel" class="meetRoomSel" id="meetRoomSel" autocomplete="off" ">
		            <option value ="null">--请选择--</option>
		                 <%
		                   MysqlAction mysqlAction2 = new MysqlAction();
		                   String meetRoomSel = mysqlAction2.getAllRooms();
		                   String[] meetRoomSel1 = meetRoomSel.split(",");
		                   if(meetRoomSel1!=null)
		                       for(int i=0;i<meetRoomSel1.length;i++){
		                     %>       
		                     <option value = "<%=meetRoomSel1[i]%>"><%="会议室编号："+meetRoomSel1[i]%></option>
		                     <%
		                   }
		                 %>
		        </select><br />                       
		        <label  for="allTime">时&nbsp;&nbsp;&nbsp;&nbsp;间:</label>
		        <div id="chooseTimeArea">   
		            <div id="timeSelectContainer1">
		                <select class="timeChoose" multiple="multiple" id="allTime" autocomplete="off">                   
		 				
		                </select>
		            </div> 
		    
		            <div id="timeChooseBtnCont1">
		                <input type="button" class="timeChooseBtn timeGoRightBtn" id="timeGoRightBtn" value=">>"/>
		                <p id="multiChooseHint">按住Ctrl或Shift键进行多选</p>
		                <input type="button" class="timeChooseBtn timeGoLeftBtn" id="timeGoLeftBtn" value="<<"/>
		            </div>
		
		            <div id="timeSelectContainer2">
		                <select name = "thisTime" class="timeChoose" multiple="multiple" id="thisTime" autocomplete="off">
		            
		                </select>
		            </div> 
		            <div id="noUse"></div>
		        </div> <br /><br /><br /><br />
		        
		         <label  for="meetType">会议类型:</label>
		         <input type="radio" name="meetType" id="meetType" value="公开" checked/>公开
		         <input type="radio" name="meetType"  value="私密"  />私密 <br />
		        
		      
		        <label  for="allParticipants">参会人员:</label>
		        <div id="participantArea">   
		            <div id="participantsSelectContainer1">
		                <select class="participants" multiple="multiple" id="allParticipants" autocomplete="off">
		       <%       
		        MysqlAction mysqlaction = new MysqlAction();
		        String participants = mysqlaction.getAllUsers();  
		        String[] participants1 = participants.split(",");        
		        if(participants1!=null)
		               for(int i=0;i<participants1.length;i++){
		          %>       
		         <option value = "<%=participants1[i]%>"><%=participants1[i]%></option>
		          <%
		          }
		    %>
		              </select>
		    </div>
		    <div id="participantsChooseBtnCont1">
		                <input type="button" class="participantsChooseBtn participantsGoRightBtnparticipantsGoRightBtn" id="participantsGoRightBtn" value=">>"/>
		                <p id="multiChooseHint">按住Ctrl或Shift键进行多选</p>
		                <input type="button" class="participantsChooseBtn participantsGoLeftBtn" id="participantsGoLeftBtn" value="<<"/>
		            </div>
		
		            <div id="participantsSelectContainer2">
		                <select name="thisparticipants"  class="participants" multiple="multiple" id="thisParticipants" autocomplete="off">
		            
		                </select>
		            </div> 
		            <div id="noUse"></div>
		        </div> 
		        <br /> 
		        <br />
		        <br /> 
		        <br />    
		        <label for="meetName">会议名称:</label>   
		        <input name="meetName" type="text" class="text meetName" id="meetName" autocomplete="off"/> <br />      
		        <label for="meetContent">会议主题:</label>   
		        <input name="meetContent" type="text" class="text meetContent" id="meetContent" autocomplete="off"/> <br />
		        <label  for="meetAgenda">会议议程:</label>   <br />
		        <div id="meetAgendaCont" style="border:1px solid #155B6A;padding-bottom: 10px;width: 70%;margin-left: 30px;border-radius: 5px;">
		            1.&nbsp;<input name = "meetAgenda" type="text" class="text meetAgenda" id="meetAgenda" autocomplete="off" style="border:0;border-radius:0;border-bottom:1px solid #000;"/> <br />
		            2.&nbsp;<input name = "meetAgenda1" type="text" class="text meetAgenda" id="meetAgenda1" autocomplete="off" style="border:0;border-radius:0;border-bottom:1px solid #000;"/> <br />
		            3.&nbsp;<input name = "meetAgenda2" type="text" class="text meetAgenda" id="meetAgenda2" autocomplete="off" style="border:0;border-radius:0;border-bottom:1px solid #000;"/> <br />
		        </div> 		
		        <input type="submit" id="reservationConfirm" class="button reservationConfirm" value="确定" />
		        <input type="submit" id="reservationCancel" class="button reservationCancel" value="取消" />
		    </form>
		
		</div>
		<!--                  预定弹窗end                    -->
		
		<!-- 会议室信息弹窗 -->
	    <div id="divInfo" class="roomInfo">
	      <form  method='post' action='RoomInfoServlet'>
			        会议室：    <span></span> <br />
			        会议室容量：<span></span> <br />
			        会议室设备：<span></span> <br />
	      </form>
	    </div>
		<!-- 会议室信息弹窗 end-->
		
		<!-- 预订信息信息弹窗 -->
	    <div id="divInfo" class="reservInfo">
	        <div id="wClose1" class="wClose1"></div>
	        <form  method='post' action='GetRoomInfoServlet'>
			            会议名：  <span></span> <br />
			            会议类型：<span></span> <br />
			            会议主题：<span></span> <br />
			            预订者：<span></span> <br />
			            会议室号：<span></span> <br />
	            <button  type="submit" id="detailedInfo">详细信息</button>
	           	<button type="button" id="cancelReservBtn">删除预订</button>
	            <input type="hidden" id="conferId" name="conferId" value=""/>      
	         </form>          	
	    </div>
		<!-- 预订信息信息弹窗 end-->
	</body>
</html>




