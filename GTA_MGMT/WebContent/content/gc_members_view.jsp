<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GC Members Registration</title>
<link href="/GTAMS/bootstrap/css/bootstrap.css" rel="stylesheet" />
<link href="/GTAMS/datepicker/css/datepicker.css" rel="stylesheet" />
<link href="/GTAMS/assets/css/bootstrap-united.css" rel="stylesheet" />

<style>
.green {
	font-weight: bold;
	color: green;
}

.message {
	margin-bottom: 10px;
}

.error {
	color: #ff0000;
	font-size: 0.9em;
	font-weight: bold;
}

.errorblock {
	color: #000;
	background-color: #ffEEEE;
	border: 3px solid #ff0000;
	padding: 8px;
	margin: 16px;
}
</style>
</head>
<body>

	<div class="navbar navbar-default">

		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-responsive-collapse">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
		</div>

		<div class="navbar-collapse collapse navbar-responsive-collapse">
			<form class="navbar-form navbar-right">
				<input type="text" class="form-control" placeholder="Search">
			</form>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="/GTAMS">Home</a></li>
				<li class="active"><a href="signup.jsp">Signup</a></li>
				<li><a href="login.jsp">Login</a></li>
			</ul>
		</div>
		<!-- /.nav-collapse -->
	</div>

	<script src="/GTAMS/jquery-1.8.3.js">
	</script>

	<script src="/GTAMS/bootstrap/js/bootstrap.js">
	</script>

	<script src="/GTAMS/datepicker/js/bootstrap-datepicker.js">
	</script>

	<div class="container">
		<div class="jumbotron">
			<div>
				<h1>Welcome to GTA Management System</h1>
			</div>
		</div>
	</div>

	<c:if test="${not empty message}">
		<div class="message green">${message}</div>
	</c:if>

	<div class="col-lg-6 col-lg-offset-3">
		<div class="well">
			<div class="container">
				<div class="row">
					<div class="col-lg-6">
						<form id="myForm" method="post" class="bs-example form-horizontal" action="../StudentController">
							<fieldset>
								<legend>GC Members Panel
								<div align="right"> 
								Welcome: <% if( request.getSession().getAttribute("name") != null)
								{ out.println(request.getSession().getAttribute("name").toString()); } %>
								</div>
								</legend>

								<%
//								Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
								Connection connection = DriverManager.getConnection( "jdbc:mysql://localhost:3306/GTAMS", "root", "root");
								
					            Statement stmtNominee = connection.createStatement() ;
					            ResultSet rsNominee = stmtNominee.executeQuery("select * from nominee order by nominated_by, ranking") ;
					            
					            Statement stmtGCMembers = connection.createStatement() ;
					            ResultSet rsGCMembers = stmtGCMembers.executeQuery("select * from gc_members") ;
					            
					            Statement stmtScorecard = connection.createStatement() ;
				            	ResultSet rsScorecard;

					            %>
						       <TABLE BORDER="1">
						            <TR>
						                <TH>Nominee</TH>
						                <TH>Nominator</TH>
						                <TH>Rank</TH>
						                <TH>Existing</TH>
						                <% while(rsGCMembers.next()){ %>
						                	<TH><%=rsGCMembers.getString("name") %></TH>
							            <% } %>
										<TH>Average Score</TH>	                
						            </TR>
						            <% while(rsNominee.next()){ %>
						            <TR>
						                 <TD> <a href="./content/nominee_detail_view.jsp?nomineeName=<%=rsNominee.getString("name")%>"  
						                onclick="window.open(this.href,'targetWindow', 'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes); return false;"> <%= rsNominee.getString("name") %> </a> </TD>
						                
						                <TD> <%= rsNominee.getString("nominated_by") %></TD>
						                <TD> <%= rsNominee.getString("ranking") %></TD>
						                <TD> <%= rsNominee.getString("is_phd_cs") %></TD>
						                <% //if(rsGCMembers.first())
						                	rsGCMembers.beforeFirst();
						                	int totalScore =0;
						                	int count = 0;
						                	while(rsGCMembers.next())
						                	{
								            	rsScorecard = stmtScorecard.executeQuery("select score from scorecard where nominee_name='" 
									            				+ rsNominee.getString("name") + "' and gcm_name='"+ rsGCMembers.getString("name") + "'") ;
						                		
							                	if (rsScorecard.next() ){
							                		totalScore +=rsScorecard.getInt("score");
							                	%>
							                	<TD> <%=rsScorecard.getInt("score") %></TD>
						                	<%} else {%>
						                	<TD> 0</TD>
							                	<%}
							                	count++;
							                	}%>
						                	<TD> <%=totalScore/count %></TD>
						                	<%}%>
						            </TR>
						        </TABLE>
								
								<input type="hidden" name="pageName" value="gc_members_view">
								<div class="col-lg-9 col-lg-offset-3">
									<button class="btn btn-default">Cancel</button>
									<button class="btn btn-primary" data-toggle="modal"
										data-target="#themodal">Submit</button>
									<div id="themodal" class="modal fade" data-backdrop="static">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal"
														aria-hidden="true">&times;</button>
													<h3>Signup Form Submission</h3>
												</div>
												<div class="modal-body">
													<p>Are you sure you want to do this?</p>
													<div class="progress progress-striped active">
														<div id="doitprogress" class="progress-bar"></div>
													</div>
												</div>
												<div class="modal-footer">
													<a href="#" class="btn btn-default" data-dismiss="modal">Close</a>
													<input type="submit" value="Yes" id="yesbutton"
														class="btn btn-primary" data-loading-text="Saving.."
														data-complete-text="Submit Complete!">
												</div>
											</div>
										</div>
									</div>

								</div>

							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		$(function() {
			$('#dateOfBirthInput').datepicker();
		});
	</script>

	<script type="text/javascript">
		$(function() {
			var yesButton = $("#yesbutton");
			var progress = $("#doitprogress");

			yesButton.click(function() {
				yesButton.button("loading");

				var counter = 0;
				var countDown = function() {
					counter++;
					if (counter == 11) {
						yesButton.button("complete");
					} else {
						progress.width(counter * 10 + "%");
						setTimeout(countDown, 100);
					}
				};

				setTimeout(countDown, 100);
			});

		});
	</script>


</body>
</html>