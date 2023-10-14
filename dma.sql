CREATE TABLE Customer (
customer_id INT NOT NULL PRIMARY KEY, name VARCHAR(50) NOT NULL,
email VARCHAR(50),
phone_number VARCHAR(20),
address VARCHAR(100)
);
CREATE TABLE Train (
trainid INT NOT NULL PRIMARY KEY, type VARCHAR(50),
name VARCHAR(50),
Seats INT
);
CREATE TABLE Route (
Route_id INT NOT NULL PRIMARY KEY,
TrainID INT NOT NULL,
FromStation VARCHAR(50),
Tostation VARCHAR(50),
Distance INT,
FOREIGN KEY (TrainID) REFERENCES Train(trainid)
);
CREATE TABLE Employee (
employee_id INT NOT NULL PRIMARY KEY, name VARCHAR(50) NOT NULL,
address VARCHAR(100),
phone VARCHAR(20),
salary DECIMAL(10,2)
);
CREATE TABLE Management (
management_id INT NOT NULL PRIMARY KEY, employee_id INT NOT NULL,
name VARCHAR(50),
email VARCHAR(50),
phone_number VARCHAR(20),
address VARCHAR(100),
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
CREATE TABLE Station (
station_id INT NOT NULL PRIMARY KEY,
Route_ID INT NOT NULL,
name VARCHAR(50),
location VARCHAR(50),
code VARCHAR(10),
FOREIGN KEY (Route_ID) REFERENCES Route(Route_id)
);
CREATE TABLE Ticket (
Ticket_id INT NOT NULL PRIMARY KEY,
trainID INT NOT NULL,
class VARCHAR(10),
departureDate DATE,
customerID INT NOT NULL,
FOREIGN KEY (trainID) REFERENCES Train(trainid),
FOREIGN KEY (customerID) REFERENCES Customer(customer_id)
);
CREATE TABLE Fare (
fare_id INT NOT NULL PRIMARY KEY,
TicketID INT NOT NULL,
class VARCHAR(10),
FOREIGN KEY (TicketID) REFERENCES Ticket(Ticket_id)
);
CREATE TABLE Schedule (
schedule_id INT NOT NULL PRIMARY KEY,
Management_id INT NOT NULL,
Train_id INT NOT NULL,
departure_time TIME,
arrival_time TIME,
FOREIGN KEY (Management_id) REFERENCES Management(management_id), FOREIGN KEY (Train_id) REFERENCES Train(trainid)
);


INSERT INTO Customer (customer_id, name, email, phone_number, address) VALUES 
(3, 'Jane Doe', 'otherjane.doe@example.com', '551-552-5556', '16 Westland Ave');

SELECT * from Customer;



INSERT INTO Train (trainid, type, name, Seats) VALUES (1, 'Express', 'Bullet Train', 100),
(2, 'Local', 'Commuter Train', 200);
INSERT INTO Train (trainid, type, name, Seats) VALUES (7, 'Local', 'Commuter Train', 1500),
(8, 'Local', 'Commuter Train', 2500), (9, 'Local', 'Commuter Train', 500);

INSERT INTO Route (Route_id, TrainID, FromStation, Tostation, Distance) VALUES (1, 1, 'Tokyo', 'Osaka', 500),
(2, 2, 'New York', 'Boston', 200);
INSERT INTO Employee (employee_id, name, address, phone, salary) VALUES (1, 'Mike Johnson', '789 Elm St', '555-123-4567', 50000),
(2, 'Sarah Lee', '321 Oak Ave', '555-987-6543', 60000);
INSERT INTO Management (management_id, employee_id, name, email, phone_number, address)
VALUES (1, 1, 'John Doe', 'john.doe@example.com', '555-111-2222', '123 Main St'),
(2, 2, 'Jane Smith', 'jane.smith@example.com', '555-333-4444', '456 Park Ave');
INSERT INTO Station (station_id, Route_ID, name, location, code) VALUES (1, 1, 'Tokyo Station', 'Tokyo', 'TKY'),
(2, 2, 'New York Penn Station', 'New York', 'NYP');
INSERT INTO Ticket (Ticket_id, trainID, class, departureDate, customerID) VALUES (1, 1, 'FirstClass', '2023-04-10', 1),
(2, 2, 'Economy', '2023-05-15', 2);
INSERT INTO Ticket (Ticket_id, trainID, class, departureDate, customerID) VALUES (3, 3, 'FirstClass', '2023-04-10', 1),
(4, 4, 'Economy', '2023-05-15', 2);
INSERT INTO Ticket (Ticket_id, trainID, class, departureDate, customerID) VALUES (5, 3, 'FirstClass', '2023-04-10', 2),
(6, 4, 'Economy', '2023-05-15', 2);
INSERT INTO Ticket (Ticket_id, trainID, class, departureDate, customerID) VALUES (7, 3, 'FirstClass', '2023-04-10', 2),
(8, 3, 'Economy', '2023-05-15', 2);
INSERT INTO Fare (fare_id, TicketID, class) VALUES (1, 1, 'First Class'),
(2, 2, 'Economy');
INSERT INTO Fare (fare_id, TicketID, class, fare) VALUES (3, 3, 'FirstClass', 200),
(4, 4, 'Economy', 150);
INSERT INTO Fare (fare_id, TicketID, class, fare) VALUES (5, 5, 'FirstClass', 700);
#INSERT INTO Fare (fare_id, TicketID, class, fare) VALUES (6, 6, 'FirstClass', 1200);
INSERT INTO Schedule (schedule_id, Management_id, Train_id, departure_time, arrival_time) VALUES (1, 1, 1, '08:00:00', '12:00:00'),
(2, 2, 2, '09:00:00', '10:30:00');





#### Analytical Queries ############
#1. Retrieve the total number of customers who have booked tickets for a particular train:
SELECT COUNT(DISTINCT Ticket.customerID) AS Total_Customers FROM Ticket WHERE Ticket.trainID = 1;

#2. Retrieve the total number of employees who are working in a particular department:
SELECT COUNT(*) AS Total_Employees 
FROM Employee WHERE Employee.employee_id 
IN (SELECT Management.employee_id 
FROM Management WHERE Management.name = 'Sales');

#3. Retrieve the name and type of all the trains that have more than 500 seats:
SELECT name, type FROM Train WHERE Seats > 500;

#4. Retrieve the total number of tickets booked for a particular train on a specific date:
SELECT COUNT(*) AS Total_Tickets FROM Ticket WHERE Ticket.trainID = 2 AND Ticket.departureDate = '2023-04-12';

#5. Retrieve the name and type of all the trains that have stations at a particular location(NEW YORK):
SELECT Train.name, Train.type 
FROM Train 
INNER JOIN Route ON Train.trainid = Route.TrainID 
INNER JOIN Station ON Route.Route_id = Station.Route_ID 
WHERE Station.location = 'New York';

#6. Retrieve the name and email of the customer who has booked the maximum number of tickets:
SELECT Customer.name, Customer.email 
FROM Customer 
INNER JOIN Ticket ON Customer.customer_id = Ticket.customerID 
GROUP BY Customer.customer_id 
ORDER BY COUNT(Ticket.Ticket_id) DESC
Limit 1;



