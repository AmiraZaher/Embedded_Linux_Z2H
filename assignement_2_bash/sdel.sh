#!/bin/bash
path=~
trashDirec=~/TRASH

#Check whether el trash file is created or not!
if [ -d ~/TRASH ]
then
	echo "Trash File Exists!"
	directory=~/TRASH
else
	echo "Trash File Doesn't Exist"
	mkdir $trashDirec
	chmod -R $trashDirec
	echo "TRASH file is now created!"
	#This command will make it run twice per day
	(crontab -l 2>/dev/null; echo "0 5,17 * * * sdel.sh") | crontab
fi

find $trashDirec -type f -mtime +2 -exec rm -f {} \;

#Loop on all the entered commands
if [$# -nq 0 ]
then
	#Check whether it is a file or directory
	if [ -e $i ] 
	then	
		for i in $@
		do
			fileType=`file --mime-type "$i" | cut -d: -f2`
			#Zip it if not already done before moving it to trash			
			if [ $fileType ~= application/gzip ]
			then
				tar cjf $i.tar.gz $i 
				mv $i.tar.gz $trashDirec 
			else 
				mv $i.tar.gz $trashDirec
			fi
		done 
		rm -r $i
	fi
fi
