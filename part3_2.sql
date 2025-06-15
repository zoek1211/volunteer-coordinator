-- PART 3 XSU - 5 NPOs

-- 6. What is the total number of events hosted by my non-profit, and who were the coordinators that managed them?

OracleXML getXML -user "grp4/heregrp4" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowsetTag "NPO_EVENTS" \
-rowTag "NPO" \
"select trim(e.enpoid.npoid) as "npo_id", e.ecoid.pname.get_fullname() as "coordinator", count(e.eid) as "number_of_events"
from event e
group by trim(e.enpoid.npoid), e.ecoid.pname.get_fullname()
order by trim(e.enpoid.npoid)"

    
-- 7. Show the total number of hours contributed by each volunteer to events hosted by my non-profit, along with their full names.

OracleXML getXML -user "grp4/heregrp4" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowsetTag "VOLUNTEER_HOURS" \
-rowTag "VOLUNTEER" \
"select trim(va.eoid.enpoid.npoid) as "npo_id", va.eoid.ename as "event_name", va.vloid.pname.get_fullname() as "volunteer_name", sum(va.vhours) as "total_hours"
from volunteerassignment va
group by trim(va.eoid.enpoid.npoid), va.eoid.ename, va.vloid.pname.get_fullname()
order by trim(va.eoid.enpoid.npoid)"

    
-- 8. Identify the volunteer with the highest feedback rating for events hosted by my non-profit, including the event name, task name, and feedback rating.

OracleXML getXML -user "grp4/heregrp4" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowsetTag "FEEDBACK_RATING" \
-rowTag "VOLUNTEER" \
"select trim(va.eoid.enpoid.npoid) as "npo_id", va.eoid.ename as "event_name", va.vloid.pname.get_fullname() as "volunteer_name", va.toid.tname as "task_name", 
va.feedbackrating as "feedback_rating"
from volunteerassignment va
where va.feedbackrating = (select max(va2.feedbackrating) from volunteerassignment va2 where va2.eoid.eid = va.eoid.eid)
order by trim(va.eoid.enpoid.npoid)"

    
-- 9. Identify the volunteer who has contributed the most hours to events hosted by my non-profit, 
-- along with the total hours and the name(s) of the event(s) they participated in.

OracleXML getXML -user "grp4/heregrp4" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowsetTag "TOP_VOLUNTEERS" \
-rowTag "VOLUNTEER" \
"select trim(va.eoid.enpoid.npoid) as "npo_id", va.vloid.pname.get_fullname() as "volunteer_name", va.vhours as "total_hours", va.eoid.ename as "event_name"
from volunteerassignment va
where va.vhours = (select max(va2.vhours) from volunteerassignment va2 where va2.eoid.eid = va.eoid.eid)
order by trim(va.eoid.enpoid.npoid)"
    

-- 10. What information (name, email, phone number) about my non-profit is stored in the system, and what is the total number of events associated with us?"

OracleXML getXML -user "grp4/heregrp4" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowsetTag "NPO_INFO" \
-rowTag "NPO" \
"select trim(e.enpoid.npoid) as "npo_id", e.enpoid.nponame as "npo_name", e.enpoid.npoemail as "npo_email", e.enpoid.npophn as "npo_phone", count(e.eid) as "number_of_events"
from event e
group by trim(e.enpoid.npoid), e.enpoid.nponame, e.enpoid.npoemail, e.enpoid.npophn"