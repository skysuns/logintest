package com.zhang.javabean;

import java.io.File;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

//import toswf.Pdf2Swf;

public class LastMod {
	
	static File file = new File("D:/library.xml");

	 

	static long time = file.lastModified();

	 

	static Date d = new Date(time);

	 

	static Format simpleFormat = new SimpleDateFormat("E dd MMM yyyy hh:mm:ss a");

	 

	static String dateString = simpleFormat.format(d);
	
	static String time1=new Long(file.lastModified()).toString();
	static String time2=Long.toString(file.lastModified());
	//"lastmod", (new Long(thumbfile.lastModified())).toString()

	 
	public static void main(String[] args) {  
//    	Pdf2Swf.pdfToSwf("D://project//file//test.pdf", "D://project//file//test.swf");  
    	System.out.println(file.getName()+"最后修改时间："+dateString);
    	System.out.println(time1+";"+time2);
    }  
	
	
}
