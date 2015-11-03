package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.SQLException;
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
		CallableStatement cstmt = null;
		String sql = "{call athoma12.resource_due_balance.get_total_balance(?,?)}";
		lobj = l1;
		double total;

		try{
			cstmt = DBConnection.conn.prepareCall(sql);
			cstmt.setDouble(1, lobj.patron_id);
			cstmt.registerOutParameter(2, java.sql.Types.DOUBLE);

			cstmt.execute();

			total = cstmt.getDouble(2);

			System.out.println(" Your total Due balance is: " + total);
		}catch (SQLException e) {
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
