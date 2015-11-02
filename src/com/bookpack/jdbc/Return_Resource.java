package com.bookpack.jdbc;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Return_Resource {

	private static Return_Resource return_resource = new Return_Resource( );
	public static Return_Resource getInstance( ) {
		return return_resource;	
	}	
	Login lobj;
	double patron_id;
	
	String user_type;
	
	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";
	
	public void display_resource(Login l1){
		
		Statement stmt = null;
		String sql = "" ;
		
		try{
			stmt = DBConnection.conn.createStatement();
			
		}catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(stmt != null)
			{
				try{stmt.close();}
				catch(SQLException e){
				}
			}
		}
		
	}
}
