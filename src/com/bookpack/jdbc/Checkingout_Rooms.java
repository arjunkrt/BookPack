package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.util.Scanner;

public class Checkingout_Rooms {

	Login lobj;
	static Scanner stdin = new Scanner(System.in);

	private static Checkingout_Rooms checkingout_rooms = new Checkingout_Rooms( );

	public static Checkingout_Rooms getObject( ) {
		return checkingout_rooms;
	}
	
	public void checkout_room(Login l1){
	
		lobj = l1;
		
		String sql = "{call athoma12.R_CHECKOUT.Checkout_or_waitlist(?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cstmt = null;
		double wait_list_no=0, borrow_id_next = 0, rtype_id = 0;
		java.sql.Timestamp ts4 = null;
		String checkout_time, return_time, date;
		
/*		checkout_time = "2015-11-12 07:01:10";//stdin.nextLine();
		return_time = "2015-11-12 09:01:10";//stdin.nextLine();

		ts2 = java.sql.Timestamp.valueOf(checkout_time);
		ts3 = java.sql.Timestamp.valueOf(return_time);
*/		
		System.out.println("hello");
		
		try{
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setDouble(1, rtype_id);
			cstmt.setDouble(2, lobj.patron_id);
			cstmt.setString(4, "");
			cstmt.setString(5, "");
			//cstmt.setTimestamp(6, ts2);
			//cstmt.setTimestamp(7, ts3);
			cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
			cstmt.registerOutParameter(9, java.sql.Types.DOUBLE);
			cstmt.registerOutParameter(10, java.sql.Types.TIMESTAMP);
			
			cstmt.setDouble(3, 2);
			cstmt.registerOutParameter(11, java.sql.Types.DOUBLE);
			
			cstmt.execute();
			
			/*wait_list_no = cstmt.getDouble(11);
			
			if(wait_list_no != 0){
				System.out.println(" You have successfully reserved the room. ");
			}
		
			else{
				System.out.println(" Room reservation was unsuccessful. ");
			}*/
			
			ts4 = cstmt.getTimestamp(10);
			if(ts4!=null){
				date = ts4.toString();
				System.out.println(" Return time: " + date);
			}
			else{
				System.out.println(" Room reservation unsuccessful. ");
			}
			
			
			
		}catch(SQLException e){
			e.printStackTrace();
		} finally {
			
		}


	
	}
	
}
