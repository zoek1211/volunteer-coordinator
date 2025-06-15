-- PART 2 - 5 NPOS

-- 1. Provide a list of events organized by my non-profit, detailing their statuses, descriptions, 
-- the number of volunteers needed, and the name(s) of the coordinator(s) overseeing them.

select xmlroot(xmlelement("npos", 
xmlagg(xmlelement("npo", xmlattributes(trim(e.enpoid.npoid) as "id"), 
xmlagg(xmlelement("event", xmlattributes(trim(e.eid) as "id"), xmlforest(e.ename as "event_name", 
e.estatus as "status", e.edesc as "description", e.requiredvolunteers as "required_volunteers",
e.ecoid.pname.get_fullname() as "coordinator_name")))))), version '1.0') as npo_events
from event e
group by e.enpoid.npoid;


-- 2. Provide the average feedback rating given to volunteers for events hosted by my
-- non-profit, including the name(s) of the coordinators who managed those events.

select xmlroot(xmlelement("npos", 
xmlagg(xmlelement("event", xmlattributes(trim(va.eoid.enpoid.npoid) as "npo_id", trim(va.eoid.eid) as "event_id"),
xmlforest(va.eoid.ename as "event_name", va.eoid.ecoid.pname.get_fullname() as "coordinator_name", round(avg(va.feedbackrating),2) as "average_feedback_rating")) 
order by trim(va.eoid.enpoid.npoid))), version '1.0') as average_ratings
from volunteerassignment va
group by va.eoid.enpoid.npoid, va.eoid.eid, va.eoid.ename, va.eoid.ecoid.pname.get_fullname();


-- 3. "Identify the volunteer with the lowest feedback rating for events hosted by my non-profit,
-- including the event name, task name, feedback rating, and feedback comment.

select xmlroot(xmlelement("npos", 
xmlagg(xmlelement("event", xmlattributes(trim(va.eoid.enpoid.npoid) as "npo_id", trim(va.eoid.eid) as "event_id"),
xmlforest(va.eoid.ename as "event_name", va.vloid.pname.get_fullname() as "volunteer_name", trim(va.toid.tid) as "task_name", va.feedbackrating as "feedback_rating", va.feedbackcomment as "feedback_comment"))
order by trim(va.eoid.eid))),version '1.0') as lowest_rating
from volunteerassignment va
where va.feedbackrating = (select min(va2.feedbackrating) from volunteerassignment va2 where va2.eoid.eid = va.eoid.eid);


-- 4. List coordinators who have managed events for my non-profit, including their certification details.

select xmlroot(xmlelement("npos", 
xmlagg(xmlelement("npo", xmlattributes(trim(e.enpoid.npoid) as "id"),
xmlforest(e.ecoid.pname.get_fullname() as "coordinator_name", e.ecoid.ccoid.certificatename as "certificate_name", e.ecoid.ccoid.certificatenumber as "certificate_number")))),
version '1.0') as coordinator_certifications 
from event e;


-- 5. Provide a list of volunteer names who have participated in events organized by my
-- non-profit, along with the tasks they were assigned to.

select xmlroot(xmlelement("npos", 
xmlagg(xmlelement("npo", xmlattributes(trim(va.eoid.enpoid.npoid) as "id"),
xmlagg(xmlelement("volunteer", xmlforest(va.vloid.pname.get_fullname() as "volunteer_name", va.toid.tname as "task_name")) 
order by va.vloid.pname.get_fullname())))), 
version '1.0') as volunteer_tasks
from volunteerassignment va
group by va.eoid.enpoid.npoid;

