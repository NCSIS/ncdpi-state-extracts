/*
v1: John Mairs, NCDPI, October 2024
v2: John Mairs, NCDPI, February 2025
This script will update or clear the saved Student and Staff UID values for a person in Infinite Campus.

To use this script:
1) Load the Demographics page in Infinite Campus.
2) Right click the heading "Person Information."
3) Select "Inspect."
4) In the Dev Tools pane, click "Console"
5) Paste the contents of this file into the console. Press Enter.
6) When prompted, input the student UID value to insert -or- click OK to make it blank.
7) When prompted, input the staff UID value to insert -or- click OK to make it blank.
*/

// Prompt for input
let studentID = prompt("Enter the Student UID value to insert:");
let staffID = prompt("Enter the Staff UID value to insert:");

// Set Race/Ethnicity Determination if needed
editRaceEthnicity(); //Open the pane so the elements exist
if (document.getElementById('Identity1.raceEthnicityDetermination').value == '') {
    document.getElementById('Identity1.raceEthnicityDetermination').value = '04'; //04 is Unknown
}

// Set Birth Country if needed
if (document.getElementById('Identity1.birthCountry').value == '') {
    document.getElementById('Identity1.birthCountry').value = 'ZZ'; //ZZ is Unknown
}

// Update all UID values
document.querySelectorAll("[id='x.studentNumber']")[1].value = studentID; //0 is the visible field. 1 is the hidden field that matters.
document.getElementById('x.stateID').value = studentID;
document.getElementById('x.staffNumber').value = staffID;
document.getElementById('x.staffStateID').value = staffID;

// Save the data
saveThis();