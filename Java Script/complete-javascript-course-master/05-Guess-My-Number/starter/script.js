'use strict';
/*
console.log(document.querySelector('.message').textContent)
document.querySelector('.message').textContent="🎉 Correct Number!"


document.querySelector('.number').textContent =13
document.querySelector('.score').textContent =10

document.querySelector('.guess').value =23
console.log(document.querySelector('.guess').value)

*/
let number=Math.trunc(Math.random()*20+1);
console.log(number)
let score=document.querySelector('.score').textContent
let highscore=document.querySelector('.highscore').textContent
// document.querySelector('.number').textContent=number
console.log("highscore=",highscore)
document.querySelector('.check').addEventListener
('click', function(){
    const guess= Number (document.querySelector('.guess').value);
    console.log(guess, typeof guess);

    if(!guess || guess>=21){
        
        document.querySelector('.message').textContent="⛔ number!"
         document.body.style.backgroundColor="orangered";
    }
    else
        {
        if(score>1) {
            if(number===guess){                         //PLAYER WINS

                document.querySelector('.message').textContent="🎉 Correct Number!";
                // score+=10
                document.querySelector('.number').textContent=number
                document.body.style.backgroundColor="#60b347";
                document.querySelector('.number').style.width='30rem'

                if (highscore<score){
                    highscore=score
                    document.querySelector('.highscore').textContent=highscore;
                }




            }
            else if(number < guess){
                document.querySelector('.message').textContent="its too high";
                score--;

            }
            else{
                document.querySelector('.message').textContent="its too loow";
                score--;
            }
            console.log(score)
            document.querySelector('.score').textContent=score


        }
        else{
             document.querySelector('.message').textContent="game over";
             document.querySelector('.score').textContent=score-1;
        }
    }
    }
);

document.querySelector('.again').addEventListener('click',function(){
    score=20
    document.querySelector('.score').textContent=score
    document.querySelector('.message').textContent='Start guessing...'
    document.body.style.backgroundColor="#222";
    document.querySelector('.number').textContent="?"
    document.querySelector('.number').style.width='15rem'
    document.querySelector('.guess').value=''
    number=Math.trunc(Math.random()*20+1);
    console.log(number)
    console.log("highscore=",highscore)
});












