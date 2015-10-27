package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;

public class Resource {
	
private static Resource resource = new Resource( );
	
	public static Resource getInstance( ) {
		return resource;
	}
	
	Login lobj;
	double patron_id;
	
	String user_type;
	
	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";
	
	public void show_resource(Login l1){

			int choice, start_time, duration;			
			lobj = l1;
			try{
					do{	
						System.out.println("1. Publications. ");
						System.out.println("2. Camera. ");
						System.out.println("3. Study Rooms. ");
						
						if(l1.user_type == "Teacher");
							System.out.println("4. Conference Rooms. ");
	
						System.out.println("99. Go Back (Main Menu). ");
						
						choice = stdin.nextInt();
						
						switch(choice){
						case 1: show_publications();break;
						case 2: if(l1.user_type == "Student"){
									show_study_rooms();
									break;
								}
								else if(l1.user_type == "Teacher"){
									show_conf_rooms();
									break;
								}
						case 3: show_cameras();break;
						case 4: break;
						default: break;
						}
		
					}while(choice!=999);
			}finally {
				
			}
	}

	static void show_publications(){
		
			int choice;

			String title = "";
			List<String> titles = new ArrayList<String>();
			
			//String sql = "{call athoma12.user_auth.<funcname>(?,?)}";
			String sql = "SELECT TITLE FROM PUBLICATION <table_name/view_name>";
			//CallableStatement cstmt = null;
			Statement stmt = null;
			int option=0;
			
				try{
					//cstmt = DBConnection.conn.prepareCall(sql);
					stmt = DBConnection.conn.createStatement();
					ResultSet rs = stmt.executeQuery(sql);
					
					System.out.println(" List of all the publications : \n");
					
					while(rs.next()){
						title = rs.getString("TITLE");
						System.out.println( option + ". Title: \t" + title);
						titles.add(title);
						option++;
					}
					
					System.out.println(" Choose any option. 999 to go back. ");
					
					choice = stdin.nextInt();
					if(choice == 999){
						;
					}
					else{
						title = titles.get(choice);
					}
					
					show_details_pub(title);
					
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
	
	public static void show_details_pub(String title){
		
		String sql = "SELECT * FROM <table_name/view_name> WHERE TITLE = " + title;
		//CallableStatement cstmt = null;
		Statement stmt = null;
		int choice;
		
		try{
		
			stmt = DBConnection.conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			
			System.out.println("Title: " + rs.getString("TITLE"));
			System.out.println("Author: " + rs.getString("AUTHOR"));
			System.out.println("Status: " + rs.getString("STATUS"));
			
			if(rs.getString("STATUS") != "checked out"){
				System.out.println(" This has not been checked out.\n1. Press 1 to check out. \n2. Go Back.  ");
				choice = stdin.nextInt();
				if(choice == 1){
					pub_checkout(title);
				}
			}
			else{
				System.out.println(" This has been checked out. Press 1 to add to the waitlist queue. ");
				choice = stdin.nextInt();
				if(choice == 1){
					pub_add_queue(title);
				}	
			}
					
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

	public static void pub_checkout(String title){
		
		String sql = "";
		String checkout, ret;
		//CallableStatement cstmt = null;
		Statement stmt = null;
		int choice, flag=0;
		
		try{
		
			while(flag==0){
				System.out.println("Enter Checkout Date: ");
				checkout = stdin.nextLine();
				
				System.out.println("Enter Return Date: ");
				ret = stdin.nextLine();
			
				if(true){
					// This if should check the constraint for Return Date and Check ot Date
					sql = "";
					stmt = DBConnection.conn.createStatement();
					if(stmt.executeUpdate(sql)!=0){										
						System.out.println(" Book has been checked out by you. ");
						flag = 1;
					}
				}
				else{
					System.out.println(" Book cannot be checked out for the desired period. ");
				}
			}
					
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
		public static void pub_add_queue(String title){

			String sql = "Query to Add to the waitlist queue.";
			String checkout, ret;
			Statement stmt = null;

			int choice, flag=0;			
			try{
					stmt = DBConnection.conn.createStatement();
					if(stmt.executeUpdate(sql)!=0){										
						System.out.println(" Book has been checked out by you. ");
						flag = 1;
					}
					
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
		public static void show_study_rooms(){

			int choice;

			String title = "";
			List<String> titles = new ArrayList<String>();
			
			//String sql = "{call athoma12.user_auth.<funcname>(?,?)}";
			String sql = "SELECT TITLE FROM PUBLICATION <table_name/view_name>";
			//CallableStatement cstmt = null;
			Statement stmt = null;
			int option=0;
			
				try{
					//cstmt = DBConnection.conn.prepareCall(sql);
					stmt = DBConnection.conn.createStatement();
					ResultSet rs = stmt.executeQuery(sql);
					
					System.out.println(" List of all the publications : \n");
					
					while(rs.next()){
						title = rs.getString("TITLE");
						System.out.println( option + ". Title: \t" + title);
						titles.add(title);
						option++;
					}
					
					System.out.println(" Choose any option. 999 to go back. ");
					
					choice = stdin.nextInt();
					if(choice == 999){
						;
					}
					else{
						title = titles.get(choice);
					}
					
					show_details_pub(title);
					
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
		public static void show_conf_rooms(){
			
		}
		public static void show_cameras(){
			
		}


}
