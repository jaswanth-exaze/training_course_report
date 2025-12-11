'use strict';

/////////////////////////////////////////////////
/////////////////////////////////////////////////
// BANKIST APP

// Data
const account1 = {
  owner: 'Jonas Schmedtmann',
  movements: [200, 450, -400, 3000, -650, -130, 70, 1300],
  interestRate: 1.2, // %
  pin: 1111,
};

const account2 = {
  owner: 'Jessica Davis',
  movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
  interestRate: 1.5,
  pin: 2222,
};

const account3 = {
  owner: 'Steven Thomas Williams',
  movements: [200, -200, 340, -300, -20, 50, 400, -460],
  interestRate: 0.7,
  pin: 3333,
};

const account4 = {
  owner: 'Sarah Smith',
  movements: [430, 1000, 700, 50, 90],
  interestRate: 1,
  pin: 4444,
};

const accounts = [account1, account2, account3, account4];

// Elements
const labelWelcome = document.querySelector('.welcome');
const labelDate = document.querySelector('.date');
const labelBalance = document.querySelector('.balance__value');
const labelSumIn = document.querySelector('.summary__value--in');
const labelSumOut = document.querySelector('.summary__value--out');
const labelSumInterest = document.querySelector('.summary__value--interest');
const labelTimer = document.querySelector('.timer');

const containerApp = document.querySelector('.app');
const containerMovements = document.querySelector('.movements');

const btnLogin = document.querySelector('.login__btn');
const btnTransfer = document.querySelector('.form__btn--transfer');
const btnLoan = document.querySelector('.form__btn--loan');
const btnClose = document.querySelector('.form__btn--close');
const btnSort = document.querySelector('.btn--sort');

const inputLoginUsername = document.querySelector('.login__input--user');
const inputLoginPin = document.querySelector('.login__input--pin');
const inputTransferTo = document.querySelector('.form__input--to');
const inputTransferAmount = document.querySelector('.form__input--amount');
const inputLoanAmount = document.querySelector('.form__input--loan-amount');
const inputCloseUsername = document.querySelector('.form__input--user');
const inputClosePin = document.querySelector('.form__input--pin');

const currencies = new Map([
  ['USD', 'United States dollar'],
  ['EUR', 'Euro'],
  ['GBP', 'Pound sterling'],
]);

const displayMovements = function (movements, sort = false) {
  containerMovements.innerHTML = '';

  const movs = sort ? movements.slice().sort((a, b) => a - b) : movements;
  movs.forEach(function (mov, i) {
    const type = mov > 0 ? 'deposit' : 'withdrawal';

    const html = `
      <div class="movements__row">
        <div class="movements__type movements__type--${type}">${
      i + 1
    } ${type}</div>
        <div class="movements__value">${mov}€</div>
      </div>
    `;

    containerMovements.insertAdjacentHTML('afterbegin', html);
  });
};

const calcDisplayBalance = function (acc) {
  acc.balance = acc.movements.reduce((acc, crr) => acc + crr, 0);
  labelBalance.textContent = `${acc.balance}€`;
};

const calcDisplaySummary = function (acc) {
  const incomes = acc.movements.filter(n => n > 0).reduce((a, c) => a + c);
  labelSumIn.textContent = `${incomes}€`;
  const outgoes = acc.movements.filter(n => n < 0).reduce((a, c) => a + c);
  labelSumOut.textContent = `${Math.abs(outgoes)}€`;

  const interest = acc.movements
    .filter(n => n > 0)
    .map(n => (n * acc.interestRate) / 100)
    .filter((n, i, ar) => n >= 1)
    .reduce((a, c) => a + c);
  labelSumInterest.textContent = `${interest}€`;
};

const createUsernames = function (accs) {
  accs.forEach(function (acc) {
    acc.username = acc.owner
      .split(' ')
      .map(n => n.toLowerCase()[0])
      .join('');
  });
};

createUsernames(accounts);

const updateUI = function (currentAccount) {
  //DISPLAY MOVEMENTS(transactions)
  displayMovements(currentAccount.movements);
  //DISPLAY BALANCE
  calcDisplayBalance(currentAccount);
  // DISPLAY SUMMARY
  calcDisplaySummary(currentAccount);
};

// /////////////////////    EVENT HANDLER    ///////////////////////////
//LOGGING IN
let currentAccount;
btnLogin.addEventListener('click', function (e) {
  e.preventDefault();
  console.log('login clicked');

  currentAccount = accounts.find(
    acc => acc.username === inputLoginUsername.value
  );
  if (currentAccount?.pin === Number(inputLoginPin.value)) {
    // DISPLAY UI AND MESSAGE
    labelWelcome.textContent = `Welcome back, ${
      currentAccount.owner.split(' ')[0]
    }`;
    containerApp.style.opacity = 100;
    // CLEAR INPUT FILEDS
    inputLoginUsername.value = inputLoginPin.value = '';
    inputLoginPin.blur();
    //UPDATING UI
    updateUI(currentAccount);
  }
});

// TRANSFER
btnTransfer.addEventListener('click', function (e) {
  e.preventDefault();
  const amount = Number(inputTransferAmount.value);
  const receiverAcc = accounts.find(
    acc => acc.username === inputTransferTo.value
  );
  inputTransferAmount.value = inputTransferTo.value = '';
  if (
    amount > 0 &&
    receiverAcc &&
    currentAccount.balance >= amount &&
    receiverAcc?.username !== currentAccount.username
  ) {
    // doing the transfer
    currentAccount.movements.push(-amount);
    receiverAcc.movements.push(amount);
    updateUI(currentAccount);
  }
});
// LOAN REQUEST
btnLoan.addEventListener('click', function (e) {
  e.preventDefault();

  const amount = Number(inputLoanAmount.value);
  if (amount > 0 && currentAccount.movements.some(n => n >= amount * 0.1)) {
    //add movement
    currentAccount.movements.push(amount);
    //update ui
    updateUI(currentAccount);
    inputLoanAmount.value = '';
  }
});

// CLOSE ACCOUNT
btnClose.addEventListener('click', function (e) {
  e.preventDefault();

  if (
    inputCloseUsername.value === currentAccount.username &&
    Number(inputClosePin.value) === currentAccount.pin
  ) {
    const index = accounts.findIndex(
      acc => acc.username === currentAccount.username
    );
    console.log(index);
    accounts.splice(index, 1);
    containerApp.style.opacity = 0;
  }
  inputClosePin.value = inputCloseUsername.value = '';
});

//SORTING
let sorted = false;
btnSort.addEventListener('click', function (e) {
  e.preventDefault();
  displayMovements(currentAccount.movements, !sorted);
  sorted = !sorted;
  // console.log(currentAccount.movements)
  // updateUI(currentAccount)
});

/////////////////////////////////////////////////
/////////////////////////////////////////////////
//                 LECTURES                    //
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/*
let arr = ['a','b',3,'c','d','e','a','3']
console.log()
console.log()
console.log(arr.findLastIndex(n=>n=='a'))
console.log(arr)
console.log(arr.find(a=>typeof a==='number'))   //  3
console.log(arr.findIndex(n=>n==='b'))          // 1
console.log(arr.findIndex(n=>n===3))          // 2
console.log(arr.slice(2,3))     //     ['c']              slice(startIndex,endIndex)  endIndex not included
console.log(arr.splice(2,3))    // (3) ['c', 'd', 'e']    splice(startIndex,length)
console.log(arr)                // (2) ['a', 'b']

const arr = [23,11,64];
console.log(arr[0])
console.log(arr.at(0))
console.log(arr.at(0))

const str="jaswanth";
console.log(str[0])
console.log(str.at(0))
console.log(str.charAt(0))

movements.forEach( function(n,i,a){if(n>0)console.log(`Movement ${i} you deposited ${n}`)
else console.log(`Movement ${i} you withdraw ${Math.abs(n)}`)})
console.log(currencies)
currencies.forEach(function(v,k,m){console.log(k,v,m)})
*/
/* 
Julia and Kate are doing a study on dogs. So each of them asked 5 dog owners about their dog's age, and stored the data into an array (one array for each). 
For now, they are just interested in knowing whether a dog is an adult or a puppy. A dog is an adult if it is at least 3 years old, and it's a puppy if it's less than 3 years old.

Create a function 'checkDogs', which accepts 2 arrays of dog's ages ('dogsJulia' and 'dogsKate'), and does the following things:

1. Julia found out that the owners of the FIRST and the LAST TWO dogs actually have cats, not dogs! So create a shallow copy of Julia's array, 
and remove the cat ages from that copied array (because it's a bad practice to mutate function parameters)
2. Create an array with both Julia's (corrected) and Kate's data
3. For each remaining dog, log to the console whether it's an adult ("Dog number 1 is an adult, and is 5 years old") or a puppy ("Dog number 2 is still a puppy 🐶")
4. Run the function for both test datasets

HINT: Use tools from all lectures in this section so far 😉

TEST DATA 1: Julia's data [3, 5, 2, 12, 7], Kate's data [4, 1, 15, 8, 3]
TEST DATA 2: Julia's data [9, 16, 6, 8, 3], Kate's data [10, 5, 6, 1, 4]

GOOD LUCK 😀
function checkDogs(dogsJulia, dogsKate) {
  const dogsJuliaCorrected = dogsJulia.slice();
  dogsJuliaCorrected.splice(0, 1);
  dogsJuliaCorrected.splice(2);
  
  const dogs = dogsJuliaCorrected.concat(dogsKate);
  console.log(dogs);
  dogs.forEach(function(n,i){
    console.log(`Dog number ${i+1} is ${n>3?`an adult, and is ${n} years old`:`still a puppy 🐶`}`)
    })
    }
checkDogs([3, 5, 2, 12, 7], [9, 16, 6, 8, 3]);


//  
const arr = [1,11,2,4,11,32,43,76,59,23]
let x=0;
arr.forEach(n=>x=x+n)
console.log(x)

arr.filter(n=> n%2==0)
console.log(arr.map(n => n*2))
console.log(arr.filter(n => n%2==0))
console.log(arr.reduce(function(n,m,i){
  return n+m
  }))
  
  let evens=arr.filter(n=>n%2==0)
  let odds=arr.filter(n=>n%2!=0)
  let squares=arr.map((n) => n**2 )
  let sum=arr.reduce((n,m,i) => n+m)
  let evenSum=arr.filter(n=>n%2==0).reduce((n,m)=>n+m)
let oddSum=arr.filter(n=>n%2!=0).reduce((n,m)=>n+m)


console.log(`evens`,...evens)
console.log(`odds`,...odds)
console.log(`squares`,...squares)
console.log(`sum of elements in a array`,sum)

console.log(`evens sum`,evenSum)
console.log(`odds sum`,oddSum)

const deposits=movements.filter(n => n>0)
const withdrawals=movements.filter(n => n<0)
console.log(deposits)
console.log(withdrawals)

const balance = movements.reduce((acc,crr)=>acc+crr)
console.log(balance)

*/
/* 
Let's go back to Julia and Kate's study about dogs. This time, they want to convert dog ages to human ages and calculate the average age of the dogs in their study.

Create a function 'calcAverageHumanAge', which accepts an arrays of dog's ages ('ages'), and does the following things in order:

1. Calculate the dog age in human years using the following formula: if the dog is <= 2 years old, humanAge = 2 * dogAge. If the dog is > 2 years old, humanAge = 16 + dogAge * 4.
2. Exclude all dogs that are less than 18 human years old (which is the same as keeping dogs that are at least 18 years old)
3. Calculate the average human age of all adult dogs (you should already know from other challenges how we calculate averages 😉)
4. Run the function for both test datasets

TEST DATA 1: [5, 2, 4, 1, 15, 8, 3]
TEST DATA 2: [16, 6, 10, 5, 6, 1, 4]

GOOD LUCK 😀

const calcAverageHumanAge = function (ages) {
  let humanAges = ages.map(n => (n <= 2 ? 2 * n : 16 + n * 4));
  console.log(humanAges);
  let adults = humanAges.filter(n => n >= 18);
  console.log(adults);
  // let avgAge=adults.reduce((acc,crr)=>acc+crr)/adults.length;
  let avgAge=adults.reduce((acc,crr,i,arr)=>acc+crr/arr.length,0);
  console.log(avgAge)
};
(calcAverageHumanAge([5, 2, 4, 1, 15, 8, 3]));

let arr=[1,2,3]

console.log(arr.reduce((a,c)=>a+c))
console.log(arr.reduce((a,c)=>a+c,0))
*/

// Coding Challenge #3

/* 
Rewrite the 'calcAverageHumanAge' function from the previous challenge, but this time as an arrow function, and using chaining!

TEST DATA 1: [5, 2, 4, 1, 15, 8, 3]
TEST DATA 2: [16, 6, 10, 5, 6, 1, 4]

GOOD LUCK 😀
const calcAverageHumanAge = function (ages) {
  let humanAges = ages.map(n => (n <= 2 ? 2 * n : 16 + n * 4)).filter(n=> n>=18).reduce((acc,crr,i,arr)=>acc+crr/arr.length,0);
  console.log(humanAges);
}
calcAverageHumanAge([5, 2, 4, 1, 15, 8, 3])
/////////////////////////////////////////////////
let arr=[22,54,7,12,87,19]
console.log(arr.find((n)=>n!==22))
*/
// let account=accounts.find(n=>n.username==='jd' && n.pin===2222)
// console.log(account)

// const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];
// console.log(movements.every(n=>n>-1))

// const arr=[[1,[2,3],[12,13,[15,15]]],[4,5,6],7,8]

// console.log(arr.flat(3).reduce((a,c)=>a>c?a:c))

// Coding Challenge #4

/*
This time, Julia and Kate are studying the activity levels of different dog breeds.

YOUR TASKS:
1. Store the the average weight of a "Husky" in a variable "huskyWeight"
2. Find the name of the only breed that likes both "running" and "fetch" ("dogBothActivities" variable)
3. Create an array "allActivities" of all the activities of all the dog breeds
4. Create an array "uniqueActivities" that contains only the unique activities (no activity repetitions). HINT: Use a technique with a special data structure that we studied a few sections ago.
5. Many dog breeds like to swim. What other activities do these dogs like? Store all the OTHER activities these breeds like to do, in a unique array called "swimmingAdjacent".
6. Do all the breeds have an average weight of 10kg or more? Log to the console whether "true" or "false".
7. Are there any breeds that are "active"? "Active" means that the dog has 3 or more activities. Log to the console whether "true" or "false".

BONUS: What's the average weight of the heaviest breed that likes to fetch? HINT: Use the "Math.max" method along with the ... operator.

TEST DATA:
const breeds = [
  {
    breed: 'German Shepherd',
    averageWeight: 32,
    activities: ['fetch', 'swimming'],
  },
  {
    breed: 'Dalmatian',
    averageWeight: 24,
    activities: ['running', 'fetch', 'agility'],
  },
  {
    breed: 'Labrador',
    averageWeight: 28,
    activities: ['swimming', 'fetch'],
  },
  {
    breed: 'Beagle',
    averageWeight: 12,
    activities: ['digging', 'fetch'],
  },
  {
    breed: 'Husky',
    averageWeight: 26,
    activities: ['running', 'agility', 'swimming'],
  },
  {
    breed: 'Bulldog',
    averageWeight: 36,
    activities: ['sleeping'],
  },
  {
    breed: 'Poodle',
    averageWeight: 18,
    activities: ['agility', 'fetch'],
  },
];


const huskyWeight=breeds.find(n=>n.breed==='Husky').averageWeight
console.log(huskyWeight)
console.log(breeds.find(n=>n.activities.includes('running','fetch')))
const allActivities=breeds.map(n=>n.activities).flat()
console.log(allActivities)
const uniqueActivities=[...new Set(allActivities)];
console.log(uniqueActivities)

const swimmingAdjacent= [...new Set(
  breeds.filter(n=>n.activities.includes('swimming')).flatMap(n => n.activities).filter(n=>n!=='swimming')
)]
console.log(swimmingAdjacent)

console.log(breeds.flatMap(n=>n.averageWeight).every(n=>n>10))
console.log(breeds.map(n=>n.activities.length).some(n=>n>=3))
console.log(breeds.some(n=>n.activities.length>=3))

console.log(breeds.filter(n=>n.activities.includes('fetch')).flatMap(n=>n.averageWeight).reduce((a,c)=>a>c?a:c))



const arr=['a','bc','d','c','b','aa','aab','ab']
const arr1=[...arr]
arr1.sort((a,b)=>a-b)
console.log(arr)
console.log(arr1)


const num=[4,2,6,222,1,23,123,54,14,121,39,111]
const num1=[...num]
num1.sort((a,b)=>b-a)
console.log(num)
console.log(num1)


const group = Object.groupBy(movements, n =>
  n > 0 ? 'deposite' : 'withdrawals'
  );
  console.log(group);
  
const status1 = Object.groupBy(accounts, function (m) {
  let n=m.movements.length
  if (n >= 8) return 'very very active';
  else if (n >= 4) return 'very active';
  else if (n >= 1) return 'active';
  else return 'inactive'
  });
console.log(status1)

const g = Object.groupBy(accounts,a=>a.interestRate)
console.log(g)


// let arr=new Array(7);
// arr.fill(0,2,4)
// console.log(arr)

// let y = Array.from({length:100},(cur,i)=>Math.trunc(Math.random()*6)+1)
// console.log(y)
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];
console.log('Before pop',movements)
const reversemov=movements.pop()
console.log(reversemov)
console.log('After pop',movements)

console.log(
  accounts
    .flatMap(n => n.movements)
    .filter(n => n > 0)
    .reduce((a, c) => a + c)
);

console.log(accounts.flatMap(n => n.movements).filter(n => n >= 1000).length);
console.log(
  accounts
  .flatMap(n => n.movements)
    .reduce((a, c) => (c >= 1000 ? a + 1 : a), 0)
);

const sums = accounts
  .flatMap(n => n.movements)
  .reduce(
    (a, c) => {
      c > 0 ? (a.deposite += c) : (a.withdrawals += c);
      return a
    },
    { deposite: 0, withdrawals: 0 }
  );

console.log(sums);


let x='this is a nice title';
const convert = function(x){
    const exp=['a','an','and','the','but','or','on','in','with']
    return x.split(" ").map((n)=>exp.includes(n)?n:n[0].toUpperCase()+n.slice(1).toLowerCase()).join(" ")

}
console.log(convert(x))
console.log(convert('this is a LONG title but not too long'))
console.log(convert('and here is another title with an EXAMPLE'))
*/
/* 
Julia and Kate are still studying dogs. This time they are want to figure out if the dogs in their are eating too much or too little food.

- Formula for calculating recommended food portion: recommendedFood = weight ** 0.75 * 28. (The result is in grams of food, and the weight needs to be in kg)
- Eating too much means the dog's current food portion is larger than the recommended portion, and eating too little is the opposite.
- Eating an okay amount means the dog's current food portion is within a range 10% above and below the recommended portion (see hint).

YOUR TASKS:
1. Loop over the array containing dog objects, and for each dog, calculate the recommended food portion (recFood) and add it to the object as a new property. Do NOT create a new array, simply loop over the array (We never did this before, so think about how you can do this without creating a new array).
2. Find Sarah's dog and log to the console whether it's eating too much or too little. HINT: Some dogs have multiple users, so you first need to find Sarah in the owners array, and so this one is a bit tricky (on purpose) 🤓
3. Create an array containing all owners of dogs who eat too much (ownersTooMuch) and an array with all owners of dogs who eat too little (ownersTooLittle).
4. Log a string to the console for each array created in 3., like this: "Matilda and Alice and Bob's dogs eat too much!" and "Sarah and John and Michael's dogs eat too little!"
5. Log to the console whether there is ANY dog eating EXACTLY the amount of food that is recommended (just true or false)
6. Log to the console whether ALL of the dogs are eating an OKAY amount of food (just true or false)
7. Create an array containing the dogs that are eating an OKAY amount of food (try to reuse the condition used in 6.)
8. Group the dogs into the following 3 groups: 'exact', 'too-much' and 'too-little', based on whether they are eating too much, too little or the exact amount of food, based on the recommended food portion.
9. Group the dogs by the number of owners they have
10. Sort the dogs array by recommended food portion in an ascending order. Make sure to NOT mutate the original array!

HINT 1: Use many different tools to solve these challenges, you can use the summary lecture to choose between them 😉
HINT 2: Being within a range 10% above and below the recommended portion means: current > (recommended * 0.90) && current < (recommended * 1.10). Basically, the current portion should be between 90% and 110% of the recommended portion.

TEST DATA:
const dogs = [
  { weight: 22, curFood: 250, owners: ['Alice', 'Bob'] },
  { weight: 8, curFood: 200, owners: ['Matilda'] },
  { weight: 13, curFood: 275, owners: ['Sarah', 'John', 'Leo'] },
  { weight: 18, curFood: 244, owners: ['Joe'] },
  { weight: 32, curFood: 340, owners: ['Michael'] },
];

GOOD LUCK 😀
*/

const dogs = [
  { weight: 22, curFood: 250, owners: ['Alice', 'Bob'] },
  { weight: 8,  curFood: 200, owners: ['Matilda'] },
  { weight: 13, curFood: 275, owners: ['Sarah', 'John', 'Leo'] },
  { weight: 18, curFood: 244, owners: ['Joe'] },
  { weight: 32, curFood: 340, owners: ['Michael'] },
];

dogs.forEach(n=>n.recFood=Math.floor(n.weight ** 0.75 * 28))
console.log(dogs)
console.log(dogs.find(n=>n.owners.includes("Sarah")&&n.curFood>n.recFood)?'over':'less')

const ownersTooMuch = dogs.filter(n=>n.curFood>n.recFood).flatMap(n=>n.owners)
const ownersTooLittle = dogs.filter(n=>n.curFood<n.recFood).flatMap(n=>n.owners)
console.log(ownersTooMuch)
console.log(ownersTooLittle)

console.log(`${ownersTooLittle.join(" and ")}'s dog` )
console.log(dogs.some(n=>(n.curFood === n.recFood)))

const OKAY = dogs.filter(n=>(n.curFood<=n.recFood*1.1 && n.curFood>=n.recFood*0.9))
console.log(OKAY)

console.log(Object.groupBy(dogs,(n)=>{
  if (n.curFood===n.recFood) return 'exact';
  else if (n.curFood>n.recFood) return 'over';
  else return 'low'
}))
console.log(Object.groupBy(dogs,n=>n.owners.length))

const dogsort = dogs.toSorted((a,b)=>a.curFood-b.curFood)
console.log(dogsort)
console.log(dogs)