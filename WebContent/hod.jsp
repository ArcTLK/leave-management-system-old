<%@ page import="com.arc.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%! User user; Connection connection; PreparedStatement preparedStatement; ResultSet resultSet; %>
<%
user = (User)session.getAttribute("user");
if (user != null && user.hod == 1) {
	connection = null;
	preparedStatement = null;
	resultSet = null;
	try {
		connection = Database.getConnection();
		preparedStatement = connection.prepareStatement("SELECT u.name, u.picture_url, u.email, l.reason FROM leaves l INNER JOIN users u ON l.user_id = u.id WHERE CURRENT_TIME - INTERVAL '1 DAY' > requested_on");
		resultSet = preparedStatement.executeQuery();
	} catch (SQLException e) {
		response.getWriter().append("<p>Database Error: SQL Error</p>");
	} catch (URISyntaxException e) {
		response.getWriter().append("<p>Database Error: URI Syntax Error</p>");
	} catch (ClassNotFoundException e) {
		response.getWriter().append("<p>Database Error: Driver not found</p>");
	}
}
%>
<h2>Faculty on leave today:</h2>
<table>
	<tr>
		<th colspan="2">Name</th>
		<th>Reason</th>
		<th>Contact (Email)</th>
	</tr>
	<% 
	while(resultSet.next()) {
		out.println("<tr><td><img src='" + resultSet.getString("picture_url") +
		"' height='64' width='64'></td><td>" + resultSet.getString("name") + "</td><td>" + resultSet.getString("reason") +
		"</td><td><a href='mailto:" + resultSet.getString("email") + "'>" + resultSet.getString("email") + "</a></td></tr>");
	}
	resultSet.close();
	preparedStatement.close();
	connection.close();
	%>
</table>