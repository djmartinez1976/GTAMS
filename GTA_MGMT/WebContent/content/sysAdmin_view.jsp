<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>System Admin Panel</title>
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
				<li><a href="./login.jsp">Login</a></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown">Explore<b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="#">Contact us</a></li>
						<li class="divider"></li>
						<li><a href="#">Further Actions</a></li>
					</ul></li>
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

    var gcMemberCount = 2;
		
    $("#addGCMember").click(function () {
				
	if(gcMemberCount>10){
            alert("Only 10 Records allowed");
            return false;
	}   
	
	var newGCMemberDiv = $("<div />");
                
	newGCMemberDiv.html('<input type="text" class="col-lg-3 control-text" name="gcMemberName' +gcMemberCount + 
			'" id="gcMemberName"' + gcMemberCount + '" placeholder="GC Member Name" /> <input type="text" class="col-lg-3 control-text" name="gcMemberEmail' +
			+ gcMemberCount + '" id="gcMemberEmail"' + gcMemberCount +'" placeholder="GC Member Email" /> <input type="text" class="col-lg-3 control-text" name="gcMemberUserName' 
			+ gcMemberCount + '" id="gcMemberUserName"' + gcMemberCount + '" placeholder="GC Member User Name" /> <input type="text" class="col-lg-3 control-text" name="gcMemberPassword' 
			+ gcMemberCount + '" id="gcMemberPassword"' + gcMemberCount + '" placeholder="GC Member Password" />');
            
	newGCMemberDiv.appendTo("#GCMembersInfo");
				
	gcMemberCount++;
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

	<c:if test="${not empty message}">
		<div class="message green">${message}</div>
	</c:if>

	<div class="col-lg-6 col-lg-offset-3">
		<div class="well">
			<div class="container">
				<div class="row">
					<div class="col-lg-6">
						<form id="myForm" method="post" class="bs-example form-horizontal" action="SysAdminActionController">
							<fieldset>
								<legend>Admin DashBoard</legend>
								
								<input type="hidden" name="pageName" value="signup">

								<div class="form-group">
									<label for="sessionIdInput" class="col-lg-3 control-label">Name</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="sessionId"
											id="sessionIdInput" placeholder="SessionId for this semester" />
									</div>
								</div>

								<div class="form-group">
									<label for="gcChairInput" class="col-lg-3 control-label">GC chair</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="gcChair"
											id="gcChair" placeholder="GC Chair" />
									</div>
								</div>

									
								<div id="GCMembersInfo" class="form-group">
										<input type="button" id="addGCMember" value="Add GC" />

										<label for="gcMemberName" class="col-lg-3 control-label">GC Member Name </label>
										<label for="gcMemberEmail" class="col-lg-3 control-label">GC Member Email </label>
										<label for="gcMemberUserName" class="col-lg-3 control-label">GC Member User Name </label>
										<label for="gcMemberPassword" class="col-lg-3 control-label">GC Member Password </label>
										
										
										
										<input type="text" class="col-lg-3 control-text" name="gcMemberName1" id="gcMemberName1" placeholder="GC Member Name" />
										<input type="text" class="col-lg-3 control-text" name="gcMemberEmail1" id="gcMemberEmail1" placeholder="GC Member Email" />
										
										<input type="text" class="col-lg-3 control-text" name="gcMemberUserName1" id="gcMemberUserName1" placeholder="GC Member UserName" />
										<input type="text" class="col-lg-3 control-text" name="gcMemberPassword1" id="gcMemberPassword1" placeholder="GC Member Password" />
								</div>

								<div class="form-group">
									<label for="deadLineNominator" class="col-lg-3 control-label">Deadline Nominator </label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="deadLineNominator"
											id="deadLineNominator" placeholder="in yyyy-MM-dd format" />
									</div>
								</div>
								
								
								<div class="form-group">
									<label for="deadLineNominee" class="col-lg-3 control-label">Deadline Nominee</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="deadLineNominee"
											id="deadLineNominee" placeholder="in yyyy-MM-dd format" />
									</div>
								</div>
								
								
								<div class="form-group">
									<label for="deadLineVerification" class="col-lg-3 control-label">Verification Deadline</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="deadLineVerification"
											id="deadLineVerification" placeholder="in yyyy-MM-dd format" />
									</div>
								</div>

								<div class="col-lg-9 col-lg-offset-3">
									<button class="btn btn-primary" data-toggle="modal"
										data-target="#themodal">Create Session</button>
									<div id="themodal" class="modal fade" data-backdrop="static">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal"
														aria-hidden="true">&times;</button>
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