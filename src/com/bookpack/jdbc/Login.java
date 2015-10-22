package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Login {

	double patron_id = 0;
	String user_type = "";
	private static Login login = new Login( );

	static Scanner stdin = new Scanner(System.in);

	protected Login(){}
	public static Login getInstance( ) {
		return login;
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
			int id = cstmt.getInt(5);

			if (id > 0) {
				System.out.println("Success");
				System.out.println(id);
			} else {
				System.out.println("Login Failed, Please login again");
				Login l1 = new Login();
				l1.login_screen();
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