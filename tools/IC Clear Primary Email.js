/*
This script will clear the saved primary email value for a person in Infinite Campus.

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

//Clear primary email
document.getElementById('Contact3.email').value = null

//Save the data
saveThis();