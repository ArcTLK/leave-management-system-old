<%@ page import="com.arc.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>  
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
		preparedStatement = connection.prepareStatement("SELECT COUNT(*) AS leave_count FROM leaves WHERE user_id = ? AND requested_date >= cast(date_trunc('month', current_date) as date)");
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
				java.util.Date date = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("date"));
				java.util.Date now = new java.util.Date();
				if (date.getDate() < now.getDate() || date.getMonth() < now.getMonth() || date.getYear() < now.getYear()) {
					response.getWriter().append("<p>Invalid date selected: Date cannot be in the past!</p>");
				}
				else {
					preparedStatement = connection.prepareStatement("INSERT INTO leaves (user_id, reason, requested_date) VALUES (?, ?, ?)");
					preparedStatement.setInt(1, user.id);
					preparedStatement.setString(2, request.getParameter("reason"));
					preparedStatement.setDate(3, new java.sql.Date(date.getTime()));
					preparedStatement.executeUpdate();
					leaves -= 1;
				}
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
<div style="margin: auto; width: 40%">
	<p>
		Your current leave balance is: <%= leaves %>
	</p>
	<% if (leaves > 0) { %>
	<form method="POST">
		<table>
			<tr>
				<td>Enter reason for absence:</td>
				<td><input type="text" name="reason" placeholder="Type here..." required></td>
			</tr>
			<tr>
				<td>Enter date:</td>
				<td><input type="date" name="date" required></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center"><button name="submit" value="apply" style="width: 30%;">Apply for Leave</button></td>
			</tr>
		</table>
	</form>
	<% } %>
</div>
