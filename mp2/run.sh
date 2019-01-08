
if [ "$1" != "" ] && [ "$2" != "" ]; then
	python3 main.py $1 $2
elif [ "$1" == "" ]; then
	echo "Missing Arguments: ./run.sh arg1 arg2"
	echo "  arg1 - File with known questions"
	echo "  arg2 - File with questions to anotate"
fi
