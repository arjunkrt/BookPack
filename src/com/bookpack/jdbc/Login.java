package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Login {

	double patron_id = 0;
	String user_type = "";
	int success_id = 0;
	private static Login login = new Login( );

	static Scanner stdin = new Scanner(System.in);

	protected Login(){}
	public static Login getInstance( ) {
		return login;
	}
	public void main_screen()
	{
		int func;

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
					
					System.out.println("----------------------------------");
					System.out.println("<Menu>");	
					System.out.println("1. Profile");
					System.out.println("2. Resources");
					System.out.println("3. Checked­out Resources");
					System.out.println("4. Resource Request");
					System.out.println("5. Notifications");
					System.out.println("6. Due­Balance");
					System.out.println("7. Logout");
					System.out.print("Enter your Choice >> ");
					func = stdin.nextInt();
					stdin.nextLine();
					switch (func) {
					case 1:
						Profile profile = Profile.getInstance();
						profile.display_student(login);
						break;
					case 2:
						
						break;
					case 3:
						Resource_check_out resource_check_out = Resource_check_out.getInstance();
						resource_check_out.display_checked_out_resources(login);
						break;
					default:
						System.out.println("Wrong input. Try again!");
					}		
				}
				break;
			case 2:
				System.out.println("Bye!!!!!!!!!!!!!!!!!!!!!!!");
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
		System.out.println("Enter your email ID");
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