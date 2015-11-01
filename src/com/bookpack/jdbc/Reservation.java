package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Reservation {

private static Reservation reservation = new Reservation( );
	
	public static Reservation getInstance( ) {
		return reservation;
	}
	
	Login lobj;
	double patron_id;
	
	String user_type;
	
	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";
	
	public void reservation_publications(Login l1){
		
		int choice; 
		
		lobj = l1;
		System.out.println("1. Reserve a Book for your students. ");
		System.out.println("2. Unreserve a book reserved by you. ");
		
		choice = stdin.nextInt();
		display(choice);		
	}
	
	public void display(int choice){
		int option=0;
		String sql1 = "SELECT * FROM athoma12.FAC_COURSE_BOOKS WHERE PATRON_ID = "+ lobj.patron_id 
				+ " AND RESERVED = 0";
		String sql2 = "SELECT * FROM athoma12.FAC_COURSE_BOOKS WHERE PATRON_ID = "+ lobj.patron_id 
				+ " AND RESERVED = 1";
		String title;
		Statement stmt = null;
		ResultSet rs;
		List<Double> rtype_ids = new ArrayList<Double>();
		double rtype_id;		
		
		try{
			stmt = DBConnection.conn.createStatement();
			if(choice == 1)
			{
				rs = stmt.executeQuery(sql1);			
				while(rs.next()){
					title = rs.getString(4);
					rtype_id = rs.getDouble(10);
					System.out.println( ++option + title);
					rtype_ids.add(rtype_id);
				}
				
				if(option == 0)
					System.out.println("You have no books to reserve. ");
				else{
					System.out.println("Enter your choice. ");
					choice = stdin.nextInt();
					update_table(rtype_ids.get(choice-1), 1);
				}					
			}
			else if(choice==2){
				rs = stmt.executeQuery(sql2);				
				while(rs.next()){
					title = rs.getString(4);
					rtype_id = rs.getDouble(10);
					System.out.println( ++option + title);
					rtype_ids.add(rtype_id);
				}				
				if(option == 0)
					System.out.println("You have no books to unreserve. ");
				else{
					System.out.println("Enter your choice. ");
					choice = stdin.nextInt();
					update_table(rtype_ids.get(choice-1), 0);
		
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
	
	public void update_table(double rtype_id, int act){
		
		String sql = "{call athoma12.user_auth.updateBookReservation(?,?)}";
		CallableStatement cstmt = null;
		String action = "";
		
		try{
			cstmt = DBConnection.conn.prepareCall(sql);
			if(act == 1)
				action = "R";
			else if(act == 0)
				action = "U";
			
			cstmt.setDouble(1, rtype_id);
			cstmt.setString(2,  action);
			
			if(cstmt.execute()){
				if(act == 1){
					System.out.println(" Book has been successsfully reserved. ");
				}
				else
					System.out.println(" Book has been successsfully unreserved. ");
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(cstmt != null)
			{
				try{cstmt.close();}
				catch(SQLException e){
				}
			}
		}
		
		
	}
	
}
