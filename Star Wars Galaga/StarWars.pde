// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

//// Audio Variables ////
import ddf.minim.*;
private Minim m;
private AudioSample pLaser;    // player laser shot sound clip
private AudioSample tLaser;    // enemy laser shot sound clip
private AudioSample explosion; // AI_Ship explosion sound clip
private AudioSample impact;    // Impact sound clip
private AudioPlayer menuTheme; // main menu song 
private AudioPlayer gameTheme; // game song
private AudioPlayer shipTheme; // ship menu song
private AudioPlayer instructTheme;  // instruction page song
private AudioPlayer defeatTheme;    // player loses song
private AudioPlayer victoryTheme;   // player wins song
//// Class Variables ////
private Laser_Array lA;   // laser array class variable
private Menu menu;        // main menu class variable
private Ship_Menu sMenu;  // ship menu class variable
private End_Menu endmenu; // end of game class variable
private Player_Ship p1Ship;    // player ship  class variable
private Instruction_Menu instruct;   // instruction page class variable
private Background arr[] = new Background[120];   // game background class
//// Boolean Variables ////
private boolean game;      // switch that broadcasts that a game is in process
private boolean pause;     // switch to turn on/off pause option
private boolean gameOver;  // switch that broadcasts that a game is over
private boolean shipMenu;  // switch to turn on/off player ship menu 
private boolean showMenu;  // switch to turn on/off main menu
private boolean instructMenu;  // switch to turn on/off the instructions page
//// Operational Variables ////
private int level;    // the current level in game
private PFont font;   // the word font  throughout the game
private ArrayList <AI_Ship> ai = new ArrayList<AI_Ship>(2);    // array of enemy ships
private ArrayList <Asteroid> a1 = new ArrayList<Asteroid>(2);  // array of asteroids

// Star Wars game setup
void setup() {
  //// Load Audio Files ////
  m = new Minim(this);
  tLaser = m.loadSample("TIE-Fire.wav");    // enemy laser sound
  pLaser = m.loadSample("XWing_shot.wav");  // player laser sound
  explosion = m.loadSample("Star Wars Tie Fighter explosion.wav");  // AI_Ship explosion sound
  impact = m.loadSample("Impact.wav");                              // Ship Im
  gameTheme = m.loadFile("Star Wars Battle Theme FULL.wav");  // game soundtrack
  menuTheme = m.loadFile("Star Wars -Imperial March- Vader Theme.wav");  // main menu soundtrack
  instructTheme = m.loadFile("Star Wars Soundtrack -  Mos Eisley Cantina.wav");  // instructions menu soundtrack
  defeatTheme = m.loadFile("Star_Wars_Episode_V_Soundtrack_The_Battle_of_Hoth.wav");  // player loses soundtrack
  victoryTheme = m.loadFile("Star_Wars_Episode_IV_Soundtrack_-_The_Throne_Room.wav"); // player wins soundtrack
  shipTheme = m.loadFile("Star Wars Rogue Squadron II Soundtrack - Calamari Hangar.wav");  // player ship menu soundtrack
  //// Class Instantiations ////
  menu = new Menu();
  lA = new Laser_Array();      // creates a new laser array list
  sMenu = new Ship_Menu();     // creates player ship menu
  endmenu = new End_Menu();    // creates a end page
  p1Ship = new Player_Ship();  // creates a player ship
  instruct = new Instruction_Menu();  // creates a instructions page
  //// Font Universalization ////
  font = loadFont("Silom-35.vlw");
  textFont(font);  // makes all programmed font same style
  //// Boolean Value Initial Setup ////
  game = false;      // game does not begin
  pause = false;     // game is not paused
  showMenu = true;   // main menu is shown first
  shipMenu = false;  // ship menu is hidden
  gameOver = false;  // game has not ended
  instructMenu = false;  // instructions page is hidden
  //// Operational Values Setup ////
  level = 0;       // beginning game level 
  size(1182,750);  // initial window size
  for(int i = 0; i < arr.length; ++i){  // create 120 moving stars
    arr[i] = new Background();
  }
}

// all game actions, displays, and updates
void draw() {
  // if the main menu is displayed
  if(showMenu==true) {
    menu.display();   // display main menu
    menuTheme.play(); // play main menu soundtrack
  }
  // if player starts to play game
  else if(shipMenu==true && showMenu==false) {
    menuTheme.pause();  // stop main menu soundtrack
    menuTheme.rewind(); // rewind main menu soundtrack
    sMenu.display();    // display the player ship menu
    shipTheme.play();   // play player ship menu soundtrack
  }
  // if player looks at instructions page
  else if(instructMenu==true) {
    menuTheme.pause();    // stop main menu soundtrack
    menuTheme.rewind();   // rewind main menu soundtrack
    instruct.display();   // display the instructions page
    instructTheme.play(); // play instructions page soundtrack
  }
  // if player chose a ship and begins to play game
  else if(game==true) {
     shipTheme.pause();  // stop player ship menu soundtrack
     shipTheme.rewind(); // rewind player ship menu soundtrack
     frame.setSize(700,750);  // shrink window frame to playing size
     // make constant moving star background
     background(0);
     for(int i = 0; i < arr.length; ++i) {    // draw stars/ background
        arr[i].drawStar();
     }
     // while the game is not paused
     if(pause == false)  {
          gameTheme.play();  // play game soundtrack
          // fire, display and move all AI_Ships
          for(int i = 0; i < ai.size(); ++i){    
            AI_Ship aaii = ai.get(i);
            aaii.fire(lA);
            aaii.display();
            aaii.move(p1Ship);
          }
          // display and move all Asteroids
          for(int i = 0; i < a1.size(); ++i){    
            Asteroid aa = a1.get(i);
            aa.display();
            aa.move(p1Ship);
          }
          // update all laser locations and effects
          lA.update();         
          // calculate AI_Ship collisions for all lasers          
          for(int i = 0; i < ai.size(); ++i){    
            AI_Ship aaii = ai.get(i);
            lA.collisionAI(aaii);
          }
          // iterates through AI ship array
          for(int i = 0; i < ai.size(); ++i){    
            AI_Ship aaii = ai.get(i);
            // if an AI still has health, no victory yet
            if(aaii.health > 0){                 
              // victory is still false
            }
          }
          // calculate Asteroid collisions for all lasers
          for(int i = 0; i < a1.size(); ++i){    
            lA.collisionAS(a1.get(i));
          }
          // calculate player ship collisions for all lasers
          lA.collisionP(p1Ship);                
          boolean victory = true;  // denotes if the player has succeded
          p1Ship.display();
          // iterates through AI ship array  
          for(int i = 0; i < ai.size(); ++i){    
            if(ai.get(i).health > 0) {            
              victory = false; // if an AI still has health, no victory yet
            }
          }
          // if player has no health --> defeat menu
          if(p1Ship.shields <= 0){  
            endmenu.gameOutcome(0);
            gameOver = true;
            game = false;
          }
          // if player has defeated all AI --> increase level
          else if(victory==true){                      
             ++level;
             // add 2 new asteroids for every level
             for(int i = 0; i < 2; ++i){               
                a1.add(new Asteroid(impact));
              }
             // each level has two time the level of AI_Ships
             for(int i = 0; i < level*2; ++i){         
                ai.add(new AI_Ship(tLaser, impact));
             }
              lA.clear();    // delete all lasers
              victory=false; // no victory
          }
          // if player has beaten level 3 --> victory menu
          else if(level>3) {          
             endmenu.gameOutcome(1);
             gameOver = true;
             game = false;
          }
          fill(255,200);
          textSize(20);
          text("Level",10,20);  // print out the current level of game
          text(str(level),75,20);
          p1Ship.pauseStatus(0); 
     }
     // if game is paused
     else {
          gameTheme.pause();  // pause game soundtrack
          // display all AI_Ships
          for(int i = 0; i < ai.size(); ++i){  
            ai.get(i).display();
          }
          // display all Asteroids
          for(int i = 0; i < a1.size(); ++i){  
            a1.get(i).display();
          }
          p1Ship.display();  // display player ship                  
          fill(255,200);
          textSize(20);
          text("Level",10,20);  // display current game level
          text(str(level),75,20);
          fill(255);
          textSize(50);
          text("PAUSED",265, height/2);  // display pause in center of screen
          p1Ship.pauseStatus(1);
     }
  } // end of game play
  // if the game is over
  else if(gameOver==true && game==false) {
       gameTheme.pause();  // pause game soundtrack
       gameTheme.rewind(); // rewind game soundtrack
       sMenu.reset();      // reset player ship menu values
       p1Ship.reset();     // reset player ship values
       // reset all asteroids
       for(int i = 0; i < a1.size(); ++i){  
          a1.get(i).resetAsteroid();
       }
        // reset all AI_Ships
       for(int i = 0; i < ai.size(); ++i){  
          ai.get(i).resetShip();
       }
       lA.clear();         // clear lasers
       level=1;            // reverts level back to 1 for new game
       endmenu.display();  // display the end of game page 
       if(endmenu.isDefeat()==true) {
         defeatTheme.play(); // play player lost soundtrack
       }
       else {
         victoryTheme.play(); // play player won soundtrack
      }
  }
} // end of draw method

// game key press actions
void keyPressed() {
  if(pause == false) {
    if(keyCode == LEFT) {   // moves ship to the left when game is in process
     p1Ship.move(-12);
    }
    if(keyCode == RIGHT) {  // moves ship to the right when game is in process
     p1Ship.move(12);
    } 
  }
  if(key=='p' && game==true) {  // pause/unpause the game
    if(pause==false) {
      pause = true;
    }
    else {
      pause = false;
    }
  }
}

// game key released actions
void keyReleased() {
  if(key == ' ' && game==true && pause==false && p1Ship.laserTemp()<=15) {
    p1Ship.fire(lA);        // fires shot from player's ship
    pLaser.trigger();   
    p1Ship.tempIncrease();  // increases gun temperature 
  }
}

// all mouse pressed actions
void mousePressed() {
  //// MAIN MENU MOUSE ACTIONS ////
  // if mouse is over game instructions page button
  if(mouseX>=850 && mouseX<=1120 && mouseY>=300 && mouseY<=375 && showMenu==true) {
    // change display to instruction menu
    instructMenu = true;  
    showMenu = false;
  }
  // if mouse is over start game button
  if(mouseX>=850 && mouseX<=1120 && mouseY>=425 && mouseY<=500 && showMenu==true) {
    // change display to player ship menu
    showMenu = false;
    shipMenu = true; 
    sMenu.changedMenu();  // start ship menu timer
  }
  // if mouse is over exit button
  if(mouseX>=850 && mouseX<=1120 && mouseY>=550 && mouseY<=625 && showMenu==true) {
    // exit game
    exit();
  }
  //// INSTRUCTIONS MENU MOUSE ACTIONS ////
  // if mouse is over return to main menu button
  if(mouseX>=1025 && mouseX<=1165 && mouseY>=702 && mouseY<=724 && instructMenu==true) {
    // change display to main menu
    instructMenu=false;
    instructTheme.pause();
    instructTheme.rewind();
    showMenu=true;
  }
  //// SHIP MENU MOUSE ACTIONS ////
  // if mouse is over X-Wing area
  if(mouseX>=15 && mouseX<=700 && mouseY>=10 && mouseY<=250 && shipMenu==true && showMenu==false && sMenu.ifShipChosen()==false && sMenu.timerDone()==true) {
    // set player ship to X-wing
    p1Ship.changeShip(1);
    sMenu.shipChosen(); 
  }
  // if mouse is over Millenium Falcon area
  if(mouseX>=520 && mouseX<=1000 && mouseY>=250 && mouseY<=500 && shipMenu==true && showMenu==false && sMenu.ifShipChosen()==false && sMenu.timerDone()==true) {
    // set player ship to Millenium Falcon
    p1Ship.changeShip(2);
    sMenu.shipChosen();
  }
  // if mouse is over Y-Wing area
  if(mouseX>=105 && mouseX<=730 && mouseY>=500 && mouseY<=680 && shipMenu==true && showMenu==false && sMenu.ifShipChosen()==false && sMenu.timerDone()==true) {
    // set player ship to Y-Wing
    p1Ship.changeShip(3);
    sMenu.shipChosen();
  }
  // if mouse is over return to main menu button area
  if(mouseX>=5 && mouseX<=130 && mouseY>=690 && mouseY<=710 && shipMenu==true) {
    // change display to main menu
    shipMenu=false;
    showMenu=true;
    shipTheme.pause();
    shipTheme.rewind();
    p1Ship.changeShip(0);
    sMenu.reset();
  }
  // if mouse is over change ship button area
  if(mouseX>=945 && mouseX<=1065 && mouseY>=520 && mouseY<=545 && shipMenu==true && sMenu.ifShipChosen()==true) {
    // deselect current player ship 
    p1Ship.changeShip(0);
    sMenu.reset();
  }
  // if mouse is over start game button area
  if(mouseX>=890 && mouseX<=1100 && mouseY>=600 && mouseY<=675  && shipMenu==true && sMenu.ifShipChosen()==true) {
    // change display to game and start game
    game = true;  
    shipMenu=false;  
  }
  //// GAME MOUSE ACTIONS ////
  // if mouse is over return to main menu button area
  if(mouseX>=9 && mouseX<=60 && mouseY>=698 && mouseY<=719 && game==true) {
    // reset the game to initial values and change display to main menu
    game = false;
    showMenu = true;
    gameTheme.pause();
    gameTheme.rewind();
    sMenu.reset();
    p1Ship.reset();
    level=0;
    gameTheme.pause();
    gameTheme.rewind();
    sMenu.reset();
    p1Ship.reset();
    level = 0;       // reset level count 
    for (int i = ai.size() - 1; i >= 0; i--) {  // remove all AI_Ships for game reset
      ai.remove(i);
    }
    for (int i = a1.size() - 1; i >= 0; i--) {  // remove all Asteroids for game reset
      a1.remove(i);
    }
    lA.clear();
    frame.setSize(1182,750); 
  }
  //// DEFEAT MENU MOUSE ACTIONS ////
  // if mouse is over return to main menu button area
  if(mouseX>=10 && mouseX<=130 && mouseY>=708 && mouseY<=735 && endmenu.isDefeat()==true) {
    // reset game to initial values and change display to main menu
    gameOver=false;
    showMenu=true;
    defeatTheme.pause();
    defeatTheme.rewind();
    menuTheme.play();
    sMenu.reset();
    p1Ship.reset();
    frame.setSize(1182,750); 
    level = 0;      // reset level count 
    for (int i = ai.size() - 1; i >= 0; i--) {    // remove all AI_Ships for game reset
      ai.remove(i);
    }
    for (int i = a1.size() - 1; i >= 0; i--) {    // remove all Asteroids for game reset
      a1.remove(i);
    }
  }
  //// VICTORY MENU MOUSE ACTIONS ////
  // if mouse is over return to main menu button area
  if(mouseX>=575 && mouseX<=700 && mouseY>=708 && mouseY<=735 && endmenu.isDefeat()==false) {
    // reset game to initial values and change display to main menu
    gameOver=false;
    showMenu=true;
    victoryTheme.pause();
    //victoryTheme.rewind();
    menuTheme.play();
    sMenu.reset();
    p1Ship.reset();
    frame.setSize(1182,750);
    level = 0;      // reset level count 
    for (int i = ai.size() - 1; i >= 0; i--) {    // remove all AI_Ships for game reset
      ai.remove(i);
    }
    for (int i = a1.size() - 1; i >= 0; i--) {    // remove all Asteroids for game reset
      a1.remove(i);
    }
  } // end of mousePressed method
  
}; // end of Star Wars class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

private class AI_Ship { 
  
  private float xx;      // laser distance horizontally from center of ship
  private float yy;      // laser distance vertically
  private float x;       // x position
  private float y;       // y position
  private PImage p;      // image of ship
  private float a, h, k;     // parabolic constants
  private float timer = 0;   // timer for automated firing
  private AudioSample shot;  // sound of shots
  private AudioSample impact; // sound of impacts
  private int fireRate;      // how fast the ship fires
  private int health;        // health
  private boolean live;      // used for collisons
  
  AI_Ship(AudioSample aa, AudioSample bb){
    this.resetShip();
    shot = aa;
    impact = bb;
  }
  
  void resetShip(){        // randomizes the ship for a new game or when ship goes off screen
    live = true;           // applicable for collisions
    a = random(0.0001, .005);    // randomizes slope of parabolic curve
    int rand = (int)random(1, 100);
    if(rand%2 == 0){             // randomizes the image of the ship
      p = loadImage("tie_fighter.png");
      xx = 10;                   // sets where lasers emits based on the image given
      yy = 25;
    }
    else if(rand%3 == 0 && rand%2 !=0){
      p = loadImage("TIE_Shuttle.png");
      xx = 13;
      yy = 35;
    }
    else{
      p = loadImage("t_intercept.png");
      xx = 7;
      yy = 10;
    }
    if(rand%2 == 0){
      h = random(800, 900);
    }
    else{
      h = random(-200, -100);
    }
    y = -200;
    k = (int)random(-75, -125);
    fireRate = (int)random(500,3000);
    x = h;                       // x position equals vertex
    timer = 0;
    health = 5; 
  }
  
  void display(){
    if(health > 0){      // displays only if ship is alive
      imageMode(CENTER);
      image(p,x, y);
    }
  }
  
  void move(Player_Ship p){
    if(h <= 350){  // if vertex is on left of screen, move positively
      ++x;
    }
    else if(h >=351){  // if vertex is on right of screen, move negatively
      --x;
    }
    if(y > 850 && health > 0){       // if ship is lower than the window, reset
      this.resetShip();
    }
    y=a*((x-h)*(x-h))+k;  // set y value
    if(live){             // if the ship can collide
      if(p.shipMode() == 1){  // xwing, if ship is in range of the player ship
          if(abs(this.y - p.y) < (p.xwing.height/2+this.p.height/2) && (this.x <= (p.x+p.xwing.height/2) && this.x >= (p.x-p.xwing.height/2))){
            p.shield();       // decrease player health
            impact.trigger();
            live = false;     // collision of the AI are no longer applicable
          }
      }
      else if(p.shipMode() == 2){  // falcon, if ship is in range of the player ship
        if(abs(this.y - p.y) < p.falcon.height/2 && (this.x <= (p.x+p.falcon.height/2) && this.x >= (p.x-p.falcon.height/2))){
          p.shield();
          impact.trigger();
          live = false;
        }
      }
      else{                      // ywing, if ship is in range of the player ship
        if(abs(this.y - p.y) < p.ywing.height/2 && (this.x <= (p.x+p.ywing.height/2) && this.x >= (p.x-p.ywing.height/2))){
          p.shield();
          impact.trigger();
          live = false;
        }
      }
    }
  }
  
  void fire(Laser_Array l) {  // fires lasers automatically
    // AI must be in frame and alive to be able to fire 
    if(health > 0 && x > 0 && x < 700 && y > 0 && y < 750){
      if(millis() - timer > fireRate) {
        shot.trigger();
        Laser left = new Laser(x+xx, y+yy, false,0, explosion);
        Laser right = new Laser(x-xx, y+yy, false,0, explosion);
        l.addL(left);
        l.addL(right);
        timer = millis();  // reset timer
        fireRate = (int)random(1000,7000);  // reset fire time
      }
    }
  }
  
};

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

private class Asteroid{
  
  private float x;          // x position
  private float y;          // y position
  private PImage p;         // image of the asteroid
  private float a, h, k;    // parabolic constants
  private float rot, tot;   // rotational speed, total rotation
  private boolean live;     // used for collisions
  private AudioSample impact;
  
  Asteroid(AudioSample aa){
    impact = aa;
    this.resetAsteroid();
    live = true;                   // applicable for collisions`
    y = -200;                      // set y value to above screen
    a = random(0.0001, .005);      // set parabolic slop
    k = 0-(100*a);                 // sets y vertex for parabolic curve
    int rand = (int)random(1, 100);
    if(rand%2==0){
      h = random(-200, -100);      // sets x vertex for parabolic curve
    }
    else{
      h = random(800, 900);        // sets x vertex for parabolic curve
    }
    x = h;                        // sets x equal to x vertex
    rot = random(0.003, 0.01);    // sets rotational speed
    tot = 0;                      // initial rotational value equals 0
  }
  
  void resetAsteroid(){
    y = k;                        // sets y equals y vertex
    if(h >= -200 && h <= -100){   // swaps x vertex
      h = random(800, 900);
    }
    else{
      h = random(-200, -100);     // swaps x vertex
    }
    a = random(0.0001, .005);     // randomizes parabolic slope
    x = h;                        // x equals x vertex
    int rand = (int)random(1, 100);  // randomizes image
    if(rand%2 == 0){
      p = loadImage("Asteroid1.png");
    }
    else{
      p = loadImage("Asteroid2.png");
    }
    rot = random(0.003, 0.01);      // randomizes rotational speed
    live = true;                    // applicable for collisions
  }
  
  void display(){
    imageMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(tot);           // rotate the image
    image(p,0, 0);
    popMatrix();
    if(h >= 800){
      tot -= rot;
    }
    else{
      tot+=rot;           // rotate the image
    }
  }
  
  void move(Player_Ship p){
    if(h <= -50){    // if vertex is on the left, move positively
      ++x;
    }
    else{    // else move negatively
      --x;
    }
    y=a*((x-h)*(x-h))+k;    // calculates y value
    if(y > 850){            // if past the bottom of the frame
      this.resetAsteroid();  // reset the asteroid
    }
    if(live){      // if it is applicable for collisions
      if(p.shipMode() == 1){ // xwing, if asteroid is in range of ship
          if(abs(this.y - p.y) < (p.xwing.height/2+this.p.height/2) && (this.x <= (p.x+p.xwing.height/2) && this.x >= (p.x-p.xwing.height/2))){
            p.shield();    // decrease player ship's health
            impact.trigger();
            live = false;  // no longer applicable for collisions
          }
      }
      else if(p.shipMode() == 2){ // falcon, if asteroid is in range of ship
        if(abs(this.y - p.y) < p.falcon.height/2 && (this.x <= (p.x+p.falcon.height/2) && this.x >= (p.x-p.falcon.height/2))){
          p.shield();
          impact.trigger();
          live = false;
        }
      }
      else{ // ywing, if asteroid is in range of ship
        if(abs(this.y - p.y) < p.ywing.height/2 && (this.x <= (p.x+p.ywing.height/2) && this.x >= (p.x-p.ywing.height/2))){
          p.shield();
          impact.trigger();
          live = false;
        }
      }
    }
  }
  
};

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

class Background {
  
  private float x;
  private float y;
  private float s;
  private float vel;
  private int b;
  
  Background(){
    x = (int)random(0, width);        // randomizes x position
    y = (int)random(10, height-10);   // randomizes y position
    s = random(.1, 2);    // size of star
    vel = s;              // speed is proportional to size
  }
  
  void drawStar(){
    noStroke();
    if(y >= height+15){            // if below frame
      y = (int)random(-20, -10);   // randomizes new starting height
    }
    y+=vel;                        // increases y position
    fill(#ffffff);
    ellipse(x, y, s, s);           // ellipse is a star
  }
  
};

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

public class End_Menu {
  
  private boolean defeat;
  private PImage defeatbackground,victorybackground;
  
   End_Menu() {
     defeatbackground = loadImage("defeatbackground.png");
     victorybackground = loadImage("victorybackground.png");
   }

   // displays all End Menu actions
   void display() {
     imageMode(CORNER);
     textSize(100);
     // if player lost the game
     if(defeat==true) {
         image(defeatbackground,0,0); // displays the defeat background
         fill(#C11717);
         text("DEFEAT",175,300); // actual defeat text and location
         // if the mouse is over the return to main menu button area
         if(mouseX>=10 && mouseX<=130 && mouseY>=708 && mouseY<=735) {
           // increase the text size
           textSize(16.5);
         }
         else {
           // otherwise keep text at its normal size
           textSize(15);
         }
         text("< Main Menu",15,715);  // actual return to main menu button text and location
     }
     // if player won the game
     else if(defeat==false) {
         image(victorybackground,0,0); // displays the victory background
         fill(0,250,0);
         text("VICTORY",140,400); // actual victory text and location
         // if the mouse is over the return to main menu button area
         if(mouseX>=575 && mouseX<=700 && mouseY>=708 && mouseY<=735) {
           // increase the text size
           textSize(16.5);
         }
         else {
           // otherwise keep text at its normal size
           textSize(15);
         }
         text("Main Menu >",580,715); // actual return to main menu text and location
     }
   }
   
   // returns if the player is defeated or not
   boolean isDefeat() {
     return defeat;
   }
   
   // changes the the game outcome to either a win or lose status
   void gameOutcome(int game) {
     if(game==1) {
       defeat = false;
     }
     else {
       defeat = true;
     }
   }
 
}; // end of End Menu class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

public class Instruction_Menu {
  
  private PImage instructions; // istruction page background
  // intructions wording
  private String mission = "Defend the Rebel base\non Yavin IV against\nthe Empire by\ndestroying all enemy\nfighters.\n\n- Avoid enemy fire\n\n- Avoid enemy ships\n\n- Avoid asteroids\n\n- Try not to overheat\n   your laser cannons";
  // controls wording
  private String controls = "\n- Move left:\n        LEFT arrow key\n\n- Move right:\n        RIGHT arrow key\n\n- Fire:\n        SPACEBAR\n\n- Pause:\n        press P\n   ";
  
  Instruction_Menu() {
    instructions = loadImage("instructionsPage.png");
  }
  
  // displays all instruction menu information
  void display() {
    image(instructions,0,0);
    fill(#FCA31C);
    textSize(54);
    text("Flight School",415,55); // instruction page title
    noStroke();
    fill(0,165);
    rect(112,113,230,50,5);  // instructions title background
    rect(840,113,230,50,5);  // controls title background
    rect(75,180,300,425,10);  // instructions body background
    rect(807,180,300,425,10);  // controls body background
    fill(#FCA31C);
    textSize(35);
    text("Mission",150,150); // instructions title and location
    text("Controls",875,150); // controls title and location
    textSize(22);
    text(mission,93,220); // instructions body text and location
    text(controls,823,220); // controls body text and location
    // if mouse is over return to main menu button area
    if(mouseX>=1025 && mouseX<=1165 && mouseY>=702 && mouseY<=724) {
      // increase text size 
      textSize(17.5);
    }
    else {
      // otherwise keep text at its normal size
      textSize(16);
    }
    text("Main Menu >",1050,715); // actual text and location of return to main menu button
  }
  
}; // end of Instruction Menu class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

private class Laser { 
  
  private float x;             // y position of the laser
  private float y;             // x position of the laser
  private float vel;           // velocity of the laser
  private boolean good;        // denotes if velocity is positive or negative
  private int shipLaserColor;  // 1 xwing  2 falcon  3 y wing  4  tie
  private boolean update;      // does the laser need to update?
  private boolean live;        // is the laser live?
  private AudioSample ex;

  Laser(float xx, float yy, boolean g, int slc, AudioSample aa) {
    x = xx;
    y = yy;
    ex = aa;
    good = g;
    shipLaserColor = slc;
    if(good){
      vel = 5;
    }
    else{
      vel = -5;
    }
    update = true;
    live = true;
    y+=vel;
    noStroke();
    rectMode(CENTER);
    if(shipLaserColor==1){      // assigns laser color based on ship
      fill(#FF0000);
    }
    else if(shipLaserColor==2){
      fill(#FC6F2E);
    }
    else if(shipLaserColor==3){
      fill(#FC4AE5);
    }
    else {
      fill(#00FF00);
    }
    rect(x,y,3,15,5);    // creates initial laser
  }
  
  boolean collisionAI(AI_Ship ai){    // Player laser collisions with AI_Ships
    if(good && live){                 // must be laser moving up and must be a live laser
      if(abs(this.y - ai.y) < ai.p.height/2 && (this.x <= (ai.x+ai.p.height/2) && this.x >= (ai.x-ai.p.height/2))){
        // if laser is in range of the AI ship
        this.update = false;  // no longer update and draw the laser
        ai.health-=1;         // decrease the AI health by one
        this.live = false;    // laser is no longer applicable for collisions
        if(ai.health <= 0){   // if the AI has no more health
          ex.trigger();
          ai.live = false;    // the AI is no longer applicable for collisions
        }
        return true;
      }
    }
    return false;
  }
  
  void collisionAS(Asteroid a){    // Player laser collisions with AI_Ships
    if(good && live){ // laser must be coming from player and must be applicable for collisions
      if(abs(this.y - a.y) < a.p.height/2 && (this.x <= (a.x+a.p.height/2) && this.x >= (a.x-a.p.height/2))){
        // if laser is in range of asteroid
        this.update = false;  // laser stops updating
        this.live = false;    // laser is no longer applicable for collisions
      }
    }
  }
  
  void collisionP(Player_Ship a){  // AI laser collisions on Player
    if(!good && live){
      if(a.shipMode() == 1){ // xwing, if laser is in range of ship
        if(abs(this.y - a.y) < a.xwing.height/2 && (this.x <= (a.x+a.xwing.height/2) && this.x >= (a.x-a.xwing.height/2))){
          this.update = false; // laser stops updating
          this.live = false;   // laser no longer applicable for collisions
          a.shield();          // player health decreases
        }
      }
      else if(a.shipMode() == 2){ // falcon, if laser is in range of ship
        if(abs(this.y - a.y) < a.falcon.height/2 && (this.x <= (a.x+a.falcon.height/2) && this.x >= (a.x-a.falcon.height/2))){
          this.update = false;
          this.live = false;
          a.shield();
        }
      }
      else{ // ywing, if laser is in range of ship
        if(abs(this.y - a.y) < a.ywing.height/2 && (this.x <= (a.x+a.ywing.height/2) && this.x >= (a.x-a.ywing.height/2))){
          this.update = false;
          this.live = false;
          a.shield();
        }
      }
    }
  }
  
  float getVel() { // returns the value of the laser's velocity
    return vel;
  }
  
};

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

private class Laser_Array {
  
  private ArrayList<Laser> l;    // keeps track of all lasers
  
  Laser_Array() {
    l = new ArrayList<Laser>();
  }
  
  void addL(Laser ll){
    l.add(ll);          // adds laser to laser arraylist
  }
  void update() {          // iterates though the array list and calls the update fuction on each laser
    if(l.size() == 0) {    // do not do anything if no lasers
      return;
    }
    Laser laser;
    for(int i = 0; i < l.size(); ++i) { // iterate through laser arraylist
      laser = l.get(i);
      if(laser.update){       // if update is true, set laser color
        if(laser.shipLaserColor==1){
          fill(#FF0000);
        }
        else if(laser.shipLaserColor==2) {
          fill(#FC6F2E);
        }
        else if(laser.shipLaserColor==3){
          fill(#FC4AE5);
        }
        else {
          fill(#00FF00);
        }
        laser.y-=laser.getVel();          // change laser y value by laser velocity
        rect(laser.x, laser.y, 3, 15, 5);
      }
      else{
        continue;
      }
    }
  }
  
  void clear(){        // remove all elements from arraylist
    for (int i = l.size() - 1; i >= 0; i--) {
      l.remove(i);
    }
  }
  
  void collisionAI(AI_Ship ai){
    for(int i = 0; i < l.size(); ++i){    // for all lasers, calculate if there is a collision with an AI ship
      Laser y = l.get(i);
      if(y.collisionAI(ai)){
      }
    }
  }
  
  void collisionAS(Asteroid a){
    for(int i = 0; i < l.size(); ++i){    // for all lasers, calculate if there is a collision with an asteroid
      Laser y = l.get(i);
      y.collisionAS(a);
    }
  }
  
  void collisionP(Player_Ship p){  // for all lasers, calculate if there is a collision with the player ship
    for(int i = 0; i < l.size(); ++i){
      Laser y = l.get(i);
      y.collisionP(p);
    }
  }
  
};

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
public class Menu {
  
 private PImage menuPic;
 
 Menu() { 
   menuPic = loadImage("menubackground.png"); // main menu background
 }
   
 // displays all Main Menu actions 
 void display() {
   // background setup
   background(0);
   imageMode(CORNER);
   rectMode(CORNER);
   image(menuPic,0,20);
   stroke(#FCA31C);
   strokeWeight(2);
   // if mouse is in instruction button area
   if(mouseX>=850 && mouseX<=1120 && mouseY>=300 && mouseY<=375) {
       // embolden the box surrounding the instruction page button
       fill(#FCA31C);
       rect(850,300,270,75);
   }
   else {
       // otherwise make box surrounding the instruction page button hollow
       fill(0);
       rect(850,300,270,75);
   }  
   // if mouse is in play game button area
   if(mouseX>=850 && mouseX<=1120 && mouseY>=425 && mouseY<=500) {
       // embolden the box surrounding the play game button
       fill(#FCA31C);
       rect(850,425,270,75);
   }
   else {
       // otherwise make box surrounding the play game button hollow
       fill(0);
       rect(850,425,270,75);
   }
   // if mouse is in exit button area
   if(mouseX>=850 && mouseX<=1120 && mouseY>=550 && mouseY<=625) {
       // embolden the box surrounding the exit button
       fill(#FCA31C);
       rect(850,550,270,75);
   }
   else {
       // otherwise make box surrounding the exit button hollow
       fill(0);
       rect(850,550,270,75);
   }
   // inner parts of the meniu buttons are black
   fill(0);
   rect(855,305,260,65); // instructions button
   rect(855,430,260,65); // play game button
   rect(855,555,260,65); // exit button
   fill(#FCA31C);
   textSize(35);
   text("Flight School",866,350); // actual text and location  of instruction button
   text("Begin Attack",865,475); // actual text and location of play game button
   text("Exit",946,600); // actual text and location of exit button
 }
 
}; // end of Menu class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

public class Player_Ship {
  
  private PImage xwing,falcon,ywing;  // image variables
  private float x,y;  // image x and y location
  private int ship, shields, temp;
  private int savedT, passedT, timer;  // timer variables
  private boolean isPaused;
  
  // Player Ship initial setup values
  Player_Ship() {
    xwing = loadImage("X-wing.png");
    falcon = loadImage("falcon.png");
    ywing = loadImage("ywing.png");
    x = 360; // initial player ship x position
    y = 630;  // initial player ship y position
    shields=3;  // player has three lives
    temp=0;
    savedT = 0;
    passedT = 0;
    timer = 1500; // gun temperature decreases after 1.5 seconds
    isPaused = false;
  }
  
  // displays all Player Ship movements and actions
  void display() {
      passedT = millis(); // start the timer for when the player can fire lasers
      /* if the game time has increased by 1.5 seconds from when the player shot a laser
         the gun temperature decreases by one only if the gun temperature is not already zero
      */
      if((timer <= passedT-savedT) && temp>0) {
        // if the game is not paused
        if(isPaused==false) {
          temp-=1;  // the gun temp decreases
          tempIncrease();  // the timer from when the next shot is fired starts
        }
        else {
          // otherwise if paused, temp does not decrease
          temp = temp;
        }
      }
      textSize(15);
      // prints out the current gun temperature (cannot exceed 15)
      fill(0,250,0,100);
      text("temp: ",175,710);
      for(float i=0; i<temp; i++) {
        fill(0,250,0,80);
        rect(230+i*5,705,5,10);  // temperature is gauged horizontally
      }
      // prints out the number of shields player has left (dies at zero shields)
      fill(0,250,0,100);
      text("shields: ",80,710);  
      for(float i=shields; i>0; i--) {
         fill(0,250,0,80);
         rect(153,715+i*-5,10,5); // shields decrease vertically
      } 
      // if mouse is over the return to main menu button area
      if(mouseX>=9 && mouseX<=60 && mouseY>=698 && mouseY<=719) {
        // change the word color to a bright green
        fill(0,250,0,175);
      }
      else {
        // otherwise keep the word color at a dull green
        fill(0,250,0,100);
      }
      text("abort",13,710);  // actual text and location of return to main menu button
     
      noStroke();
      imageMode(CENTER); // orients the x and y to the center of the image
      // if the player chose the X-Wing
      if(shipMode()==1) {
        image(xwing,x,y); // display the X-Wing image
      }
      // if the player chose the Millenium Falcon
      else if(shipMode()==2) {
        image(falcon,x,y); // display the Millenium Falcon image
      }
      // if the player chose the Y-Wing
      else if(shipMode()==3) {
        image(ywing,x,y); // display the Y-Wing image
      }
  }  // end of display method
  
  // moves the player's ship left and right
  void move(float xx) {
    x+=xx; // increase the ship's x value by the input number
    // if the player goes past the game bounds on the close side of the screen
    if(x<-40) {
      // make the player return to the far side of the screen
      x=700;
    }
    // if the player goes past the game bounds on the far side of the screen
    if(x>740) {
      // make the player return to the near side of the screen
      x=0;
    }
  }
  
  // fires the pair of lasers that player's current ship can shoot
  void fire(Laser_Array l) {
    // the X-Wing's lasers
    if(shipMode()==1) {
      Laser left = new Laser(x+33, y-24, true,shipMode(), explosion); // rightmost laser
      Laser right = new Laser(x-33, y-24, true,shipMode(), explosion);  // leftmost laser
      l.addL(left);
      l.addL(right);
    }
    // the Millenium Falcon's lasers
    else if(shipMode()==2) {
      Laser left = new Laser(x+17, y-30, true,shipMode(), explosion);  // rightmost laser
      Laser right = new Laser(x-17, y-30, true,shipMode(), explosion); // leftmost laser
      l.addL(left);
      l.addL(right);
    }
    // the Y-Wing's lasers
    else if(shipMode()==3) {
      Laser left = new Laser(x+5, y-35, true,shipMode(), explosion); // rightmost laser
      Laser right = new Laser(x-5, y-35, true,shipMode(), explosion); // leftmost laser
      l.addL(left);
      l.addL(right);
    }
    temp+=1;  // when fired, the gun temperature increases by one
  }  
  
  // changes the ship that player uses
  void changeShip(int s) {
    /* 
       No Ship: s=0
       X-Wing: s=1
       Millenium Falcon: s=2
       Y-Wing: s=3
    */
    ship = s;
  }
  
  // shows which ship has been choosen by the player
  int shipMode() {
    return ship;
  }
  
  // shows the gun temperature value
  int laserTemp() {
    return temp;
  }
  
  // starts the timer for when a shot was fired
  void tempIncrease() {
    savedT = millis();
  }
  
  // if the game is paused, isPaused boolean is true
  void pauseStatus(int p) {
    if(p==1) {
      isPaused=true;
    }
    else {
      isPaused=false;
    }
  }
  
  // decreases player shields by one
  void shield() {
    shields-=1;
  }
  
  // resets Player Ship to initial setup values
  void reset() {
    x = 360;
    y = 630;
    shields=3;
    temp=0;
    changeShip(0);
  }
  
};  // end of Player Ship class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV
// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

public class Ship_Menu {
  
  private Player_Ship ps;
  private PImage menu,symbol;
  private boolean shipChosen,choose;
  private int x,y;  // rebel insignia x and y location
  private int savedT, passedT, timer;  // timer variables
  
  // Ship Menu initial setup values
  Ship_Menu() {
    ps = new Player_Ship();
    symbol = loadImage("rebel.png"); // rebel insignia
    menu = loadImage("shipMenuBackground.png"); // background image
    choose=false;
    shipChosen = false;
    x=250; // rebel insignia initial resting x position
    y=0;  // rebel insignia initial resting y position
    savedT=0;
    passedT=0;
    timer = 1000;  // player must wait 1 sec before choosing a ship
  }
  
  // displays all Ship Menu actions 
  void display() {
    background(menu); // sets background image
    textSize(45);
    fill(#A20F02);
    text("Choose Your Ship",730,135);  // places menu title/instructions
    passedT = millis(); // counts the time passed
     
    // if 1 second has passed, the player can choose a ship
    if(timer < passedT-savedT) {
      choose=true;
    }
    // the ability to return to the main menu option
    // if the mouse is over the main menu button
    if(mouseX>=5 && mouseX<=130 && mouseY>=690 && mouseY<=710) {
      // increase the text size
      textSize(17.5);
    }  
    else {
      // otherwise keep text at its normal size
      textSize(16);
    }    
    text("< Main Menu",15,705);  // actual text and location of main menu button

    // if the 1 sec timer has ended
    if(timerDone()==true) {
        /* if player has not selected a ship, the rebel insignia moves to where the mouse   
           is located in accordance of the ship button boundaries 
        */
        if(shipChosen==false) {
            // if the mouse is over/around the X-Wing image
            if(mouseX>=15 && mouseX<=700 && mouseY>=10 && mouseY<=250) {
              // rebel insignia location temporarily rests here:
              x=250;
              y=0;
            }
            // if the mouse is over/around the Millenium Falcon image
            else if(mouseX>=520 && mouseX<=1000 && mouseY>=250 && mouseY<=500) {
              // rebel insignia location temporarily rests here:
              x=555;
              y=200;
            }
            // if the mouse is over/around the Y-Wing image
            else if(mouseX>=15 && mouseX<=730 && mouseY>=500 && mouseY<=700) {
              // rebel insignia location temporarily rests here:
              x=260;
              y=445;
            }
        }
        /* if player has selected a ship, the rebel insignia stays on the selected ship 
           and the options to change ships or start the game appear
        */
        else if(shipChosen==true) {
            // if the player chooses the X-Wing
            if(ps.shipMode()==1) {
              // rebel insignia location stays here:
              x=250;
              y=0;
            }
            // if the player chooses the Millenium Falcon
            else if(ps.shipMode()==2) {
              // rebel insignia location stays here:
              x=555;
              y=200;
            }
            // if the plater chooses the Y-Wing
            else if(ps.shipMode()==3) {
              // rebel insignia location stays here:
              x=260;
              y=445;
            }
            // the ability to start the game is now an option
            // if the player has the mouse over the start game button area
            if(mouseX>=890 && mouseX<=1100 && mouseY>=600 && mouseY<=675) {
              // the word color is a bright red
              fill(242,25,5);
            }
            else {
              // otherwise the word color is a darker red
              fill(#A20F02);
            }
            textSize(35);
            text("    Enter \nBattlefield",900,625);  // actual text and location of the game start button
            // the abiltiy to change ships is now an option
            // if the player has the mouse over the change ship button area...
            if(mouseX>=945 && mouseX<=1065 && mouseY>=520 && mouseY<=545) {
              // increase the text size 
              textSize(17.5);
            }  
            else {
              // otherwise keep the text at its normal size
              textSize(16);
            }  
            fill(#A20F02);
            text("Change Ship",950,530);  // actual text and location of the change ship button
        } 
        // always show rebel insignia at the specified x and y location
        tint(255,20);  // makes rebel insignia transparent
        image(symbol,x,y);  // prints the actual image to the screen at x and y
        tint(255,255);  // changes all tints back to normal levels
    }
  }  //end of display method
  
  // switch that is turned on when the palyer chooses a ship
  void shipChosen() {
    shipChosen = true;
  }
  
  // deselects the player's choice of ship
  void unChoose() {
     shipChosen = false; 
  }
  
  // checks if a ship has been chosen by the player
  boolean ifShipChosen() {
    return shipChosen;
  }
  
  // allows player to choose ship after timer is done
  boolean timerDone() {
    return choose;
  }
  
  // starts the timer when Ship Menu is first shown
  void changedMenu() {
      savedT=millis();  
  }
  
  // resets Ship Menu to its initial setup values
  void reset() {  
    shipChosen = false;
    choose=false;
    x=250;
    y=0;
    savedT=0;
    passedT=0;
    timer = 1000;
  }
  
};  // end of Ship Menu class

// Madison Hicks and Alex Payne : Final Project : Star Wars - Battle Over Yavin IV

