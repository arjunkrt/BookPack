package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class search {
	
	static Scanner stdin = new Scanner(System.in);
	
	public static void search_resource(){
		try{
			int choice, start_time, duration;
			String res_name="";
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			
			try{
					do{	
						System.out.println("1. Search Publications. ");
						System.out.println("2. Search Camera. ");
						System.out.println("3. Search Room. ");
						System.out.println("4. Display all available Cameras. ");
						System.out.println("5. View available Rooms. ");
						System.out.println("999. Quit. ");
						choice = stdin.nextInt();
						
						switch(choice){
						case 1: System.out.println(" Enter name of the book. ");
								res_name = stdin.nextLine();break;
						case 2: System.out.println(" Enter name of the camera. ");
								res_name = stdin.nextLine();break;
						case 5: System.out.println("Enter time slot start time. ");
								res_name = stdin.nextLine();break;
						default: ;break;
						}
						
						String sql = "{ ? = call USER_AUTH.SEARCH_RESOURCE(?,?) }";
						CallableStatement cstmt = conn.prepareCall(sql);
						cstmt.registerOutParameter(1, java.sql.Types.INTEGER);  
						cstmt.setString(2,String.valueOf(choice));
						cstmt.setString(3,res_name);
						
						cstmt.execute();
						
						
						
		
					}while(choice!=999);
			}finally {
				close(rs);
				close(stmt);
				close(conn);
			}
		}
			catch(Throwable oops) {
		oops.printStackTrace();
		}
	}

	static void close(Connection conn) {
		if(conn != null) {
			try { conn.close(); } catch(Throwable whatever) {}
		}
	}
	
	static void close(Statement st) {
		if(st != null) {
			try { st.close(); } catch(Throwable whatever) {}
		}
	}
	static void close(ResultSet rs) {
		if(rs != null) {
			try { rs.close(); } catch(Throwable whatever) {}
		}
	}
	
}
