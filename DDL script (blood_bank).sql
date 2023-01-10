 -- Checking to see if there is already an existing blood bank database, and if there is none the code automatically creates one  
CREATE DATABASE IF NOT EXISTS blood_bank;

USE blood_bank;

-- Creating my tables

CREATE TABLE blood_donor (
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
blood_type VARCHAR(4) NOT NULL,
age INT NOT NULL,
gender ENUM('M','F') NOT NULL,
house_address VARCHAR(125) DEFAULT('Not disclosed'),
email_address VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE patients (
patient_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
age INT NOT NULL,
blood_type VARCHAR(4) NOT NULL,
need_status VARCHAR(4) NOT NULL,
house_address VARCHAR(125),
medical_condition VARCHAR(125) NOT NULL
)

-- Creating a table that stores the medical record of donors to show that they were examined and deemed medically fit to donate blood.

CREATE TABLE donor_report (
dr_id VARCHAR(10) NOT NULL UNIQUE PRIMARY KEY,
donor_id INT NOT NULL,
hemoglobin_gDL INT NOT NULL,
temperature_celcius DECIMAL(5,2) NOT NULL,
blood_pressure_mmhg VARCHAR(10) NOT NULL,
pulse_rate_bpm INT NOT NULL,
weight_kg INT NOT NULL,
height_ft VARCHAR(10) NOT NULL,
date_recorded DATE NOT NULL,
FOREIGN KEY(donor_id) REFERENCES blood_donor(id)
);


CREATE TABLE requests(
request_id VARCHAR(10) NOT NULL PRIMARY KEY,
r_patient_id INT NOT NULL,
blood_type_rqst VARCHAR(10) NOT NULL,
date_rqst DATE NOT NULL,
quantity_rqst INT NOT NULL,
FOREIGN KEY(r_patient_id) REFERENCES patients(patient_id)
);


CREATE TABLE blood_bags (
blood_bag_id INT AUTO_INCREMENT PRIMARY KEY,
blood_type VARCHAR(5) NOT NULL,
quantity_avaliable INT DEFAULT 0
);

-- Creating a table that shows how often a donor donates blood.

CREATE TABLE donation_rate (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
no_of_donations_made INT NOT NULL,
donor_id INT NOT NULL,
date_of_last_donation DATE,
FOREIGN KEY(donor_id) REFERENCES blood_donor(id)
);

-- Creating database triggers

DELIMITER $$
CREATE TRIGGER low_hemoglobin_level
	BEFORE INSERT ON donor_report FOR EACH ROW
    BEGIN
		IF NEW.hemoglobin_gDL < 12
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = " can't donate blood due to low hemoglobin level! ";
		END IF;
	END;
$$

DELIMITER $$
CREATE TRIGGER high_body_temperature
	BEFORE INSERT ON donor_report FOR EACH ROW
    BEGIN
		IF NEW.temperature_celcius > 38.0
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "can't donate blood due to a high body temperature";
			END IF;
	END;
    $$
 
 DELIMITER $$
CREATE TRIGGER low_pulse_rate
	BEFORE INSERT ON donor_report FOR EACH ROW
    BEGIN
		IF NEW.pulse_rate_bpm < 50
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = " can't donate blood due to a low pulse rate!";
			END IF;
    END;
    $$

DELIMITER $$
CREATE TRIGGER high_pulse_rate
	BEFORE INSERT ON donor_report FOR EACH ROW
    BEGIN
		IF NEW.pulse_rate_bpm > 100
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "can't donate blood due to a high pulse rate!";
			END IF;
    END;
    $$
    DELIMITER ;
    
