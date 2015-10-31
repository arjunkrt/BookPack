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
		
		String sql = "select nt.*, np.notification_id, np.patron_id, "
				+ "np.attribute1, "
				+ "np.notif_seen, np.notif_sent, ngp.attribute1 as attribute1_1, ngp.attribute2, "
				+ "ngp.attribute3 from athoma12.notification_templates nt, "
				+ "athoma12.notification_patrons np, athoma12.notification_grp_params ngp  "
				+ "where nt.template_name = np.template_name "
				+ "and nt.template_name = 'FIRST_REMINDER' "
				+ "and np.notif_seen <> 'Y' "
				+ "and ngp.notification_id = np.notification_id "
				+ "and np.patron_id = ?";
		
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
