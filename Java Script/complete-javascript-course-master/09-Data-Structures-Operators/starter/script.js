'use strict';

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
/*
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

jk.company= jk.company && '<ANONYMOUS>'

if (jk.company==false){
  jk.company
}

mk.company=mk.company && '<ANONYMOUS>'

console.log(jk.company)
console.log(mk.company)