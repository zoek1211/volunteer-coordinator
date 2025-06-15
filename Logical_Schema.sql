--Creating UDTs

CREATE TYPE name_t AS OBJECT (
	fname VARCHAR2(10),
	mname VARCHAR2(10),
	lname VARCHAR2(10),
	MEMBER FUNCTION get_fullname RETURN VARCHAR2);
/
    
CREATE TYPE skill_t AS OBJECT (
    skid CHAR(3),
    skillname VARCHAR2(20),
    skilldesc VARCHAR2(50),
    skilltype VARCHAR2(10));
/

CREATE TYPE person_t AS OBJECT (
    pid CHAR(10),
    pname name_t,
    dob DATE,
    address VARCHAR2(50),
    phn CHAR(10),
    email VARCHAR2(20),
    MEMBER FUNCTION get_age RETURN INT,
    MEMBER FUNCTION get_role RETURN VARCHAR2,
    MAP MEMBER FUNCTION sort_training_hours RETURN NUMBER
    )NOT FINAL;
/

CREATE TYPE personskill_t AS OBJECT (
    psid CHAR(10),
    poid REF person_t,
    skoid REF skill_t);
/

CREATE TYPE coordinatorcertificate_t AS OBJECT (
    crid CHAR(10),
    certificatename VARCHAR2(30),
    certificatenumber VARCHAR2(15),
    expirydate DATE,
    certificatedesc VARCHAR2(50));
/

CREATE TYPE coordinator_t UNDER person_t (
    cid CHAR(10),
    cstatus VARCHAR2(10),
    ccoid coordinatorcertificate_t,
    OVERRIDING MEMBER FUNCTION get_role RETURN VARCHAR2,
    MEMBER FUNCTION get_number_of_events RETURN INT);
/

CREATE TYPE npo_t AS OBJECT (
    npoid CHAR(10),
    nponame VARCHAR2(30),
    npophn CHAR(10),
    npoemail VARCHAR2(20));
/

CREATE TYPE event_t AS OBJECT (
    eid CHAR(10),
    ename VARCHAR2(20),
    edatetime TIMESTAMP,
    enpoid REF npo_t,
    ecoid REF coordinator_t,
    estatus VARCHAR2(15),
    edesc VARCHAR2(50),
    requiredvolunteers INT,
    MEMBER FUNCTION get_events(startdate IN DATE, enddate IN DATE) RETURN INT,
    ORDER MEMBER FUNCTION order_by_date(e2 IN event_t) RETURN INT
    );
/

CREATE TYPE task_t AS OBJECT (
    tid CHAR(10),
    tname VARCHAR2(30),
    tdesc VARCHAR2(50));
/    
    
CREATE TYPE training_t AS OBJECT (
    trid CHAR(10),
    trname VARCHAR2(30),
    toid REF task_t,
    trdesc VARCHAR2(50),
    trhours NUMBER(5,2),
    MEMBER FUNCTION passed_percent RETURN INT);
/

CREATE TYPE volunteer_t UNDER person_t (
    vid CHAR(10),
    vstatus VARCHAR2(10),
    MEMBER FUNCTION get_volunteer_hours RETURN NUMBER,
    MEMBER FUNCTION get_train_hours RETURN NUMBER,
    MEMBER FUNCTION get_latest_training RETURN training_t,
    MEMBER FUNCTION get_average_rating RETURN NUMBER,
    OVERRIDING MEMBER FUNCTION get_role RETURN VARCHAR2,
    OVERRIDING MAP MEMBER FUNCTION sort_training_hours RETURN NUMBER);
/

CREATE TYPE volunteertraining_t AS OBJECT (
    vtid CHAR(10),
    vloid REF volunteer_t,
    troid REF training_t,
    passed NUMBER(1),
    training_date DATE);
/

CREATE TYPE volunteerassignment_t AS OBJECT (
    vaid CHAR(10),
    vloid REF volunteer_t,
    eoid REF event_t,
    toid REF task_t,
    vhours NUMBER(5,2),
    feedbackrating NUMBER(4,2),
    feedbackcomment VARCHAR2(50),
    MEMBER FUNCTION get_number_of_volunteers RETURN INT,
    MEMBER FUNCTION get_highest_rating_volunteer RETURN volunteer_t,
    MEMBER FUNCTION get_active_volunteers RETURN volunteer_t);
/

--Creating Tables

CREATE TABLE skill OF skill_t(skid PRIMARY KEY);

CREATE TABLE person OF person_t(pid PRIMARY KEY);

CREATE TABLE personskill OF personskill_t(psid PRIMARY KEY);

CREATE TABLE coordinator OF coordinator_t(cid PRIMARY KEY);

CREATE TABLE npo OF npo_t(npoid PRIMARY KEY); 

CREATE TABLE event OF event_t(eid PRIMARY KEY); 

CREATE TABLE task OF task_t(tid PRIMARY KEY); 

CREATE TABLE training OF training_t(trid PRIMARY KEY);

CREATE TABLE volunteer OF volunteer_t(vid PRIMARY KEY); 

CREATE TABLE volunteertraining OF volunteertraining_t(vtid PRIMARY KEY); 

ALTER TABLE volunteertraining
ADD CONSTRAINT chk_passed CHECK(passed IN (0,1));

CREATE TABLE volunteerassignment OF volunteerassignment_t(vaid PRIMARY KEY);