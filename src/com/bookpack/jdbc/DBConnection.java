package com.bookpack.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";
	public static Connection conn;

	public void login_screen()
	{
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String user = "akarat";	
			String passwd = "200109405";

				conn = DriverManager.getConnection(jdbcURL, user, passwd);
				conn.setAutoCommit(false);
				System.out.println("Connection established.");
				
		} catch(Throwable oops) {
			oops.printStackTrace();
		}
	}
	
	protected void finalize() throws Throwable {
	     try {
	         if(!conn.isClosed())
	         {
	        	 conn.commit();
	        	 conn.close();        // close open files
	         }
	     } finally {
	         super.finalize();
	     }
	 }
}