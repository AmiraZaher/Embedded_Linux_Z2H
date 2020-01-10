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
fi

find $trashDirec -type f -mtime +2 -exec rm -f {} \;

if [$# -nq 0 ]
then
	if [ -e $i ]
	then	
		for i in $@
		do
			fileType=`file --mime-type "$i" | cut -d: -f2`
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
