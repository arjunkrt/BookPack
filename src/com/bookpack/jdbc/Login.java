package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;
import oracle.jdbc.OracleTypes;

public class Login {

	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";

	public static void login_screen()
	{
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String user = "";	
			String passwd = "";

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

				String sql = "{ ? = call athoma12.USER_AUTH.VALIDATELOGIN(?,?) }";
				CallableStatement cstmt = conn.prepareCall(sql);
				cstmt.registerOutParameter(1, java.sql.Types.INTEGER);  
				cstmt.setString(2,email_id);
				cstmt.setString(3,user_pwd);
				
				//System.out.println("Before execution");
				cstmt.execute();
				//System.out.println("After execution");

				int id = cstmt.getInt(1);
				if (id > 0) {
					System.out.println("Success");
				} else {
					System.out.println("Login Failed, Please login again");
					Login.login_screen();
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