package com.zhang.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.zhang.VerifyLogin.MD5Implementation;
import com.zhang.dao.MysqlAction;
import com.zhang.javabean.Booking;


public class FileUploadServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
    

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		request.setCharacterEncoding("UTF8");
		
		String conferName = null;
		HttpSession session =  request.getSession() ;
		MysqlAction mysqlaction = new MysqlAction();
		
//		String conferId = request.getParameter("conferId");
//		String conferId = (String) session.getAttribute("conferId");
//		String date = request.getParameter("chooseResevDate");
//		System.out.println("测试后台能够拿到会议名和日期："+conferId);
//	String uploadPath = getServletContext().getRealPath("/")+"upload";  
//		String uploadPath =this.getServletContext().getRealPath("/")+"upload";  
		String uploadPath = "E:\\conference\\file\\"+"upload\\";
 
	File folder = new File(uploadPath);
	System.out.println("文件存放在服务器上的路径："+folder);
    //Servlet初始化时执行,如果上传文件目录不存在则自动创建  
   if(!folder.exists())
	   folder.mkdirs();
   try {
	if(ServletFileUpload.isMultipartContent(request)){  //判断获取的是否是文件
		DiskFileItemFactory disk = new DiskFileItemFactory();
		disk.setSizeThreshold(20*1024);  //设置内存可取字节数
		disk.setRepository(disk.getRepository());  //设置临时文件目录
		ServletFileUpload up = new ServletFileUpload(disk);
		int maxsize = 20*1024*1024;
		List<FileItem> list = up.parseRequest(request);  //获取上传列表
		Iterator<FileItem> i = list.iterator();  //遍历类表的迭代器
		while(i.hasNext()){
			 String fileName = "";
			 double filesize =0;
			 Date now = null;
 			 FileItem fm = (FileItem)i.next();  //遍历列表	
			 filesize = fm.getSize();
			 session.setAttribute("fileSize", filesize);
			 
			if(!fm.isFormField()){
				String filePath = fm.getName();  //获取文件全路径名
//				System.out.println("文件名："+filePath);
				
				int startIndex = filePath.lastIndexOf("\\");
				if(startIndex!=-1){  //对文件名进行截取
					fileName = filePath.substring(startIndex+1);
					session.setAttribute("fileName", fileName);
//					System.out.println("文件名1："+fileName);
				}else{
					fileName = filePath;

//					System.out.println("文件名2："+fileName);

				}
				if(fm.getSize()>maxsize){
//					message= "文件太长了，不要超过20MB";
							break;
				}
				if((fileName==null)||(fileName.equals(""))&&(fm.getSize()==0)){
//					message = "文件不能为空，文件大小也不能为零！";

					break;
				}
				File saveFile = new File(uploadPath,fileName);
				fm.write(saveFile);  //向文件中写入数据
//				message = "文件上传成功！";
				 now = new Date();
				session.setAttribute("uploadtime", now);

//				System.out.println("文件上传成功！");			
				
//				HttpSession session =  request.getSession();
				int conferId =  (Integer) session.getAttribute("conferId");
				String uploader = (String) session.getAttribute("userName");
//				String fileName = (String) session.getAttribute("fileName");
//				Double filesize = (Double) session.getAttribute("filesize");
//				Date date = (Date) session.getAttribute("uploadtime");
				
//				MysqlAction mysqlaction = new MysqlAction();
				
					//get bookingInfo from db  
					Booking newbooking = new Booking(); 
					try {
						newbooking= mysqlaction.getBookingbyconferId(conferId);

						int roomnum = newbooking.getRoomNum();
						conferName = newbooking.getConferName();
						
						mysqlaction.addFileInfo(fileName, uploader, now, roomnum, conferId, filesize);	
//						System.out.println("hahh！");
						
					} catch (Exception e) {
						
						e.printStackTrace();
					}
			}
			//处理上传的文件并上传到会中系统
			// 1 获得不带扩展名的文件名和文件后缀
			String fileNameNoEx = "";
			String filetype = "";
				if ((fileName != null) && (fileName.length() > 0)) { 
		            int dot = fileName.lastIndexOf('.'); 
		            if ((dot >-1) && (dot < (fileName.length()))) { 
//		            	System.out.println("获得不带扩展名的文件名和文件后缀");
		            	fileNameNoEx =  fileName.substring(0, dot); 
//		            	System.out.println("fileNameNoEx:"+fileNameNoEx);
		            	filetype = fileName.substring(dot+1,fileName.length());
//		            	System.out.println("filetype:"+filetype);
		            } 
		        } 
		       
				// 对文件名加上当前时间进行hash处理
			MD5Implementation md5Implementation = new MD5Implementation();
			String fileHashName = md5Implementation.createPassPhrase(fileNameNoEx+now);
			
			//在red5服务器的upload/files下新建文件夹（名字为fileHashName），为后面把上传的文件重命名后生成pdf、swf等格式，生成xml文件作准备
			String red5FilePath = "E:\\conference\\opm\\3.0.x\\dist\\red5\\webapps\\openmeetings\\upload\\files\\"+fileHashName+"\\";
			File newFile =new File(red5FilePath);
			if(newFile.exists())
			 {
//			      System.out.println("多级目录已经存在不需要创建！！");
			  
			}else{
			       //如果要创建的多级目录不存在才需要创建。
			       newFile.mkdirs();
			      }
			
			// 复制文件
				FileInputStream fi = null;
		        FileOutputStream fo = null;
		        FileChannel in = null;
		        FileChannel out = null;
		        
		        try {
		        	fi = new FileInputStream(folder+"\\"+fileName);

		            fo = new FileOutputStream(newFile+"\\"+fileName);

		            in = fi.getChannel();//得到对应的文件通道

		            out = fo.getChannel();//得到对应的文件通道

		            in.transferTo(0, in.size(), out);//连接两个通道，并且从in通道读取，然后写入out通道
				} catch (Exception e) {
					// TODO: handle exception
//					System.out.println("复制文件时出错啦！");
					e.printStackTrace();
				}
		        
		        try {

	                fi.close();

	                in.close();

	                fo.close();

	                out.close();

	            } catch (IOException e) {

	                e.printStackTrace();

	            }
		    // 文件重命名
		        
		        File File1 = new File(red5FilePath+fileName);
		        File FileOriginal = new File(red5FilePath+fileHashName+"."+filetype);
		      if (File1.exists()) {		    	   
			        File1.renameTo(FileOriginal);
//			        System.out.println("转化后的文件名为："+FileOriginal.getName());
			} else {
//					System.out.println("文件重命名错误！");
			}		      
		       		  
		        
		    // 生成pdf，swf，xml文件
		      //topdf
		        if (FileOriginal.exists()) {
//		        	System.out.println("正要转化为pdf！");
		        	String openOfficePath = "E:\\conference\\OpenOffice 4\\";
		        	OfficeToPDFTools otp = new OfficeToPDFTools();
		        	otp.startService(openOfficePath);
//			        System.out.println("openoffice 启动成功！");
			        otp.threadOfficeToPDF(red5FilePath+fileHashName+"."+filetype, red5FilePath+fileHashName+".pdf");
		
				}else {
//					System.out.println("找不到源文件，无法转化为pdf");
				}
		        
		        TimeUnit.MILLISECONDS.sleep(120000);//休息一分钟
		        
		      //to swf
		        if (new File(red5FilePath+fileHashName+".pdf").exists()) {
					Pdf2Swf.pdfToSwf(red5FilePath+fileHashName+".pdf", red5FilePath, fileHashName+".swf");
				} else {
//					System.out.println("找不到pdf文件，无法转化为swf");
				}
		        
		        TimeUnit.MILLISECONDS.sleep(60000);//休息一分钟
		        
		       // xml
		        File filePdf = new File(red5FilePath+fileHashName+".pdf"); 
		        File fileSwf = new File(red5FilePath+fileHashName+".swf");

		        String originalSize =Long.toString(FileOriginal.lastModified());
		        String pdfSize = Long.toString(filePdf.lastModified());		        		
		        String swfSize =  Long.toString(fileSwf.lastModified());	
		        
		        if (FileOriginal.exists()&&filePdf.exists()&&fileSwf.exists()) {	
		        	
		        	XmlGenerator xg = new XmlGenerator();			        
			        xg.build(red5FilePath+"library.xml",red5FilePath+fileHashName, fileHashName+"."+filetype,fileHashName+".pdf" , fileHashName+".swf", Long.toString(FileOriginal.length()), Long.toString(filePdf.length()), Long.toString(fileSwf.length()), originalSize, pdfSize,swfSize);
			       
			        try {
//			        	   System.out.println("hahh,要往数据库里写啦！1");
			        	   Date date = new Date();
//			        	   System.out.println("hahh,要往数据库里写啦！2");
					       java.sql.Date sql_date = new java.sql.Date(date.getTime());
//					       System.out.println("hahh,要往数据库里写啦！3");
					       int room_id = mysqlaction.getRoom_idbyconferName(conferName);
//					       long  room_id = (Integer) session.getAttribute("room_id");
//					       System.out.println("hahh"+room_id);
//					       System.out.println("即将往表fileexploreritem写数据！");
//					       MysqlAction mysqlAction = new MysqlAction();
					       mysqlaction.addFileInfo2Fileexploreritem(fileHashName, fileName, sql_date, room_id, sql_date);
//					       System.out.println("往表fileexploreritem写数据完成！");  
					} catch (Exception e) {
						// TODO: handle exception
					}
		        } else {
//					System.out.println("生成xml文件错误！");
				}
		        		        
		        
			//把会中系统需要的文件信息写入数据库
//		        try {
//		        	   Date date = new Date();
//				       java.sql.Date sql_date = new java.sql.Date(date.getTime());
//				       long  room_id = (Integer) session.getAttribute("room_id");
//				       System.out.println("即将往表fileexploreritem写数据！");
//				       MysqlAction mysqlAction = new MysqlAction();
//				       mysqlAction.addFileInfo2Fileexploreritem(fileHashName, fileName, sql_date, room_id, sql_date);
//				       System.out.println("往表fileexploreritem写数据完成！");  
//				} catch (Exception e) {
//					// TODO: handle exception
//				}
//		       
		}
	}
   } catch (Exception e) {
	// TODO: handle exception
	   e.printStackTrace();
   }
//     request.getRequestDispatcher("documentInfo.jsp");
   response.sendRedirect("documentInfo.jsp");
    }  
}

