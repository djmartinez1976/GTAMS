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

<script type="text/javascript">

$(document).ready(function(){

    var prevPHDACount = 2;
	var courseCount = 2;
	var pubCount =2;
	
    $("#addPHDA").click(function () {
	if(prevPHDACount>5){
            alert("Only 5 Records allowed");
            return false;
	}   
	var newPHDADiv = $("<div />");
                
	newPHDADiv.html('<input type="text" class="col-lg-5 control-text" name="prevPHDAdvisor' +prevPHDACount + 
			'" id="prevPHDAdvisor"' + prevPHDACount + '" placeholder="Previous PHD Advisor" /> <input type="text" class="col-lg-5 control-text" name="prevPHDAdvisorPeriod' +
			+ prevPHDACount + '" id="prevPHDAdvisor"' + prevPHDACount +'" placeholder="Duration" />');
            
	newPHDADiv.appendTo("#PHDAdvisorInfo");
	prevPHDACount++;
     });
    
    $("#addCourse").click(function () {
    	if(courseCount>5){
                alert("Only 5 Records allowed");
                return false;
    	}   
    	var newCourseDiv = $("<div />");
                    
    	newCourseDiv.html('<input type="text" class="col-lg-5 control-text" name="courseName' +courseCount + 
    			'" id="courseName"' + courseCount + '" placeholder="Name of Course" /> <input type="text" class="col-lg-5 control-text" name="courseGrade' +
    			+ courseCount + '" id="courseGrade"' + courseCount +'" placeholder="Grade Achieved" />');
                
    	newCourseDiv.appendTo("#gradCoursesInfo");
    	courseCount++;
    });

	/*<div id="publicationInfo">
	<label for="lblpubName" class="col-lg-5 control-label">Publication Name</label>
	<label for="lblpubComment" class="col-lg-5 control-label">Comments </label>
		<input type="text" class="col-lg-5 control-text" name="pubName1" id="pubName1" placeholder="Publication Name" />
		<input type="text" class="col-lg-5 control-text" name="pubComment1" id="pubComment1" placeholder="Comments" />*/
    
    $("#addPub").click(function () {
    	if(pubCount>5){
                alert("Only 5 Records allowed");
                return false;
    	}   
    	var newPubDiv = $("<div />");
                    
    	newPubDiv.html('<input type="text" class="col-lg-5 control-text" name="pubName' +pubCount + 
    			'" id="pubName"' + pubCount + '" placeholder="Name of Publication" /> <input type="text" class="col-lg-5 control-text" name="pubComment' +
    			+ pubCount + '" id="pubComment"' + pubCount +'" placeholder="Comments" />');
                
    	newPubDiv.appendTo("#publicationInfo");
    	pubCount++;
         });
});
</script>
	<div class="container">
		<div class="jumbotron">
			<div>
				<h1>Welcome to GTA Management System</h1>
			</div>
		</div>
		<div></div>
	</div>

	<div class="col-lg-6 col-lg-offset-3">
		<div class="well">
			<div class="container">
				<div class="row">
					<div class="col-lg-6">
						<form id="myForm" method="post" class="bs-example form-horizontal" action="NomineeActionController">
							<fieldset>
								<legend>Nominee Registration Form
								<% 
								String nomineeName=request.getSession().getAttribute("name").toString();
								String nomineeEmail="";
								String nomineePid="";
								String nominatedBy="";
								
								if( nomineeName != null) 
								{
									//Connection connection = DriverManager.getConnection( "jdbc:mysql://localhost:3306/GTAMS", "root", "root");
									Connection connection = DriverManager.getConnection( application.getInitParameter("DBURL"), 
										application.getInitParameter("DBUSER") ,application.getInitParameter("DBPWD")) ;
						            Statement stmtNominee = connection.createStatement() ;
						            ResultSet rsNominee = stmtNominee.executeQuery("select * from nominee where name='" + nomineeName +"'") ;
						            if (rsNominee.next())
						            {
							            nomineeEmail = rsNominee.getString("email");
										nomineePid = rsNominee.getString("pid");
										nominatedBy = rsNominee.getString("nominated_by");
						            }
								%>
								<div align="right">  
								<%
								 out.println("Welcome:"+ nomineeName +"|"+ nomineeEmail); %>
								</div>
								<%} %>
								
								</legend>
								<input type="hidden" name="pageName" value="nominee_view">

 								<div class="form-group">
									<label for="nomineeNameInput" class="col-lg-3 control-label">Name</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="nomineeName"
											id="nomineeName" value=<%=nomineeName %> readonly />
									</div>
								</div>

								<div class="form-group">
									<label for="NomineeEmailInput" class="col-lg-3 control-label">Email Address</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="email"
											id="emailInput" value=<%=nomineeEmail %> readonly />
									</div>
								</div>

								<div class="form-group">
									<label for="pidInput" class="col-lg-3 control-label">PID</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="pid"
											id="pidInput" value=<%=nomineePid %> readonly />
									</div>
								</div>
		
								<div class="form-group">
									<label for="nominatedByInput" class="col-lg-3 control-label">Nominated By</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="nominatedBy"
											id="nominatedby" value=<%=nominatedBy %> readonly />
									</div>
								</div>

								<div class="form-group">
									<label for="phoneNoInput" class="col-lg-3 control-label">Phone No</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="phoneNo"
											id="phoneNo" placeholder="Nominee Phone No" />
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
									<label for="speakTestPassed" class="col-lg-3 control-label">SPEAK TEST PASSED</label>
									<div class="col-lg-9">
										<input type="radio" name="speakTestPassed" id="radioSpeakTestPassedY" placeholder="SPEAK TEST PASSED" value="Yes" /> YES
										<input type="radio" name="speakTestPassed" id="radioSpeakTestPassedN" placeholder="SPEAK TEST PASSED" value="No" checked /> No
										<input type="radio" name="speakTestPassed" id="radioSpeakTestPassedUS" placeholder="SPEAK TEST PASSED" value="USG" /> US Graduate
									</div>
								</div>

								<div class="form-group">
									<label for="numSem" class="col-lg-3 control-label">Number of Semesters in Graduation</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="numSemesters"
											id="numSemesters" placeholder="Number of Semesters in Graduation" />
									</div>
								</div>

								<div class="form-group">
									<label for="numSemGTA" class="col-lg-3 control-label">Number of Semesters As GTA</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="numSemestersGTA"
											id="numSemestersGTA" placeholder="Number of Semesters as GTA" />
									</div>
								</div>


								<div class="form-group">
									<label for="currPHDAdvisor" class="col-lg-3 control-label">Current PHD Advisor </label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="currPHDAdvisor"
											id="currentPHDAdvisor" placeholder="Current PHD Advisor" />
									</div>
								</div>
								
								<div id="PHDAdvisorInfo">
									<label for="prevPHDAdvisor" class="col-lg-5 control-label">Previous PHD Advisor </label>
									<label for="prevPHDAdvisor" class="col-lg-5 control-label">Duration </label>
									<!-- <div class="col-lg-5">  -->
										<input type="text" class="col-lg-5 control-text" name="prevPHDAdvisor1" id="prevPHDAdvisor1" placeholder="Previous PHD Advisor" />
										<input type="text" class="col-lg-5 control-text" name="prevPHDAdvisorPeriod1" id="prevPHDPeriod1" placeholder="Duration" />
										<input type="button"class="col-lg-2 control-text" id="addPHDA" value="Add Record" />
    								<!--additional PHD Advisor Info will be here -->
								</div>

								<div id="gradCoursesInfo">
									<label for="lblcourseName" class="col-lg-5 control-label">Name of course</label>
									<label for="lblcourseGrade" class="col-lg-5 control-label">Grade </label>
										<input type="text" class="col-lg-5 control-text" name="courseName1" id="courseName1" placeholder="Course Name" />
										<input type="text" class="col-lg-5 control-text" name="courseGrade1" id="courseGrade1" placeholder="Grade Achieved" />
										<input type="button"class="col-lg-2 control-text" id="addCourse" value="Add Course" />
    								<!--Additional Courses will be added here -->
								</div>

								<div class="form-group">
									<label for="gpaLbl" class="col-lg-3 control-label">GPA of Above courses </label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="GPA"
											id="GPA" placeholder="GPA of All Above Courses" />
									</div>
								</div>

								<div id="publicationInfo">
									<label for="lblpubName" class="col-lg-5 control-label">Publication Name</label>
									<label for="lblpubComment" class="col-lg-5 control-label">Comments </label>
										<input type="text" class="col-lg-5 control-text" name="pubName1" id="pubName1" placeholder="Publication Name" />
										<input type="text" class="col-lg-5 control-text" name="pubComment1" id="pubComment1" placeholder="Comments" />
										<input type="button"class="col-lg-2 control-text" id="addPub" value="Add Publication" />
    								<!--Additional Publications will be added here -->
								</div>

								<%if (request.getAttribute("errorMessage")!=null) %>
								<div style="color: #FF0000;"><%=request.getAttribute("errorMessage") %></div>

								<%if (request.getAttribute("successMessage")!=null) %>
								<div style="color: #00FF00;"><%=request.getAttribute("successMessage") %></div>

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