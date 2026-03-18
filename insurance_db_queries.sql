-- Project : Insurance Claims Processing--

-- CREATING DATABASE--
CREATE DATABASE insurance_db;

-- USING/SELECTING DATABASE--
USE insurance_db;

-- CREATING TABLE customers--
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    date_of_birth DATE,
    phone VARCHAR(15)
);

DESC customers;

-- CREATING TABLE agents--
CREATE TABLE agents (
    agent_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);

DESC agents;

-- CREATING TABLE policies--
CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    customer_id INT,
    agent_id INT,
    policy_type VARCHAR(20),
    premium DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

DESC policies;

-- CREATING TABLE claims--
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    description VARCHAR(100),
    claim_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);


DESC claims;

-- CREATING TABLE payments--
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    claim_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);

DESC payments;

-- INSERTING DATA INTO customers--
INSERT INTO customers VALUES
(1,'Rahul Sharma','1990-05-12','9876543210'),
(2,'Priya Verma','1988-09-23','9876543211'),
(3,'Amit Patel','1992-02-10','9876543212'),
(4,'Sneha Iyer','1995-07-18','9876543213'),
(5,'Rohit Mehta','1985-11-05','9876543214'),
(6,'Anjali Singh','1993-03-21','9876543215'),
(7,'Vikas Rao','1989-06-14','9876543216'),
(8,'Neha Gupta','1991-12-01','9876543217'),
(9,'Karan Malhotra','1987-04-09','9876543218'),
(10,'Pooja Nair','1994-08-30','9876543219');

SELECT * FROM customers;

-- INSERTING DATA INTO agents --
INSERT INTO agents VALUES
(1,'Arjun Kumar','Auto'),
(2,'Meena Das','Life'),
(3,'Suresh Reddy','Home'),
(4,'Kavita Joshi','Auto'),
(5,'Ramesh Shah','Life'),
(6,'Sunita Roy','Home'),
(7,'Nitin Kulkarni','Auto'),
(8,'Deepa Menon','Life'),
(9,'Alok Mishra','Home'),
(10,'Manoj Yadav','Auto');

SELECT * FROM agents;

-- INSERTING DATA INTO policies--
INSERT INTO policies VALUES
(101,1,1,'Auto',12000,'2023-01-01','2024-01-01'),
(102,2,2,'Life',18000,'2023-02-01','2033-02-01'),
(103,3,3,'Home',15000,'2023-03-01','2028-03-01'),
(104,4,4,'Auto',13000,'2023-04-01','2024-04-01'),
(105,5,5,'Life',20000,'2023-05-01','2033-05-01'),
(106,6,6,'Home',16000,'2023-06-01','2028-06-01'),
(107,7,7,'Auto',14000,'2023-07-01','2024-07-01'),
(108,8,8,'Life',22000,'2023-08-01','2033-08-01'),
(109,9,9,'Home',17000,'2023-09-01','2028-09-01'),
(110,10,10,'Auto',12500,'2023-10-01','2024-10-01'),
(111,1,2,'Life',19000,'2023-11-01','2033-11-01'),
(112,2,3,'Home',15500,'2023-12-01','2028-12-01'),
(113,3,4,'Auto',13500,'2024-01-01','2025-01-01'),
(114,4,5,'Life',21000,'2024-02-01','2034-02-01'),
(115,5,6,'Home',16500,'2024-03-01','2029-03-01');

SELECT * FROM policies;

-- INSERTING DATA INTO claims--
INSERT INTO claims VALUES
(201,101,'2023-06-10','Accident Damage',50000,'Approved'),
(202,102,'2023-07-15','Medical Claim',75000,'Approved'),
(203,103,'2023-08-20','Fire Damage',120000,'Pending'),
(204,104,'2023-09-05','Car Theft',300000,'Rejected'),
(205,105,'2023-10-10','Life Coverage',100000,'Approved'),
(206,106,'2023-11-12','Water Damage',60000,'Pending'),
(207,107,'2023-12-01','Minor Accident',20000,'Approved'),
(208,108,'2024-01-10','Hospitalization',80000,'Approved'),
(209,109,'2024-02-15','Earthquake Damage',150000,'Pending'),
(210,110,'2024-03-05','Car Repair',40000,'Approved');

SELECT * FROM claims;

-- INSERTING DATA INTO payments--
INSERT INTO payments VALUES
(301,201,'2023-06-20',50000),
(302,202,'2023-07-25',75000),
(303,205,'2023-10-20',100000),
(304,207,'2023-12-10',20000),
(305,208,'2024-01-20',80000),
(306,210,'2024-03-15',40000),
(307,201,'2023-06-25',20000),
(308,202,'2023-07-30',45000),
(309,205,'2023-10-25',26000),
(310,208,'2024-01-25',12000);

SELECT * FROM payments;


-- Q1) List all claims for a specific customer.--
SELECT claims. * 
FROM customers
JOIN policies ON customers.customer_id = policies.customer_id
JOIN claims ON policies.policy_id = claims.policy_id
WHERE customers.name = 'Rahul Sharma';



-- Q2) Calculate the total claim amount paid out per policy type.--
SELECT policies.policy_type, SUM(claims.claim_amount)
FROM policies
JOIN claims ON policies.policy_id = claims.policy_id
WHERE claims.status = 'Approved'
GROUP BY policies.policy_type;



-- Q3) Find the agent who has sold the most policies.--
SELECT agents.name, COUNT(policies.policy_id)
FROM agents
LEFT JOIN policies ON agents.agent_id = policies.agent_id
GROUP BY agents.name
ORDER BY COUNT(policies.policy_id) DESC;




-- Q4) Identify customers with more than one active policy.--
SELECT customers.name, policies.end_date, COUNT(policies.policy_id)
FROM customers
JOIN policies ON customers.customer_id = policies.customer_id
WHERE policies.end_date > CURDATE()
GROUP BY customers.name,policies.end_date;
-- HAVING COUNT(policies.policy_id) > 1;



-- Q5) Calculate the average claim amount.--
SELECT AVG(claim_amount)
FROM claims;



-- Q6) Find policies that have no claims filed against them.--
SELECT policies.policy_id
FROM policies
LEFT JOIN claims ON policies.policy_id = claims.policy_id
WHERE claims.claim_id IS NULL;



-- Q7) List all claims that are still pending approval.--
SELECT * FROM claims
WHERE status = 'Pending';



-- Q8) Calculate the total premium revenue per agent.--
SELECT agents.name, SUM(policies.premium)
FROM agents
JOIN policies ON agents.agent_id = policies.agent_id
GROUP BY agents.name;



-- Q9) Identify the most common type of claim.--
SELECT policies.policy_type, COUNT(claims.claim_id)
FROM policies
JOIN claims ON policies.policy_id = claims.policy_id
GROUP BY policies.policy_type
ORDER BY COUNT(claims.claim_id) DESC;



-- Q10) Find the customer with the highest total claim amount approved.--
SELECT customers.name, claims.status, SUM(claims.claim_amount)
FROM customers, policies, claims
WHERE customers.customer_id = policies.customer_id
AND policies.policy_id = claims.policy_id
AND claims.status = 'Approved'
GROUP BY customers.name;



