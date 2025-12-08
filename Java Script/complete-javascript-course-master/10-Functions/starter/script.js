'use strict';

const bookings = [];

const createBooking = function (flightNum, numPassengers = 1, price = 199) {
  const booking = {
    flightNum,
    numPassengers,
    price,
  };
  console.log(booking);
  bookings.push(booking);
};

createBooking('IN456');
createBooking('LH123', undefined, 154);

const obj1 = {
  name: 'jaswanth',
};

function change(obj) {
  obj = { name: 'kumar' };
}
change(obj1);
console.log(obj1.name);

const greet = function (greeting) {
  return function (name) {
    console.log(greeting, name);
  };
};
const greater = greet('hey hi');
greater('jk');

const greet = greeting => name => console.log(greeting, name);
greet('hey hi')('jk');

function show(city, company) {
  console.log(this.name, city, company);
}
let user = { name: 'jaswanth' };
let person = { name: 'Kumar' };

show.call(user, 'Hyderabad', 'exaze');
