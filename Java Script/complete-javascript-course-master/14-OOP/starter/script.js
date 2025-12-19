'use strict';

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
}

new Person('manoj',1999).calcAge()