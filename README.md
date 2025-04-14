# 🐳 ELK Stack with SQL DB Integration using Docker

This project sets up the ELK (Elasticsearch, Logstash, Kibana) stack with integration to a Microsoft SQL Server database using Docker. If you change Elastic Password Remember to change compose file logstash.yml and logstash.conf

📦 Prerequisites

Docker and Docker Compose installed
Git installed
Internet access to download dependencies

 🚀 Quick Start

### 1. Clone the Repository

git clone https://github.com/ayeshaAhmed123/ELK-Stack-SQL-DB-migration-with-Docker.git
cd ELK-Stack-SQL-DB-migration-with-Docker
### 2. Make Certs Before making cert update script.sh with your ip

cd certls
sudo nano script.sh
chmod +x script.sh
./script.sh

3. change file permissions

chmod 755 es01.key es01.crt rootCA.pem rootCA.key kib01.key kib01.crt
cd ..
### 4 Give jar File of JDBC the permission (Used for input task of logstash pipeline to migrate data) Jar file ws downloaded from this :curl -k -o logstash/jars/mssql-jdbc-9.2.1.jre8.jar https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/9.2.1.jre8/mssql-jdbc-9.2.1.jre8.jar

chmod 755 logstash/jars/mssql-jdbc-9.2.1.jre8.jar
### 5. Docker Setup

docker compose up -d
### 6. Get Service Token For Kibana And Restart kibana

docker exec -it elasticsearch bin/elasticsearch-service-tokens create elastic/kibana kibana-system
sudo nano kibana.yml
Get service token and replace it kibana.yml with elasticsearch.serviceAccountToken:

docker restart kibana
### 7. Initilize DB wiuth this by connecting through SSMS

-- Step 1: Create the database
CREATE DATABASE logdb;
Use logdb;
-- Step 2: Connect to the new database (depends on your client/tool)

-- Step 3: Create a 'patients' table
CREATE TABLE patients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    admission_date DATE
);
GO

-- Step 4: Insert 20 sample patient records
INSERT INTO patients (first_name, last_name, age, gender, admission_date) VALUES
('John', 'Doe', 45, 'Male', '2024-12-01'),
('Jane', 'Smith', 30, 'Female', '2025-01-10'),
('Alice', 'Johnson', 27, 'Female', '2025-02-15'),
('Bob', 'Williams', 50, 'Male', '2025-03-02'),
('Emma', 'Brown', 35, 'Female', '2025-03-05'),
('Michael', 'Jones', 60, 'Male', '2025-03-10'),
('Olivia', 'Garcia', 22, 'Female', '2025-03-12'),
('William', 'Miller', 40, 'Male', '2025-03-14'),
('Sophia', 'Davis', 38, 'Female', '2025-03-16'),
('James', 'Rodriguez', 29, 'Male', '2025-03-18'),
('Isabella', 'Martinez', 31, 'Female', '2025-03-20'),
('Henry', 'Hernandez', 55, 'Male', '2025-03-22'),
('Mia', 'Lopez', 33, 'Female', '2025-03-24'),
('Alexander', 'Gonzalez', 41, 'Male', '2025-03-26'),
('Charlotte', 'Wilson', 26, 'Female', '2025-03-28'),
('Daniel', 'Anderson', 48, 'Male', '2025-03-30'),
('Amelia', 'Thomas', 36, 'Female', '2025-04-01'),
('Matthew', 'Taylor', 44, 'Male', '2025-04-03'),
('Harper', 'Moore', 39, 'Female', '2025-04-05'),
('Elijah', 'Jackson', 52, 'Male', '2025-04-07');

Select * from patients;
### 8. Restart logstash

docker restart logstash
