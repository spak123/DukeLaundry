laundry=# SELECT * FROM Student;
 netid |        email        
-------+---------------------
 abu22 | abu22@laundrydb.com
 bnu54 | bnu54@laundrydb.com
(2 rows)



laundry=# SELECT * FROM MachineLoc
laundry-# ;
 dorm_name  | laundry_room | machine_num | machine_id 
------------+--------------+-------------+------------
 wannamaker | 001          | a1          | 1
 wannamaker | 001          | a2          | 2
 wannamaker | 001          | a3          | 3
 wannamaker | 001          | a4          | 4
 wannamaker | 001          | b1          | 5
 wannamaker | 001          | b2          | 6
 wannamaker | 001          | b3          | 7
 wannamaker | 001          | b4          | 8
(8 rows)


laundry=# SELECT * FROM Machine
laundry-# ;
 id |  status   | start_time | machine_type 
----+-----------+------------+--------------
 2  | available |            | washer
 3  | available |            | washer
 4  | available |            | washer
 6  | available |            | dryer
 1  | busy      | 01:00:00   | washer
 5  | busy      | 01:00:00   | dryer
(6 rows)


laundry=# SELECT * FROM MachinesInUse;
 id | duration | student_id 
----+----------+------------
 1  |       26 | abu22
 5  |       30 | bnu54
(2 rows)

----------------SAMPLE QUERIES-------------------
What laundry machines do we have to display based on what the user has selected?
Note: will store laundry rooms and room number in a DECLARE variable so it can be dynamic
--User selects "wannamaker" on web interface
--We query out laundry rooms in wannamaker:
SELECT DISTINCT laundry_room FROM MachineLoc WHERE dorm_name = 'wannamaker';
 laundry_room 
--------------
 001
(1 row)

--Display to user drop down menu of possible laundry rooms
--User selects laundry room 001 
--We query out machines that are in room 001:
SELECT machine_id FROM MachineLoc WHERE dorm_name = 'wannamaker' AND laundry_room = '001';
 machine_id 
------------
 1
 2
 3
 4
 5
 6
 7
 8
(8 rows)

--We need to determine the specific laundry machine information based on the id
SELECT Machine.id, Machine.status, Machine.start_time, Machine.machine_type FROM Machine, 
(SELECT machine_id FROM MachineLoc WHERE dorm_name = 'wannamaker' AND laundry_room = '001') 
AS M
WHERE M.machine_id = Machine.id;
 id |  status   | start_time | machine_type 
----+-----------+------------+--------------
 1  | busy      | 01:00:00   | washer
 2  | available |            | washer
 3  | available |            | washer
 4  | available |            | washer
 5  | busy      | 01:00:00   | dryer
 6  | available |            | dryer
(6 rows)

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
 id | duration | student_id | start_time | machine_type 
----+----------+------------+------------+--------------
 1  |       26 | abu22      | 01:00:00   | washer
(1 row)


