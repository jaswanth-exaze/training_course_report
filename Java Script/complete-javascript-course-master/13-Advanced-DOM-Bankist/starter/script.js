'use strict';

///////////////////////////////////////
// Modal window

const modal = document.querySelector('.modal');
const overlay = document.querySelector('.overlay');
const btnCloseModal = document.querySelector('.btn--close-modal');
const btnsOpenModal = document.querySelectorAll('.btn--show-modal');
const btnScrollTo = document.querySelector('.btn--scroll-to');
const section1 = document.querySelector('#section--1');
const nav = document.querySelector('.nav');
const tabs = document.querySelectorAll('.operations__tab');
const tabsContainer = document.querySelector('.operations__tab-container');
const tabsContent = document.querySelectorAll('.operations__content');

const openModal = function (e) {
  e.preventDefault();
  modal.classList.remove('hidden');
  overlay.classList.remove('hidden');
};

const closeModal = function () {
  modal.classList.add('hidden');
  overlay.classList.add('hidden');
};

// for (let i = 0; i < btnsOpenModal.length; i++)
//   btnsOpenModal[i].addEventListener('click', openModal);
btnsOpenModal.forEach(n => n.addEventListener('click', openModal));

btnCloseModal.addEventListener('click', closeModal);
overlay.addEventListener('click', closeModal);

document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
    closeModal();
  }
});


// Button scrolling
btnScrollTo.addEventListener('click', function (e) {
  // const s1coords = section1.getBoundingClientRect();
  // console.log(s1coords);
  
  // console.log(e.target.getBoundingClientRect());
  
  // console.log('Current scroll (X/Y)', window.pageXOffset, window.pageYOffset);
  
  // console.log(
  //   'height/width viewport',
  //   document.documentElement.clientHeight,
  //   document.documentElement.clientWidth
  // );
   section1.scrollIntoView({ behavior: 'smooth' });
  });
  
  //page navigation

document.querySelectorAll('.nav__link').forEach(
  function(el){
    el.addEventListener('click',function(e){
      e.preventDefault()
      const id=this.getAttribute('href');
      console.log(id)
      document.querySelector(id).scrollIntoView({behavior:'smooth'});
    })
  }
)
console.log(document.querySelectorAll('.nav__link'))


let a =['a','b','c','d']

console.log(a)
console.log(a.length)
for (let i=0;i<a.length;i++){
  console.log(a[i])
}

let b ={
  name:'jk',
  age:25,
}
console.log(b)
console.log(b.age)
console.log(b.name)

console.log(a)
// let c = a;
let c= [name,...a]
c[1]='jk'
console.log(c)
console.log(a)






// function arrayIntersection(arr1, arr2) 
// {
//   // const set2 = new Set(arr2); 
//   // return arr1.filter(value => set2.has(value));
//   const set1= new Set(arr1)
//   const set2= new Set(arr2)
//   return set1.intersection(set2)
// }

// console.log(arrayIntersection([5, 6, 7], [6, 7,8 ]));
  /*

// console.log(document.querySelectorAll(".section"))
// console.log(document.getElementsByTagName("button"))
const header = document.querySelector('.header');
const footer = document.querySelector('.footer');
const section = document.querySelector('.section');

const message = document.createElement('div');
message.classList.add('cookie-message');
// message.textContent='we use cookies for improved and functionality and analytics.'
message.innerHTML= 'we use cookies for improved and functionality and analytics. <button class="btn btn--close--cookie">Got it!</button>';
// console.log(message);

// header.prepend(message)
// header.append(message)

// header.prepend(item)
// item.remove()

header.before(message);
// header.append(message);

// document.querySelector('.nav').remove()
// console.log(message.parentElement)
// console.log(header);
document.querySelector('.btn--close--cookie').addEventListener('click',function(){
  console.log("cookies accepted")
  // message.remove()
  message.parentElement.removeChild(message);
  console.log(message);
  console.log(header)
})
//styles
////////////////////////////
message.style.backgroundColor='#37373d'
message.style.width='100%'
message.style
message.style
console.log(getComputedStyle(message))
console.log(getComputedStyle(message).color)
console.log(getComputedStyle(message).height)

// document.documentElement.style.setProperty('--color-primary','orangered')
let logo = document.querySelector('.nav__logo');
logo.alt="Beautful minimalist logo"
console.log(logo.alt)



let game= document.createElement('div');
game.classList.add('btn');
game.innerHTML='<btton>click me</btton>'

header.before(game)
game.addEventListener('click',function(){
  let i=0;
  let tags=[header,footer,section];
  let where=[ tags[`${Math.trunc(Math.random()*3)}`].after , tags[`${Math.trunc(Math.random()*3)}`].before , tags[`${Math.trunc(Math.random()*3)}`].append , tags[`${Math.trunc(Math.random()*3)}`].prepend];
  while (i<10){
    
  game.remove()
  console.log(where[`${Math.trunc(Math.random()*4)}`])
  // header.after(game)
    where[`${Math.trunc(Math.random()*4)}`](game)
    
    i++;
  }
  })
  // console.log(Math.trunc(Math.random()*4))
  const btnScrollTo = document.querySelector('.btn--scroll-to');
  const section1 = document.querySelector('#section--1');
  
  btnScrollTo.addEventListener('click', function (e) {
  const s1coords = section1.getBoundingClientRect();
  console.log(s1coords);

  console.log(e.target.getBoundingClientRect());
  
  console.log('current scroll (X/Y)', window.pageXOffset, window.pageYOffset);
  console.log(
    'height/width viewport',
    document.documentElement.clientHeight,
    document.documentElement.clientWidth
  );
  // window.scrollTo(s1coords.left+window.pageXOffset,s1coords.top+window.pageYOffset);
  // window.scrollTo({
    //   left: s1coords.left + window.pageXOffset,
    //   top: s1coords.top + window.pageYOffset,
    //   behavior: 'smooth' }
    // );
    section1.scrollIntoView({behavior:'smooth'})
  });
  
  const h1 = document.querySelector('h1');
  
  const alertfun= function(e){
    alert('its working great!...');
    
  }

  h1.addEventListener('mouseenter',alertfun)
  h1.addEventListener('copy',function(e){
    alert('you are not supposed to copy this content')
  })
setTimeout(() => {
  h1.removeEventListener('mouseenter',alertfun)
},3000);

h1.addEventListener('dblclick',function(e){
  console.log("selected")
})


const randomInt = (min,max) => Math.floor(Math.random()*(max-min+1)+min);

console.log(randomInt(1,60))
const randomColor=()=> `rgb(${randomInt(0,255)},${randomInt(0,255)},${randomInt(0,255)})`


const h1=document.querySelector('h1')
h1.style.color=randomColor()


document.querySelector('.nav__link').addEventListener('click',function(e){
  
this.style.backgroundColor=randomColor()
  e.stopPropagation()
});
document.querySelector('.nav__links').addEventListener('click',function(e){

this.style.backgroundColor=randomColor()
});
document.querySelector('.nav').addEventListener('click',function(e){
  this.style.backgroundColor=randomColor()
});
// */

// const h1= document.querySelector('h1');

// console.log(h1.querySelectorAll('.highlight'));
// console.log(h1.childNodes)
// console.log(h1.children)

// h1.firstElementChild.style.color='red'
// h1.lastElementChild.style.color='red'

// console.log(h1.firstElementChild)
// console.log(h1.firstChild)
// console.log(h1.lastElementChild)
// console.log(h1.lastChild)

// console.log(h1.parentElement)
// console.log(h1.parentNode)
