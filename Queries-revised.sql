-- #1 Finds the names of volunteers who participated in events organized by NPO "SickKids_Foundation"
SELECT va.vloid.pname.get_fullname() AS Volunteer_Name
FROM volunteerassignment va
WHERE va.eoid.enpoid.nponame = 'SickKids_Foundation';



-- #2 Sorting Volunteer by the training hours (MAP method)
COLUMN vid FORMAT A10
COLUMN volunteer_name FORMAT A20
COLUMN training_hours FORMAT 999.99
select 
    v.vid, 
    v.pname.get_fullname() as volunteer_name, 
    v.sort_training_hours() as training_hours
from 
    volunteer v
order by value(v) DESC;


-- #3 A query demonstrating that ORDER method declared in the corresponding abstract data type works
SET LINESIZE 200;
COLUMN eid FORMAT A10
COLUMN event_name FORMAT A20
COLUMN event_date FORMAT A10
COLUMN coordinator_name FORMAT A20
SELECT e.eid,
    e.ename AS event_name,
    e.edatetime AS event_date,
    e.ecoid.pname.get_fullname() AS coordinator_name
FROM event e
ORDER BY VALUE(e);


-- #4 Get Role for Person and Volunteers (Demonstrates Overridden Method)
-- Query to get role of a person
COLUMN person_skill_id FORMAT A20
COLUMN role FORMAT A20
SELECT 
    ps.psid AS person_skill_id,
    ps.poid.get_role() AS role
FROM personskill ps;

-- Query to get role of a volunteer
COLUMN volunteer_id FORMAT A20
COLUMN Average_Rating FORMAT 999.99
COLUMN role FORMAT A20
SELECT 
    va.vloid.vid AS volunteer_id,
    va.vloid.get_average_rating() AS Average_Rating,
    va.vloid.get_role() AS role
FROM volunteerassignment va;


-- #5 Names, vids of volunteers with their assigned events and tasks 
COLUMN VID FORMAT A20;
COLUMN volunteer_name FORMAT A20;
COLUMN event_name FORMAT A30;
COLUMN task_name FORMAT A30;
SELECT va.vloid.vid AS VID,
    va.vloid.pname.get_fullname() AS volunteer_name,
    va.eoid.ename AS event_name,
    va.toid.tname AS task_name
FROM volunteerassignment va;
    

-- #6 Names of volunteers and events they attended where feedback rating is higher than 4.0
COLUMN volunteer_name FORMAT A20;
COLUMN event_name FORMAT A30;
COLUMN feedbackrating FORMAT 999.99;
SELECT va.vloid.pname.get_fullname() AS volunteer_name,
    va.eoid.ename AS event_name,
    va.feedbackrating
FROM volunteerassignment va
WHERE va.feedbackrating > 4.0;


-- #7 Coordinators’ names, events they managed, the number of volunteers assigned to the event 
COLUMN coordinator_name FORMAT A20;
COLUMN event_name FORMAT A30;
COLUMN total_volunteers FORMAT 999;
SELECT DISTINCT va.eoid.ecoid.pname.get_fullname() AS coordinator_name,
    va.eoid.ename AS event_name,
    va.get_number_of_volunteers() AS total_volunteers
FROM volunteerassignment va
ORDER BY va.get_number_of_volunteers() DESC;


-- #8 Names of events and their associated npos and coordinators 
COLUMN npo_name FORMAT A20;
COLUMN event_name FORMAT A20;
COLUMN coordinator_name FORMAT A20;
SELECT e.ename AS event_name,
    e.enpoid.nponame AS npo_name,
    e.ecoid.pname.get_fullname() AS coordinator_name
FROM event e;
    

-- #9 Finding Events's Volunteer Count and Coordinator Info
SET LINESIZE 200;
COLUMN EID FORMAT A07;
COLUMN event_name FORMAT A20;
COLUMN Total_Volunteer_Count FORMAT 999;
COLUMN cid FORMAT A07;
COLUMN Coordinator_Name FORMAT A20;
COLUMN Coordinator_Email FORMAT A20;
select DISTINCT va.eoid.eid AS EID,
  va.eoid.ename as Event_Name,
  va.eoid.edatetime as Event_Date,
  va.get_number_of_volunteers() as Total_Volunteer_Count,
  va.eoid.ecoid.cid AS cid,
  va.eoid.ecoid.pname.get_fullname() as Coordinator_Name,
  va.eoid.ecoid.email as Coordinator_Email
from volunteerassignment va;


-- #10 Get latest training with date and passed status for volunteer ID 'V001'
SET LINESIZE 150;
COLUMN Training_Details FORMAT A60;
COLUMN Training_Date FORMAT A20;
COLUMN passed FORMAT 99;
SELECT 
    vt.vloid.get_latest_training() AS Training_Details,   
    vt.training_date AS Training_Date,
    vt.passed
FROM 
    volunteertraining vt
WHERE 
    vt.vloid.vid='V001';


-- #11 Finds volunteer IDs, names and total hours worked in the event 'EVT001'
COLUMN VID FORMAT A20;
COLUMN Volunteer_Hours FORMAT 999.99;
COLUMN Name FORMAT A20;
SELECT 
    va.vloid.vid AS VID, 
    va.vloid.pname.get_fullname() AS Name, 
    va.vloid.get_volunteer_hours() AS Volunteer_Hours
FROM  
    volunteerassignment va
WHERE 
    va.eoid.eid = 'EVT001';


-- #12 Shows the percentage of participants who passed for each training program
COLUMN training_name FORMAT A30;
COLUMN percentage_passed FORMAT 999.99;
COLUMN training_date FORMAT A20;

SELECT
    vt.troid.trname AS training_name,
    vt.troid.passed_percent() AS percentage_passed,
    vt.training_date
FROM
    volunteertraining vt
ORDER BY
    vt.troid.passed_percent() DESC;
    

-- #13 Finds Coordinators Managing Events with Certificates expiring in a year
SET LINESIZE 150;
COLUMN Coordinator_Name FORMAT A20;
COLUMN Certificate_Name FORMAT A30;
COLUMN Expiry_Date FORMAT A20;
COLUMN Number_of_Events FORMAT 999;
SELECT 
    c.pname.get_fullname() AS Coordinator_Name,
    c.get_number_of_events() AS Number_of_Events,
    c.ccoid.certificatename AS Certificate_Name,
    c.ccoid.expirydate AS Expiry_Date
FROM 
    coordinator c
WHERE 
    c.cid IN (SELECT DISTINCT e.ecoid.cid FROM event e)
AND 
    c.ccoid.expirydate < ADD_MONTHS(SYSDATE,12)
ORDER BY 
    c.ccoid.expirydate ASC;