'use strict';

/*
// Data needed for a later exercise
const flights =
  '_Delayed_Departure;fao93766109;txl2133758440;11:25+_Arrival;bru0943384722;fao93766109;11:45+_Delayed_Arrival;hel7439299980;fao93766109;12:05+_Departure;fao93766109;lis2323639855;12:30';

const italianFoods = new Set([
  'pasta',
  'gnocchi',
  'tomatoes',
  'olive oil',
  'garlic',
  'basil',
]);

const mexicanFoods = new Set([
  'tortillas',
  'beans',
  'rice',
  'tomatoes',
  'avocado',
  'garlic',
]);

// Data needed for first part of the section
const restaurant = {
  name: 'Classico Italiano',
  location: 'Via Angelo Tavanti 23, Firenze, Italy',
  categories: ['Italian', 'Pizzeria', 'Vegetarian', 'Organic'],
  starterMenu: ['Focaccia', 'Bruschetta', 'Garlic Bread', 'Caprese Salad'],
  mainMenu: ['Pizza', 'Pasta', 'Risotto'],

  openingHours: {
    thu: {
      open: 12,
      close: 22,
    },
    fri: {
      open: 11,
      close: 23,
    },
    sat: {
      open: 0, // Open 24 hours
      close: 24,
    },
  },
};
const [a, b] = restaurant.categories;
console.log(a, b);

let aa = 10;
let bb = 20;

aa=aa+bb;
bb=aa-bb
aa=aa-bb

[aa, bb] = [bb, aa];

console.log(aa, bb);

const {name,openingHours,categories}=restaurant;
console.log(name,categories,openingHours)

const {name: restaurantName,openingHours:hours}=restaurant;
console.log(restaurantName,hours)


let user = { name: "Jaswanth", age: 22 };

let name = user.name;
let age = user.age;

console.log(name, age);

const a = [1,2,3]
const b = [4,5,6]

let ab=[...a,...b]
console.log(ab)
console.log(a)
console.log(...a)
console.log(...a,...b)



let a = { x: 1 };
let b = { y: 2 };

let ab = {...a,...b}
console.log(ab)

// SHORT CIRCUTING(&& and  ||)

console.log(null || "jk");

const a=10;

// console.log( a===b || "jk" );

const c= a===10 || 21

console.log(c)
const e = null;
const d= e ?? 23;
console.log(d)
*/

/*
const jk={
  name: 'jaswanth kumar',
  age: 24,
  height: 5.5,
  company: 'EXAZE'
}
const mk={
  name: 'manoj kumar',
  age :null,
  height: 5.4,
}

console.log(mk)      // {name: 'manoj kumar', height: 5.4}

mk.age||= 26         // OR (||) assignment operator //
mk.age??=26          // nullish assignment operator  ( ?? ) //
console.log(jk.age)  // 24
console.log(mk.age)  // 26
console.log(mk)      // {name: 'manoj kumar', height: 5.4, age: 26}

jk.company= jk.company && '<ANONYMOUS>'  //  <ANONYMOUS>
mk.company= mk.company && '<ANONYMOUS>'  //  undefined

// jk.company= jk.company && '<ANONYMOUS>'  //  <ANONYMOUS>
//        ||
//if (jk.company) {
//    jk.company = '<ANONYMOUS>';
//} else {
//    jk.company = jk.company;
//}


mk.company=mk.company && '<ANONYMOUS>'

console.log(jk.company)
console.log(mk.company)
We're building a football betting app (soccer for my American friends 😅)!

Suppose we get data from a web service about a certain game (below). In this challenge we're gonna work with the data. So here are your tasks:

1. Create one player array for each team (variables 'players1' and 'players2')
   // const {players:[players1,players2]} = game; 
2. The first player in any player array is the goalkeeper and the others are field players. For Bayern Munich (team 1) create one variable ('gk') with the goalkeeper's name, and one array ('fieldPlayers') with all the remaining 10 field players
   // const [gk,...fieldplayers]=players1;
3. Create an array 'allPlayers' containing all players of both teams (22 players)
  //const allPlayers=[...game.players[0],...game.players[1]]
4. During the game, Bayern Munich (team 1) used 3 substitute players. So create a new array ('players1Final') containing all the original team1 players plus 'Thiago', 'Coutinho' and 'Perisic'
  // const players1Final =[...players1,'Thiago', 'Coutinho' ,'Perisic']
5. Based on the game.odds object, create one variable for each odd (called 'team1', 'draw' and 'team2')
  // const {odds:{team1,x:draw,team2}}=game
6. Write a function ('printGoals') that receives an arbitrary number of player names (NOT an array) and prints each of them to the console, along with the number of goals that were scored in total (number of player names passed in)
  // const printGoals=function(...players){
  // players.forEach(n => console.log(n, players.length))}

  // printGoals(...game.players[0])
7. The team with the lower odd is more likely to win. Print to the console which team is more likely to win, WITHOUT using an if/else statement or the ternary operator.
  // const {odds:{team1,x:draw,team2}}=game
  // team1<team2 && console.log('team1 is more likely to win');
  // team1>team2 && console.log('team2 is more likely to win');
TEST DATA FOR 6: Use players 'Davies', 'Muller', 'Lewandowski' and 'Kimmich'. Then, call the function again with players from game.scored

GOOD LUCK 😀

const game = {
  team1: 'Bayern Munich',
  team2: 'Borrussia Dortmund',
  players: [
    [
      'Neuer',
      'Pavard',
      'Martinez',
      'Alaba',
      'Davies',
      'Kimmich',
      'Goretzka',
      'Coman',
      'Muller',
      'Gnarby',
      'Lewandowski',
    ],
    [
      'Burki',
      'Schulz',
      'Hummels',
      'Akanji',
      'Hakimi',
      'Weigl',
      'Witsel',
      'Hazard',
      'Brandt',
      'Sancho',
      'Gotze',
    ],
  ],
  score: '4:0',
  scored: ['Lewandowski', 'Gnarby', 'Lewandowski', 'Hummels'],
  date: 'Nov 9th, 2037',
  odds: {
    team1: 1.33,
    x: 3.25,
    team2: 6.5,
  },
};


// const printGoals=function(...players){
//   players.forEach(n => console.log(n, players.length))}

//   printGoals(...game.players[0])

// 

// console.log(team1,draw,team2)

// const allPlayers=[...game.players[0],...game.players[1]]
// console.log(allPlayers)

// const {players:[players1,players2]} = game; 

// console.log(players1)
// console.log(players2)

// const gk= [game.players[0][0],game.players[1][0]]

// const fieldPlayers= [...game.players[0],...game.players[1]]


// // let gk=[]
// // let fieldPlayers=[]

// const players1Final =[...players1,'Thiago', 'Coutinho' ,'Perisic']
// console.log(players1Final)
// // console.log(gk)
// // console.log(fieldPlayers)

// const jk=[12,23,34,45,56,67]
// for (let j=0; j<jk.length;j++) console.log(jk[j])

// for (let [i,el] of jk.entries()) console.log(i,el)

// jk.forEach(n =>  console.log(n))

const trainee ={
    name:'jaswanth',
    age: 24,
    courses: {
      database:['postgres sql','mysql'],
      frontend:['html','css'],
      backend:['linux','docker','javascript'],
      tools:['vscode','git and github']
    },
    workingdays:['mon','tue','wed','thu','fri'],
    workinghours:8,
    plainsdays(){
      return this.workingdays.join(" ")
    },
    text(){
        console.log(`${this.name} works ${this.workinghours} hours every ${this.plainsdays()} in a week`)
    }
}

trainee.text()
console.log(trainee.workingdays)

const ujk=(age)=>{ 
  console.log("uppu jaswanth kumar",age)
}
ujk(24)



//OPTIONAL CHAINING

let user={
  name:'jaswanth'
}
console.log(user.name)
// console.log(user.age.month)  // Uncaught TypeError: Cannot read properties of undefined (reading 'month')

console.log(user.age?.month)    // undefined
//    MEANING ==>>
// If address exists → return address.city
// If not → return undefined safely
console.log(trainee.courses?.backend?.[0]);  //linux

console.log(trainee.profile?.experience?.years);   // undefined
console.log(trainee.plainsdays?.() )     // mon tue wed thu fri
let data = [2,3,3,4];
console.log(data?.[6]);  //undefined

const trainee ={
    name:'jaswanth',
    age: 24,
    courses: {
      database:['postgres sql','mysql'],
      frontend:['html','css'],
      backend:['linux','docker','javascript'],
      tools:['vscode','git and github']
    },
    workingdays:['mon','tue','wed','thu','fri'],
    workinghours:8,
    plainsdays(){
      return this.workingdays.join(" ")
    },
    text(){
      console.log(`${this.name} works ${this.workinghours} hours every ${this.plainsdays()} in a week`)
    }
  }
  
  for (let i of Object.values(trainee)){
    console.log(i)
}

for (let i of trainee.workingdays){
  process.stdout.write(i)
}
const game = {
  team1: 'Bayern Munich',
  team2: 'Borrussia Dortmund',
  players: [
    [
      'Neuer',
      'Pavard',
      'Martinez',
      'Alaba',
      'Davies',
      'Kimmich',
      'Goretzka',
      'Coman',
      'Muller',
      'Gnarby',
      'Lewandowski',
    ],
    [
      'Burki',
      'Schulz',
      'Hummels',
      'Akanji',
      'Hakimi',
      'Weigl',
      'Witsel',
      'Hazard',
      'Brandt',
      'Sancho',
      'Gotze',
    ],
  ],
  score: '4:0',
  scored: ['Lewandowski', 'Gnarby', 'Lewandowski', 'Hummels'],
  date: 'Nov 9th, 2037',
  odds: {
    team1: 1.33,
    x: 3.25,
    team2: 6.5,
  },
};

for (let [i,j] of Object.entries(game.odds)){
  console.log(`Odd of ${game[i]  || 'draw'}: ${j}`)
}
*/
/* 

Let's continue with our football betting app!

1. Loop over the game.scored array and print each player name to the console, along with the goal number (Example: "Goal 1: Lewandowski")
      for(let i=0;i<game.scored.length;i++){
      console.log(`Goal ${i+1}: ${game.scored[i]}`)
      }
      for (let [i,j] of game.scored.entries()){
        console.log(`Goal ${i+1}: ${j}`)
      }
2. Use a loop to calculate the average odd and log it to the console (We already studied how to calculate averages, you can go check if you don't remember)
      let x=0
      let k=0
      for (let i of Object.values(game.odds)){
        x+=i;
        k++
      }
      console.log(x/k)
3. Print the 3 odds to the console, but in a nice formatted way, exaclty like this:
      Odd of victory Bayern Munich: 1.33
      Odd of draw: 3.25
      Odd of victory Borrussia Dortmund: 6.5
Get the team names directly from the game object, don't hardcode them (except for "draw"). HINT: Note how the odds and the game objects have the same property names 😉

BONUS: Create an object called 'scorers' which contains the names of the players who scored as properties, and the number of goals as the value. In this game, it will look like this:
      {
        Gnarby: 1,
        Hummels: 1,
        Lewandowski: 2
      }

GOOD LUCK 😀

let name="jaswanth kumar uppu"
console.log(...name,name.length)
let setname=[...new Set(name)]
console.log(...setname,setname.length)

let x=new Set([1,2,3,4,5,2,3,1,3,1,4,2])
console.log(x.size)
console.log(x.has(5))
console.log(x.has(6))
x.add(7)
x.add(8)
x.add(9)
x.add(6)
let count= x.has(4)? 1: 0
console.log(count)
console.log(x)

const italianFoods = new Set([
  'pasta',
  'gnocchi',
  'tomatoes',
  'olive oil',
  'garlic',
  'basil',
]);

const mexicanFoods = new Set([
  'tortillas',
  'beans',
  'rice',
  'tomatoes',
  'avocado',
  'garlic',
]);
 // INTERSECTION
 const commonFood = italianFoods.intersection(mexicanFoods)
 console.log(commonFood)
 // UNION
 const italinaMexicanFusion = italianFoods.union(mexicanFoods)
 console.log(italinaMexicanFusion)
 // DIFFERENCE
 const uniqueItalinaFood = italianFoods.difference(mexicanFoods)
 console.log(uniqueItalinaFood)
 
 const UniqeMexicanFoods = mexicanFoods.difference(italianFoods)
 console.log(UniqeMexicanFoods)
 
 const uniqueItalianAndMexicanFoods =
 italianFoods.symmetricDifference(mexicanFoods);
 console.log(uniqueItalianAndMexicanFoods);
 
 
 
 const square= new Map();
 const sq=(x) => x*x;
 console.log(sq(11))
 for (let i=1 ; i<=20;i++) {
  if (i%2==0) square.set(i,sq(i))
 }

  console.log(square)
  for(let [j,k] of square) console.log(j,k)
  
  
    const x = n =>n**2
    console.log(x(5))  //25
    
    
    
    console.log(abc(7))
    function abc(n){
      return n**2
    }
    
    
    console.log(xyz(7))
    const xyz= function(n){
      return n**2
    }
    
    // Maps: Iteration
const question = new Map([
  ['question', 'What is the best programming language in the world?'],
  [1, 'C'],
  [2, 'Java'],
  [3, 'JavaScript'],
  ['correct', 3],
  [true, 'Correct 🎉'],
  [false, 'Try again!'],
  ['hey','hello'],
]);
console.log(question);

for(let [i,j] of question ){
  if(typeof i === 'number'){
    console.log(i,j)
  }
}
const answer = Number (prompt('your answer'))

if (answer===question.get('correct')){
  console.log(question.get(true))
}else{
  console.log(question.get(false))
}

*/
/* 
Let's continue with our football betting app! This time, 
we have a map with a log of the events that happened during the game. 
The values are the events themselves, and the keys are the minutes in which each event happened 
(a football game has 90 minutes plus some extra time).

1. Create an array 'events' of the different game events that happened (no duplicates)
    const events = (new Set(gameEvents.values()))
    console.log(events)

2. After the game has finished, is was found that the yellow card from minute 64 was unfair. So remove this event from the game events log.
    gameEvents.delete(92)
    console.log(gameEvents)

3. Print the following string to the console: "An event happened, on average, every 9 minutes" (keep in mind that a game has 90 minutes)
4. Loop over the events and log them to the console, marking whether it's in the first half or second half (after 45 min) of the game, like this:
      [FIRST HALF] 17: ⚽️ GOAL
  for (let [i, j] of gameEvents) {
  if (i <= 45 && j === '⚽️ GOAL') {
    console.log(`[FIRST HALF] ${i}: ${j}`);
  } else if (i > 45 && j === '⚽️ GOAL') {
    console.log(`[SECOND HALF] ${i}: ${j}`);
  }
}

GOOD LUCK 😀

const gameEvents = new Map([
  [17, '⚽️ GOAL'],
  [36, '🔁 Substitution'],
  [47, '⚽️ GOAL'],
  [61, '🔁 Substitution'],
  [64, '🔶 Yellow card'],
  [69, '🔴 Red card'],
  [70, '🔁 Substitution'],
  [72, '🔁 Substitution'],
  [76, '⚽️ GOAL'],
  [80, '⚽️ GOAL'],
  [92, '🔶 Yellow card'],
]);

const events = [...new Set(gameEvents.values())];
console.log(events);
gameEvents.delete(92);
console.log(gameEvents);

console.log(90/gameEvents.size)


let a = 'my name is Jaswanth';
console.log(a.split(' ').join(' '));
console.log(a.indexOf('Jaswanth'));
console.log(a.slice(a.lastIndexOf(' ') + 1));
let b = '   jaswanth@gmail.com \n';
console.log(b.trim());
console.log(a.replaceAll('a', '0'));
console.log(a.startsWith('my'));
console.log(a.endsWith('Jaswanth'));
console.log(a.charAt(11));
// console.log(a.padStart(2,'-'))

//loop for 4 digit number 1000 - 9999
for (let i = 1000; i <= 9999; i++) {
  // last digit is twice the 1st digit
  if (Math.trunc(i / 1000) === (i % 10) / 2) {
    //last 2 digits is twice the first 2 digits
    if (Math.trunc(i / 100) === (i % 100) / 2) {
      // 2nd digit is same as 3rd digit
      if (Math.trunc(i / 100) % 10 === Math.trunc((i % 100) / 10)) {
        console.log(i);
      }
    }
  }
}

const box = [];
for (let i = 1000; i <= 9999; i++) {
  box.push(i.toString());
}

for (let i of box) {
  if (i[0]*2 == i[3]) {                //4998 ==> [4]*2==[8]
    if (i[1] === i[2]) {               //4998 ==> [9]==[9]
      if (i.slice(0,2)*2==i.slice(-2))  //4998 ==> [49]*2==[98]
      console.log(i);
    }
  }
}

let r="jaswanth "
console.log(r.repeat(10))
console.log()


Write a program that receives a list of variable names written in underscore_case and convert them to camelCase.

The input will come from a textarea inserted into the DOM (see code below), and conversion will happen when the button is pressed.

THIS TEST DATA (pasted to textarea)
underscore_case
 first_name
Some_Variable 
  calculate_AGE
delayed_departure

SHOULD PRODUCE THIS OUTPUT (5 separate console.log outputs)
underscoreCase      ✅
firstName           ✅✅
someVariable        ✅✅✅
calculateAge        ✅✅✅✅
delayedDeparture    ✅✅✅✅✅

HINT 1: Remember which character defines a new line in the textarea 😉
HINT 2: The solution only needs to work for a variable made out of 2 words, like a_b
HINT 3: Start without worrying about the ✅. Tackle that only after you have the variable name conversion working 😉
HINT 4: This challenge is difficult on purpose, so start watching the solution in case you're stuck. Then pause and continue!

Afterwards, test with your own test data!

GOOD LUCK 😀

document.body.append(document.createElement('textarea'));
document.body.append(document.createElement('button'));

document.querySelector('button').addEventListener('click', function () {
  const text = document.querySelector('textarea').value.split('\n');
  console.log(text);
  for (let [i,j] of text.entries()){
    const [f,l] =j.toLowerCase().trim().split('_'); 
    console.log(`${f}${l.replace(l[0],l[0].toUpperCase())}`.padEnd(20," ").concat('✅'.repeat(i+1)))
  }
});

console.log('delayedDeparture    ✅✅✅✅✅'.toUpperCase())
console.log('V'.toUpperCase())

*/

const flights =
  '_Delayed_Departure;fao93766109;txl2133758440;11:25+_Arrival;bru0943384722;fao93766109;11:45+_Delayed_Arrival;hel7439299980;fao93766109;12:05+_Departure;fao93766109;lis2323639855;12:30';

const list= flights.split("+")
// console.log(list)
list.forEach(n => {
  const d = n.split(';')
  const outpu=`${(d[0].startsWith('_Delayed'))? '🔴' : "" }${d[0].replaceAll('_',' ')} from ${d[1].toUpperCase().slice(0,3)} to ${d[2].toUpperCase().slice(0,3)} (${d[3].replace(':','h')})`
  console.log(outpu.padStart(45," "))

});
console.log('🔴 Delayed Departure from FAO to TXL (11h25)'.length)