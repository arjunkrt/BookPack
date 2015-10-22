package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Main {
	static Scanner stdin = new Scanner(System.in);

	public static void main(String[] args) {

		int func;

		do {
			System.out.println();
			System.out.println("BookPack! Library Management System");
			System.out.println("----------------------------------");
			System.out.println("<Menu>");	
			System.out.println("1. Login");
			System.out.println("2. Quit");
			System.out.print("Enter your Command >> ");
			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				DBConnection cobj = new DBConnection();
				cobj.JDBCConnection();
				Login login = Login.getInstance();// new Login();
				login.login_screen();
				break;
			case 2:
				
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}
		while (func != 2);
	}

}
