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

				if(l1.user_type.equals("F"))
					System.out.println("4. Conference Rooms. ");

				System.out.println("-999. Go Back (Main Menu). ");

				choice = stdin.nextInt();

				switch(choice){
				case 1: show_publications();break;
				case 2: show_cameras();break;
				case 3: show_study_rooms();break;						
				case 4: show_conf_rooms();break;
				default: break;
				}

			}while(choice!=-999);
		}finally {

		}
	}

	public void show_publications(){

		int choice;

		String title = "";
		List<Double> rtype_ids = new ArrayList<Double>();
		List<String> titles = new ArrayList<String>();

		String sql = "SELECT * FROM athoma12.PUB_VIEW";
		Statement stmt = null;
		int option=0,  type=0;
		double rtype_id=0;

		try{
			stmt = DBConnection.conn.createStatement();

			ResultSet rs = stmt.executeQuery(sql);
			System.out.println(" List of all the publications : \n");

			while(rs.next()){
				title = rs.getString("title");
				rtype_id = rs.getDouble("RTYPE_ID");
				System.out.println( ++option + ". Title: \t" + title);
				rtype_ids.add(rtype_id);
				//titles.add(title);
			}

			System.out.println(" Choose any option. -999 to go back. ");
			choice = stdin.nextInt();

			if(choice == -999){
				;
			}
			else{
				rtype_id = rtype_ids.get(choice-1);						
				show_details_pub(rtype_id);
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

	public void show_details_pub(double rtype_id){

		//String sql = "{call athoma12.user_auth.pubCheckoutProc1(?,?,?,?,?,?,?,?)}";
		String sql = "select * from athoma12.PUB_CHECKOUT_VIEW where patron_id = " + 
				lobj.patron_id + "AND rtype_id = " + rtype_id;
		Statement stmt = null;
		int choice=0, type=0;
		String r_title="", r_isbn="", r_publishers="", type_pub="", r_year="";
		double r_edition=-999, r_action=0, lib_choice=0 ;
		ResultSet rs;
		double option=0;

		try{

			stmt = DBConnection.conn.prepareCall(sql);
			rs = stmt.executeQuery(sql);

			while(rs.next()){
				r_title = rs.getString(1);
				r_isbn = rs.getString(2);
				r_edition = rs.getDouble(3);
				r_publishers = rs.getString(4);
				r_year = rs.getString(5);
				r_action = rs.getDouble(6);

				System.out.println("Title: " + r_title);
				System.out.println("ISBN/ISSN/Conf No.: " + r_isbn);
				if(!"JUNK".equalsIgnoreCase(r_publishers)){
					System.out.println("Author(s): " + r_publishers);
				}
				if(r_edition!=-999){
					System.out.println("Edition: " + r_edition);
				}
				System.out.println("Year: " + r_year);
			}

			if(r_action==3){
				System.out.println("This publication is already present with you. Please follow the renew procedure to renew the book.");
				System.out.println(" Enter 2 for soft copy. ");
				type = stdin.nextInt();	
			}
			else if(r_action==4){
				System.out.println("You have renewed this publication once. You Must return the publication.");
				System.out.println(" Enter 2 for soft copy. ");
				type = stdin.nextInt();	
			}
			else if(r_action==5){
				System.out.println("You have already requested this book. You will be notified when available.");
				System.out.println(" Enter 2 for soft copy. ");
				type = stdin.nextInt();	
			}
			else if(r_action==6){
				System.out.println("This publication is reserved. Cannot be checked out.");
				System.out.println(" Enter 2 for soft copy. ");
				type = stdin.nextInt();	
			}
			else{
				System.out.println(" Enter 1 for hard copy, 2 for soft copy. ");
				type = stdin.nextInt();

			}

			if(type == 1)
			{
				type_pub = "H";
				if(r_action==1){
					System.out.println("This publication is available for issue. Press 1 to issue. ");
					choice = stdin.nextInt();

					System.out.println("Enter choice of Lib. 1: D.H. Hill. 2: James B. Hunt Library.");
					lib_choice = stdin.nextDouble();
				}
				else if(r_action==2){
					System.out.println("This publication is not currently available. Press 1 to be added to wait list. ");
					choice = stdin.nextInt();
				}				
			}
			else if(type == 2)
			{
				type_pub = "E";
				r_action = 1;
				choice = 1;

			}
			if(choice == 1)
				pub_checkout(rtype_id, r_action, type_pub, lib_choice);
			else
				System.out.println("Invalid Choice.");


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

	/*					1r_rtype_id 		IN 			athoma12.books.rtype_id%type,
						2r_patron_id		IN 			athoma12.patrons.patron_id%type,
						3r_action		  IN	 		NUMBER,
						4r_h_or_e 		  IN 			VARCHAR2,
						5r_lib_of_preference IN	 	NUMBER,
						6room_reservation_start IN	TIMESTAMP,
						7room_reservation_end IN		TIMESTAMP,
						8r_libname_of_pick_up OUT	athoma12.library.lib_name%type,
						9r_no_in_waitlist OUT		NUMBER,
	          			10r_due_time    OUT   TIMESTAMP,
	          			11borrow_id_nextval OUT NUMBER)*/

	public void pub_checkout(double rtype_id, double r_action, String type_pub, double lib_choice){

		String sql = "{call athoma12.R_CHECKOUT.Checkout_or_waitlist(?,?,?,?,?,?,?,?,?,?,?)}";
		String library_name = "", ret = "";
		java.sql.Timestamp ts2=null, ts3=null;
		CallableStatement cstmt = null;
		double wait_list_no=0, dummy=0;

		try{

			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setDouble(1, rtype_id);
			cstmt.setDouble(2, lobj.patron_id);
			cstmt.setDouble(3, r_action);
			cstmt.setString(4, type_pub);
			cstmt.setDouble(5, lib_choice);
			cstmt.registerOutParameter(6, java.sql.Types.TIMESTAMP);
			cstmt.registerOutParameter(7, java.sql.Types.TIMESTAMP);
			cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(9, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(10, java.sql.Types.TIMESTAMP);
			cstmt.registerOutParameter(11, java.sql.Types.DOUBLE);

			cstmt.execute();

			library_name = cstmt.getString(8);
			wait_list_no = cstmt.getDouble(9);
			ts2 = cstmt.getTimestamp(10);

			ret = ts2.toString();
			if(r_action == 1){
				if(ts2 != null && type_pub!="E"){			
					System.out.println("Congrats, you have checked it out. Return Date is : " + ret);
				}
				else if(type_pub == "E"){
					System.out.println("Congrats, you have checked it out. ");
				}
			}
			else if(r_action == 2){
				System.out.println(" Your wait list number is: " + wait_list_no);
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

		public void show_cameras(){
			
			String sql = "select * from athoma12.CAM_CHECKOUT_VIEW";
			Statement stmt = null;
			ResultSet rs;
			double option=0, rid=0, rtype_id=0;
			String model = "", lib_name = "";
			List<Double> rids = new ArrayList<Double>();
			List<Double> rtype_ids = new ArrayList<Double>();
			int choice;
			
			try{
				stmt = DBConnection.conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					rtype_id = rs.getDouble("RTYPE_ID"); //rtype_id
					//rtype_id = rs.getDouble("RTYPE_ID");
					model = rs.getString("DESCRIPTION");
					lib_name = rs.getString("lib_name");
					System.out.println( ++option + ". Desc: \t" + model);
					rtype_ids.add(rtype_id);
					//rtype_ids.add(rtype_id);
				}
			
				System.out.println(" Choose any option. -999 to go back. ");
				choice = stdin.nextInt();
			
				if(choice == -999){
					;
				}
				else{
					rtype_id = rtype_ids.get(choice-1);						
					show_details_cam(rtype_id);
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
		/* rid, model, memory, lens_config, make */
		public void show_details_cam(double rtype_id){
			
			Statement stmt = null;
			String sql = "select * from athoma12.CAM_CHECKOUT_VIEW WHERE RTYPE_ID =" + rtype_id;
			ResultSet rs;
			String memory = "", model = "", lens_config = "", make = "", description = "";
			int choice=0;
			
			try{
				stmt = DBConnection.conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					//memory = rs.getString("memory");
					//model = rs.getString("model");
					//lens_config = rs.getString("lens_config");
					//make = rs.getString("make");
					//rtype_id = rs.getDouble("rtype_id");
					description = rs.getString("DESCRIPTION");
					
					/*System.out.println(" Memory: " + memory);
					System.out.println(" Lens Configuration: " + lens_config);
					System.out.println(" Model: " + model);
					System.out.println(" Make: " + make);*/
					System.out.println(" Description: " + description);
				}
				
				System.out.println(" Press 1 to Reserve for upcoming friday. 2 for cancel. 3. Checkout the Camera. ");
				choice = stdin.nextInt();
				
				if(choice == 1 || choice == 3)
					cam_checkout(rtype_id, choice);
				
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
		/*Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	NA
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	VALID
	          			r_due_time    			OUT  -----------	NA
	          			borrow_id_nextval 		OUT  -----------	NA
						  );
					*/
		public void cam_checkout(double rtype_id, int choice){
			
			String sql = "{call athoma12.R_CHECKOUT.Checkout_or_waitlist(?,?,?,?,?,?,?,?,?,?,?)}";
			CallableStatement cstmt = null;
			double wait_list_no=0, borrow_id_next = 0;
			java.sql.Timestamp ts2 = null;
			
			try{
				cstmt = DBConnection.conn.prepareCall(sql);

				cstmt.setDouble(1, rtype_id);
				cstmt.setDouble(2, lobj.patron_id);
				cstmt.setDouble(3, 0);
				cstmt.setString(4, "");
				cstmt.setString(5, "");
				cstmt.setTimestamp(6, ts2);
				cstmt.setTimestamp(7, ts2);
				cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(9, java.sql.Types.DOUBLE);
				cstmt.registerOutParameter(10, java.sql.Types.TIMESTAMP);
				cstmt.registerOutParameter(11, java.sql.Types.DOUBLE);
				
				if(choice == 1){
					cstmt.setDouble(3, 2);
					cstmt.registerOutParameter(9, java.sql.Types.DOUBLE);
					
					cstmt.execute();
					
					wait_list_no = cstmt.getDouble(9);
					
					if(wait_list_no == 1){
						System.out.println(" You have successfully reserved the camera. Your check out date is friday 9am ");
					}
					else if(wait_list_no > 1){
						System.out.println(" Camera is not available. You have been added to queue. Your number is : " + wait_list_no);
					}
				}
				
				else if(choice == 2){
					cstmt.setDouble(3, 1);
					cstmt.registerOutParameter(11, java.sql.Types.DOUBLE);
					
					cstmt.execute();
					
					System.out.println(" You have checked out the camera. ");
				}
				
			}catch(SQLException e){
				e.printStackTrace();
			} finally {
				
			}
		}

}
