'use strict';
/* 

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

const greet1 = greeting => name => console.log(greeting, name);
greet('hey hi')('jk');

function show(city, company) {
  console.log(this.name, city, company);
}
let user = { name: 'jaswanth' };
let person = { name: 'Kumar' };

show.call(user, 'Hyderabad', 'exaze');

///////////////////////////////////////
// The call and apply Methods
const lufthansa = {
  airline: 'Lufthansa',
  iataCode: 'LH',
  bookings: [],
  // book: function() {}
  book(flightNum, name) {
    console.log(
      `${name} booked a seat on ${this.airline} flight ${this.iataCode}${flightNum}`
    );
    this.bookings.push({ flight: `${this.iataCode}${flightNum}`, name });
  },
};

lufthansa.book(239, 'Jonas Schmedtmann');
lufthansa.book(635, 'John Smith');

const eurowings = {
  airline: 'Eurowings',
  iataCode: 'EW',
  bookings: [],
};

const book = lufthansa.book;

// Does NOT work
// book(23, 'Sarah Williams');

// Call method
book.call(eurowings, 23, 'Sarah Williams');
console.log(eurowings);

book.call(lufthansa, 239, 'Mary Cooper');
console.log(lufthansa);

const swiss = {
  airline: 'Swiss Air Lines',
  iataCode: 'LX',
  bookings: [],
};

book.call(swiss, 583, 'Mary Cooper');

// Apply method
const flightData = [583, 'George Cooper'];
book.apply(swiss, flightData);
console.log(swiss);

book.call(swiss, ...flightData);

///////////////////////////////////////
// The bind Method
// book.call(eurowings, 23, 'Sarah Williams');

const bookEW = book.bind(eurowings);
const bookLH = book.bind(lufthansa);
const bookLX = book.bind(swiss);

bookEW(23, 'Steven Williams');

const bookEW23 = book.bind(eurowings, 23);
bookEW23('Jonas Schmedtmann');
bookEW23('Martha Cooper');


// With Event Listeners
lufthansa.planes = 300;
lufthansa.buyPlane = function () {
  console.log(this);

  this.planes++;
  console.log(this.planes);
};
lufthansa.buyPlane();

document.querySelector('.buy').addEventListener
('click',lufthansa.buyPlane.bind(lufthansa))

///////////////////////////////////////
// Coding Challenge #1

Let's build a simple poll app!

A poll has a question, an array of options from which people can choose, and an array with the number of replies for each option. This data is stored in the starter object below.

Here are your tasks:

1. Create a method called 'registerNewAnswer' on the 'poll' object. The method does 2 things:
  1.1. Display a prompt window for the user to input the number of the selected option. The prompt should look like this:
        What is your favourite programming language?
        0: JavaScript
        1: Python
        2: Rust
        3: C++
        (Write option number)
  
  1.2. Based on the input number, update the answers array. For example, if the option is 3, increase the value AT POSITION 3 of the array by 1. Make sure to check if the input is a number and if the number makes sense (e.g answer 52 wouldn't make sense, right?)
2. Call this method whenever the user clicks the "Answer poll" button.
3. Create a method 'displayResults' which displays the poll results. The method takes a string as an input (called 'type'), which can be either 'string' or 'array'. If type is 'array', simply display the results array as it is, using console.log(). This should be the default option. If type is 'string', display a string like "Poll results are 13, 2, 4, 1". 
4. Run the 'displayResults' method at the end of each 'registerNewAnswer' method call.

HINT: Use many of the tools you learned about in this and the last section 😉

BONUS: Use the 'displayResults' method to display the 2 arrays in the test data. Use both the 'array' and the 'string' option. Do NOT put the arrays in the poll object! So what shoud the this keyword look like in this situation?

BONUS TEST DATA 1: [5, 2, 3]
BONUS TEST DATA 2: [1, 5, 3, 9, 6, 1]

GOOD LUCK 😀


const poll = {
  question: 'What is your favourite programming language?',
  options: ['0: JavaScript', '1: Python', '2: Rust', '3: C++'],
  // This generates [0, 0, 0, 0]. More in the next section 😃
  answers: new Array(4).fill(0),
  registerNewAnswer() {
    // Get answer
    const answer = Number(
      prompt(
        
        `${this.question}\n${this.options.join('\n')}\n(Write option number)`
      
      )
    );
    console.log(answer);
    typeof answer === "number" && answer < this.answers.length && this.answers[answer]++;
    // Register answer
    // console.log(this.answers);
    this.displayResult();
    this.displayResult('string')
  },
  displayResult(type='array'){
    if (type === 'array'){
      console.log(this.answers);
    }
    else if (type === 'string'){
      console.log(`poll results are ${this.answers.join(', ')}`)
    }
  }
}

document
.querySelector('.poll')
.addEventListener('click', poll.registerNewAnswer.bind(poll));


const runonce = function(){
  console.log('this will never run again');
}

runonce();

(function (x){
  console.log('this will never execute again '+x);
})('x');

(() => console.log('hey jk'))
();

const secureBooking =function(){
  let passengerCount=0;
  return function(){
    passengerCount++;
    console.log(`${passengerCount} passengers`)
  }
}

const booker = secureBooking();
booker();
booker();
booker();



let f;

const g = function () {
  const a = 23;
  f = function () {
    console.log(a * 2);
  };
};

const h = function () {
  const b = 777;
  f = function () {
    console.log(b * 2);
  };
};

h();
f();
g();
f();
const boardPassengers = function (n, wait) {
  const perGroup = n / 3;

  setTimeout(function () {
     console.log(`We are now boarding all ${n} passengers`);
    console.log(`There are 3 groups, each with ${perGroup} passengers`);
  }, wait * 1000);


  console.log(`will start boarding in ${wait} seconds`);
};
boardPassengers(180,6)


///////////////////////////////////////
// Coding Challenge #2

/* 
This is more of a thinking challenge than a coding challenge 🤓

Take the IIFE below and at the end of the function, attach an event listener that changes the color of the selected h1 element ('header') to blue, each time the BODY element is clicked. Do NOT select the h1 element again!

And now explain to YOURSELF (or someone around you) WHY this worked! Take all the time you need. Think about WHEN exactly the callback function is executed, and what that means for the variables involved in this example.

GOOD LUCK 😀
*/

(function(){
  const header =document.querySelector('h1');
  header.style.color='red'

  document.querySelector('body').addEventListener('click',function(){
    header.style.color='blue';
  })
})();