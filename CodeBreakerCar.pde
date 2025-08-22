// CodeBreaker Car

import java.util.ArrayList;


PImage playerCar, backgroundImage, enemyCar;
PImage gameOverBg, restartButton;
PImage bulletImg, checkpointImg, bossImage, bossBulletImg;
Checkpoint checkpoint;
Enemy bossTruck;

int enemiesKilled = 0, puzzleStage = 0;
float bgY = 0, backgroundSpeed = 3;
boolean gameOver = false, bossKilled = false, bossReleased = false, gameWon = false;

Player player;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
ArrayList<Bullet> bossBullets;

/**
 * setup
 * pre: Assets (images) must exist in the sketch folder.
 * post: Initializes game variables, loads images, sets up the player, enemies, and game state.
 */
void setup(){
  fullScreen(P2D); 
  frameRate(60);
 
  gameOverBg = loadAndResize("game_over.jpg", width, height);
  restartButton = loadAndResize("restart.png", 150, 150);
  backgroundImage = loadAndResize("track_bg.png", width, height);
  enemyCar = loadAndResize("enemy_car.png", 80, 80);
  playerCar = loadAndResize("player_car.png", 80, 80);
  bulletImg = loadAndResize("bullet.png", 20, 40);
  checkpointImg = loadAndResize("checkpoint.png", 50, 50);
  bossImage = loadAndResize("truck_car.png", 150, 150);
  bossBulletImg = loadAndResize("bossBullet.png", 30, 50);
  
  checkpoint = new Checkpoint(width/2-25, 50, checkpointImg);
  player = new Player(100,300,playerCar);
  
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  bossBullets = new ArrayList <Bullet>();
  
  releaseEnemies(3);
  backgroundSpeed = (width > 1000) ? 1 : 3;
}

/**
 * draw
 * pre: Called automatically by Processing.
 * post: Renders the game frame by frame depending on game state (active, puzzle, over, won).
 */
void draw(){
  if (!gameOver && !gameWon){
    drawBackground();
    player.move();
    player.display();
    
    handleEnemies();
    handleBoss();
    handleBullets();
    handleBossBullets();
    spawnEnemies();
    
    if (bossKilled && enemies.size()==0){
      checkpoint.display();
      if (player.collidesWith(checkpoint)){
        gameWon = true;
      } 
    }
  }else if (gameOver) displayGameOver();
  else if(gameWon) showGameWon();
}

/**
 * drawBackground
 * pre: backgroundImage must be loaded.
 * post: Scrolls and displays the background.
 */
void drawBackground(){
  background(0);
  bgY += backgroundSpeed;
  if (bgY >= height) bgY = 0;
  image(backgroundImage, 0, bgY);
  image(backgroundImage, 0, bgY-height);
}

/**
 * handleEnemies
 * pre: enemies must be initialized.
 * post: Moves and displays enemies; ends game on player collision.
 */
void handleEnemies(){
  for (int i = enemies.size()-1; i>=0; i--){
    Enemy e = enemies.get(i);
    e.move();
    e.display();
    if (player.collidesWith(e)){
      gameOver = true;
    } 
  }
}

/**
 * handleBoss
 * pre: Enemies must be initialized; player must exist.
 * post: Spawns boss when conditions are met; handles boss movement and shooting.
 */
void handleBoss(){
  if (!bossReleased && enemiesKilled >= 50){
    bossTruck = new Enemy(random(width*0.3,width*0.7), 1, bossImage);
    bossTruck.speed = 0;
    bossTruck.w = 100;
    bossTruck.h = 100;
    bossTruck.hp = 20;
    enemies.clear();
    enemies.add(bossTruck);
    bossReleased = true;
    backgroundSpeed = 0;
  }
  
  if (bossReleased && !bossKilled && bossTruck != null){
    bossTruck.y = 50;
    bossTruck.x += (player.x < bossTruck.x ? -1.5 : 1.5);
    if (frameCount%60 == 0){
      Bullet bossShot = new Bullet(bossTruck.x+bossTruck.w/2-10-bossBulletImg.width/2, bossTruck.y+bossTruck.h, bossBulletImg, true);
      bossShot.speed = 3;
      bossBullets.add(bossShot);
    }
  }
}

/**
 * handleBullets
 * pre: bullets and enemies must be initialized.
 * post: Moves bullets, checks for collisions with enemies or boss, updates state.
 */
void handleBullets(){
  for(int i = bullets.size()-1; i >= 0; i--){
    Bullet b = bullets.get(i);
    b.move();
    b.display();
    boolean hit = false;
    for (int j = enemies.size()-1; j>=0; j--){
      Enemy target = enemies.get(j);
      if (b.collidesWith(target)){
        if (target == bossTruck){
          bossTruck.hp--;
          if(bossTruck.hp <= 0){
            enemies.remove(j);
            bossKilled = true;
          }
        }else enemies.remove(j);
        bullets.remove(i);
        enemiesKilled++;
        hit = true;
        break;
      }
    }
    if (b.isOffScreen() && !hit) bullets.remove(i);
  }
}

/**
 * handleBossBullets
 * pre: bossBullets must be initialized.
 * post: Moves and displays boss bullets; ends game on collision with player.
 */
void handleBossBullets(){
  for (int i = bossBullets.size()-1; i >= 0; i--){
    Bullet b = bossBullets.get(i);
    b.move();
    b.display();
    if (b.collidesWith(player)){
      gameOver = true;
    } 
    if (b.isOffScreen()) bossBullets.remove(i);
  }
}

/**
 * spawnEnemies
 * pre: enemyCar image must be loaded.
 * post: Spawns new enemies and increases difficulty over time.
 */
void spawnEnemies(){
  if (frameCount%120==0 && !bossKilled && !bossReleased){
    for (int i = 0; i < 3; i++){
      Enemy newEnemy = new Enemy(random(width*0.25,width*0.75), random(-600, 0), enemyCar);
      boolean overlapping = false;
      for (Enemy e: enemies){
        if (newEnemy.collidesWith(e)){
          overlapping = true;
          break;
        }
      }
      if (bossTruck != null && newEnemy.collidesWith(bossTruck)) overlapping = true;
      if (!overlapping) enemies.add(newEnemy);
    }
  }
  
  if (frameCount%180==0){
    backgroundSpeed += 1;
    for (Enemy e: enemies){
      e.speed+=0.2;
    }
  }
}

/**
 * releaseEnemies
 * pre: enemyCar image must be loaded.
 * post: Clears and reinitializes enemy list with n non-overlapping enemies.
 */
void releaseEnemies(int n){
  enemies.clear();
  int attempts = 0;
  while(enemies.size()<n && attempts < 1000){
    float x = random(width*0.25,width*0.75);
    float y = random(-600, 0);
    Enemy newEnemy = new Enemy(x, y, enemyCar);
    boolean overlapping = false;
    for (Enemy existing : enemies){
      if (newEnemy.collidesWith(existing)){
        overlapping = true;
        break;
      }
    }
    if (!overlapping){
      enemies.add(newEnemy);
    }
    attempts++;
  }
}

/**
 * keyPressed
 * pre: Called by Processing when key is pressed.
 * post: Fires bullet or modifies userInput for puzzles.
 */
void keyPressed(){
  if(!gameOver && key == ' '){
    Bullet b = new Bullet(player.x+player.w/2-10, player.y-20, bulletImg);
    b.speed = -3;
    bullets.add(b);
  }
}

/**
 * mousePressed
 * pre: Called when mouse is clicked.
 * post: Restarts game if click is on restart button after game over.
 */
void mousePressed(){
  if(gameOver){
    float btnX = width/2-75;
    float btnY = height/2+20;
    float btnW = 150;
    float btnH = 150;
    if (mouseX >= btnX && mouseX <= btnX+btnW &&
        mouseY >= btnY && mouseY <= btnY + btnH){
          restartGame();
    }
  }
}

/**
 * restartGame
 * pre: None
 * post: Resets all game state variables to start a new game.
 */
void restartGame(){
  gameOver = false;
  gameWon = false;
  bossKilled = false; 
  bossReleased = false;
  enemiesKilled = 0;
  player.resetPosition();
  releaseEnemies(3);
  bullets.clear();
  bossBullets.clear();
  enemies.clear();
  backgroundSpeed = (width > 1000) ? 1 : 3;
  bgY = 0;
}

/**
 * displayGameOver
 * pre: gameOver must be true.
 * post: Displays game over screen and restart button.
 */
void displayGameOver(){
  image(gameOverBg, 0, 0);
  textAlign(CENTER,CENTER);
  textSize(70);
  fill(random(255), random(255), random(255));
  text("GAME OVER", width/2, height/2-100);
  image(restartButton, width/2-75, height/2);
}

/**
 * showGameWon
 * pre: gameWon must be true.
 * post: Displays winning message and writes results to file.
 */
void showGameWon(){
  background(0, 150, 0);
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("CONGRATULATIONS!", width/2, height/2-50);
  textSize(24);
  text("You killed 50 enemies, YOHOO!)", width/2, height/2);
}

/**
 * loadAndResize
 * pre: filename must exist.
 * post: Loads and resizes image to w x h.
 */
PImage loadAndResize(String filename, int w, int h){
  PImage img = loadImage(filename);
  img.resize(w, h);
  return img;
}
