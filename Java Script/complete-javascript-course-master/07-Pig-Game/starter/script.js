'use strict';

const player1El = document.querySelector('.player--0');
const player2El = document.querySelector('.player--1');
const score0E1 = document.querySelector('#score--0');
const score0E2 = document.querySelector('#score--1');
const current0E1 = document.getElementById('current--0');
const current0E2 = document.getElementById('current--1');
const diceEl = document.querySelector('.dice');
const btnNew = document.querySelector('.btn--new');
const btnRoll = document.querySelector('.btn--roll');
const btnHold = document.querySelector('.btn--hold');

score0E1.textContent = 0;
score0E2.textContent = 0;
diceEl.classList.add('hidden');

const score = [0, 0];
let activePlayer = 0;
let currentScore = 0;
let playing = true;

const switchPlayer = function () {
  currentScore = 0;
  document.getElementById(`current--${activePlayer}`).textContent = currentScore;
  activePlayer = activePlayer === 0 ? 1 : 0;
  player1El.classList.toggle('player--active');
  player2El.classList.toggle('player--active');
};

//Rolling dice functionality

btnRoll.addEventListener('click', function () {
  if (playing) {
    const dice = Math.trunc(Math.random() * 6 + 1);     

    diceEl.classList.remove('hidden');
    diceEl.src = `dice-${dice}.png`;

    if (dice !== 1) {
      currentScore += dice;
      document.getElementById(`current--${activePlayer}`).textContent =
        currentScore;

     
      console.log(score);
    } else {
      switchPlayer();
    }
  } else {
    console.log('hello');
  }
});

btnHold.addEventListener('click', function () {
  if (playing) {
    score[activePlayer]+=currentScore;
    // console.log(score[activePlayer])
    document.getElementById(`score--${activePlayer}`).textContent =
      score[activePlayer];
    if (score[activePlayer] >= 20) {
      playing = false;
      diceEl.classList.add('hidden');
      document
        .querySelector(`.player--${activePlayer}`)
        .classList.add('player--winner');
      document
        .querySelector(`.player--${activePlayer}`)
        .classList.remove('player--active');
    } else {
      switchPlayer();
    }

    switchPlayer();
  }
});

btnNew.addEventListener('click',function(){
    playing = true;
    score[0]=0
    score[1]=0
    currentScore=0
    activePlayer=0
    document.getElementById(`score--0`).textContent =score[0];
    document.getElementById(`score--1`).textContent =score[1];
     document.getElementById(`current--0`).textContent =currentScore;
     document.getElementById(`current--1`).textContent =currentScore;
     player1El.classList.remove('player--winner');
     player2El.classList.remove('player--winner');
     player1El.classList.add('player--active');
     player2El.classList.remove('player--active');
})