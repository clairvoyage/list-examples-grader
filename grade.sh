CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]]
then
  echo "ListExamples.java file found."
else
    echo "ListExamples.java file not found"
    echo "Grade: 0"
    exit
fi

mv student-submission/ListExamples.java grading-area
cp -r TestListExamples.java grading-area
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java &> compliation-results.txt
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > test-results.txt

error=$?
if [[ error -ne 0 ]]
then
  echo "Error code " $error
else
  echo "All tests passed"
  exit
fi
# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

test_failures=$(tail -4 test-results.txt | grep Failures | cut -d " " -f 6)
compilation_errors=$(tail -2 compliation-results.txt | grep error | cut -d " " -f 1 )

score=$((100 - test_failures * 10 - compilation_errors * 10))
echo "Score: $score"