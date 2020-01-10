#!/bin/bash
flag="0"
if [ $# -eq 0 ]
then
	#Welcoming the user and introducing the options
	echo "Welcome to your phonebook"
	echo " -i : Insert New Name and Number "
	echo " -v : View All Saved Contacts "
	echo " -s : Search by Contact Name "
	echo " -e : Delete Eveything "
	echo " -d : Delete only One Contact "
	exit 0
fi

#get your current path
path=~
#checking whether the directory exists or not
if [ -d $path/phonebook ]
then
	echo "Phonebook Directory Exists!"
	directory=$path/phonebook
else
	echo "Phonebook Directory Doesn't Exist"
	mkdir $path/phonebook
	chmod -R u+r $path/phonebook
	directory=$path/phonebook
	echo "Directory is now created!"
fi

#If the file exists or not
if [ -e $directory/.Phonebook.txt ]
then
	echo "Phonebook file exists!"
	file=$directory/.Phonebook.txt
else
	echo "file .Phonebook.txt doesn't exist!"
	touch $directory/.Phonebook.txt
	chmod 777 $directory/.Phonebook.txt
	file=$directory/.Phonebook.txt
	echo "Phonebook is now created!"
fi

#Read the argument and excute it
while getopts "ivsed" option;
do
	case "$option" in
	i)
		read -p "Enter the contact first Name: " contact_fname
		while [ "$flag" -eq "0" ]
		do
			if [[ "$contact_fname" != *[a-z]* ]];
			then
				echo "Invalid Input"
				read -p "Please re-enter a valid contact's first name: " contact_fname
			else
				flag=1
			fi
		done
		flag="0"
		read -p "Enter the contact last Name: " contact_lname
		while [ "$flag" -eq "0" ]
		do
			if [[ "$contact_lname" != *[a-z]* ]];
			then
                        	echo "Invalid Input"
                      		read -p "Please re-enter a valid contact's last name: " contact_lname
			else
				flag=1
			fi
		done
		flag="0"
		read -p "Enter the contact Phone Number: " contact_num

		while [ "$flag" -eq 0 ]
		do
			if [[ "$contact_num" != *[0-9]* ]];
               		then
                        	echo "Invalid Input"
                       		read -p "Please re-enter a valid contact's number: " contact_num
			else
				flag=1
			fi
		done
		#Now print the contact's info, -n is used to not print a new line
		echo -n "Name: $contact_fname $contact_lname, Number: $contact_num" >>Phonebook.txt

		#Check if the user wants to add another number
		read -p "Do you want to add another number for the same contact? (Y/N)" choice
		if [[ "$choice" == 'y' ]];
		then 
			read -p "Enter the other number" contact_num
			if [[ "$contact_num" != *[0-9]* ]];
	                then
        	                echo "Invalid Input"
                	        read -p "Please re-enter a valid contact's number" contact_num
               		 fi
			#Add the number in the same line
			echo "  $contact_num" >>Phonebook.txt
			echo "Contact is added successfully!!"
		elif [[ "$choice" == 'n' ]];
		then
			echo >> Phonebook.txt
			echo "Contact is added successfully!!"
		else
			echo "You entered wrong choice"
		fi
		;;
	v)
		cat Phonebook.txt
		;;

	s)
		read -p "Enter name of the contact you want to search for: " search
		grep -i "$search" Phonebook.txt
		;;
	d)
		read -p "Enter the contact's first name that you want to delete: " fname
		read -p "Enter the contact's last name: " lname
		grep -v "$fname $lname" Phonebook.txt > temp && mv temp Phonebook.txt
		;;
	e)
		cat /dev/null > Phonebook.txt
		;;
	*)
		echo "Please enter a valid argument"
		;;
	esac
done
