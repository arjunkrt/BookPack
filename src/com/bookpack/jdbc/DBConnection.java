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

			String user = "ghanams";	
			String passwd = "200109966";


				conn = DriverManager.getConnection(jdbcURL, user, passwd);
				conn.setAutoCommit(false);
				
		} catch(Throwable oops) {
			oops.printStackTrace();
		}
	}
	
	protected void finalize() throws Throwable {
	     try {
	         if(!conn.isClosed())
	         {
	        	 conn.commit();
	        	 conn.close();        
	         }
	     } finally {
	         super.finalize();
	     }
	 }
}
