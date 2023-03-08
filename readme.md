# Parking Lot Management System in Condominium (Group 5)

## Objectives

- Develop a system that can detect the license plate number of vehicles entering a parking lot, verify it with a database, and allow access if the number is registered. Also, display an error message if the number is not in the database.
- Implement a feature that uses Bluetooth signals to verify the user's identity by matching it with the detected license plate number. Allow entry to the parking lot if the match is successful and display an error message if not.
- Create a system that can maintain a secure record of license plate numbers and entry/exit timestamps of vehicles entering and exiting the parking lot. Also, provide authorized personnel with easy access to the record for querying purposes.

## User Stories and Acceptance Criteria:

### User Story 1:

As a parking lot user, I want to be able to easily enter and exit the parking lot using my registered license plate number and Bluetooth device.

- Scenario: Registration, given a user wants to register their license plate number and Bluetooth device, when they provide the required information, then the system should register their information and store it in a secure database.

- Scenario: Automatic entry and exit, given a registered user approaches the parking lot entrance or exit, when the license plate number and Bluetooth signal are detected by the system, then the system should automatically open the barricade and allow the user to enter or exit the parking lot.

- Scenario: Confirmation message display, given a user enters or exits the parking lot, when the barricade opens, then the system should display a confirmation message to the user.


### User Story 2:

As a administrator, I want the system to detect the license plate number of vehicles entering the parking lot, check if the plate number is in the database, and use Bluetooth signal to double check that the passed user is not using a fake license plate. If the plate number is in the database and the Bluetooth signal matches, I want the system to open the barricade and allow the user to enter.

- Scenario: vehicle enters parking lot, given a vehicle approaches the entrance with a license plate, when the license plate number is detected and checked against the database, and the Bluetooth signal matches with the detected license plate number, then the barricade opens and allows the user to enter.

- Scenario: vehicle enters parking lot with fake license plate, given a vehicle approaches the entrance with a license plate, when the license plate number is detected and checked against the database, but the Bluetooth signal does not match with the detected license plate number, then the barricade remains closed and displays an error message.

### User Story 3:

As a administrator, I want the system to maintain a record of vehicles entering and exiting the parking lot.

- Scenario: vehicle enters parking lot, given a vehicle enters the parking lot, then the system records the license plate number and entry timestamp in the database.

- Scenario: vehicle exits parking lot, given a vehicle exits the parking lot, then the system records the license plate number and exit timestamp in the database.

- Scenario: record query, given a parking lot manager queries the record database, then the system responds with the history (timestamp, entry/exit time) of the queried license plate number.


### User Story 4:

As a parking lot user, I want to be able to book a parking spot for my friend who is visiting me, so that they can easily park their car without any hassle.

- Scenario: Parking spot booking, given a user wants to book a parking spot for their friend, when they enter their friend's license plate number and the expected arrival time in the application, then the system should reserve a parking spot for the designated time period.

- Scenario: Guest parking, given a guest arrives at the parking lot, when their license plate number is detected by the system, then the system should automatically recognize the booking and allow the guest to park in the designated parking spot.

- Scenario: Booking modification, given a user wants to modify or cancel the booking, when they access the booking details in the application, then the system should allow them to make the necessary changes or cancel the booking.



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
![alt text](https://github.com/JimHok/Software-Design-for-AI/blob/master/Readme-Content/Image/Workflow3.jpg)
![alt text](https://github.com/JimHok/Software-Design-for-AI/blob/master/Readme-Content/Image/Workflow2.jpg)

### ESP-32 tag:

### ESP-32 scanner:

### Line bot:

### AI:

### LIFF UI:

## Software Implementation

### Firmware development

### LINE bot development

### LIFF UI development
