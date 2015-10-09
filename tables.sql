CREATE TABLE Student(netid VARCHAR(10) NOT NULL PRIMARY KEY,
                 email VARCHAR(100));
CREATE TABLE MachineLoc(dorm_name VARCHAR(70) NOT NULL,
                  laundry_room VARCHAR(20) NOT NULL,
                  machine_num VARCHAR(70) NOT NULL,
                  machine_id VARCHAR(70) NOT NULL PRIMARY KEY);
CREATE TABLE Machine(id VARCHAR(70) NOT NULL PRIMARY KEY REFERENCES MachineLoc(machine_id),
                     status VARCHAR(70) NOT NULL,
                     start_time TIME,
                     machine_type VARCHAR(50) NOT NULL);
CREATE TABLE MachinesInUse(id VARCHAR(70) NOT NULL UNIQUE PRIMARY KEY REFERENCES Machine(id),
                       duration SMALLINT NOT NULL,
                       student_id VARCHAR(10) NOT NULL REFERENCES Student(netid));

--Function and Trigger to prevent adding Machine if a MachineLoc doesn't already exist
CREATE FUNCTION TF_NoMachineLoc_ThenNoMachine() RETURNS TRIGGER AS $$
BEGIN
  -- (f) YOUR IMPLEMENTATION GOES HERE
  IF (SELECT MachineLoc.machine_id FROM MachineLoc WHERE 
  	NEW.id = MachineLoc.machine_id) IS NULL THEN
  	RAISE EXCEPTION 'Cannot add machine without machine location';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql

CREATE TRIGGER TG_NoMachineLoc_ThenNoMachine
  BEFORE INSERT OR UPDATE ON Machine
  FOR EACH ROW
  EXECUTE PROCEDURE TF_NoMachineLoc_ThenNoMachine();

--Function and Trigger to prevent Machine that is in use to be used again by another 

--\COPY Student(netid, email) FROM 'data/students.dat' WITH DELIMITER ',' NULL '' CSV;

INSERT INTO Student VALUES('abu22', 'abu22@laundrydb.com');
INSERT INTO Student VALUES('bnu54', 'bnu54@laundrydb.com');

INSERT INTO MachineLoc VALUES('wannamaker', '001', 'a1', '1');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'a2', '2');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'a3', '3');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'a4', '4');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'b1', '5');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'b2', '6');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'b3', '7');
INSERT INTO MachineLoc VALUES('wannamaker', '001', 'b4', '8');

INSERT INTO Machine VALUES('1', 'available', NULL, 'washer');
INSERT INTO Machine VALUES('2', 'available', NULL, 'washer');
INSERT INTO Machine VALUES('3', 'available', NULL, 'washer');
INSERT INTO Machine VALUES(4, 'available', NULL, 'washer');
INSERT INTO Machine VALUES(5, 'available', NULL, 'dryer');
INSERT INTO Machine VALUES(6, 'available', NULL, 'dryer');

INSERT INTO Machine VALUES('5', available, NULL, 'dryer');
UPDATE Machine SET status = 'busy', start_time = '1:00:00' WHERE id = '1';
UPDATE Machine SET status = 'busy', start_time = '1:00:00' WHERE id = '5';
INSERT INTO MachinesInUse VALUES('1',26,'abu22');
INSERT INTO MachinesInUse VALUES('5',30,'bnu54');
--failing insertions:
--try to use machine that doesn't exist
INSERT INTO MachinesInUse VALUES('100',26,'abu22');
--trying to have 2+ people use a machine at the same time
INSERT INTO MachinesInUse VALUES('1',30,);


-- create a trigger to remove a machine from MachineInUse when its status changes from busy to availible:
CREATE FUNCTION TF_Remove_From_Machine_In_Use() RETURNS TRIGGER AS $$
BEGIN
IF EXISTS (SELECT * from Machine where NEW.status = 'available')
    THEN
    DELETE FROM MachineInUse where machineInUse.id = NEW.id
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_Remove_From_Machine_In_Use
AFTER UPDATE OF status ON Machine
FOR EACH ROW
EXECUTE PROCEDURE TF_Remove_From_Machine_In_Use();

--create a trigger that prevents a user from selecting a machine already used by another user
CREATE FUNCTION TF_One_Machine_Per_User() RETURNS TRIGGER AS $$
BEGIN
IF EXCISTS (SELECT * FROM Machine WHERE Machine.id = new.id AND Machine.status='busy')
THEN RAISE EXCEPTION 'This machine is already in use', 
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_One_Machine_Per_User
BEORE INSERT ON MachineInUse
FOR EACH ROW
EXECUTE PROCEDURE TF_One_Machine_Per_User