package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;


public class ResourceCheckout {

	static Scanner stdin = new Scanner(System.in);

	private static ResourceCheckout resource_check_out = new ResourceCheckout( );

	public static ResourceCheckout getObject( ) {
		return resource_check_out;
	}
	public void display_pub_books(Login login,double rtype_id)
	{
		String sql = "SELECT * FROM athoma12.book_rid_details where rtype_id = ? and rownum<2";
		PreparedStatement cstmt= null;
		ResultSet rs = null;

		try
		{
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, rtype_id);

			rs = cstmt.executeQuery();

			System.out.print("RID			");
			System.out.print("LIB_NAME		");
			System.out.print("ISBN		");
			System.out.print("PUBLISHERS		");
			System.out.print("YEAR		");
			System.out.println("TITLE		");

			while(rs.next())
			{	
				System.out.print(rtype_id);
				System.out.print("		");
				String lib_name = rs.getString("LIB_NAME");
				System.out.print(lib_name);
				System.out.print("		");
				String isbn = rs.getString("ISBN");
				System.out.print(isbn);
				System.out.print("		");
				String publishers = rs.getString("PUBLISHERS");
				System.out.print(publishers);
				System.out.print("			");
				int year = rs.getInt("YEAR");
				System.out.print(year);
				System.out.print("		  ");
				String title = rs.getString("TITLE");
				System.out.println(title);
			}
		}
		catch (SQLException e) {
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

	public void display_pub_conf(Login login,double rtype_id)
	{
		String sql = "SELECT * FROM athoma12.conf_proc_rid_details where rtype_id = ? and rownum<2";
		PreparedStatement cstmt = null;
		ResultSet rs = null;

		try
		{
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, rtype_id);

			rs = cstmt.executeQuery();

			System.out.print("RID			");
			System.out.print("LIB_NAME		");
			System.out.print("CONF NO		");
			System.out.print("CONF NAME		");
			System.out.print("STATUS		");
			System.out.print("YEAR		");
			System.out.println("TITLE		");

			while(rs.next())
			{	
				System.out.print(rtype_id);
				System.out.print("		");
				String lib_name = rs.getString("LIB_NAME");
				System.out.print(lib_name);
				System.out.print("		");
				String conf_no = rs.getString("CONF_NO");
				System.out.print(conf_no);
				System.out.print("		");
				String conf_name = rs.getString("CONF_NAME");
				System.out.print(conf_name);
				System.out.print("			");
				String status = rs.getString("STATUS");
				System.out.print(status);
				System.out.print("			");
				String year = rs.getString("YEAR");
				System.out.print(year);
				System.out.print("			");
				String title = rs.getString("TITLE");
				System.out.println(title);
			}
		}
		catch (SQLException e) {
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

	public void display_pub_journal(Login login,double rtype_id)
	{
		String sql = "SELECT * FROM athoma12.journal_rid_details where rtype_id = ? and rownum<2";
		PreparedStatement cstmt = null;
		ResultSet rs = null;

		try
		{
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, rtype_id);

			rs = cstmt.executeQuery();

			System.out.print("RID			");
			System.out.print("LIB_NAME		");
			System.out.print("ISSN		");
			System.out.print("STATUS		");
			System.out.print("YEAR		");
			System.out.println("TITLE		");

			while(rs.next())
			{	
				System.out.print(rtype_id);
				System.out.print("		");
				String lib_name = rs.getString("LIB_NAME");
				System.out.print(lib_name);
				System.out.print("		");
				String issn = rs.getString("ISSN");
				System.out.print(issn);
				System.out.print("		");
				String status = rs.getString("STATUS");
				System.out.print(status);
				System.out.print("			");
				String year = rs.getString("YEAR");
				System.out.print(year);
				System.out.print("			");
				String title = rs.getString("TITLE");
				System.out.println(title);
			}
		}
		catch (SQLException e) {
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

	public void display_camera_details(Login login,double rid)
	{
		String sql = "SELECT * FROM athoma12.journal_rid_details where rid = ?";
		PreparedStatement cstmt = null;
		ResultSet rs = null;

		try
		{
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, rid);

			rs = cstmt.executeQuery();

			System.out.print("RESOURCE ID		");
			System.out.print("LIB_NAME		");
			System.out.print("CAM ID		");
			System.out.print("STATUS		");
			System.out.print("MAKE		");
			System.out.println("MODEL		");
			System.out.println("MEMORY		");
			System.out.println("LENS CONFIG		");

			while(rs.next())
			{	
				System.out.print(rid);
				System.out.print("		");
				String lib_name = rs.getString("LIB_NAME");
				System.out.print(lib_name);
				System.out.print("		");
				String cam_id = rs.getString("CAM_ID");
				System.out.print(cam_id);
				System.out.print("		");
				String status = rs.getString("STATUS");
				System.out.print(status);
				System.out.print("			");
				String make = rs.getString("MAKE");
				System.out.print(make);
				System.out.print("			");
				String model = rs.getString("MODEL");
				System.out.print(model);
				System.out.print("			");
				String memory = rs.getString("MEMORY");
				System.out.print(memory);
				System.out.print("			");
				String lens_config = rs.getString("LENS_CONFIG");
				System.out.println(lens_config);
			}
		}
		catch (SQLException e) {
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

	public void display_room_details(Login login,double rid)
	{
		String sql = "SELECT * FROM athoma12.rooms_rid_details where rid = ?";
		PreparedStatement cstmt = null;
		ResultSet rs = null;

		try
		{
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, rid);

			rs = cstmt.executeQuery();

			System.out.print("RESOURCE ID		");
			System.out.print("LIB_NAME		");
			System.out.print("ROOM ID		");
			System.out.print("STATUS		");
			System.out.print("POSITION		");
			System.out.print("CAPACITY		");
			System.out.println("ROOM TYPE		");

			while(rs.next())
			{	
				System.out.print(rid);
				System.out.print("		");
				String lib_name = rs.getString("LIB_NAME");
				System.out.print(lib_name);
				System.out.print("		");
				String room_id = rs.getString("ROOM_ID");
				System.out.print(room_id);
				System.out.print("		");
				String status = rs.getString("STATUS");
				System.out.print(status);
				System.out.print("	");
				String position = rs.getString("POSITION");
				System.out.print(position);
				System.out.print("		 ");
				String capacity = rs.getString("CAPACITY");
				System.out.print(capacity);
				System.out.print("	   		");
				String room_type = rs.getString("ROOMTYPE");
				System.out.println(room_type);
			}
		}
		catch (SQLException e) {
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

	public void checked_out_resources_details(Login login)
	{	

		List<Double> rids = new ArrayList<Double>();
		List<Double> rtypeids = new ArrayList<Double>();
		List<String> rtypes = new ArrayList<String>();

		int sl_no = 0;
		double rid=0, rtype_id=0, borrow_id=0;
		String r_type = "";
		int func = 0;
		
		String sql = "select BORROW_ID,rid, rtype_id, E_OR_H, TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time, checkout_time from athoma12.user_checkout_summary where patron_id = ?";

		PreparedStatement pstmt=null;
		ResultSet rs = null;

		try {
			pstmt = DBConnection.conn.prepareStatement(sql);
			pstmt.setDouble(1, login.patron_id);

			rs = pstmt.executeQuery();

			while(rs.next())
			{
				sl_no++;
				borrow_id = rs.getDouble("BORROW_ID");
				r_type = rs.getString("TYPE");
				rid = rs.getDouble("RID");
				rtype_id = rs.getDouble("RTYPE_ID");
				rids.add(rid);
				rtypes.add(r_type);
				rtypeids.add(rtype_id);

			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null)
			{
				try{pstmt.close();}
				catch(SQLException e){
				}
			}
		}

		if(sl_no == 0)
		{
			System.out.println("You dont have any resource to view the details");
		}
		else
		{
			System.out.println("<Menu>");	
			System.out.println("Enter the serial no to view the details");
			System.out.print("Enter your Choice >> ");


			func = stdin.nextInt();
			stdin.nextLine();

			rid = rids.get(func-1);
			rtype_id = rtypeids.get(func-1);
			r_type = rtypes.get(func-1);
			if(r_type.equals("PB"))
			{
				display_pub_books(login,rtype_id);
			}
			else if(r_type.equals("PC"))
			{
				display_pub_conf(login,rtype_id);
			}
			else if(r_type.equals("PJ"))
			{
				display_pub_journal(login,rtype_id);
			}
			else if(r_type.equals("C"))
			{
				display_camera_details(login,rid);
			}
			else if(r_type.equals("RC"))
			{
				display_room_details(login,rid);
			}
			else if(r_type.equals("RS"))
			{
				display_room_details(login,rid);
			}
		}

		do
		{
			System.out.println("1. GO back");
			System.out.print("Enter your Choice >> ");

			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				display_checked_out_resources(login);
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(func!=999);


	}

	public void renew_procedure(Login lobj, double rid, String r_type, double borrow_id, double rtype_id){

		String sql = "select * from athoma12.PUB_CHECKOUT_VIEW where patron_id = " + 
				lobj.patron_id + "AND rtype_id = " + rtype_id;

		String sql1 = "{call athoma12.R_CHECKOUT.Renew(?,?,?)}";
		CallableStatement cstmt = null;

		Statement stmt = null;
		String ret_date = "";
		java.sql.Timestamp ts2=null;

		double r_action=0 ;
		ResultSet rs;

		try{

			stmt = DBConnection.conn.prepareCall(sql);
			rs = stmt.executeQuery(sql);

			while(rs.next()){
				r_action = rs.getDouble(6);
			}

			//System.out.println(" RACTION =" + r_action);

			if(r_action==4){
				System.out.println("You cannot renew this resource, there are people waiting in the queue for this resource.");
			}

			else if(r_action==3){
				try{
					cstmt = DBConnection.conn.prepareCall(sql1);

					cstmt.setDouble(1, borrow_id);
					cstmt.setDouble(2, lobj.patron_id);
					cstmt.registerOutParameter(3, java.sql.Types.TIMESTAMP);

					cstmt.execute();

					ts2 = cstmt.getTimestamp(3);
					ret_date = ts2.toString();
					System.out.println(" Congrats, you have renewed it. Your return date is: "+ ret_date);

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

	public void renew_resources(Login login)
	{
		List<Double> rtypeids = new ArrayList<Double>();
		List<Double> rids = new ArrayList<Double>();
		List<Double> borrowids = new ArrayList<Double>();
		List<String> rtypes = new ArrayList<String>();
		
		double rid=0, rtype_id=0, borrow_id=0;
		String r_type = "";
		int func = 0;
		int sl_no=0;
		
		String sql = "select BORROW_ID,rid, rtype_id, E_OR_H, TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time, checkout_time from athoma12.user_checkout_summary where patron_id = ?";

		PreparedStatement pstmt=null;
		ResultSet rs = null;

		try {
			pstmt = DBConnection.conn.prepareStatement(sql);
			pstmt.setDouble(1, login.patron_id);

			rs = pstmt.executeQuery();

			while(rs.next())
			{
				sl_no++;
				borrow_id = rs.getDouble("BORROW_ID");
				r_type = rs.getString("TYPE");
				rid = rs.getDouble("RID");
				rtype_id = rs.getDouble("RTYPE_ID");
				rids.add(rid);
				rtypeids.add(rtype_id);
				borrowids.add(borrow_id);
				rtypes.add(r_type);

			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null)
			{
				try{pstmt.close();}
				catch(SQLException e){
				}
			}
		}


		if(sl_no == 0)
		{
			System.out.println("You dont have any resource to renew");
		}
		else
		{
			System.out.println("<Menu>");	
			System.out.println("Enter the serial no to renew the resource");
			System.out.print("Enter your Choice >> ");

			func = stdin.nextInt();
			stdin.nextLine();

			borrow_id = borrowids.get(func-1);
			rid = rids.get(func-1);
			r_type = rtypes.get(func-1);
			rtype_id = rtypeids.get(func-1);

			if(r_type.equals("PB") || r_type.equals("PC") || r_type.equals("PJ"))
			{

				renew_procedure(login, rid, r_type, borrow_id, rtype_id);

			}
			else{
				System.out.println(" This resource is non renewable. ");
			}			
		}

		int i = 0;

		do
		{
			System.out.println("1. GO back");
			System.out.print("Enter your Choice >> ");

			i = stdin.nextInt();
			stdin.nextLine();
			switch (i) {
			case 1:
				display_checked_out_resources(login);
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(i!=999);

	}

	public void return_resources(Login login)
	{

		List<Double> rtypeids = new ArrayList<Double>();
		List<Double> rids = new ArrayList<Double>();
		List<Double> borrowids = new ArrayList<Double>();
		List<String> rtypes = new ArrayList<String>();
		
		int func;
		
		String sql = "select BORROW_ID,rid, rtype_id, E_OR_H, TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time, checkout_time from athoma12.user_checkout_summary where patron_id = ?";

		PreparedStatement pstmt=null;
		ResultSet rs = null;
		double r_id,rtype_id,borrow_id = 0;
		int sl_no = 0;

		try {
			pstmt = DBConnection.conn.prepareStatement(sql);
			pstmt.setDouble(1, login.patron_id);

			rs = pstmt.executeQuery();

			while(rs.next())
			{
				sl_no++;
				borrow_id = rs.getDouble("BORROW_ID");
				String r_type = rs.getString("TYPE");
				r_id = rs.getDouble("RID");
				rtype_id = rs.getDouble("RTYPE_ID");
				rids.add(r_id);
				rtypeids.add(rtype_id);
				borrowids.add(borrow_id);
				rtypes.add(r_type);

			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null)
			{
				try{pstmt.close();}
				catch(SQLException e){
				}
			}
		}

		if(sl_no == 0)
		{
			System.out.println("Currently you dont have any resource to return");

		}

		else
		{
			
			System.out.println("<Menu>");	
			System.out.println("Enter the serial no to return the resource");
			System.out.print("Enter your Choice >> ");

			borrow_id = 0;
			func = stdin.nextInt();
			stdin.nextLine();

			borrow_id = borrowids.get(func-1);
			
			sql = "{call athoma12.resource_due_balance.return_resource(?)}";
			CallableStatement cstmt=null;

			try {
				cstmt = DBConnection.conn.prepareCall(sql);

				cstmt.setDouble(1,borrow_id);

				cstmt.execute();

			}
			catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if(cstmt != null)
				{
					try{cstmt.close();}
					catch(SQLException e){
					}
				}
			}

			System.out.println("Book Returned with Borrow ID:" + borrow_id);
		}

		do
		{
			System.out.println("1. GO back");
			System.out.print("Enter your Choice >> ");

			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				display_checked_out_resources(login);
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(func!=999);
	}

	public void display_checked_out_resources(Login login)
	{
		List<Double> rtypeids = new ArrayList<Double>();
		List<Double> rids = new ArrayList<Double>();
		List<Double> borrowids = new ArrayList<Double>();
		List<String> rtypes = new ArrayList<String>();
		
		System.out.println("Display Checked out resources");

		String sql = "select BORROW_ID,rid, rtype_id, E_OR_H, TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time, checkout_time from athoma12.user_checkout_summary where patron_id = ?";

		PreparedStatement cstmt=null;
		ResultSet rs = null;
		double r_id,rtype_id,borrow_id = 0;

		try {
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, login.patron_id);

			rs = cstmt.executeQuery();

			System.out.print("Sl.No    ");
			System.out.print("Borrow ID    ");
			System.out.print("Resource Type      ");
			System.out.print("Resource Category       ");
			System.out.print("Checkout date          		");
			System.out.print("Due date         	 	");
			System.out.print("Due Balance       	");
			System.out.println("Resource Description    ");

			int sl_no = 0;

			while(rs.next())
			{
				sl_no++;
				borrow_id = rs.getDouble("BORROW_ID");
				String r_type = rs.getString("TYPE");
				String e_or_h = rs.getString("E_OR_H") != null ? rs.getString("E_OR_H") : "";
				if(e_or_h.equals("H"))
					e_or_h = "Hard Copy";
				else if(e_or_h.equals("E"))
					e_or_h = "Electronic Copy";
				int due_balance = rs.getInt("DUE_BALANCE");
				Timestamp checkout_date = rs.getTimestamp("CHECKOUT_TIME");
				Timestamp due_date = rs.getTimestamp("DUE_TIME");
				String desc = rs.getString("DESCRIPTION");
				r_id = rs.getDouble("RID");
				rtype_id = rs.getDouble("RTYPE_ID");
				rids.add(r_id);
				rtypeids.add(rtype_id);
				borrowids.add(borrow_id);
				rtypes.add(r_type);

				System.out.print(sl_no);
				System.out.print("             ");
				System.out.print(borrow_id);
				System.out.print("          ");
				System.out.print(r_type);
				System.out.print("             ");
				System.out.print(e_or_h);
				System.out.print("             ");
				System.out.print(checkout_date);
				System.out.print("             ");
				System.out.print(due_date);
				System.out.print("            	 ");
				System.out.print(due_balance);
				System.out.print("             ");
				System.out.println(desc);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(cstmt != null)
			{
				try{cstmt.close();}
				catch(SQLException e){
				}
			}
		}
		int func;
		do
		{
			System.out.println("<Menu>");	
			System.out.println("1. View the details");
			System.out.println("2. Return the resource");
			System.out.println("3. Renew the resource");
			System.out.println("4. GO back");
			System.out.print("Enter your Choice >> ");

			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				checked_out_resources_details(login);
				break;
			case 2:
				return_resources(login);
				break;
			case 3:
				renew_resources(login);
				break;
			case 4:
				login.home_screen(login);
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(func!=999);
	}
}
