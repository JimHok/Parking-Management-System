# Parking Lot Management System (Group 5)

## Objectives

- Develop a system that can detect the license plate number of vehicles entering a parking lot, verify it with a database, and allow access if the number is registered. Also, display an error message if the number is not in the database.
- Implement a feature that uses Bluetooth signals to verify the user's identity by matching it with the detected license plate number. Allow entry to the parking lot if the match is successful and display an error message if not.
- Create a system that can maintain a secure record of license plate numbers and entry/exit timestamps of vehicles entering and exiting the parking lot. Also, provide authorized personnel with easy access to the record for querying purposes.

## User Stories and Acceptance Criteria:

### User Story 1:

As a parking lot manager, I want the system to detect the license plate number of vehicles entering the parking lot and check if the plate number is in the database. If the plate number is in the database, I want the system to open the barricade and allow the user to enter.

Acceptance Criteria:

- The system should be able to detect the license plate number of vehicles entering the parking lot
- The system should be able to check if the license plate number is in the database
- If the license plate number is in the database, the system should open the barricade and allow the user to enter the parking lot
- If the license plate number is not in the database, the system should not open the barricade and should display an error message.

### User Story 2:

As a parking lot manager, I want the system to use Bluetooth signal to double check that the passed user is not using a fake license plate.

Acceptance Criteria:

- The system should be able to detect Bluetooth signal of the user's device
- The system should be able to verify the signal with the license plate number detected by the camera
- If the Bluetooth signal matches with the detected license plate number, the user is allowed to enter the parking lot
- If the Bluetooth signal does not match with the detected license plate number, the user is not allowed to enter the parking lot and should display an error message.

### User Story 3:

As a parking lot manager, I want the system to maintain a record of vehicles entering and exiting the parking lot.

Acceptance Criteria:

- The system should maintain a record of license plate numbers and entry/exit timestamps of vehicles entering and exiting the parking lot
- The record should be stored in a database and be easily queryable
- The record should be secure and only accessible to authorized personnel.

### User Story 4:

As a parking lot user, I want to be able to easily enter and exit the parking lot using my registered license plate number and Bluetooth device.

Acceptance Criteria:

- The user should be able to register their license plate number and Bluetooth device with the system
- The user should be able to easily enter and exit the parking lot by having the system automatically detect their license plate number and Bluetooth signal
- The user should receive a confirmation message upon successful entry and exit.

## Impact of the Project

1. Improved security: The system will prevent unauthorized access to the parking lot by verifying the license plate number and Bluetooth signal, which will enhance security and reduce the risk of theft and vandalism.
2. Increased efficiency: The system will automate the entry and exit process, which will reduce the time it takes for vehicles to enter and exit the parking lot, thereby improving efficiency and reducing congestion.
3. Enhanced record-keeping: The system will maintain a record of vehicles entering and exiting the parking lot, which will enable the parking lot management to track usage patterns, identify potential issues, and generate reports.
4. Improved customer satisfaction: The system will provide a convenient and efficient way for registered users to enter and exit the parking lot, which will enhance customer satisfaction and increase loyalty.

## System Requirement

### Things layer:

### Gateway layer:

### Server layer:

### Service layer:

### UI layer:

## Software Architecture
![alt text](https://github.com/JimHok/Software-Design-for-AI/blob/master/Readme-Content/Image/287838.jpg)

### ESP-32 tag:

### ESP-32 scanner:

### Line bot:

### AI:

### LIFF UI:

## Software Implementation

### Firmware development

### LINE bot development

### LIFF UI development
