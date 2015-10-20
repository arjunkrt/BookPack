package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;
import oracle.jdbc.OracleTypes;

public class Login {

	double patron_id;
	String user_type;
	
	Login()
	{
		patron_id = 0;
		user_type = "";
	}
	
	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";

	public void login_screen()
	{
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String user = "akarat";	
			String passwd = "200109405";

			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			try {

				conn = DriverManager.getConnection(jdbcURL, user, passwd);

				stmt = conn.createStatement();
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
				CallableStatement cstmt = conn.prepareCall(sql);
			
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
				
			} finally {
				close(rs);
				close(stmt);
				close(conn);
			}

		} catch(Throwable oops) {
			oops.printStackTrace();
		}
	}

	static void close(Connection conn) {
		if(conn != null) {
			try { conn.close(); } catch(Throwable whatever) {}
		}
	}

	static void close(Statement st) {
		if(st != null) {
			try { st.close(); } catch(Throwable whatever) {}
		}
	}

	static void close(ResultSet rs) {
		if(rs != null) {
			try { rs.close(); } catch(Throwable whatever) {}
		}
	}
}