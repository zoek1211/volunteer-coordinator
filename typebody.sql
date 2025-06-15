--Defining Functions

CREATE TYPE BODY name_t AS
    MEMBER FUNCTION get_fullname RETURN VARCHAR2
    IS
    BEGIN
    RETURN self.fname||' '||self.mname||' '||self.lname;
    END;
END;
/

CREATE TYPE BODY person_t AS
    MEMBER FUNCTION get_age RETURN INT
    IS
    BEGIN
    RETURN ((SYSDATE-self.dob)/365);
    END;
    MEMBER FUNCTION get_role RETURN VARCHAR2
    IS
    BEGIN
    RETURN 'User';
    END;
    MAP MEMBER FUNCTION sort_training_hours RETURN NUMBER
    IS
    BEGIN
    RETURN 0;
    END;
END;
/

CREATE TYPE BODY coordinator_t AS
    OVERRIDING MEMBER FUNCTION get_role RETURN VARCHAR2
    IS
    BEGIN
    RETURN 'Coordinator';
    END;
    MEMBER FUNCTION get_number_of_events RETURN INT
    IS
    event_count INT DEFAULT 0;
    BEGIN
    SELECT COUNT(*) INTO event_count
    FROM event e
    WHERE DEREF(e.ecoid).cid = self.cid;
    RETURN event_count;
    END;
END;
/

CREATE TYPE BODY event_t AS
    MEMBER FUNCTION get_events(startdate IN DATE, enddate IN DATE) RETURN INT
    IS
    event_count INT DEFAULT 0;
    BEGIN
    SELECT COUNT(*) INTO event_count
    FROM event e
    WHERE TRUNC(e.edatetime) >= startdate AND TRUNC(e.edatetime) <= enddate;
    RETURN event_count;
    END;
    ORDER MEMBER FUNCTION order_by_date(e2 IN event_t) RETURN INT
    IS
    BEGIN
    IF self.edatetime < e2.edatetime THEN
        RETURN -1;
    ELSIF self.edatetime > e2.edatetime THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
    END;
END;
/

CREATE OR REPLACE TYPE BODY training_t AS
    MEMBER FUNCTION passed_percent RETURN INT
    IS
    total INT DEFAULT 0;
    passed INT DEFAULT 0;
    BEGIN
    SELECT COUNT(DEREF(vt.vloid).vid) INTO total
    FROM volunteertraining vt
    WHERE DEREF(vt.troid).trid =self.trid;
    IF total = 0 THEN
        RETURN 0;
    END IF;
    SELECT COUNT(*) INTO passed
    FROM volunteertraining vt
    WHERE vt.passed = 1 AND DEREF(vt.troid).trid =self.trid;
    RETURN (passed/total)*100;
    END;
END;
/

CREATE TYPE BODY volunteer_t AS
    OVERRIDING MEMBER FUNCTION get_role RETURN VARCHAR2
    IS
    BEGIN
    RETURN 'Volunteer';
    END;
    MEMBER FUNCTION get_volunteer_hours RETURN NUMBER
    IS
    total_hours NUMBER(5,2);
    BEGIN
    SELECT NVL(SUM(va.vhours),0) INTO total_hours
    FROM volunteerassignment va
    WHERE DEREF(va.vloid).vid = self.vid;
    RETURN total_hours;
    END;
    MEMBER FUNCTION get_train_hours RETURN NUMBER
    IS
    training_hours NUMBER(5,2);
    BEGIN
    SELECT NVL(SUM(DEREF(vt.troid).trhours),0) INTO training_hours
    FROM volunteertraining vt
    WHERE DEREF(vt.vloid).vid = self.vid;
    RETURN training_hours;
    END;
    MEMBER FUNCTION get_latest_training RETURN training_t
    IS
    latest_training training_t;
    BEGIN
    SELECT DEREF(vt.troid) INTO latest_training
    FROM volunteertraining vt
    WHERE DEREF(vt.vloid).vid = self.vid
    ORDER BY vt.training_date DESC
    FETCH FIRST 1 ROW ONLY;
    END;
    MEMBER FUNCTION get_average_rating RETURN NUMBER
    IS
    average_rating NUMBER(5,2);
    BEGIN
    SELECT NVL(AVG(CAST(feedbackrating AS NUMBER)),0) INTO average_rating
    FROM volunteerassignment va
    WHERE DEREF(va.vloid).vid = self.vid;
    END;
    OVERRIDING MAP MEMBER FUNCTION sort_training_hours RETURN NUMBER
    IS
    training_hours NUMBER(5,2);
    BEGIN
    SELECT NVL(SUM(DEREF(vt.troid).trhours),0) INTO training_hours
    FROM volunteertraining vt
    WHERE DEREF(vt.vloid).vid = self.vid;
    RETURN training_hours;
    END;
END;
/

CREATE OR REPLACE TYPE BODY volunteerassignment_t AS
    MEMBER FUNCTION get_number_of_volunteers RETURN INT
    IS
    volunteer_number INT;
    BEGIN
    SELECT COUNT(*) INTO volunteer_number
    FROM volunteerassignment va
    WHERE DEREF(va.eoid).eid = DEREF(self.eoid).eid;
    RETURN volunteer_number;
    END;
    MEMBER FUNCTION get_highest_rating_volunteer RETURN volunteer_t
    IS
    highest_rated_volunteer volunteer_t;
    BEGIN
    SELECT DEREF(va.vloid) INTO highest_rated_volunteer
    FROM volunteerassignment va
    WHERE va.feedbackrating IN(
    SELECT MAX(feedbackrating)
    FROM volunteerassignment);
    RETURN highest_rated_volunteer;
    END;
    MEMBER FUNCTION get_active_volunteers RETURN volunteer_t
    IS
    active_volunteers volunteer_t;
    BEGIN
    SELECT DEREF(va.vloid) INTO active_volunteers
    FROM volunteerassignment va
    WHERE DEREF(va.vloid).status = 'Active';
    RETURN active_volunteers;
    END;
END;
/