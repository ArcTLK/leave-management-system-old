<%@ page import="com.arc.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%! User user; Connection connection; PreparedStatement preparedStatement; ResultSet resultSet; int leaves; %> 
<%
user = (User)session.getAttribute("user");
if (user != null) {
	//fetch current leaves for this month
	connection = null;
	preparedStatement = null;
	resultSet = null;
	try {
		connection = Database.getConnection();
		preparedStatement = connection.prepareStatement("SELECT COUNT(*) AS leave_count FROM leaves WHERE user_id = ? AND CURRENT_TIME - INTERVAL '30 DAY' > requested_on");
		preparedStatement.setInt(1, user.id);
		resultSet = preparedStatement.executeQuery();
		if (resultSet.next()) {
			leaves = User.ALLOWED_LEAVES - resultSet.getInt("leave_count");
		}
		else leaves = User.ALLOWED_LEAVES;
		resultSet.close();
		resultSet = null;
		preparedStatement.close();
		preparedStatement = null;
		if (request.getParameter("submit") != null) {
			if (leaves > 0) {
				preparedStatement = connection.prepareStatement("INSERT INTO leaves (user_id, reason) VALUES (?, ?)");
				preparedStatement.setInt(1, user.id);
				preparedStatement.setString(2, request.getParameter("reason"));
				preparedStatement.executeUpdate();
				leaves -= 1;
			}
		}
	} catch (SQLException e) {
		e.printStackTrace();
		response.getWriter().append("<p>Database Error: SQL Error</p>");
	} catch (URISyntaxException e) {
		response.getWriter().append("<p>Database Error: URI Syntax Error</p>");
	} catch (ClassNotFoundException e) {
		response.getWriter().append("<p>Database Error: Driver not found</p>");
	} finally {
		try {
			if (resultSet != null) resultSet.close();
			if (preparedStatement != null) preparedStatement.close();
			if (connection != null) connection.close();
		} catch(SQLException e) {
			response.getWriter().append("<p>Database Error: Unable to close connection</p>");
		}
	}
}
%>

<p>
	Your current leave balance is: <%= leaves %>
</p>
<% if (leaves > 0) { %>
<form method="POST">
	<input type="text" name="reason" placeholder="Enter reason of absence" required>
	<button name="submit" value="apply">Apply for Leave</button>
</form>
<% } %>
