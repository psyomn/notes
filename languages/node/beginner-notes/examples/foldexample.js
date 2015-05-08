
function sum (prev, next, ix, arr) {
  return (+prev) + (+next);
}

var arr = [1,2,3,4];
var strarr = ["1", "2", "3", "4", "5"];

console.log(arr.reduce(sum));
console.log(strarr.reduce(sum));
console.log(arr.reduce(function (p,n,x,a) { return p + n; }));

