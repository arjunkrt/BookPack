package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;

public class ResourceCheckout {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceCheckout resource_check_out = new ResourceCheckout( );
	
	public static ResourceCheckout getInstance( ) {
		return resource_check_out;
	}
	public void checked_out_resources_details(Login login,int borrow_id)
	{
		String sql = "{call athoma12.resources_mgmt.getResourceDetailsCursor(?,?,?)}";
		CallableStatement cstmt=null;

		try {
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setInt(1,borrow_id);
			cstmt.registerOutParameter (2, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter (3, OracleTypes.CURSOR);
			cstmt.execute();
			
			ResultSet rs = (ResultSet)cstmt.getObject (3);

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
	public void display_checked_out_resources(Login login)
	{
		System.out.println("Display Checked out resources");
		
		String sql = "select * from athoma12.user_checkout_summary where patron_id = ?";
		
		PreparedStatement cstmt=null;
		ResultSet rs = null;
		
		try {
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, login.patron_id);

			rs = cstmt.executeQuery();
				
			System.out.print("Sl.No    ");
			System.out.print("Resource Type    ");
			System.out.print("Resource Description    ");
			
			int sl_no = 0;
			
			while(rs.next())
			{
				sl_no++;
				int borrow_id = rs.getInt("BORROW_ID");
				String desc = rs.getString("DESCRIPTION");
				System.out.print(sl_no);
				System.out.print("             ");
				System.out.print(borrow_id);
				System.out.print("             ");
				System.out.print(desc);
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
		int func,borrow_id_detail = 0;
		do
		{
		System.out.println("<Menu>");	
		System.out.println("1. Enter the sl_no to view the details of that resource");
		System.out.println("2. GO back");
		System.out.print("Enter your Choice >> ");

		func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			checked_out_resources_details(login,borrow_id_detail);
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
