

declare
ret boolean;
begin
ret:=dbms_xdb.createfolder('/public/MA810');
commit;
end;
/





SELECT xmlroot(
XMLELEMENT("EventVolunteers",
XMLAGG(
XMLELEMENT ("Event", XMLATTRIBUTES(trim(e.eoid.eid) as "ID"), xmlelement("EventName",e.eoid.ename),xmlagg (xmlelement("Volunteer",XMLATTRIBUTES(trim(e.vloid.vid) as "ID"),
XMLFOREST(e.vloid.pname.get_fullname() AS "VolunteerName",  e.vloid.email as "VolunteerEmail")) 
order by e.eoid.ename))
)
)
, version '1.0', standalone yes) as Document
FROM volunteerassignment e
group by  e.eoid;




Declare
ret boolean;
begin
ret := dbms_xdb.createresource('/public/MA810/EventVolunteers5.xml','
<EventVolunteers>
  <Event ID="EVT002">
    <EventName>PAWS Adoption Fair</EventName>
    <Volunteer ID="V002">
      <VolunteerName>Michael M Davis</VolunteerName>
      <VolunteerEmail>davis@gmail.com</VolunteerEmail>
    </Volunteer>
    <Volunteer ID="V005">
      <VolunteerName>Sophia A Clark</VolunteerName>
      <VolunteerEmail>clark@gmail.com</VolunteerEmail>
    </Volunteer>
    <Volunteer ID="V004">
      <VolunteerName>William T Harris</VolunteerName>
      <VolunteerEmail>harris@gmail.com</VolunteerEmail>
    </Volunteer>
    <Volunteer ID="V003">
      <VolunteerName>Olivia B Taylor</VolunteerName>
      <VolunteerEmail>taylor@gmail.com</VolunteerEmail>
    </Volunteer>
  </Event>
  <Event ID="EVT003">
    <EventName>Habitat Build-A-Home</EventName>
    <Volunteer ID="V004">
      <VolunteerName>William T Harris</VolunteerName>
      <VolunteerEmail>harris@gmail.com</VolunteerEmail>
    </Volunteer>
  </Event>
  <Event ID="EVT004">
    <EventName>Safety Fair</EventName>
    <Volunteer ID="V002">
      <VolunteerName>Michael M Davis</VolunteerName>
      <VolunteerEmail>davis@gmail.com</VolunteerEmail>
    </Volunteer>
  </Event>
  <Event>
    <EventName>Tussa</EventName>
    <Volunteer ID="V001">
      <VolunteerName>Emma L Wilson</VolunteerName>
      <VolunteerEmail>wilson@gmail.com</VolunteerEmail>
    </Volunteer>
    <Volunteer ID="V003">
      <VolunteerName>Olivia B Taylor</VolunteerName>
      <VolunteerEmail>taylor@gmail.com</VolunteerEmail>
    </Volunteer>
    <Volunteer ID="V002">
      <VolunteerName>Michael M Davis</VolunteerName>
      <VolunteerEmail>davis@gmail.com</VolunteerEmail>
    </Volunteer>
  </Event>
</EventVolunteers>
');
 commit;
 end;
 /







SELECT xmlroot(
XMLELEMENT("EventCoordinators",
XMLAGG(
XMLELEMENT ("Event", XMLATTRIBUTES(trim(e.eid) as "ID"), xmlelement("EventName",e.ename),xmlelement("Coordinator", XMLATTRIBUTES(trim(e.ecoid.cid) as "ID"),
XMLFOREST(e.ecoid.pname.get_fullname() AS "CoordinatorName",  e.ecoid.email as "CoordinatorEmail") ))
)
)
, version '1.0', standalone yes) as Document
FROM event e








Declare
ret boolean;
begin
ret := dbms_xdb.createresource('/public/MA810/EventCoordinators5.xml','
<EventCoordinators>
  <Event ID="EV001">
    <EventName>SickKidsFD</EventName>
    <Coordinator ID="C001">
      <CoordinatorName>John M Doe</CoordinatorName>
      <CoordinatorEmail>doe@gmail.com</CoordinatorEmail>
    </Coordinator>
  </Event>
  <Event ID="EVT002">
    <EventName>PAWS Adoption Fair</EventName>
    <Coordinator ID="C002">
      <CoordinatorName>Jane L Smith</CoordinatorName>
      <CoordinatorEmail>smith@gmail.com</CoordinatorEmail>
    </Coordinator>
  </Event>
  <Event ID="EVT003">
    <EventName>Habitat Build-A-Home</EventName>
    <Coordinator ID="C003">
      <CoordinatorName>Alice S Johnson</CoordinatorName>
      <CoordinatorEmail>johnson@gmail.com</CoordinatorEmail>
    </Coordinator>
  </Event>
  <Event ID="EVT004">
    <EventName>Safety Fair</EventName>
    <Coordinator ID="C001">
      <CoordinatorName>John M Doe</CoordinatorName>
      <CoordinatorEmail>doe@gmail.com</CoordinatorEmail>
    </Coordinator>
  </Event>
</EventCoordinators>
');
 commit;
 end;
 /


SELECT xmlroot(
XMLELEMENT("NPOEvents",
XMLAGG(
XMLELEMENT ("NPO", XMLATTRIBUTES(trim(e.enpoid.npoid) as "ID"), xmlelement("NPOName",e.enpoid.nponame),xmlagg (xmlelement("Event",
XMLFOREST(e.eid as "EventID", e.ename AS "EventName",  e.edatetime as "EventDateTime", e.edesc as "Description", e.requiredvolunteers as "NumberOfVolunteersRequired")) 
order by e.edatetime))
)
)
, version '1.0', standalone yes) as Document
FROM event e
group by  e.enpoid;


Declare
ret boolean;
begin
ret := dbms_xdb.createresource('/public/MA810/NPOEvents5.xml','


<NPOEvents>
  <NPO ID="N001">
    <NPOName>SickKids_FND</NPOName>
    <Event>
      <EventID>EV001</EventID>
      <EventName>SickKidsFD</EventName>
      <EventDateTime>2025-03-29T10:30:00.000000</EventDateTime>
      <Description>Fun and engaging activities for children</Description>
      <NumberOfVolunteersRequired>3</NumberOfVolunteersRequired>
    </Event>
  </NPO>
  <NPO ID="N002">
    <NPOName>PAWS</NPOName>
    <Event>
      <EventID>EVT002</EventID>
      <EventName>PAWS Adoption Fair</EventName>
      <EventDateTime>2025-02-02T11:30:00.000001</EventDateTime>
      <Description>An event to promote pet adoption</Description>
      <NumberOfVolunteersRequired>4</NumberOfVolunteersRequired>
    </Event>
  </NPO>
  <NPO ID="N003">
    <NPOName>Habitat_for_Humanity</NPOName>
    <Event>
      <EventID>EVT003</EventID>
      <EventName>Habitat Build-A-Home</EventName>
      <EventDateTime>2025-01-23T10:30:00.000002</EventDateTime>
      <Description>A construction event to build a home</Description>
      <NumberOfVolunteersRequired>2</NumberOfVolunteersRequired>
    </Event>
  </NPO>
  <NPO ID="N004">
    <NPOName>Canadian_Red_Cross</NPOName>
    <Event>
      <EventID>EVT004</EventID>
      <EventName>Safety Fair</EventName>
      <EventDateTime>2025-04-23T12:30:00.000003</EventDateTime>
      <Description>A community event focused on safety.</Description>
      <NumberOfVolunteersRequired>1</NumberOfVolunteersRequired>
    </Event>
  </NPO>
</NPOEvents>

');
 commit;
 end;
 /



SELECT xmlroot(
XMLELEMENT("VolunteersTranings",
XMLAGG(
XMLELEMENT ("Volunteer", XMLATTRIBUTES(trim(e.vloid.vid) as "ID"),  xmlelement("VolunteerInfo",
XMLFOREST(e.vloid.pname.get_fullname() AS "VolunteerName",  e.vloid.email as "VolunteerEmail")) 
,xmlagg (xmlelement("Training",
XMLFOREST(e.troid.trid AS "TrainingID",  e.troid.trname as "TrainingName", e.troid.trdesc as "Description", e.troid.trhours as "Capasity")) 
order by e.troid.trid))
)
)
, version '1.0', standalone yes) as Document
FROM volunteertraining e
group by  e.vloid;


Declare
ret boolean;
begin
ret := dbms_xdb.createresource('/public/MA810/VolunteersTranings5.xml','
<VolunteersTranings>
  <Volunteer ID="V001">
    <VolunteerInfo>
      <VolunteerName>Emma L Wilson</VolunteerName>
      <VolunteerEmail>wilson@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training>
      <TrainingID>TR10000003</TrainingID>
      <TrainingName>Supportive
Interaction</TrainingName>
      <Description>Learn key components and uses of emergency kits.</Description
>
      <Capasity>11</Capasity>
    </Training>
  </Volunteer>
  <Volunteer ID="V002">
    <VolunteerInfo>
      <VolunteerName>Michael M Davis</VolunteerName>
      <VolunteerEmail>davis@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training>
      <TrainingID>TR10000006</TrainingID>
      <TrainingName>Pet Care
Basics</TrainingName>
      <Description>Learn pet care basics for happy, healthy pets.</Description>
      <Capasity>15</Capasity>
    </Training>
    <Training>
      <TrainingID>TR10000007</TrainingID>
      <TrainingName>Children Gift
Bag Assembly</TrainingName>
      <Description>Learn how to assemble and decorate gift bags</Description>
      <Capasity>2</Capasity>
    </Training>
    <Training/>
  </Volunteer>
  <Volunteer ID="V003">
    <VolunteerInfo>
      <VolunteerName>Olivia B Taylor</VolunteerName>
      <VolunteerEmail>taylor@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training>
      <TrainingID>TR10000002</TrainingID>
      <TrainingName>Communication
101</TrainingName>
      <Description>Learn basics of effective communication.</Description>
      <Capasity>6</Capasity>
    </Training>
    <Training>
      <TrainingID>TR10000009</TrainingID>
      <TrainingName>Engaging
Storytelling</TrainingName>
      <Description>Learn to tell engaging stories to delight kids.</Description>

      <Capasity>2</Capasity>
    </Training>
  </Volunteer>
  <Volunteer ID="V004">
    <VolunteerInfo>
      <VolunteerName>William T Harris</VolunteerName>
      <VolunteerEmail>harris@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training>
      <TrainingID>TR10000001</TrainingID>
      <TrainingName>Event Setup
Essentials</TrainingName>
      <Description>Core skills for arranging eq.</Description>
      <Capasity>10</Capasity>
    </Training>
    <Training>
      <TrainingID>TR10000008</TrainingID>
      <TrainingName>Safe
Furniture Moving</TrainingName>
      <Description>Learn techniques to move furniture safely.</Description>
      <Capasity>3</Capasity>
    </Training>
  </Volunteer>
  <Volunteer ID="V005">
    <VolunteerInfo>
      <VolunteerName>Sophia A Clark</VolunteerName>
      <VolunteerEmail>clark@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training/>
  </Volunteer>
  <Volunteer ID="V006">
    <VolunteerInfo>
      <VolunteerName>Emily A Jones</VolunteerName>
      <VolunteerEmail>jones@gmail.com</VolunteerEmail>
    </VolunteerInfo>
    <Training/>
  </Volunteer>
</VolunteersTranings>
');
 commit;
 end;
 /
 

 ---Part 5
 ---1. Query qualified a)b)c) reqs. Selects   Volunteer which passed a particular Training
xquery  
let $c:= doc("/public/MA810/VolunteersTranings5.xml")  
for $m in $c/VolunteersTranings/Volunteer  
where $m/Training/TrainingID ='TR10000008'  
return $m/VolunteerInfo/VolunteerName  

--- 2. Query qualified  a)b)d) reqs. Selects   Trainings passed by  a particular Training
xquery  
let $c:= doc("/public/MA810/VolunteersTranings5.xml")  
for $m in $c/VolunteersTranings/Volunteer  
where $m/@ID="V004"  
return $m/Training  

---3 Query qualified  a)b)d)f) reqs. Selects   Names of Volunteers for a particular Event
let $c:= doc("/public/MA810/EventVolunteers5.xml")  
for $m in $c/EventVolunteers/Event 
where $m/@ID="EVT002"  
return $m/Volunteer/VolunteerName/text()  


--- 4 Query qualified a)b)c)d)e)f). Returns list of Coodinators  involved in Events of a particular NPO

xquery  
let $c:=doc("/public/MA810/NPOEvents5.xml") 
for $d in $c/NPOEvents/NPO[@ID="N002"]
let $s := doc("/public/MA810/EventCoordinators5.xml") 
for $e in $s/EventCoordinators/Event 
where ($d/Event/EventID = $e/@ID) 
return  $e/Coordinator/CoordinatorName/text()
 /

--- 5 Query  qualified a)b)d). Reurns  list of trainings of a particular volunteer 
xquery  
let $c:= doc("/public/MA810/VolunteersTranings5.xml")  
for $m in $c/VolunteersTranings/Volunteer  
where $m/@ID='V004'
return $m/Training  
/

--- 6 Query qualified a)b)c)f) Returns number of Volunteers required for a particular Event

xquery  
let $c:=doc("/public/MA810/NPOEvents5.xml") 
for $d in $c/NPOEvents/NPO/Event
where $d/EventID='EVT003'
return $d/NumberOfVolunteersRequired/text()
/

--- 7 Query qualified a)b)c)d)e)f). Returns list of Volunteers  incolved in Events of a particular NPO

xquery  
let $c:=doc("/public/MA810/NPOEvents5.xml") 
for $d in $c/NPOEvents/NPO[@ID="N002"]
let $s := doc("/public/MA810/EventVolunteers5.xml") 
for $e in $s/EventVolunteers/Event 
where ($d/Event/EventID = $e/@ID) 
return  $e/Volunteer/VolunteerName/text()
 /

--- 8 Query qualified a)b)c)f). Returns Volunteers who passe a particular Treining
 xquery  
let $c:=doc("/public/MA810/VolunteersTranings5.xml") 
for $d in $c/VolunteersTranings/Volunteer
where $d/Training/TrainingID='TR10000006'
return  $d/VolunteerInfo/VolunteerName/text()
/




---9. Query qualified a)b)c)f) reqs. Returns List of e-mails of Volunteers who passed a particular Training
xquery  
let $c:= doc("/public/MA810/VolunteersTranings5.xml")  
for $m in $c/VolunteersTranings/Volunteer  
where $m/Training/TrainingID ='TR10000008'  
return $m/VolunteerInfo/VolunteerEmail/text()
/


---10. Query qualified a)b)c) reqs. Returns List of Trainings with number of seats more than 3
xquery  
let $c:= doc("/public/MA810/VolunteersTranings5.xml")  
for $m in $c/VolunteersTranings/Volunteer  
where $m/Training/Capasity > 3  
return  $m/Training/TrainingName


---11. Query qualified a)b)d)e)f) reqs. Returns List of Volunteers who worked  on events with a particular coordinator
xquery  
let $c:=doc("/public/MA810/EventCoordinators5.xml") 
for $d in $c/EventCoordinators/Event 
let $s := doc("/public/MA810/EventVolunteers5.xml") 
for $e in $s/EventVolunteers/Event 
where ($d/@ID = $e/@ID) and $d/Coordinator/@ID='C003'
return  $e/Volunteer/VolunteerName/text()
 /



---12. Query qualified a)b)d)e)f) reqs. Returns List of Coordinators who worked  on events with a particular Volunteer
xquery  
let $c:=doc("/public/MA810/EventCoordinators5.xml") 
for $d in $c/EventCoordinators/Event 
let $s := doc("/public/MA810/EventVolunteers5.xml") 
for $e in $s/EventVolunteers/Event 
where ($d/@ID = $e/@ID) and $d/Coordinator/@ID='C003'
return  $d/Coordinator/CoordinatorName/text()
 /

---13. Query qualified a)b)d)e)f) reqs. Returns List of Trainings passed by Volunteers of a particular event
xquery  
let $c:=doc("/public/MA810/VolunteersTranings5.xml") 
for $d in $c/VolunteersTranings/Volunteer 
let $s := doc("/public/MA810/EventVolunteers5.xml") 
for $e in $s/EventVolunteers/Event
where $e/@ID='EVT002' and ($d/@ID = $e/Volunteer/@ID)  
return  $d/Training
 /

 --- 14 uery qualified a)b)d) reqs. Returns the Coordinator Infp of a particular event

xquery  
let $c:=doc("/public/MA810/EventCoordinators5.xml") 
for $d in $c/EventCoordinators/Event 
where $d/@ID =  'EVT003'
return  $d/Coordinator

--- 14 uery qualified a)b)d) reqs. Returns the list of events by a particular NPO
xquery  
let $c:=doc("/public/MA810/NPOEvents5.xml") 
for $d in $c/NPOEvents/NPO
where $d/@ID='N003'
return  $d/Event
