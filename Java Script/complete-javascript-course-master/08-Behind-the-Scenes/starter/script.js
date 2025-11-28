'use strict';

const jessica = {
  firstName: 'jessica',
  lastName: 'williams',
  age: 27,
};

const marriedJessica = jessica;
marriedJessica.lastName = 'Davis';

console.log('before:', jessica);
console.log('after:', marriedJessica);

const jessica2 = {
  firstName: 'jessica',
  lastName: 'williams',
  age: 27,
};

const jessicaCopy = { ...jessica2 };
jessicaCopy.lastName = 'Davis';
console.log('before:', jessica2);
console.log('after:', jessicaCopy);
