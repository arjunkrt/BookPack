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

			int choice;
			double start_time, duration;			
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
						case 2: if(l1.user_type == "Student"){		/* Value of Student/teacher check with DB */
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

	public void show_publications(){
		
			int choice;

			String title = "";
			List<Double> rtype_ids = new ArrayList<Double>();
			List<String> titles = new ArrayList<String>();
			
			//String sql = "{call athoma12.user_auth.<funcname>(?,?)}";
			String sql = "SELECT * FROM PUB_VIEW";
			Statement stmt = null;
			int option=0,  type=0;
			double rtype_id=0;
			
				try{
					//cstmt = DBConnection.conn.prepareCall(sql);
					stmt = DBConnection.conn.createStatement();
					ResultSet rs = stmt.executeQuery(sql);
					
					System.out.println(" List of all the publications : \n");
					
					while(rs.next()){
						title = rs.getString(2);
						rtype_id = rs.getDouble(1);
						System.out.println( option + ". Title: \t" + title);
						rtype_ids.add(rtype_id);
						//titles.add(title);
						option++;
					}
					
					System.out.println(" Choose any option. -999 to go back. ");
					choice = stdin.nextInt();
					System.out.println(" Press 1 for Hard copy, 2 for Soft copy. ");
					type = stdin.nextInt();
					
					if(choice == -999){
						;
					}
					else{
						rtype_id = rtype_ids.get(choice);						
						show_details_pub(rtype_id, type);
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
	
	/* 				1 r_rtype_id 		IN			pkattep.books.rtype_id%type,
					2 r_h_or_e 		IN 			VARCHAR2,
					3 r_title			OUT 		pkattep.publications.title%type,
					4 r_isbn 			OUT 		pkattep.books.isbn%type,
					5 r_edition 		OUT 		pkattep.books.edition%type,
					6 r_publishers 	OUT 		pkattep.books.publishers%type,
					7 r_year 		 	OUT 		pkattep.publications.year%type,
					8 r_action		OUT 		NUMBER*/
	
	public void show_details_pub(double rtype_id, int type){
		
		String sql = "{call athoma12.user_auth.pubCheckoutProc1(?,?,?,?,?,?,?,?)}";
		CallableStatement cstmt = null;
		//Statement stmt = null;
		int choice=0;
		String r_title, r_isbn, r_publishers;
		double r_edition, r_year, r_action;
		
		try{
		
			cstmt = DBConnection.conn.prepareCall(sql);
			
			cstmt.setDouble(1,rtype_id);
			if(type==1)
				cstmt.setString(2,"h");
			else
				cstmt.setString(2,"e");
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(5, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(7, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(8, java.sql.Types.DOUBLE);

			cstmt.execute();
			
			r_title = cstmt.getString(3);
			r_isbn = cstmt.getString(4);
			r_edition = cstmt.getDouble(5);
			r_publishers = cstmt.getString(6);
			r_year = cstmt.getDouble(7);
			r_action = cstmt.getDouble(8);
			
			System.out.println("Title: " + r_title);
			System.out.println("ISBN: " + r_isbn);
			System.out.println("Author: " + r_publishers);
			System.out.println("Edition: " + r_edition);
			System.out.println("Year: " + r_year);
			
			if(r_action==1){
				System.out.println("This book is available for issue. Press 1 to issue. ");
				choice = stdin.nextInt();
			}
			else if(r_action==2){
				System.out.println("This book is not currently available. Press 1 to be added to wait list. ");
				choice = stdin.nextInt();
			}
			else if(r_action==3){
				System.out.println("This book is already present with you. Press 1 to renew the book.");
				choice = stdin.nextInt();
			}
			else if(r_action==4){
				System.out.println("You have renewed this book once. You Must return the book.");
			}
			
			if(choice == 1)
				pub_checkout(rtype_id, r_action);
			else
				System.out.println("Invalid Choice.");

					
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
	/*				1r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					2r_patron_id		IN 			athoma12.patrons.patron_id%type,
					3r_action		IN	 		NUMBER,
					4r_checkout_time IN	 		DATETIME,
--					Commented 5r_return_time 	IN			DATETIME,
					5r_due_time		OUT 		DATETIME*/

	public void pub_checkout(double rtype_id, double r_action){
		
		String sql = "{call athoma12.user_auth.pubCheckoutProc2(?,?,?,?,?,?)}";
		String checkout, ret;
		java.sql.Timestamp ts2, ts3=null;
		CallableStatement cstmt = null;
		
		try{
		
			cstmt = DBConnection.conn.prepareCall(sql);
			System.out.println("Enter Checkout Date: ");
			checkout = stdin.nextLine();			
			ts2 = java.sql.Timestamp.valueOf(checkout);// Format : "2005-04-06 09:01:10"
			
			cstmt.setDouble(1, rtype_id);
			cstmt.setDouble(2, lobj.patron_id);
			cstmt.setDouble(3, r_action);
			cstmt.setTimestamp(4, ts2);
			cstmt.registerOutParameter(5, java.sql.Types.TIMESTAMP);
						
			cstmt.execute();
			
			ts3 = cstmt.getTimestamp(5);
			ret = ts3.toString();
			if(ts3 != null){			
				System.out.println("Congrats, you have checked it out. Return Date is : " + ret);
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
	
	/*roomCheckoutProc1(
					1 r_patron_id		IN 			athoma12.patrons.patron_id%type,
					2 r_no_occupants	IN			NUMBER,
					3 r_libid			IN 			pkattep.publications_authors.aid%type
					4 r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME*/
		public void show_study_rooms(){

			int choice;
			double r_no_occupants, r_libid, room_id, rtype_id;
			java.sql.Timestamp ts2;
			
			List<Double> rtype_ids = new ArrayList<Double>();
			String checkout = "";
		
			String sql = "{call athoma12.user_auth.roomCheckout1(?,?,?,?)}";
			String sql1 = "SELECT * FROM <view_name>";
			CallableStatement cstmt = null;
			Statement stmt = null;
			ResultSet rs;
			
			int option=0;
			
			System.out.println("Enter Required capacity. ");
			r_no_occupants = stdin.nextDouble();
			
			System.out.println("Enter Lib ID ( Hill = 1, Hunt=2)");
			r_libid = stdin.nextDouble();
			
			System.out.print("Enter Checkout Time");		//Correct format required
			checkout = stdin.nextLine();
			
			ts2 = java.sql.Timestamp.valueOf(checkout);
									
			try{
				cstmt = DBConnection.conn.prepareCall(sql);
				
				cstmt.setDouble(1, lobj.patron_id);
				cstmt.setDouble(2, r_no_occupants);
				cstmt.setDouble(3, r_libid);
				cstmt.setTimestamp(4, ts2);
				
				cstmt.execute();
				
				System.out.println(" Select the room number. List of all the rooms as per requirement : \n");
				
				stmt = DBConnection.conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					room_id = rs.getDouble("room_id");
					rtype_id = rs.getDouble("rtype_id");
					System.out.println( option + ". Room no.: \t" + room_id);
					rtype_ids.add(rtype_id);
					option++;
				}
				
				System.out.println(" Choose any option. -999 to go back. ");
				
				choice = stdin.nextInt();
				if(choice == 999){
					;
				}
				else{
					rtype_id = rtype_ids.get(choice);
					reserve_room(rtype_id, ts2);
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
					if(cstmt != null)
					{
						try{cstmt.close();}
						catch(SQLException e){
						}
					}
				}
			
		}
		
		public void show_conf_rooms(){
			
			int choice;
			double r_no_occupants, r_libid = 2, room_id, rtype_id;
			java.sql.Timestamp ts2;
			
			List<Double> rtype_ids = new ArrayList<Double>();
			String checkout = "";
		
			String sql = "{call athoma12.user_auth.roomCheckout1(?,?,?,?)}";
			String sql1 = "SELECT * FROM <view_name>";
			CallableStatement cstmt = null;
			Statement stmt = null;
			ResultSet rs;
			
			int option=0;
			
			System.out.println("Enter Required capacity. ");
			r_no_occupants = stdin.nextDouble();
			
			System.out.print("Enter Checkout Time");		//Correct format required
			checkout = stdin.nextLine();
			
			ts2 = java.sql.Timestamp.valueOf(checkout);
									
			try{
				cstmt = DBConnection.conn.prepareCall(sql);
				
				cstmt.setDouble(1, lobj.patron_id);
				cstmt.setDouble(2, r_no_occupants);
				cstmt.setDouble(3, r_libid);
				cstmt.setTimestamp(4, ts2);
				
				cstmt.execute();
				
				System.out.println(" Select the room number. List of all the rooms as per requirement : \n");
				
				stmt = DBConnection.conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					room_id = rs.getDouble("room_id");
					rtype_id = rs.getDouble("rtype_id");
					System.out.println( option + ". Room no.: \t" + room_id);
					rtype_ids.add(rtype_id);
					option++;
				}
				
				System.out.println(" Choose any option. -999 to go back. ");
				
				choice = stdin.nextInt();
				if(choice == -999){
					;
				}
				else{
					rtype_id = rtype_ids.get(choice);
					reserve_room(rtype_id, ts2);
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
					if(cstmt != null)
					{
						try{cstmt.close();}
						catch(SQLException e){
						}
					}
				}
			
		}
		public void reserve_room(double rtype_id, java.sql.Timestamp ts2){
			
			String sql = "{call athoma12.user_auth.roomCheckout2(?,?,?)}";
			CallableStatement cstmt = null ;		
					
			try{
				cstmt = DBConnection.conn.prepareCall(sql);
				
				cstmt.setDouble(1, rtype_id);
				cstmt.setDouble(2, lobj.patron_id);
				cstmt.setTimestamp(3, ts2);	
				
				System.out.println(" Room has been reserved successfully.");
				
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
		public static void show_cameras(){
			
			String sql = "SELECT * FROM CAM_VIEW";
			Statement stmt = null;
			ResultSet rs;
			double option=0, rtype_id;
			String model;
			List<Double> rtype_ids = new ArrayList<Double>();
			int choice;
			
			try{
				stmt = DBConnection.conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					rtype_id = rs.getDouble("CAMERA_ID");
					model = rs.getString("model");
					System.out.println( option + ". Model: \t" + model);
					rtype_ids.add(rtype_id);
					option++;
				}
				
				System.out.println(" Enter your choice number. -999 to exit. ");
				choice = stdin.nextInt();
				
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
