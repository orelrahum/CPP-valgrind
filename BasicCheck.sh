#!/bin/bash
dirPath=$1
program=$2
arguments=${@:3}

cd $dirPath
make &> /dev/null

if [[ $? -gt 0 ]]; then
	echo  "Compilation     Memory leaks      Thread race"  
	echo  "     FAIL           FAIL             FAIL"
	exit 7
else
comp=0


	 valgrind --leak-check=full --error-exitcode=1  ./$program $arguments &> /dev/null
	 if [[ $? -gt 0 ]] ; then
		 Memory=1
	 	 else
		 Memory=0
	 fi
	 
	 valgrind --tool=helgrind  --error-exitcode=1 ./$program $arguments &> /dev/null
	 if [[ $? -gt 0 ]]; then
		 Thread=1
	 else
		 Thread=0
	 fi

 fi
 Answer="$comp$Memory$Thread"
 
 if [[ $Answer -eq "000" ]]; then 
	echo  "Compilation     Memory leaks      Thread race"  
	echo  "     PASS           PASS             PASS"
	 exit 0
fi
if [[ $Answer -eq "001" ]]; then
	echo  "Compilation     Memory leaks      Thread race"  
	echo  "     PASS           PASS             FAIL"
	exit 1
fi

if [[ $Answer -eq "010" ]]; then
	echo  "Compilation     Memory leaks      Thread race"  
	echo  "     PASS           FAIL             PASS"
	exit 2
fi
if [[ $Answer -eq "011" ]]; then
echo  "Compilation     Memory leaks      Thread race"  
	echo  "     PASS           FAIL             FAIL"
		exit 3
fi
