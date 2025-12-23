'use strict';

/*
const Person = function (firstName, birthYear) {
  this.firstName=firstName;
  this.birthYear=birthYear; 
};

const jk=new Person('jk',2001);
console.log(jk)
console.log(jk instanceof Person)
// console.log(jaswanth instanceof Person)

Person.prototype.calcAge= function(){
    console.log(2025-this.birthYear)
    console.log(this)
}

const brother = new Person('manoj',1999);

const subbu = new Person('subramanyam',2000);

console.log(subbu)
subbu.calcAge()
jk.calcAge()

console.log(Person.prototype)
console.log(Person.__proto__)
console.log(jk.__proto__===Person.prototype)
console.log(jk.constructor)
console.log(jk.prototype)
console.log(jk.hasOwnProperty('firstName'))
console.log(subbu.firstName)
console.log(subbu.birthYear)
console.log(subbu.birthYear.toString())
console.log(subbu.firstName.toString()===subbu.firstName)
console.log(subbu.birthYear.toString()===subbu.birthYear)

console.log(jk)
console.log(jk.__proto__)
console.log(jk.__proto__.__proto__)
console.log(jk.__proto__.__proto__.__proto__)

Array.prototype.maxlength=function(){
  return ((this.reduce((a,c)=>a.toString().length>c.toString().length?a:c)).toString().length)
}
const arr = new Array(1,3,421,5,2)
console.log(arr)
console.log(arr.maxlength())

const a = [123,3456,34565,3454]
console.log(a,typeof a)
console.log(a.maxlength())

const abc={
  name:'jkds',
  age:24,
}
console.log(abc,typeof abc)
console.log(Map.prototype)
// console.log(abc.maxlength())  // error


const h1 = document.querySelector('h1')
console.log(h1)
console.log(h1.lastChild)
console.log(typeof h1.lastChild)

*/

// Coding Challenge #1

/* 
1. Use a constructor function to implement a Car. A car has a make and a speed property. The speed property is the current speed of the car in km/h;
2. Implement an 'accelerate' method that will increase the car's speed by 10, and log the new speed to the console;
3. Implement a 'brake' method that will decrease the car's speed by 5, and log the new speed to the console;
4. Create 2 car objects and experiment with calling 'accelerate' and 'brake' multiple times on each of them.

DATA CAR 1: 'BMW' going at 120 km/h
DATA CAR 2: 'Mercedes' going at 95 km/h

GOOD LUCK 😀

const Car=function(speed){
  this.speed= speed;
}

Car.prototype.accelerate = function(){
  this.speed=this.speed+10
  console.log(this.speed)
}
Car.prototype.break = function(){
  this.speed=this.speed-5;
  console.log(this.speed)
}

const BMW=new Car(120)
const Mercedes=new Car(95)

console.log(BMW)
BMW.accelerate()
BMW.break()
BMW.break()
Mercedes.accelerate()
Mercedes.break()
Mercedes.break()


class PersonCl {
  constructor(firstName,birthYear){
    this.firstName=firstName;
    this.birthYear=birthYear
  }
  calcAge(){
    console.log(new Date().getFullYear()-this.birthYear)
  }
}

const jk = new PersonCl('jaswanth',2001);

console.log(PersonCl.prototype);
(jk.calcAge());


const a =[3,4,5,6]
const x=a.shift()
console.log(x)

class Rectangle{
  constructor(w,h){
    this.w=w;
    this.h=h;
  }
  peremeter(){
    return 2*(this.h+this.w)
  }
  get area(){
    return this.w*this.h
  }
  calarea(){
    return this.w*this.h
  }
}

let rect1 = new Rectangle(20,15)
rect1.h=20;

console.log(rect1)
console.log(rect1.peremeter())
console.log(rect1.area)

const PersonProto= {
  calcAge(){
    console.log(2037-this.birthTear);
  },
}


const steven = Object.create(PersonProto)
console.log(steven)
steven.name= 'Steven';
steven.birthTear=2002;
steven.calcAge();
console.log(steven)
*/

///////////////////////////////////////
// Coding Challenge #2

/* 
1. Re-create challenge 1, but this time using an ES6 class;
2. Add a getter called 'speedUS' which returns the current speed in mi/h (divide by 1.6);
3. Add a setter called 'speedUS' which sets the current speed in mi/h (but converts it to km/h before storing the value, by multiplying the input by 1.6);
4. Create a new car and experiment with the accelerate and brake methods, and with the getter and setter.

DATA CAR 1: 'Ford' going at 120 km/h

GOOD LUCK 😀

class CarCl{
  constructor(make,speed){
    this.make= make;
    this.speed=speed;
  };
  accelerate(){
    this.speed+=10;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  break(){
    this.speed-=5;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  
  get speedUS(){
    return this.speed/1.6
  }
  
  set speedUS(speed){
    this.speed=speed*1.6;
  }
}

console.log(CarCl)
const ford = new CarCl ('Ford',120)
console.log(ford)

console.log(ford.speedUS)
ford.accelerate()
ford.accelerate()
ford.accelerate()
console.log(ford.speedUS)
ford.break()
ford.break()
console.log(ford.speedUS)

class Person{
  constructor(name,birthYear){
    this.name=name;
    this.birthYear=birthYear;
  }
  clacAge(){
    console.log(new Date().getFullYear()-this.birthYear)
  }
}


class Student extends Person{
  constructor(name,birthYear,course){
    // this.name=name
    // this.birthYear=birthYear
    super(name,birthYear);
    this.course=course;
  }
  intro(){
    console.log(`My name is ${this.name} and I study ${this.course}.`)
  }
  clacAge(){
    console.log(`My name is ${this.name} and I am ${new Date().getFullYear()-this.birthYear} old.`)
  }
}

const jk = new Person('jaswanth',2001)

console.log(jk)
jk.clacAge()

const mk= new Student('Manoj',1999,'computer science')
console.log(mk)
mk.intro()
mk.clacAge()
mk.clacAge()
*/

// Coding Challenge #3

/* 
1. Use a constructor function to implement an Electric Car (called EV) as a CHILD "class" of Car. Besides a make and current speed, the EV also has the current battery charge in % ('charge' property);
2. Implement a 'chargeBattery' method which takes an argument 'chargeTo' and sets the battery charge to 'chargeTo';
3. Implement an 'accelerate' method that will increase the car's speed by 20, and decrease the charge by 1%. Then log a message like this: 'Tesla going at 140 km/h, with a charge of 22%';
4. Create an electric car object and experiment with calling 'accelerate', 'brake' and 'chargeBattery' (charge to 90%). Notice what happens when you 'accelerate'! HINT: Review the definiton of polymorphism 😉

DATA CAR 1: 'Tesla' going at 120 km/h, with a charge of 23%

GOOD LUCK 😀
class CarCl{
  constructor(make,speed){
    this.make= make;
    this.speed=speed;
  };
  accelerate(){
    this.speed+=10;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  break(){
    this.speed-=5;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  
  get speedUS(){
    return this.speed/1.6
  }
  
  set speedUS(speed){
    this.speed=speed*1.6;
  }
}

class EV extends CarCl{
  constructor(make,speed,charge){
    super(make,speed);
    this.charge=charge;
  }
  info(){
    console.log(`${this.make} current speed ${this.speed} and it has ${this.charge}% charge.`)
  }
  
}

const Tesla = new EV('Tesla',120,23);
console.log(Tesla)
Tesla.info()
Tesla.accelerate()
Tesla.accelerate()
Tesla.break()
Tesla.info()
console.log(Tesla.speedUS)
Tesla.speedUS = 100
console.log(Tesla.speed)
////////////////////////////////////////////////////////////
class Account {
  locale=navigator.locale;
  bank= 'bankist';       //public fields
  #movements=[];       //private fields
  #pin;                //private fields
  
  constructor(owner,currency,pin){
    this.owner=owner;
    this.currency=currency;
    // this.#pin=pin;  //making private (we should use only inside the class ,not accessible outside of class)
    // this.movements=[];
    // this.locale=navigator.language;
    console.log(`Thanks for opening an account,${owner}`);
  }
    deposit(x){
      this.#movements.push(x);
      return this;
    }
    withdrawa(x){
      this.#movements.push(-x);
      return this;
    }
    #approveLoan(val){
      return true;
    }
    requestLoan(val){
      if(this.#approveLoan(val)){
        this.deposit(val);
        console.log(`Loan approved ${val}`);
      }
      return this;
    }
    display(){
      console.log(this.#movements)
  }
  
}

const acc1= new Account('Jonas','EUR',1111);
console.log(acc1)
acc1.deposit(700);
acc1.deposit(100);
acc1.withdrawa(300)
acc1.deposit(400);
acc1.withdrawa(500)
// console.log(acc1.movements.slice(-1))
acc1.requestLoan(4000)
// console.log(acc1.movements.slice(-1))
console.log(acc1.movements)   //undefined
console.log(acc1.bank)  //bankist
console.log(acc1.pin) //undefined
// console.log(acc1.#pin) // Uncaught SyntaxError: Private field '#pin' must be declared in an enclosing class.
// console.log(acc1.#approveLoan())

acc1.deposit(300).withdrawa(100).withdrawa(50).requestLoan(25000).withdrawa(10000)
acc1.display()


*/

// Coding Challenge #4

/* 
1. Re-create challenge #3, but this time using ES6 classes: create an 'EVCl' child class of the 'CarCl' class
2. Make the 'charge' property private;
3. Implement the ability to chain the 'accelerate' and 'chargeBattery' methods of this class, and also update the 'brake' method in the 'CarCl' class. They experiment with chining!

DATA CAR 1: 'Rivian' going at 120 km/h, with a charge of 23%

GOOD LUCK 😀
*/
class CarCl{
  constructor(make,speed){
    this.make= make;
    this.speed=speed;
  };
  accelerate(){
    this.speed+=10;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  break(){
    this.speed-=5;
    console.log(`${this.make} is going at ${this.speed} km/h`)
  }
  
  get speedUS(){
    return this.speed/1.6
  }
  
  set speedUS(speed){
    this.speed=speed*1.6;
  }
}

class EVCl extends CarCl{
  #charge;
  constructor(make,speed,charge){
    super(make,speed);
    this.#charge=charge;
  }
  chargeBattery(chargeTo){
    this.#charge=chargeTo;
    return this;
  }
  accelerate(){
    this.speed+=20;
    this.#charge--;
    console.log(`${this.make} is going at ${this.speed} km/h with charge of ${this.#charge}`);
    return this;
  }



}

const rivian=new EVCl ('Rivian',120,23);
console.log(rivian)

rivian.accelerate()
rivian.accelerate()
rivian.accelerate()
rivian.accelerate()
rivian.accelerate()
rivian.chargeBattery(50)
rivian.accelerate()
rivian.accelerate()
rivian.accelerate()