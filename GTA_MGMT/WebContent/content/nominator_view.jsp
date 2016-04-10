<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Nominee Registration</title>
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
			<ul class="nav navbar-nav navbar-right">
				<li><a href="/GTAMS">Home</a></li>
				<li><a href="content/login.jsp">Login</a></li>
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
		<div></div>
	</div>

	<c:if test="${not empty message}">
		<div class="message green">${message}</div>
	</c:if>

	<div class="col-lg-6 col-lg-offset-3">
		<div class="well">
			<div class="container">
				<div class="row">
					<div class="col-lg-6">
						<form id="myForm" method="post" class="bs-example form-horizontal" action="NominatorActionController">
							<fieldset>
								<legend>Nominator Dashboard
								<% if( request.getSession().getAttribute("name") != null) 
								{
									Connection connection = DriverManager.getConnection( "jdbc:mysql://localhost:3306/GTAMS", "root", "root");
						            Statement stmtNominator = connection.createStatement() ;
						            ResultSet rsNominator = stmtNominator.executeQuery("select * from nominator where name='" + request.getSession().getAttribute("name") +"'") ;
			
								%>
								<div align="right">  
								<%
								 out.println("Welcome:"+ request.getSession().getAttribute("name").toString() +"|"+ (rsNominator.next() ? rsNominator.getString("email"): "")); %>
								</div>
								<%} %>
								</legend>
								
								
								<input type="hidden" name="pageName" value="nominator_view">
								<!-- 
								<div class="form-group">
									<label for="nominatorNameInput" class="col-lg-3 control-label">Name</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="nominatorName"
											id="nominatorNameInput" placeholder="Nominator Name" />
									</div>
								</div>

								<div class="form-group">
									<label for="NominatorEmailInput" class="col-lg-3 control-label">Email Address</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="email"
											id="emailInput" placeholder="Nominator Email Address" />
									</div>
								</div>
								 -->

								<div class="form-group">
									<label for="rankingInput" class="col-lg-3 control-label">Ranking</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="ranking"
											id="rankingInput" placeholder="Ranking Among all your nominees" />
									</div>
								</div>

								<div class="form-group">
									<label for="nomineeNameInput" class="col-lg-3 control-label">NomineeName</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="nomineeName"
											id="nomineeNameInput" placeholder="Nominee Name" />
									</div>
								</div>

								<div class="form-group">
									<label for="NomineeEmailInput" class="col-lg-3 control-label">Nominee Email Address</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="nomineeEmail"
											id="NomineemailInput" placeholder="Nominee Email Address" />
									</div>
								</div>

								<div class="form-group">
									<label for="pidInput" class="col-lg-3 control-label">PID</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="pid"
											id="pidInput" placeholder="Nominee PID" />
									</div>
								</div>

								<div class="form-group">
									<label for="isPHDCS" class="col-lg-3 control-label">PHD Student in Computer Science</label>
									<div class="col-lg-3">
										<input type="radio" name="isPHDCS" id="radioIsPHDCSY"  value="Yes" /> YES
										<input type="radio" name="isPHDCS" id="radioIsPHDCSN"  value="No" checked /> No
									</div>
								</div>

								<div class="form-group">
									<label for="newPHD" class="col-lg-3 control-label">New PHD Student</label>
									<div class="col-lg-9">
										<input type="radio" name="newPHD" id="radionewPHDY" value="Yes" /> YES
										<input type="radio" name="newPHD" id="radionewPHDN"  value="No" checked /> No
									</div>
								</div>

								<%if (request.getAttribute("errorMessage")!=null) %>
								<div style="color: #FF0000;"><%=request.getAttribute("errorMessage") %></div>

								<%if (request.getAttribute("successMessage")!=null) %>
								<div style="color: #00FF00;"><%=request.getAttribute("successMessage") %></div>

								<div class="col-lg-9 col-lg-offset-3">
									<button class="btn btn-default">Cancel</button>
									<button class="btn btn-primary" data-toggle="modal" data-target="#themodal">Submit</button>
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