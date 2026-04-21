-- =============================================
-- 1. DATABASE SCHEMA: CREATE TABLES (DDL)
-- =============================================

CREATE TABLE Patients (
    PatientID CHAR(5) PRIMARY KEY,
    PatientName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender CHAR(10),
    PhoneNumber CHAR(10)
);

CREATE TABLE Families (
    FamilyID CHAR(5) PRIMARY KEY,
    PatientID CHAR(5) NOT NULL,
    FatherName VARCHAR(50) NOT NULL,
    MotherName VARCHAR(50) NOT NULL,
    NumberOfChildren INT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE Administrator (
    AdminID CHAR(5) PRIMARY KEY,
    AdminName VARCHAR(50) NOT NULL,
    Gender VARCHAR(15),
    DeptName VARCHAR(30) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID CHAR(5) PRIMARY KEY,
    DoctorName VARCHAR(50) NOT NULL,
    Gender VARCHAR(15),
    DeptName VARCHAR(30) NOT NULL,
    Salary DECIMAL(10, 2),
    AdminID CHAR(5),
    FOREIGN KEY (AdminID) REFERENCES Administrator(AdminID)
);

CREATE TABLE Rooms (
    RoomNumber VARCHAR(10) PRIMARY KEY,
    Floor INT,
    Status VARCHAR(20) NOT NULL
);

CREATE TABLE Appointments (
    AppointmentID VARCHAR(10) PRIMARY KEY,
    PatientID CHAR(5) NOT NULL,
    DoctorID CHAR(5),
    AppointmentDate DATE,
    AppointmentTime VARCHAR(10),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE MedicalRecords (
    RecordID CHAR(5) PRIMARY KEY,
    PatientID CHAR(5),
    DoctorID CHAR(5),
    DateOfVisit DATE,
    Symptoms VARCHAR(200),
    Diagnosis VARCHAR(200),
    Medications VARCHAR(200),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Surgeries (
    SurgeryID CHAR(5) PRIMARY KEY,
    SurgeryDate DATE,
    SurgeryDescription VARCHAR(200),
    PatientID CHAR(5),
    DoctorID CHAR(5),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Employees (
    Employee_id CHAR(5) PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Job_Title VARCHAR(30),
    PhoneNumber CHAR(10)
);

CREATE TABLE Bill (
    BillNo CHAR(5) PRIMARY KEY,
    PatientID CHAR(5),
    Gender CHAR(10),
    HealthCard VARCHAR(20),
    Amount DECIMAL(10, 2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- =============================================
-- 2. DATA INSERTION: INSERT DATA (DML)
-- =============================================

-- Inserting sample patients
INSERT INTO Patients VALUES ('11244', 'ASEEL', TO_DATE('12/06/2003','DD/MM/YYYY'), 'female', '0543218885');
INSERT INTO Patients VALUES ('11245', 'ABDULLAH', TO_DATE('01/01/1990','DD/MM/YYYY'), 'male', '0501234567');

-- Inserting sample families
INSERT INTO Families VALUES ('201', '11244', 'Ahmed', 'Layla', 2);

-- Inserting sample rooms
INSERT INTO Rooms VALUES ('112333', 1, 'Available');
INSERT INTO Rooms VALUES ('66454', 2, 'Available');
INSERT INTO Rooms VALUES ('1020', 1, 'Booked');

-- Inserting sample appointments
INSERT INTO Appointments VALUES ('A006', '11244', 'D0002', TO_DATE('05/08/2023','DD/MM/YYYY'), '2:00 PM');
INSERT INTO Appointments VALUES ('A003', '11245', 'D0001', TO_DATE('10/10/2023','DD/MM/YYYY'), '10:00 AM');

-- =============================================
-- 3. ANALYSIS & OPERATIONS: SELECT, UPDATE, DELETE
-- =============================================

-- Count of surgeries for each doctor
SELECT DoctorID, COUNT(SurgeryID) AS TotalSurgeries 
FROM Surgeries 
GROUP BY DoctorID;

-- Doctors who have not conducted any surgeries
SELECT d.DoctorName
FROM Doctors d
LEFT JOIN Surgeries s ON d.DoctorID = s.DoctorID 
WHERE s.DoctorID IS NULL;

-- Delete all the Appointments in October
DELETE FROM Appointments
WHERE EXTRACT(MONTH FROM AppointmentDate) = 10;

-- Top 3 most common symptoms
SELECT Symptoms, COUNT(*) AS SymptomCount 
FROM MedicalRecords
GROUP BY Symptoms
ORDER BY SymptomCount DESC 
FETCH FIRST 3 ROWS ONLY;

-- Oldest and youngest patient
SELECT MIN(DateOfBirth) AS OldestPatient, MAX(DateOfBirth) AS YoungestPatient 
FROM Patients;

-- Doctors whose salary is higher than any dentist's salary
SELECT * FROM Doctors
WHERE Salary > ALL (SELECT Salary 
                    FROM Doctors
                    WHERE DeptName = 'dentist');

-- Update status of specific rooms
UPDATE Rooms
SET Status = CASE 
                WHEN RoomNumber IN ('112333', '66454') THEN 'Booked'
                WHEN RoomNumber = '1020' THEN 'Available'
                ELSE Status
            END
WHERE RoomNumber IN ('112333', '66454', '1020');

-- List record IDs and names for records
SELECT M.RecordID, D.DoctorName, P.PatientName
FROM MedicalRecords M
JOIN Doctors D ON M.DoctorID = D.DoctorID
JOIN Patients P ON M.PatientID = P.PatientID;