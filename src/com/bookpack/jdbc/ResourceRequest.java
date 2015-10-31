package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;


public class ResourceRequest {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceRequest resource_request = new ResourceRequest( );
	
	public static ResourceRequest getInstance( ) {
		return resource_request;
	}
	public void requested_resources_details(Login login)
	{
		String sql = "{call pkatttep.RProcRes_req_display.resourceReqProc(?,?)}";
		CallableStatement cstmt=null;

		try {
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setDouble(1,login.patron_id);
			cstmt.registerOutParameter (2,OracleTypes.ARRAY, "pkattep.resource_req");
			cstmt.execute();
			ARRAY simpleArray = (ARRAY) cstmt.getObject(2);
			
			Object[] data = (Object[]) simpleArray.getArray();
//			for(Object tmp : data) {
//	            Struct row = (Struct) tmp;
//	            // Attributes are index 1 based...
//	            int idx = 1;
//	            for(Object attribute : row.getAttributes()) {               
//	                System.out.println(metaData.getColumnName(idx) + " = " + attribute);                                            
//	                ++idx;
//	            }
//	            System.out.println("---");
//	        }

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
	public void display_requested_resources(Login login)
	{
		System.out.println("Display Requested resources");
		requested_resources_details(login);
		int func;
		do
		{
		System.out.println("<Menu>");	
		System.out.println("1. GO back");
		System.out.print("Enter your Choice >> ");
		
		func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			login.home_screen(login);
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
		}
		while(func!=1);
	}
}
