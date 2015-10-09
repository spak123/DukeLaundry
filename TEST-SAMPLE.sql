SELECT * FROM Student;

SELECT * FROM MachineLoc;

SELECT * FROM Machine;

SELECT * FROM MachinesInUse;


----------------SAMPLE QUERIES-------------------
--What laundry machines do we have to display based on what the user has selected?
--Note: will store laundry rooms and room number in a DECLARE variable so it can be dynamic
--User selects "wannamaker" on web interface
--We query out laundry rooms in wannamaker:
SELECT DISTINCT laundry_room FROM MachineLoc WHERE dorm_name = 'wannamaker';


--Display to user drop down menu of possible laundry rooms
--User selects laundry room 001 
--We query out machines that are in room 001:
SELECT machine_id FROM MachineLoc WHERE dorm_name = 'wannamaker' AND laundry_room = '001';


--We need to determine the specific laundry machine information based on the id
SELECT Machine.id, Machine.status, Machine.start_time, Machine.machine_type FROM Machine, 
(SELECT machine_id FROM MachineLoc WHERE dorm_name = 'wannamaker' AND laundry_room = '001') 
AS M
WHERE M.machine_id = Machine.id;

--This information will then be used to render laundry machines in the room
--along with their statuses. 
--Based on status, the machines will be color coded so user knows what is being used by him/herself (blue)
--what is busy because someone else is using it (red), what is available (green),
--and what is out of order (gray)

--We also need information for when a student begins to use a machine to know when to
--notify the student when the machine is done via email
--Start time will be used on the application code side to determine when the machine is done
--Add duration to start_time and that's when an email will be sent to notify the user
--NOTE: student_id will also be stored in a dynamic variable in the actual implementation
SELECT Machine.id, MachinesInUse.duration, MachinesInUse.student_id, 
Machine.start_time, Machine.machine_type
FROM MachinesInUse, Machine WHERE student_id = 'abu22' AND MachinesInUse.id = Machine.id;

