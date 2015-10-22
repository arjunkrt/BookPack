package com.bookpack.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";
	public static Connection conn;

	public void JDBCConnection()
	{
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String user = "";	
			String passwd = "";

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
