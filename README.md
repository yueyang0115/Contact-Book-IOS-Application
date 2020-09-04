#   ECE564_HW 
This is the project you will use for all four of your ECE564 homework assignments. You need to download to your computer, add your code, and then add a repo under your own ID with this name ("ECE564_HW"). It is important that you use the same project name.  Any notes, additional functions, comments you want to share with the TA and I before grading please put in this file in the correspondiing section below.  Part of the grading is anything you did above and beyond the requirements, so make sure that is included here in the README.

## HW1
Extra Features includes:  
Error Checking:  
If no first name and last name are provided when the button is clicked, the app will print error message "Error: FirstName and LastName cannot be null".

Default Value:  
If user don't choose the gender, program and role when add a person, the values will be set to default values: .Male, .NA and .Student.

FromWhere and Program Field :  
If user doesn't provide the information of where a newly added person is from, then the fromWhere information will not be printed when the person is found.  
If a person's program is N/A, it will not be printed when the person is found.

Gender Field:  
Gender information is shown by the preposition "she" or "he".

Find Fucntion:  
The person can be found by providing the name no matter it is in lowercase or uppercase.

UI Features:  
Use UITextField.layer.cornerRadius to change add cornerRadius.  
Use UITextField.font and UIButton.titleLabel?.font to change the font.  
Use UISegmentedControl.backgroundColor and UITextField.textColor to change color.  

Database:  
Add more test persons in the database. Information of all persons in database are printed in debug area.

## HW2
Extra Features includes:  
Database:  
Use Core Data as database, write database-related functions: clearDB(), addDefaultPersonInDB(), fetchAllPersonFromDB(), addPersonToDB(), deletePersonFromDB(). Use try catch blcok for database-related functions.  

Data Model Field:  
"Team" field and "Email" field are added to the DukePerson class. "Hobby" field and "Language" field now hold array of string.  

Multiple Type Controls:  
Use PickerView for gender and role.    

Picture support:  
Added pictures for person "Yue Yang" and "Ric Telford". Default pictures for other persons.  

Error Checking:  
If no first name and last name is provided, if no gender and role information is selected in the pickerview, if the user type string into the gender and role field, the app will print error message.  


## HW3
add text here

## HW4
add text here


