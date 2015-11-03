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

		String sql3 = "select * from athoma12.notification_grp_params ngp "
				+ "where ngp.notification_id = ?"
				+ "order by grp_attribute_number, ind_attribute_number";//1018

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
				double notif_id = rs1.getDouble("NOTIFICATION_ID");
				cstmt = DBConnection.conn.prepareStatement(sql2);
				cstmt.setDouble(1,notif_id);//currently hardcoded the notification_id

				rs2 = cstmt.executeQuery();
				while(rs2.next())
				{
					message1 = message1.replace("|"+rs2.getString("ATTRIBUTE_NAME")+"|",rs2.getString("ATTRIBUTE_VALUE"));
				}

				int aftergargbegin = message1.indexOf("|GARG|")+6;
				int gargend = message1.lastIndexOf("|GARG|");
				//System.out.println(message1.subSequence(aftergargbegin, gargend));
				//for (int i=0; i<temp.length; i++)
				//	System.out.println(i+"."+temp[i]);

				//System.out.println("Afergargbegin: "+aftergargbegin);
				if (aftergargbegin > 5)
				{
					cstmt = DBConnection.conn.prepareStatement(sql3);
					cstmt.setDouble(1,notif_id);//currently hardcoded the notification_id

					rs3 = cstmt.executeQuery();


					int sno=0;
					String gargtext = "";
					String tempLines = "";
					double old_grp_attribute_number=0 ;
					double new_grp_attribute_number;
					while(rs3.next())
					{
						new_grp_attribute_number= rs3.getDouble("GRP_ATTRIBUTE_NUMBER");
						if (new_grp_attribute_number != old_grp_attribute_number)
						{
							//Adding previous group to tempLines
							tempLines=tempLines+gargtext+'\n';

							//Setting gargtext to default template
							gargtext = (String) message1.subSequence(aftergargbegin, gargend);
							++sno;

							gargtext = gargtext.replace("|SNO|",""+sno);

						}	

						gargtext = gargtext.replace("|"+rs3.getString("ATTRIBUTE_NAME")+"|",rs3.getString("ATTRIBUTE_VALUE"));

						old_grp_attribute_number = new_grp_attribute_number;
					}
					tempLines=tempLines+gargtext+'\n'; //Adding last line to gargtext
					String[] temp = message1.split("\\|[G][A][R][G]\\|.*\\|[G][A][R][G]\\|");
					message1 = temp[0]+tempLines+temp[1];
				}

				message1 = message1.replace("|\\t|", "\t");
				System.out.println(message1);
				System.out.println("----------------------------------");

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
		while(func!=999);
	}


}
