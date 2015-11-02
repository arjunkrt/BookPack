package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;


public class ResourceRequest {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceRequest resource_request = new ResourceRequest( );
	
	public static ResourceRequest getInstance( ) {
		return resource_request;
	}
	public void requested_resources_details(Login login)
	{
		String sql = "select * from athoma12.user_waitlist_summary where patron_id = ?";
		PreparedStatement cstmt=null;
		ResultSet rs = null;

		try {

			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, login.patron_id);

			rs = cstmt.executeQuery();
			

			System.out.print("Resource Type    ");
			System.out.print("Resource Description    ");
			System.out.println("Library Name    ");
			
			while(rs.next())
			{
				String r_type = rs.getString("TYPE");
				String last_name = rs.getString("DESCRIPTION");
				String dept = rs.getString("LIBRARY");
//				if(sex.equals("M"))
//				{
//					sex = "Male";
//				}
//				else if(sex.equals("F"))
//				{
//					sex = "Female";
//				}

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
	public void display_requested_resources(Login login)
	{
		System.out.println("Display Requested resources");
		requested_resources_details(login);
		int func;
		do
		{
		System.out.println("<Menu>");	
		System.out.println("1. GO back");
		System.out.print("Enter your Choice >> ");
		
		func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			login.home_screen(login);
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
		}
		while(func!=1);
	}
}
