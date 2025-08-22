/**
* Class: Enemy  
* Represents an enemy vehicle with optional tracking behavior and hit points.
* pre: Requires initial x, y position and a PImage for the enemy sprite.  
* post: Creates an Enemy object with movement behavior and random tracking capability.
*/
class Enemy extends Rectangle{
  boolean isTracking;
  int hp = 1;
  
  /**
  * Constructor: Enemy  
  * Initializes an enemy with given position and image, and assigns random tracking behavior.
  * pre: x and y are valid float coordinates; image is a loaded PImage.  
  * post: Enemy is created with a default size, speed, and tracking status.
  */
  Enemy(float x, float y, PImage image){
    super(x,y,50,50,3,image);
    isTracking = random(1)<0.5;
  }
  
  /**
  * Method: move  
  * Moves the enemy down the screen; if tracking, also adjusts x-position towards the player.
  * pre: Player object must be initialized; enemy must be within screen bounds.  
  * post: Enemy position is updated. If off-screen, enemy respawns at the top with a new random x-position.
  */
  void move(){
    if (isTracking){
      if(player.x < x){
        x-=2;
      }else if(player.x>x){
        x+=2;
      }
    }
    y+=speed;
    if (y>height){
      y = random(-600, 0);
      x = random(width*0.25, width*75);
    }
  }
}
