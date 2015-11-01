package com.bookpack.jdbc;

import java.util.Scanner;

public class Due_Balance {
	
	Login lobj;
	double patron_id;
	String user_type;
	static Scanner stdin = new Scanner(System.in);
	static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";

	private static Due_Balance due_balance = new Due_Balance( );
	
	public static Due_Balance getInstance( ) {
		return due_balance;
	}
	public void display_balance(Login l1){
		lobj = l1;
		
	}
}
