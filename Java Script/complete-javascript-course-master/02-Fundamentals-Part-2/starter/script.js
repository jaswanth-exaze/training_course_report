"use strict";
/*
function prime(n){
    if (n<2){
        console.log(`${n} is Not a prime number`);
    }
    else{
        let flag =false;
        for(let i=2;i<(n/2)+1;i++){
            if (n%i==0){
                flag=true;
                break;
            } 
        }
        flag ? console.log(`${n} is not a prime number`): console.log(`${n} is a prime number`);
    }
}

for (let i=0;i<25;i++){
    prime(i);
}

function prime1(n){
    if (n<2){
        return (`${n} prime`);
    }
    else{
        for (let i=2;i<(n/2)+1;i++){
            if (n%i==0) return (`${n} Not Prime`)
        }
    return (`${n} prime`);

    }
}

for (let i=0;i<25;i++){
    console.log(prime1(i));
}
let x="jaswanth"
for(let i in x){
    
}

let happy = function (age){
    return 2025-age

}
console.log(happy(2001));


const add = (x,y) => x*y ;

console.log(add(3,5));


const square= n => n*n ;
for (let i=1;i<11;i++){
    console.log(square(i))
}

// Calling an external function
function great(){
    return "hellooo";
}

function great_for(name){
    return great()+" "+name;
}
console.log(great_for("jaswanth"));

// Function inside another function (Inner function / Lexical scope)
function great_for(name){
    return great(name)
    function great(name){
        return "helloo "+name;
    }
}
console.log(great_for("jaswanth"));


function add(y=3,x=2){
    console.log("x is",x);
    console.log("y is",y);
}
add()

const arr = ["jaswanth","kumar","uppu","manoj","akhil"]

//console.log(arr)

for (let i=0;i<arr.length;i++){
    //console.log(arr[i]);
    for(let j=0;j<arr[i].length;j++){
        //console.log(arr[i][j]);
    }
}

const names =new Array("jaswanth","kumar","uppu","akhil");
names.push("jk","mk")
names.unshift("uppu")
names.pop()
names.shift()
console.log(names)


console.log(names)

names[names.length+1]="karthik"

console.log(names)
const arr = ["jaswanth","kumar","uppu","manoj","akhil"]
let add=[1,4,2,8,3];
let t=0
for(let i=0;i<add.length;i++) {
    t=t+add[i];
    add[i]=t;
}
console.log(add)

const nums = [2, 4, 7, 11];
console.log(nums.filter((n) => n % 2 != 0).length);'


let a=0;
a=10;
console.log(a)

const b=0;
b=10;  // here also i am modifing 
console.log(b)
const jk={
    name:"jaswanth",
    age:25,
    city:"hyderabad",
    
    
    year: function(age){
        return 2025-age
    }
}
console.log(jk.age)
console.log(jk.year(jk.age))


function User(name,age,city){
    this.name=name;
    this.age=age;
    this.city=city;
}
let i = new User("manoj",27,"Dosapadu");
console.log(i)
*/
let i=0;
while(i<5){
    console.log(i)
    i++
}

let j=0;
do{
    console.log(j)
    j++
}while(j<0)