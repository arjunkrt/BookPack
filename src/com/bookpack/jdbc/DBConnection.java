package com.bookpack.jdbc;

import java.sql.*;

public class DBConnection {

    static final String jdbcURL = "jdbc:oracle:thin:@ora.csc.ncsu.edu:1521:orcl";

    public static void main(String[] args) {
        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            //Add your oracle user name and pwd
	    String user = "";	
	    String passwd = "";

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {

		conn = DriverManager.getConnection(jdbcURL, user, passwd);

		stmt = conn.createStatement();
		
// Run the following statement only once, because once it is created, it will be in your schema
	
		/**/
		stmt.executeUpdate("CREATE TABLE COFFEES " +
			   "(COF_NAME VARCHAR(32), SUP_ID INTEGER, " +
			   "PRICE FLOAT, SALES INTEGER, TOTAL INTEGER)");
		/**/

		stmt.executeUpdate("INSERT INTO COFFEES " +
			   "VALUES ('Colombian', 101, 7.99, 0, 0)");

		stmt.executeUpdate("INSERT INTO COFFEES " +
			   "VALUES ('French_Roast', 49, 8.99, 0, 0)");

		stmt.executeUpdate("INSERT INTO COFFEES " +
			   "VALUES ('Espresso', 150, 9.99, 0, 0)");

		stmt.executeUpdate("INSERT INTO COFFEES " +
			   "VALUES ('Colombian_Decaf', 101, 8.99, 0, 0)");

		stmt.executeUpdate("INSERT INTO COFFEES " +
			   "VALUES ('French_Roast_Decaf', 49, 9.99, 0, 0)");

		rs = stmt.executeQuery("SELECT COF_NAME, PRICE FROM COFFEES");


		while (rs.next()) {
		    String s = rs.getString("COF_NAME");
		    float n = rs.getFloat("PRICE");
		    System.out.println(s + "   " + n);
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
