/*
v1: John Mairs, NCDPI, October 2024
v2: John Mairs, NCDPI, February 2025
This bookmarklet will update or clear the saved Student and Staff UID values for a person in Infinite Campus.

To use this script:
1) Copy the line below beginning with "javascript".
2) Create a new bookmark in your browser. Paste the line below as the URL / location.
3) To use it within Infinite Campus, open the Person's Demographics page. Right-click on the page and select "This Frame" > "Show Only This Frame"
4) Click the bookmarklet. Input the Student UID value to insert (or leave blank / click OK). Input the Staff UID value to insert (or leave blank / click OK).
*/

javascript:(function(){let studentID=prompt("Enter the Student UID value to insert:"),staffID=prompt("Enter the Staff UID value to insert:");editRaceEthnicity(),""==document.getElementById("Identity1.raceEthnicityDetermination").value&&(document.getElementById("Identity1.raceEthnicityDetermination").value="04"),""==document.getElementById("Identity1.birthCountry").value&&(document.getElementById("Identity1.birthCountry").value="ZZ"),document.querySelectorAll("[id='x.studentNumber']")[1].value=studentID,document.getElementById("x.stateID").value=studentID,document.getElementById("x.staffNumber").value=staffID,document.getElementById("x.staffStateID").value=staffID,saveThis();}());