% Beginner notes on Node.js
% Simon Symeonidis

# Setup


To work with node, you'll need to install first node on your computer. On linux
systems we can do this with the package manager.

The next step is optional but nice. There is a package manager for node. The
package manager however does not have user-only installs, so if you don't like
that kind of organization (in other words, you do not want system wide installs
of node packages), you can follow the following link to fix that:

    http://stackoverflow.com/questions/10081293/

There is an interfactive tutorial thing called learnyounode. It is possible
to install using npm.

~~~~nocode
    $ npm install -g learnyounode
~~~~

If you followed the above link, and configured your environment, you'll
be able to run `learnyounode` on the command line and view the
tutorials.

~~~~~nocode
    $ learnyounode
~~~~~

## Getting argument values

Getting argument values in node programs may be done in the following manner:

~~~~javascript
    var args = process.argv;
~~~~

The arguments are given in an array. However one has to be careful: the two
first elements in the array is the name of the entity executing the script (in
this case it is the node binary), and the name of the actual, running script.
Anything after these two elements is actually the arguments supplied to the
script.

So the following code snippet:

~~~~nocode
    var args = process.argv;
    console.log(args);
~~~~

Prints the following in console:

~~~~nocode
psyomn@aeolus beginner-notes $ node examples/getargs.js firstarg 2 3 4
[ 'node',
  '/home/psyomn/programming/architecture-notes/languages/node/beginner-notes/examples/getargs.js',
  'firstarg',
  '2',
  '3',
  '4' ]
~~~~

## Folds in arrays

To perform folds, we define a function we want to use, and pass it in the reduce
function. Alternatively we can pass a simple anonymous function to achieve the
same result, similar to lambdas.

~~~~javascript
    function sum (prev, next, ix, arr) {
      return (+prev) + (+next);
    }

    var arr = [1,2,3,4];
    var strarr = ["1", "2", "3", "4", "5"];

    console.log(arr.reduce(sum));
    console.log(strarr.reduce(sum));
    console.log(arr.reduce(function (p,n,x,a) { return p + n; }));
~~~~

The above prints out the following:

~~~~node
    psyomn@aeolus examples $ node foldexample.js
    10
    15
    10
~~~~



## Async Calls

Node supports asynchronous calls. For example if you have IO calls,
which take time, you can run that operation in the background, while consuming
other ones. You use callbacks in order to tie everything together. For example,
take the following code:

~~~~javascript
    var fs = require('fs');
    var countLines = undefined;

    function fileLines(callback) {
      fs.readFile(process.argv[2], function handleFile (err, data) {
        var strContents = data.toString();
        countLines = 0;

        for (var i = 0; i < strContents.length; ++i) {
          if (strContents[i] == '\n') {
            countLines += 1;
          }
        }
        callback();
      });
    }

    function logLines() {
      console.log(countLines);
    }

    fileLines(logLines);
~~~~

For example the expensive IO call in this case is the readFile part, which will
be done asynchronously. Notice we are passing a parameter called `callback`. We
do this to have a function called, when we are don with the body of this
expensive `readFile` operation. In this case we want to print the result.

If you had not this organization, and you ran it without the callbacks, then the
print call would print `undefined`.
