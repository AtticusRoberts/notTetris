//Made by AtticusRoberts 11/27/18
obj control;
obj next;
int delay;
int[][] board;
int[][] display;
int z=0;
int t,oldT,unitSize,score,nextPiece,xz;
boolean gameOver,check2;
void setup() {
  size(450,600);
  gameOver=false;
  nextPiece=int(random(-1,7));
  delay=1000;
  control=new obj(int(random(-1,7)),false);
  next=new obj(nextPiece,true);
  next.make(false);
  xz=0;
  unitSize=300/10;
  t=0;
  oldT=0;
  background(0);
  board = new int[10][20]; //Initilize my board
  display = new int[4][4]; //This is where I display the next piece
  for (int x=0;x<4;x++) {
    for (int y=0;y<4;y++) {
      display[x][y]=100001; //It's initilized and rendered in the same way as the main board, so I don't have to rewrite anything
    }
  }
  for (int x=0;x<10;x++) {
    for (int y=0;y<20;y++) {
      board[x][y]=100001; //I have sigs for different places. the ones at the ends are so that 0000 dosent turn into 0. In retrospect, they should be strings, but whatever. The number right here 1[x]xxx1 is my player tag. If the piece is being controlled by the player, it's one. Otherwise it's 0. The next three 1x[x][x][x]1 are rgb values for the square. An empty square is 100001 because it's not being controled (1[x]xxx1), and the color is black, or rgb(0,0,0) signified by 1x[x][x][x]1
    } 
  }
}
void draw() {
  control.make(false); //Assign pieces to board
  if (xz==0) {
    xz++;
    displayInit();
  }
  drawBoard(); //Actually draw the board
  t=millis(); //Delay between dowm movement
  if (t-oldT<delay+15 && t-oldT>delay-5) {
    oldT=t;
    moveDown();
    lineClear();
  }
  if (gameOver) {
    background(0);
    fill(255);
    textSize(25);
    text("Game Over!",75,200);
    text("Score: "+score,75,275);
  }
}
void keyPressed() {
  if (key==CODED && !gameOver) {
    if (keyCode==DOWN) { //If down, move down
      score++;
      moveDown();
      lineClear();
    }
    if (keyCode==LEFT) { 
      if (!bottomPieceCheck(-1,0)) {//If left, check if I can move left
        control.make(true); //If I can, destroy the old pos 
        control.x--; //And create the new pos
      }
      
    }
    if (keyCode==RIGHT) {
      if (!bottomPieceCheck(1,0)) { //It's not a bottom piece check, it's a general piece check that can check in different dirs depending on the arguments. It could check up or even diag if I wanted. 
        control.make(true); 
        control.x++;
      }
    }
    if (keyCode==UP) { //Rotate it. 
      control.make(true);
      control.rotatePiece();
    }
    
  }
  if (key==' ') {
    check2=true;
    while (check2) {
      moveDown();
      control.make(false);
      drawBoard();
    }
  }
}
class obj { //My class for the pieces
  int x,y,sig,choice,xOff,yOff,counter,lastSig,moveCount;
  int[][] offs;
  String type;
  boolean nxt;
  obj(int temp,boolean nextTemp) {
    moveCount=0;
    x=4;
    nxt=nextTemp;
    y=0;
    counter=0;
    offs = new int[4][2];
    choice=temp;
    xOff=yOff=1; //I don't think I even use these, they just stuck around from an earlier version. 
  }
  int lng(boolean clear) { //Good
    type="lng";
    sig = 111111;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=-1;
      offs[0][1]=0;
      offs[1][0]=1;
      offs[1][1]=0;
      offs[2][0]=2;
      offs[2][1]=0;
      counter++;
    }
    if (!nxt) assign(sig);
    return 101111;
  }
  int hat(boolean clear) {
    type="hat";
    sig = 110101;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=0;
      offs[0][1]=1;
      offs[1][0]=-1;
      offs[1][1]=0;
      offs[2][0]=1;
      offs[2][1]=0;
      counter++;
    }
    if (!nxt)  assign(sig);
    return 100101;
  }
  int leftL(boolean clear) {
    type="leftL";
    sig = 111001;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=1;
      offs[0][1]=0;
      offs[1][0]=-1;
      offs[1][1]=0;
      offs[2][0]=1;
      offs[2][1]=1;
      counter++;
    }
    if (!nxt) assign(sig);
    return 101001;
  }
  int rightL(boolean clear) {
    type="rightL";
    sig = 110011;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=1;
      offs[0][1]=0;
      offs[1][0]=-1;
      offs[1][1]=0;
      offs[2][0]=-1;
      offs[2][1]=1;
      counter++;
    }
    if (!nxt) assign(sig);
    return 100011;
  }
  int sqr(boolean clear) {
    type="sqr";
    sig = 110111;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=1;
      offs[0][1]=0;
      offs[1][0]=0;
      offs[1][1]=1;
      offs[2][0]=1;
      offs[2][1]=1;
      counter++;
  }
    if (!nxt) assign(sig);
    return 100111;
  }
  int leftS(boolean clear) {
    type="leftS";
    sig = 111011;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=1;
      offs[0][1]=0;
      offs[1][0]=0;
      offs[1][1]=1;
      offs[2][0]=-1;
      offs[2][1]=1;
      counter++;
    }
    if (!nxt) assign(sig);
    return 101011;
  }
  int rightS(boolean clear) {
    type="rigthS";
    sig = 111101;
    if (clear) sig = 100001;
    if (counter==0) {
      offs[0][0]=-1;
      offs[0][1]=0;
      offs[1][0]=0;
      offs[1][1]=1;
      offs[2][0]=1;
      offs[2][1]=1;
      counter++;
    }
    assign(sig);
    return 101101;
  }
  void rotatePiece() {
    boolean check=true;
    for (int i=0;i<offs.length;i++) {
      int testX=-offs[i][1];
      int testY=offs[i][0];
      if (x+testX > 9 || x+testX <0 || y+testY > 19 || y+testY <0) break;
      
      if (board[x+testX][y+testY]!=100001) check=false;
    }
    if (type!="sqr" && check) {
      for (int i=0;i<offs.length;i++) {
        int temp = offs[i][0];
        offs[i][0]=-offs[i][1];
        offs[i][1]=temp;
      }
    }
    for (int i=0;i<offs.length;i++) {
      if (x+offs[i][0]<0) x++;
      if (x+offs[i][0]>9) x--;
      if (y+offs[i][1]<0) y++;
      if (y+offs[i][1]>19) y--;
    }
  }
  void assign(int sig) {
    
    board[x][y]=sig;
    for (int i=0;i<offs.length;i++) {
      board[x+offs[i][0]][y+offs[i][1]]=sig;
    }
  }
  void make(boolean clear) {
    if (choice==0) lastSig=lng(clear);
    else if (choice==1) lastSig=hat(clear);
    else if (choice==2) lastSig=leftL(clear);
    else if (choice==3) lastSig=rightL(clear);
    else if (choice==4) lastSig=sqr(clear);
    else if (choice==5) lastSig=leftS(clear);
    else if (choice==6) lastSig=rightS(clear);
    else println("Piece selection error");
  }
}
void drawBoard() {
  background(0);
  fill(255);
  textSize(20);
  text("Score: ",350,50);
  text(score,350,75);
  text("Next piece:",320,180);
  noFill();
  stroke(255);
  for (int x=0;x<300/unitSize;x++) {
    for (int y=0;y<600/unitSize;y++) {
      
      fill(int(str(str(board[x][y]).charAt(2)))*255,int(str(str(board[x][y]).charAt(3)))*255,int(str(str(board[x][y]).charAt(4)))*255);
      rect(x*unitSize,y*unitSize,unitSize,unitSize);
    }
  }
  for (int x=0;x<4;x++) {
    for (int y=0;y<4;y++) {
      fill(int(str(str(display[x][y]).charAt(2)))*255,int(str(str(display[x][y]).charAt(3)))*255,int(str(str(display[x][y]).charAt(4)))*255);
      rect(x*unitSize+315,y*unitSize+200,unitSize,unitSize);
    }
  }
}
void moveDown() {
  control.moveCount++;
  if (bottomPieceCheck(0,1)) {
    check2=false;
    finish();
  }
  if (!bottomPieceCheck(0,1)) {
    control.make(true);
    control.y++;
  }
}
void finish() {
  for (int x=0;x<4;x++) {
    for (int y=0;y<4;y++) {
      display[x][y]=100001; //It's initilized and rendered in the same way as the main board, so I don't have to rewrite anything
    }
  }
  if (control.moveCount==1) gameOver=true;
  for (int x=0;x<10;x++) {
    for (int y=0;y<20;y++) {
       if(str(board[x][y]).charAt(1)=='1') {
         board[x][y]=control.lastSig;
       }
    }
  }
  control=new obj(nextPiece,false);
  nextPiece=int(random(-1,7));
  next=new obj(nextPiece,true);
  next.make(false);
  control.make(false);
  displayInit();
}
boolean bottomPieceCheck(int x, int y) {
  for (int i=0;i<control.offs.length;i++) {
    if (control.y+control.offs[i][1]>=19 && y==1) return true; //Multipurpose edge detection
    if (control.x+control.offs[i][0]==0 && x==-1) return true;
    if (control.x+control.offs[i][0]==9 && x==1) return true;
    if (board[control.x+control.offs[i][0]+x][control.y+control.offs[i][1]+y]!=100001 && str(board[control.x+control.offs[i][0]+x][control.y+control.offs[i][1]+y]).charAt(1)!='1') return true;
  }
  return false;
}
void lineClear() {
  boolean row=false;
  for (int y=0;y<20;y++) {
    row=true;
    for (int x=0;x<10;x++) {
      if(board[x][y]==100001) {
        row=false;
        break;
      }
    }
    if (row) {
      score+=100;
      if (delay>100) delay-=100;
      for (int x=0;x<10;x++) {
        board[x][y]=100001;
        for (int y2=y;y2>0;y2--) {
          board[x][y2]=board[x][y2-1];
        }
      }
      lineClear();
    }
  }
}
void displayInit() {
  for (int i=0;i<next.offs.length;i++) {
    display[1+next.offs[i][0]][1+next.offs[i][1]]=next.sig;
  }
}
