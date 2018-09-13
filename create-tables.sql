PRAGMA foreign_keys=ON;
.mode csv


CREATE TABLE Carriers(
	cid VARCHAR PRIMARY KEY,
	name VARCHAR
);
.import carriers.csv Carriers


CREATE TABLE Months(
	mid INT PRIMARY KEY,
	month VARCHAR
);
.import months.csv Months


CREATE TABLE Weekdays(
	did INT PRIMARY KEY,
	day_of_week VARCHAR
);
.import weekdays.csv Weekdays


CREATE TABLE Flights(
	fid INT PRIMARY KEY,
	year INT,
	month_id INT,
	day_of_month INT,
	day_of_week_id INT,
	carrier_id CHAR(2),
	flight_num INT,
	origin_city VARCHAR,
	origin_state VARCHAR,
	dest_city VARCHAR,
	dest_state VARCHAR,
	departure_delay INT,
	taxi_out INT,
	arrival_delay INT,
	canceled INT,
	actual_time INT,
	distance INT,
	FOREIGN KEY (carrier_id) REFERENCES Carriers(cid),
	FOREIGN KEY (month_id) REFERENCES Months(mid),
	FOREIGN KEY (day_of_week_id) REFERENCES Weekdays(did)
);
.import flights-small.csv Flights
