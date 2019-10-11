package com.arc;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.auth.openidconnect.IdToken;
import com.google.api.client.auth.openidconnect.IdTokenVerifier;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.apache.ApacheHttpTransport;
import com.arc.Database;
import com.arc.User;
/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String CLIENT_ID = "188419469527-usdhao1pp0kgaammglv15r9s9d7al26o.apps.googleusercontent.com";
       
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		session.setAttribute("user", null);
		response.setContentType("application/json");
		response.getWriter().append("{\"result\":true}");
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpTransport transport = new ApacheHttpTransport();
		GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, JacksonFactory.getDefaultInstance())
			    .setAudience(Collections.singletonList(CLIENT_ID))
			    .build();
		GoogleIdToken idToken;
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		Connection connection = null;
		
		try {
			idToken = verifier.verify(request.getParameter("token"));
			if (idToken != null) {
				  Payload payload = idToken.getPayload();
				  String domain = payload.getHostedDomain();
				  if (domain != null && (domain.equals("student.mes.ac.in")  || domain.equals("mes.ac.in"))) {
					  String userId = payload.getSubject();
					  String email = payload.getEmail();
					  String name = (String) payload.get("name");
					  String pictureUrl = (String) payload.get("picture");
					  String familyName = (String) payload.get("family_name");
					  String givenName = (String) payload.get("given_name");
					  int id, hod = 0;
					  connection = Database.getConnection();
					  preparedStatement = connection.prepareStatement("SELECT id, google_id, email, name, hod, picture_url FROM users WHERE google_id = ?");
					  preparedStatement.setString(1, userId);
					  resultSet = preparedStatement.executeQuery();
					  if (resultSet.next() == false) {
						  resultSet.close();
						  preparedStatement.close();
						  resultSet = null;
						  preparedStatement = null;
						  //insert
						  preparedStatement = connection.prepareStatement("INSERT INTO users (google_id, email, name, picture_url) VALUES (?, ?, ?, ?)", PreparedStatement.RETURN_GENERATED_KEYS);
						  preparedStatement.setString(1, userId);
						  preparedStatement.setString(2, email);
						  preparedStatement.setString(3, name);
						  preparedStatement.setString(4, pictureUrl);
						  preparedStatement.executeUpdate();
						  resultSet = preparedStatement.getGeneratedKeys();
						  if (resultSet.next()) {
							  id = resultSet.getInt(1);
						  }
						  else id = 0;
						  resultSet.close();
						  resultSet = null;
					  }
					  else {
						  id = resultSet.getInt("id");
						  hod = resultSet.getInt("hod");
						  resultSet.close();
						  preparedStatement.close();
						  resultSet = null;
						  preparedStatement = null;
						  //update
						  preparedStatement = connection.prepareStatement("UPDATE users SET email = ?, name = ?, picture_url = ? WHERE google_id = ?");
						  preparedStatement.setString(4, userId);
						  preparedStatement.setString(1, email);
						  preparedStatement.setString(2, name);
						  preparedStatement.setString(3, pictureUrl);
						  preparedStatement.execute();
					  }
					  HttpSession session = request.getSession();
					  User user = new User(id, name, pictureUrl, email, userId, hod);
					  session.setAttribute("user", user);
					  response.setContentType("application/json");
					  response.getWriter().append("{\"result\":true}");
				  }
				  else {
					  response.setStatus(403);
					  response.setContentType("application/json");
					  if (domain == null) {
						  response.getWriter().append("{\"result\":false, \"error\":\"Only mes users can log in\"}");
					  }
					  else response.getWriter().append("{\"result\":false, \"error\":\"Invalid Domain: " + domain + "\"}");
				  }
			}
			else {
				response.setStatus(403);
				response.setContentType("application/json");
				response.getWriter().append("{\"result\":false, \"error\":\"Invalid Token\"}");
			}
		} catch (GeneralSecurityException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Security Error\"}");
		} catch (SQLException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Database Error: SQL Error\"}");
		} catch (URISyntaxException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Database Error: URI Syntax error\"}");
		} catch (ClassNotFoundException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Database Error: Driver not found\"}");
		} finally {
			try {
				if (resultSet != null) resultSet.close();
				if (preparedStatement != null) preparedStatement.close();
				if (connection != null) connection.close();
			} catch(SQLException e) {
				response.setStatus(500);
				response.setContentType("application/json");
				response.getWriter().append("{\"result\":false, \"error\":\"Database Error: Unable to close connection\"}");
			}
		}
	}

}
