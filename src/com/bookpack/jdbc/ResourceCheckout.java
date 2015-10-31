package com.bookpack.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class ResourceCheckout {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceCheckout resource_check_out = new ResourceCheckout( );
	
	public static ResourceCheckout getInstance( ) {
		return resource_check_out;
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
			System.out.println("Due date"); 
			
			while(rs.next())
			{
				String sl_no = rs.getString("ATTRIBUTE1_1");
				String resource_type = rs.getString("ATTRIBUTE2");
				String date = rs.getString("ATTRIBUTE3");
				System.out.print(sl_no);
				System.out.print("             ");
				System.out.print(resource_type);
				System.out.print("             ");
				System.out.println(date);

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
		
		System.out.println("<Menu>");	
		System.out.println("1. GO back");
		System.out.print("Enter your Choice >> ");

		int func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			login.home_screen(login);
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
	}
}
