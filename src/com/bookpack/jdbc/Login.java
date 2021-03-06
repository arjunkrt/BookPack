package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Login {

	double patron_id = 0;
	String user_type = "";
	String user_name = "";
	String user_password = "";
	int success_id = 0;
	private static Login login = new Login( );

	static Scanner stdin = new Scanner(System.in);

	protected Login(){}
	public static Login getObject( ) {
		return login;
	}
	public void home_screen(Login login)
	{
		int func;
		do{
			System.out.println("----------------------------------");
			System.out.println("<Menu>");	
			System.out.println("1. Profile");
			System.out.println("2. Resources");
			System.out.println("3. Checked�out Resources");
			System.out.println("4. Resource Request");
			System.out.println("5. Notifications");
//			System.out.println("6. Due�Balance");
			if(login.user_type.equalsIgnoreCase("F"))
				System.out.println("6. Reserve a publication. ");
			System.out.println("-999. Logout");
			System.out.print("Enter your Choice >> ");
			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				Profile profile = Profile.getObject();
				profile.display_profile(login);
				break;
			case 2:
				Resource resource = Resource.getInstance();
				resource.show_resource(login);
				break;
			case 3:
				ResourceCheckout resource_check_out = ResourceCheckout.getObject();
				resource_check_out.display_checked_out_resources(login);
				break;
			case 4:
				ResourceRequest resource_request = ResourceRequest.getObject();
				resource_request.requested_resources_details(login);
				break;
			case 5:
				Notifications notifications = Notifications.getObject();
				notifications.display_notifications(login);
				break;
//			case 6:
//				Due_Balance due_balance = Due_Balance.getInstance();
//				due_balance.display_balance(login);
//				break;
			case 6:
				Reservation reservation = Reservation.getInstance();
				reservation.reservation_publications(login);
				break;
/*			case 7:
				Checkingout_Rooms checkingout_res = Checkingout_Rooms.getObject();
				checkingout_res.checkout_room(login);
				break;*/
			case -999:
				login.patron_id = 0;
				login.user_type = "";
				login.user_name = "";
				login.user_password = "";
				main_screen();
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}while(func!=-999);
	}
	public void main_screen()
	{
		int func = 0;

		do {
			System.out.println();
			System.out.println("BookPack! Library Management System");
			System.out.println("----------------------------------");
			System.out.println("<Menu>");	
			System.out.println("1. Login");
			System.out.println("2. Quit");
			System.out.print("Enter your Choice >> ");
			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				login.login_screen();
				if (login.success_id > 0) {
					login.home_screen(login);
				}
				break;
			case 2:
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}
		while (func != 2);
	}
	public void login_screen()
	{
		System.out.println();
		System.out.println("Login Screen");
		System.out.println("----------------------------------");
		String email_id;
		System.out.println("Enter your login ID");
		email_id = stdin.nextLine();
		String user_pwd;
		System.out.println("Enter the password");
		user_pwd = stdin.nextLine();
		

		String sql = "{call athoma12.user_auth.validateLogin(?,?,?,?,?)}";
		CallableStatement cstmt=null;
		
		try {
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setString(1,email_id);
			cstmt.setString(2,user_pwd);
			cstmt.registerOutParameter(3, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(5, java.sql.Types.INTEGER);

			cstmt.execute();

			patron_id = cstmt.getDouble(3);
			user_type = cstmt.getString(4);			
			success_id = cstmt.getInt(5);
			user_name = email_id;
			user_password = user_pwd;

			if (success_id == 0){
				System.out.println("Login Failed, Please login again");
				login.login_screen();
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
}