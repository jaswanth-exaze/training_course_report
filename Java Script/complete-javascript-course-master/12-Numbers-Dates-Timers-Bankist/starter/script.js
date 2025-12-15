'use strict';

/////////////////////////////////////////////////
/////////////////////////////////////////////////
// BANKIST APP

/////////////////////////////////////////////////
// Data

// DIFFERENT DATA! Contains movement dates, currency and locale

const account1 = {
  owner: 'Jonas Schmedtmann',
  movements: [200, 455.23, -306.5, 25000, -642.21, -133.9, 79.97, 1300],
  interestRate: 1.2, // %
  pin: 1111,

  movementsDates: [
    '2019-11-18T21:31:17.178Z',
    '2019-12-23T07:42:02.383Z',
    '2025-12-12T09:15:04.904Z',
    '2020-04-01T10:17:24.185Z',
    '2025-12-16T14:11:59.604Z',
    '2020-05-27T17:01:17.194Z',
    '2020-07-11T23:36:17.929Z',
    '2025-12-15T10:51:36.790Z',
  ],
  currency: 'EUR',
  locale: 'pt-PT', // de-DE
};

const account2 = {
  owner: 'Jessica Davis',
  movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
  interestRate: 1.5,
  pin: 2222,

  movementsDates: [
    '2019-11-01T13:15:33.035Z',
    '2019-11-30T09:48:16.867Z',
    '2019-12-25T06:04:23.907Z',
    '2020-01-25T14:18:46.235Z',
    '2020-02-05T16:33:06.386Z',
    '2020-04-10T14:43:26.374Z',
    '2020-06-25T18:49:59.371Z',
    '2020-07-26T12:01:20.894Z',
  ],
  currency: 'USD',
  locale: 'en-US',
};

const accounts = [account1, account2];

/////////////////////////////////////////////////
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

/////////////////////////////////////////////////
// Functions

const formatMovementDate = function (date, locale) {
  const calcDaysPassed = (date1, date2) =>
    Math.round(Math.abs(date2 - date1) / (1000 * 60 * 60 * 24));

  const DaysPassed = calcDaysPassed(new Date(), date);

  if (DaysPassed === 0) return 'Today';
  if (DaysPassed === 1) return 'Yesterday';
  if (DaysPassed <= 7) return `${DaysPassed} days ago`;
  return new Intl.DateTimeFormat(locale).format(date);
};

const formatCur = function (value, locale, currency) {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency,
  }).format(value);
};

const displayMovements = function (acc, sort = false) {
  containerMovements.innerHTML = '';

  const combinedMovsDates = acc.movements.map((mov, i) => ({
    movement: mov,
    movementDate: acc.movementsDates.at(i),
  }));

  if (sort) combinedMovsDates.sort((a, b) => a.movement - b.movement);

  // const movs = sort
  //   ? acc.movements.slice().sort((a, b) => a - b)
  //   : acc.movements;

  combinedMovsDates.forEach(function (mov, i) {
    const { movement, movementDate } = mov;

    const type = movement > 0 ? 'deposit' : 'withdrawal';
    const date = new Date(movementDate);

    const displayDate = formatMovementDate(date, acc.locale);

    const formattedMov = formatCur(movement, acc.locale, acc.currency);

    const html = `
      <div class="movements__row">
        <div class="movements__type movements__type--${type}">${
      i + 1
    } ${type}</div>
    <div class="movements__date">${displayDate}</div>
        <div class="movements__value">${formattedMov}</div>
      </div>
    `;

    containerMovements.insertAdjacentHTML('afterbegin', html);
  });
};

const calcDisplayBalance = function (acc) {
  acc.balance = acc.movements.reduce((acc, mov) => acc + mov, 0);

  labelBalance.textContent = formatCur(acc.balance, acc.locale, acc.currency);
};

const calcDisplaySummary = function (acc) {
  const incomes = acc.movements
    .filter(mov => mov > 0)
    .reduce((acc, mov) => acc + mov, 0);
  labelSumIn.textContent = formatCur(incomes, acc.locale, acc.currency);

  const out = acc.movements
    .filter(mov => mov < 0)
    .reduce((acc, mov) => acc + mov, 0);
  labelSumOut.textContent = formatCur(out, acc.locale, acc.currency);

  const interest = acc.movements
    .filter(mov => mov > 0)
    .map(deposit => (deposit * acc.interestRate) / 100)
    .filter((int, i, arr) => {
      // console.log(arr);
      return int >= 1;
    })
    .reduce((acc, int) => acc + int, 0);
  labelSumInterest.textContent = formatCur(interest, acc.locale, acc.currency);
};

const createUsernames = function (accs) {
  accs.forEach(function (acc) {
    acc.username = acc.owner
      .toLowerCase()
      .split(' ')
      .map(name => name[0])
      .join('');
  });
};
createUsernames(accounts);

const updateUI = function (acc) {
  // Display movements
  displayMovements(acc);

  // Display balance
  calcDisplayBalance(acc);

  // Display summary
  calcDisplaySummary(acc);
};

const startLogOutTimer = function () {
  //set time to 5 minutes
  let time = 10;

  //call the timer every second
  const timer = setInterval(() => {
    const min = `${Math.trunc(time / 60)}`.padStart(2, 0);
    const sec = `${time % 60}`.padStart(2, 0);
    //in each call, print the remining time to UI
    labelTimer.textContent = `${min}:${sec}`;
    console.log(labelTimer.textContent);

    //when 0 second, stop timer and logout
    if (time === 0) {
      // document.body.style.opacity=0;
      clearInterval(timer);
      labelWelcome.textContent = 'Log in to get started';
      containerApp.style.opacity = 0;
    }
    //decrese 1 second
    time--;
  }, 1000);
};

///////////////////////////////////////
// Event handlers
let currentAccount, timer;

//currentAccount = account1;
// updateUI(currentAccount);
// containerApp.style.opacity = 100;

// experimenting API
const now = new Date();
const options = {
  hour: 'numeric',
  minute: 'numeric',
  day: 'numeric',
  month: 'numeric',
  year: 'numeric',
  // weekday: 'long',
};
const locale = navigator.language;

labelDate.textContent = new Intl.DateTimeFormat(locale, options).format(now);

btnLogin.addEventListener('click', function (e) {
  // Prevent form from submitting
  e.preventDefault();

  currentAccount = accounts.find(
    acc => acc.username === inputLoginUsername.value
  );
  console.log(currentAccount);
  if (currentAccount?.pin === Number(inputLoginPin.value)) {
    // Display UI and message
    labelWelcome.textContent = `Welcome back, ${
      currentAccount.owner.split(' ')[0]
    }`;
    containerApp.style.opacity = 100;

    // create current date and time
    const now = new Date();
    const options = {
      hour: 'numeric',
      minute: 'numeric',
      day: 'numeric',
      month: 'numeric',
      year: 'numeric',
      // weekday: 'long',
    };
    const locale = navigator.language;
    console.log(locale);

    labelDate.textContent = new Intl.DateTimeFormat(
      currentAccount.locale,
      options
    ).format(now);

    // const now = new Date();
    // const day = `${now.getDate()}`.padStart(2, 0);
    // const month = `${now.getMonth() + 1}`.padStart(2, 0);
    // const year = now.getFullYear();
    // const hour = `${now.getHours()}`.padStart(2, 0);
    // const min = `${now.getMinutes()}`.padStart(2, 0);
    // labelDate.textContent = `${day}/${month}/${year}, ${hour}:${min}`;

    // Clear input fields
    inputLoginUsername.value = inputLoginPin.value = '';
    inputLoginPin.blur();

    startLogOutTimer();

    // Update UI
    updateUI(currentAccount);
  }
});

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
    // Doing the transfer
    currentAccount.movements.push(-amount);
    receiverAcc.movements.push(amount);

    // add transfer date
    currentAccount.movementsDates.push(new Date().toISOString());
    receiverAcc.movementsDates.push(new Date().toISOString());

    // Update UI
    updateUI(currentAccount);
  }
});

btnLoan.addEventListener('click', function (e) {
  e.preventDefault();

  const amount = Math.floor(Number(inputLoanAmount.value));

  if (amount > 0 && currentAccount.movements.some(mov => mov >= amount * 0.1)) {
    setTimeout(function () {
      // Add movement
      currentAccount.movements.push(amount);

      // add loan date
      currentAccount.movementsDates.push(new Date().toISOString());

      // Update UI
      updateUI(currentAccount);
    }, 2500);
  }
  inputLoanAmount.value = '';
});

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
    // .indexOf(23)

    // Delete account
    accounts.splice(index, 1);

    // Hide UI
    containerApp.style.opacity = 0;
  }

  inputCloseUsername.value = inputClosePin.value = '';
});

let sorted = false;
btnSort.addEventListener('click', function (e) {
  e.preventDefault();
  displayMovements(currentAccount, !sorted);
  sorted = !sorted;
});

/////////////////////////////////////////////////
/////////////////////////////////////////////////
/*
LECTURES
console.clear()
console.log((0.1+0.2)===0.3)
console.log(Number.isNaN())
console.log()

let x='jen74y99hfh'
let c=0;

for (let i of x){
  if (Number.isFinite(+i))
  {
    c=c+1
    console.log(i)
  }
}
console.log(c)
console.log(new Date()) 
const d = new Date()
console.log(d , typeof d)

console.log(Number((0.1 + 0.2).toFixed(10)))

console.log(Math.max([1,2,3,2].flat()))
console.log(Math.max(...[1,2,3,2]))
console.log(Math.sqrt(25))

function randomGenarator(x,y){
  return Math.trunc((Math.random())*(y+1-x)+x)
}
console.log(randomGenarator(30,34))
console.log(randomGenarator(30,31))
console.log(randomGenarator(0,2))
console.log(randomGenarator(0,2))
console.log(randomGenarator(0,2))
console.log(randomGenarator(0,2))


console.log(Math.round(12.1232454))   //      12
console.log(Math.round(12.6232454))   //      13
console.log(Math.floor(12.1232454))   //   12.123 ⬇ 12
console.log(Math.ceil(12.1232454))    //   12.123 ⬆ 13
console.log('======================= ')

console.log(Math.round(-12.1232454))  //      -12
console.log(Math.round(-12.6232454))  //      -13
console.log(Math.floor(-12.1232454))  //   -12.123 ⬇ -13
console.log(Math.ceil(-12.1232454))   //   -12.123 ⬆ -12
//rounding decimals
console.log((2.7).toFixed(0))    //3 type string
console.log((2.7).toFixed(4))    //2.7000 type string
console.log((2.34567).toFixed(3))  //2.345 type string
console.log(+(2.34567).toFixed(4))  //3 type Number
console.log(+(54/10).toFixed(0))

let a= [1,2,3]
let b= new Array(1,2,34)
console.log(typeof a , a)
console.log(typeof b , b)


labelBalance.addEventListener('click', function () {
  [...document.querySelectorAll('.movements__row')].forEach(function (row, i) {
    // 0, 2, 4, 6
    if (i % 2 === 0) row.style.backgroundColor = 'orangered';
    // 0, 3, 6, 9
    if (i % 3 === 0) row.style.backgroundColor = 'blue';
  });
});


const diameter = 2_87_46_00_00_000;
console.log(diameter);
const now = new Date()
console.log(now.getMilliseconds())
console.log(now)

console.log(new Date('10 22 1000'))
console.log(new Date('10 29 2001'))
console.log(new Date(0))
console.log(new Date('11'))
console.log(new Date(2320))

const date= new Date(2001 , 9 ,29 ,15 ,23)
console.log(date.getDay())
console.log(date.getFullYear())
console.log(date.getHours())
console.log(date.getMilliseconds())
console.log(date.getTime())
console.log(date.getDate())
console.log(date.toISOString())
console.log(date)
console.log(date)
console.log(date)
console.log(date)
console.log(date)
console.log(date)


const future = new Date(2037,10,19,15,23);

const calcDaysPassed = (date1,date2)=>Math.abs(date2-date1)/(1000*60*60*24)

console.log(calcDaysPassed(new Date(2037,3,14) , new Date(2037,3,24)))
console.log(calcDaysPassed(new Date(2001,10-1,29),new Date())/365)
console.log(new Date() , new Date(2001,10-1,29))
console.log(calcDaysPassed(new Date(2037,4,14) , new Date(2037,3,14)))
console.log(calcDaysPassed(new Date(2037,1,24,10,8,1) , new Date(2037,1,24,10,0,1)))
console.log(new Date(2037,1,24,10,8,1) , new Date(2037,1,24,10,0,1))

const num= 65345467.54;
const options1={
  style:'currency',
  // unit:'currency',
  currency:'INR'
  
}
console.log(new Intl.NumberFormat('en-IN',options1).format(num))
console.log(new Intl.NumberFormat('de-DE',options1).format(num))
console.log(new Intl.NumberFormat(navigator.language,options1).format(num))


setTimeout(()=>document.body.style.opacity=0,10000)
for(let i=0;i<11;i++){
  setTimeout(()=>console.log(`timmer:: ${10-i}`),i*1000);
  
}

// setInterval(() => console.log(new Date().getSeconds()), 1000);

setInterval(() => {
  const now = new Date();
  console.log(now)
  
}, 1000);
*/
