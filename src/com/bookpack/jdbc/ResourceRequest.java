package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;


public class ResourceRequest {

	static Scanner stdin = new Scanner(System.in);
	private static ResourceRequest resource_request = new ResourceRequest( );

	public static ResourceRequest getObject( ) {
		return resource_request;
	}

	public void checkout(String r_type,double rtype_id,Login login)
	{

		String sql = "{call athoma12.R_CHECKOUT.Checkout_or_waitlist(?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cstmt = null;
		double borrow_id_next = 0;
		java.sql.Timestamp ts2 = null;

		try{
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setDouble(1, rtype_id);
			cstmt.setDouble(2, login.patron_id);
			cstmt.setDouble(3, 1);
			cstmt.setString(4, "");
			cstmt.setString(5, "");
			cstmt.setTimestamp(6, ts2);
			cstmt.setTimestamp(7, ts2);
			cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(9, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(10, java.sql.Types.TIMESTAMP);
			cstmt.registerOutParameter(11, java.sql.Types.DOUBLE);

			cstmt.execute();

			borrow_id_next = cstmt.getDouble(11);
			if(borrow_id_next > 1000)
				System.out.println(" You have checked out the resource. ");
			else
				System.out.println(" User cannot checkout  the resource");


		}catch(SQLException e){
			e.printStackTrace();
		} finally {
			if(cstmt != null)
			{
				try{cstmt.close();}
				catch(SQLException e){
				}
			}
		}

		requested_resources_details(login);
	}
	public void requested_resources_details(Login login)
	{
		System.out.println("Display Requested resources");
		String sql = "select * from athoma12.user_waitlist_summary where patron_id = ?";
		PreparedStatement cstmt=null;
		ResultSet rs = null;
		int index = 0;
		String r_type = null;

		try {

			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setDouble(1, login.patron_id);

			rs = cstmt.executeQuery();

			System.out.println("Waitlist Queue");
			System.out.print("Sl. no		");
			System.out.print("Resource Type    	");
			System.out.println("Resource Description    	");

			while(rs.next())
			{
				index++;
				System.out.print(index);
				System.out.print(" 		");
				r_type = rs.getString("TYPE");
				System.out.print(r_type);
				System.out.print(" 		");
				String desc = rs.getString("DESCRIPTION");
				System.out.println(desc);
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		System.out.println("<Menu>");	
		System.out.println("1. Checkout a resource (room/camera)");
		System.out.println("2. GO back");
		System.out.print("Enter your Choice >> ");

		int sl_no = 0,func = 0;
		double rtype_id = 0;
		do
		{
			func = stdin.nextInt();
			stdin.nextLine();

			switch (func) {
			case 1:
				System.out.println("<Menu>");	
				System.out.println("Enter the serial no to return the resource");
				System.out.print("Enter your Choice >> ");

				func = stdin.nextInt();
				stdin.nextLine();

				try {

					while(rs.next())
					{
						sl_no++;
						if(sl_no == func)
						{	
							rtype_id = rs.getInt("RTYPE_ID");
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
				checkout(r_type,rtype_id,login);
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
