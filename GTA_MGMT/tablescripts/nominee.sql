-- create database GTAMS;

use GTAMS;

create table login_master(
	userName varchar(16) primary key,
	password varchar(16) NOT NULL,
	pwd_expired char,					-- y/N
	role char,							--N->Nominee, F->Faculty, G->GCMember, S->SysAdm
	pwd_recovery_key varchar(64),
	name varchar(30) not null
);

insert into login_master values ('sysadm', 'sysadm', 'N', 'S', '', 'sysadm');
insert into login_master values ('nominee', 'nominee', 'N', 'N', '', 'gta');
insert into login_master values ('nominator', 'nominator', 'N', 'F', '', 'faculty');
insert into login_master values ('gcm', 'gcm', 'N', 'G', '', 'gcm');

insert into login_master values ('gta1', 'gta1', 'N', 'N', '', 'gta1');
insert into login_master values ('gta2', 'gta2', 'N', 'N', '', 'gta2');

insert into login_master values ('faculty1', 'faculty1', 'N', 'F','', 'faculty1');
insert into login_master values ('faculty2', 'faculty2', 'N', 'F','', 'faculty2');
insert into login_master values ('faculty3', 'faculty3', 'N', 'F','', 'faculty3');

insert into login_master values ('gcm1', 'gcm1', 'N', 'G', '', 'gcm1');
insert into login_master values ('gcm2', 'gcm2', 'N', 'G', '', 'gcm2');
insert into login_master values ('gcm3', 'gcm3', 'N', 'G', '', 'gcm3');


create table session_master(
	session_id varchar(20) primary key,
	faculty_deadline date,
	nominee_deadline date,
	gc_deadline date,
	gc_chair varchar(20)
);

insert into session_master(session_id, faculty_deadline, nominee_deadline, gc_deadline,  gc_chair) values ('fall2016', '2016-04-19', '2016-04-19', '2016-04-19', 'gcm');

create table gc_members(
	name varchar(32) primary key,
	email varchar(32),
	session_id varchar(20) references session_master(session_id)
);

insert into gc_members(name,email,session_id) values ('gcm','gcm@abc.com', 'fall2016');
insert into gc_members(name,email,session_id) values ('gcm1','gcm1@abc.com', 'fall2016');
insert into gc_members(name,email,session_id) values ('gcm2','gcm2@abc.com', 'fall2016');
insert into gc_members(name,email,session_id) values ('gcm3','gcm3@abc.com', 'fall2016');

create table scorecard(
	nominee_name varchar(30),
	gcm_name varchar(30),
	session_id varchar(20) references session_master(session_id),
	score INT,
	comment varchar(32)
	CONSTRAINT scorecard_PK PRIMARY KEY (nominee_name,gcm_name)
);

insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta1','gcm', 'fall2016',70, 'Comment1');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta1','gcm1', 'fall2016',60, 'Comment2');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta1','gcm2', 'fall2016',80, 'Comment3');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta1','gcm3', 'fall2016',90, 'Comment4');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta2','gcm', 'fall2016',80, 'Comment5');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta2','gcm1', 'fall2016',70, 'Comment6');
insert into scorecard(nominee_name,gcm_name,session_id,score,comment) values ('gta2','gcm2', 'fall2016',90, 'Comment7');
--insert into scorecard(nominee_name,gcm_name,session_id,score) values ('gta2','gcm3', 'fall2016',70);

create table nominator(
	name varchar(30) primary key,
	email varchar(30),
	session_id varchar(20) references session_master(session_id)
);

insert into nominator (name,email) values ('faculty1','faculty1@abc.com');
insert into nominator (name,email) values ('faculty2','faculty2@abc.com');
insert into nominator (name,email) values ('faculty3','faculty3@abc.com');

create table nominee(
	name varchar(30) primary key,
	email varchar(30),
	pid varchar(20),
	phone varchar(16),
	nominated_by varchar(30) references nominator(name),
	ranking int,
	current_phd_advisor varchar(30),
	is_phd_cs char,
	is_new char,
	numSemGrad int,
	speakTestPassed char,
	numSemGTA int,
	isRegistered char,
	nominated_at date,
	registered_at date,
	verified_at date,
	session_id varchar(20) references session_master(session_id)
);

insert into nominee (name, email, pid, phone, nominated_by, ranking, current_phd_advisor, is_phd_cs, is_new, numSemGrad, speakTestPassed, numSemGTA, 
isRegistered, nominated_at, registered_at, verified_at, session_id) values ('gta1','gta1@abc.com','1','0000001','faculty1', 1, 'ADV1', 'Y', 'Y', 4, 'Y', 3, 'N', '2016-04-19','2016-04-19','2016-04-19','fall2016');


insert into nominee (name, email, pid, phone, nominated_by, ranking, current_phd_advisor, is_phd_cs, is_new, numSemGrad, speakTestPassed, numSemGTA, 
isRegistered, nominated_at, registered_at, verified_at, session_id) values ('gta2','gta2@abc.com','2','0000002','faculty1',2,  'ADV2', 'Y', 'Y',4,'Y',3,'N','2016-04-19','2016-04-19','2016-04-19','fall2016');


insert into nominee (name, email, pid, phone, nominated_by, ranking,current_phd_advisor, is_phd_cs, is_new, numSemGrad, speakTestPassed, numSemGTA, 
isRegistered, nominated_at, registered_at, verified_at, session_id) values ('gta3','gta3@abc.com','3','0000003','faculty2', 2, 'ADV3', 'Y', 'Y',4,'Y',3,'N','2016-04-19','2016-04-19','2016-04-19','fall2016');


insert into nominee (name, email, pid, phone, nominated_by, ranking, current_phd_advisor, is_phd_cs, is_new, numSemGrad, speakTestPassed, numSemGTA, 
isRegistered, nominated_at, registered_at, verified_at, session_id) values ('gta4','gta4@abc.com','4','0000004','faculty2', 1,  'ADV4', 'Y', 'Y',4,'Y',3,'N','2016-04-19','2016-04-19','2016-04-19','fall2016');


insert into nominee (name, email, pid, phone, nominated_by, ranking, current_phd_advisor, is_phd_cs, is_new, numSemGrad, speakTestPassed, numSemGTA, 
isRegistered, nominated_at, registered_at, verified_at, session_id) values ('gta5','gta5@abc.com','5','0000005','faculty3', 1, 'ADV5', 'Y', 'Y',4,'Y',3,'N','2016-04-19','2016-04-19','2016-04-19','fall2016');

