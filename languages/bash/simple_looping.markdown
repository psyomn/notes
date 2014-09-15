# Simple Looping in bash

To iterate through a list, we can do this in bash. 

~~~~bash
fruits=("orange" "banana" "apple" "potato")

for fruit in ${fruits[@]}
do
  echo $fruit
done
~~~~

Extend the example to iterate through a list:

~~~~bash
files=$(ls)

for f in $files
do
  echo $f
done
~~~~

And a cute script to prefix a bunch of files:

~~~~bash
files=$(ls) 
# So you prefix everything with "prefx-"
myprefix="prefx-"

for f in $files
do
  mv $f "$myprefix$f"
done
~~~~

