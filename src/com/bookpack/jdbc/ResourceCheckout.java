package com.bookpack.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Scanner;


public class ResourceCheckout {

	static Scanner stdin = new Scanner(System.in);
	private static ResourceCheckout resource_check_out = new ResourceCheckout( );

	public static ResourceCheckout getInstance( ) {
		return resource_check_out;
	}
	public void checked_out_resources_details(Login login)
	{	
		int func,sl_no=0,rid = 0;
		String r_type = "";
		PreparedStatement cstmt = null;
		
		String sql = "select BORROW_ID,RID,TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time from athoma12.user_checkout_summary where patron_id = ?";

		ResultSet rs = null;

		try {
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, 1019/*login.patron_id*/);

			rs = cstmt.executeQuery();

		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		System.out.println("<Menu>");	
		System.out.println("Enter the serial no to view the details");
		System.out.print("Enter your Choice >> ");

		
		func = stdin.nextInt();
		stdin.nextLine();
		try {
			
			while(rs.next())
			{
				sl_no++;
				if(sl_no == func)
				{	
					rid = rs.getInt("RID");
					r_type = rs.getString("TYPE");
					break;
				}
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
		
		cstmt = null;
		rs = null;
		
		try {
			if(r_type.equals("PB"))
			{
				sql = "SELECT * FROM athoma12.book_rid_details where rid = ?";

				cstmt = DBConnection.conn.prepareStatement(sql);
				cstmt.setInt(1, rid);

				rs = cstmt.executeQuery();
				
				System.out.print("RID			");
				System.out.print("LIB_NAME		");
				System.out.print("ISBN		");
				System.out.print("PUBLISHERS		");
				System.out.print("YEAR		");
				System.out.println("TITLE		");
				
				while(rs.next())
				{	
					System.out.print(rid);
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
					System.out.print("			");
					String title = rs.getString("TITLE");
					System.out.println(title);
				}
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
	}while(func!=2);
		
	}
	public void display_checked_out_resources(Login login)
	{
		System.out.println("Display Checked out resources");

		String sql = "select BORROW_ID,TYPE, ATHOMA12.resource_due_balance.get_due_balance(BORROW_ID) as due_balance, DESCRIPTION, due_time from athoma12.user_checkout_summary where patron_id = ?";

		PreparedStatement cstmt=null;
		ResultSet rs = null;

		try {
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, 1019/*login.patron_id*/);

			rs = cstmt.executeQuery();

			System.out.print("Sl.No    ");
			System.out.print("Borrow ID    ");
			System.out.print("Resource Type      	 ");
			System.out.print("Due date          ");
			System.out.print("Due Balance       ");
			System.out.println("Resource Description    ");

			int sl_no = 0;

			while(rs.next())
			{
				sl_no++;
				int borrow_id = rs.getInt("BORROW_ID");
				String r_type = rs.getString("TYPE");
				int due_balance = rs.getInt("DUE_BALANCE");
				Timestamp due_date = rs.getTimestamp("DUE_TIME");
				String desc = rs.getString("DESCRIPTION");
				System.out.print(sl_no);
				System.out.print("             ");
				System.out.print(borrow_id);
				System.out.print("          ");
				System.out.print(r_type);
				System.out.print("             ");
				System.out.print(due_date);
				System.out.print("             ");
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
			System.out.println("2. GO back");
			System.out.print("Enter your Choice >> ");

			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				checked_out_resources_details(login);
				break;
			case 2:
				login.home_screen(login);
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(func!=2);
	}
}
