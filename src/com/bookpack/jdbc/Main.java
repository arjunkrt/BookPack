package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Main {
	static Scanner stdin = new Scanner(System.in);

	public static void main(String[] args) {
		
		DBConnection cobj = new DBConnection();
		cobj.JDBCConnection();
		
		Login login = Login.getInstance();
		login.main_screen();
		
		try {
			cobj.conn.close();
		} catch (SQLException e) {
			
			e.printStackTrace();
		}

	}

}