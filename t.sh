if diff -q "./train.csv" "data/train.csv"; then
	echo "Files are the same"
elif [ $? -eq 1 ]; then
	echo "Files are different"
else
	echo "An error occurred when comparing"
fi
