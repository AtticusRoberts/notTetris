# notTetris
I wrote tetris in processing. It works just like normal tetris, with the exception of scoring, which is still a work in progress.
I've implimented a rudimentary scoring system as a placeholder untill I can figure out how tetris is acutally scored (it's more
confusing then you think). The archetecture for the scoring is all there though. One of the parts of the code that I'm most proud 
of is the rotation algoritm. Since my board is represented in a 20x10 matrix, I had to find a way to rotate values in a matrix 
around a fixed point. The fact that I wasn't rotating actual objects but values in a matrix threw me off. Eventually, after an 
embarrasing ammount of work, I figured it out.
