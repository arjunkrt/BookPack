package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Main {
	static Scanner stdin = new Scanner(System.in);

	public static void main(String[] args) {
		
		DBConnection cobj = new DBConnection();
		cobj.JDBCConnection();
		
		Login login = Login.getObject();
		login.main_screen();
		System.out.println("Thank you for using Bookpack!!!! See you again");
		
		try {
			DBConnection.conn.close();
		} catch (SQLException e) {
			
			e.printStackTrace();
		}

	}

}
