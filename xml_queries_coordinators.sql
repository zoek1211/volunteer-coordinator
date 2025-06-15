-- PART 2

-- Coordinators 

-- 1) Provide the names and email addresses of all volunteers who are assigned to the events I am managing.

select xmlroot(xmlelement("coordinators", 
xmlagg(xmlelement("coordinator", xmlattributes(trim(va.eoid.ecoid.cid) as "id"),
xmlagg(xmlelement("volunteer_information", xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.vloid.email as "volunteer_email", va.eoid.ename as "event_name"))
order by va.eoid.ename)))), version '1.0') as volunteer_information
from volunteerassignment va
group by va.eoid.ecoid.cid;

-- 2) Provide a list of tasks for all my events, showing the names of the assigned volunteers for each task.

select xmlroot(xmlelement("coordinators", 
xmlagg(xmlelement("coordinator", xmlattributes(va.eoid.ecoid.pname.get_fullname() as "coordinator_name", va.eoid.ename as "event_name"),
xmlagg(xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.toid.tname as "task_name"))))), version '1.0') as volunteer_task
from volunteerassignment va
group by va.eoid.ecoid.pname.get_fullname(), va.eoid.ename;


-- 3) What personal details as well as certification are currently stored in the system and which events have I managed.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(trim(e.ecoid.cid) as "id"),
xmlforest(e.ecoid.pname.get_fullname() as "coordinator_name", e.ecoid.dob as "date_of_birth", e.ecoid.address as "address", e.ecoid.phn as "phone_number", e.ecoid.email as "email",
e.ecoid.ccoid.certificatename as "certification"),
xmlelement("events", xmlagg(xmlelement("event", e.ename)))))),
version '1.0') as coordinator_details
from event e
group by e.ecoid.cid, e.ecoid.pname.get_fullname(), e.ecoid.dob, e.ecoid.address, e.ecoid.phn, e.ecoid.email, e.ecoid.ccoid.certificatename
order by e.ecoid.cid;

-- 4) List feedback ratings and comments for volunteers under my supervision.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(va.eoid.ecoid.pname.get_fullname() as "name"),
xmlagg(xmlelement("volunteers", (xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.feedbackrating as "feedback_rating", va.feedbackcomment as "feedback_comment"))))))),
version '1.0') as volunteer_feedback
from volunteerassignment va
group by va.eoid.ecoid.pname.get_fullname()
order by va.eoid.ecoid.pname.get_fullname();


-- 5) Show me the details of upcoming events I am managing.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(trim(e.ecoid.cid) as "id", e.ecoid.pname.get_fullname() as "coordinator_name"),
xmlagg(xmlelement("event", xmlforest(e.ename as "event_name", e.edatetime as "event_date")))))),
version '1.0') as upcoming_events
from event e
where TRUNC(e.edatetime) > TRUNC(SYSDATE)
group by e.ecoid.cid, e.ecoid.pname.get_fullname()
order by e.ecoid.cid;

-- 6) Show the required volunteer count and actual count for each event I am managing.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(event_data.coordinator_name as "coordinator_name"),
xmlelement("events", xmlagg(xmlelement("event", xmlforest(event_data.event_name as "event_name", event_data.required_volunteers as "required_volunteers", event_data.actual_volunteers as "actual_volunteers"))))))),
version '1.0') as volunteer_count
from (select DISTINCT va.eoid.ecoid.pname.get_fullname() as coordinator_name, va.eoid.ename as event_name, va.eoid.requiredvolunteers as required_volunteers, va.get_number_of_volunteers() as actual_volunteers
from volunteerassignment va) event_data
group by event_data.coordinator_name
order by event_data.coordinator_name;


-- 7)Provide the names and contact details for all non-profits I have been assigned for the the events.

select xmlroot(xmlelement("coordinators", 
xmlagg(xmlelement("coordinator", xmlattributes(trim(e.ecoid.cid) as "id"),
xmlagg(xmlelement("event", xmlforest(e.ename as "event_name", e.enpoid.nponame as "npo_name", e.enpoid.npoemail as "npo_email", e.enpoid.npophn as "npo_phone")))))),
version '1.0') as assigned_npos
from event e
group by e.ecoid.cid;


-- 8) What is the total number of hours contributed by volunteers for each of my events?

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(trim(va.eoid.ecoid.cid) as "id", va.eoid.ecoid.pname.get_fullname() as "coordinator_name"),
xmlforest(va.eoid.ename as "event_name", sum(va.vhours) as "total_hours")) order by va.eoid.ecoid.cid)),
version '1.0') as volunteer_hours
from volunteerassignment va
group by va.eoid.ecoid.cid, va.eoid.ecoid.pname.get_fullname(), va.eoid.ename;


-- 9) Identify the volunteer with their completed training hours  assigned to events I manage, along with their assigned task.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(va.eoid.ecoid.pname.get_fullname() as "coordinator_name", va.eoid.ename as "event_name"),
xmlagg(xmlelement("volunteer", xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.vloid.get_train_hours() as "training_hours", va.toid.tname as "task_name")))))),
version '1.0') as volunteer_training
from volunteerassignment va
group by va.eoid.ecoid.pname.get_fullname(), va.eoid.ename
order by va.eoid.ecoid.pname.get_fullname(), va.eoid.ename;


-- 10) Provide the total number of events I'm assigned to, grouped by nonprofit organization name.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(name as "name"),
xmlagg(xmlelement("npo", xmlforest(npo_name as "npo_name", number_of_events as "number_of_events")))))),
version '1.0') as assigned_events
from (select distinct va.eoid.ecoid.pname.get_fullname() as name, va.eoid.enpoid.nponame as npo_name, va.eoid.ecoid.get_number_of_events() as number_of_events
from volunteerassignment va) coordinator_npo_pairs
group by name;


-- 11) List all volunteers who have contributed more than 8 volunteer hours across events I am managing, including their total hours, assigned tasks, and the name of the event(s) they participated in.

select xmlroot(xmlelement("coordinators",
xmlagg(xmlelement("coordinator", xmlattributes(va.eoid.ecoid.pname.get_fullname() as "coordinator_name", va.eoid.ename as "event_name"),
xmlagg(xmlelement("volunteer", xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.vloid.get_volunteer_hours() as "volunteer_hours", va.toid.tname as "task_name")))))),
version '1.0') as high_hours
from volunteerassignment va
where va.vloid.get_volunteer_hours() > 8
group by va.eoid.ecoid.pname.get_fullname(), va.eoid.ename
order by va.eoid.ecoid.pname.get_fullname(), va.eoid.ename;

