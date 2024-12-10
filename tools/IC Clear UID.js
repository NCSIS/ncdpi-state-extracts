/*
This script will clear the saved Student and Staff UID values for a person in Infinite Campus.

To use this script:
1) Load the Demographics page in Infinite Campus.
2) Right click the heading "Person Information."
3) Select "Inspect."
4) In the Dev Tools pane, click "Console"
5) Paste the contents of this file into the console. Press Enter.


*/

// Set Race/Ethnicity Determination if needed
editRaceEthnicity(); //Open the pane so the elements exist
if (document.getElementById('Identity1.raceEthnicityDetermination').value == '') {
    document.getElementById('Identity1.raceEthnicityDetermination').value = '04' //04 is Unknown
}

//Set Birth Country if needed
if (document.getElementById('Identity1.birthCountry').value == '') {
    document.getElementById('Identity1.birthCountry').value = 'ZZ' //ZZ is Unknown
}

//Clear all UID values
document.querySelectorAll("[id='x.studentNumber']")[1].value = null //0 is the visible field. 1 is the hidden field that matters.
document.getElementById('x.stateID').value = null
document.getElementById('x.staffNumber').value = null
document.getElementById('x.staffStateID').value = null

//Save the data
saveThis();