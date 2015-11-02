package com.bookpack.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Notifications {

	static Scanner stdin = new Scanner(System.in);
	private static Notifications notifications = new Notifications( );
	
	public static Notifications getObject( ) {
		return notifications;
	}
	public void display_notifications(Login login)
	{
		System.out.println("Display Notifications");
		System.out.println("----------------------------------");
		
		String sql1 = "select * from athoma12.notification_patrons np, "
				+ "athoma12.notification_templates nt where np.patron_id = ? "
				+ "and np.template_name = nt.template_name";
		
		String sql2 = "select * from athoma12.notification_attributes na "
				+ "where notification_id = ? order by attribute_number";
		
		String sql3 = "select * from notification_grp_params ngp "
				+ "where ngp.notification_id = ?";//1018
		
		PreparedStatement cstmt=null;
		ResultSet rs1,rs2,rs3 = null;
		String message1 = null, message2 = null, message3 = null;
		login.patron_id = 1021;
		try {
			cstmt = DBConnection.conn.prepareStatement(sql1);
			cstmt.setDouble(1,login.patron_id);//1021

			rs1 = cstmt.executeQuery();
				
//			System.out.print("Sl.No    ");
//			System.out.print("Resource Type    ");
//			System.out.println("Due date"); 
			while(rs1.next())
			{
				message1 = rs1.getString("TEMPLATE_BODY");

				cstmt = DBConnection.conn.prepareStatement(sql2);
				cstmt.setInt(1,1019/*login.patron_id*/);//1019

				rs2 = cstmt.executeQuery();
				while(rs2.next())
				{
//					if(rs2.getInt("ATTRIBUTE_NUMBER") == 1)
//					{
//						message2 = message1.replace("|ARG|",rs2.getString("ATTRIBUTE_VALUE"));
//					}
//					else if(rs2.getInt("ATTRIBUTE_NUMBER") == 2)
//					{
//						message2 = message2.replace("|ARG|",rs2.getString("ATTRIBUTE_VALUE"));
//					}
					System.out.println(rs2.getString("ATTRIBUTE_VALUE"));
					message2 = message1.replace("|ARG|",rs2.getString("ATTRIBUTE_VALUE"));
				}
				System.out.println(message2);
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
