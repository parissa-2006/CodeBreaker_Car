/**
 * Class: Player  
 * Represents the player-controlled vehicle with movement constrained to the road.
 * pre: Requires initial position (x, y) and image for the player sprite.  
 * post: Creates a Player object with defined size and speed.
 */
class Player extends Rectangle{
  /**
   * Constructor: Player  
   * Initializes the player with position, size, speed, and image.
   * pre: x, y are valid coordinates; image is a loaded PImage.  
   * post: Player object is created ready for movement.
   */
  Player(float x, float y, PImage image){
    super(x,y,50,50,5,image);
  }
  
  /**
   * Method: move  
   * Updates player position based on keyboard input; constrains player within road boundaries.
   * pre: keyPressed and keyCode reflect current keyboard state; road boundaries are defined.  
   * post: Player position is updated or reset if out of bounds.
   */
  void move(){
    if (keyPressed){
      if (keyCode == LEFT){
        x-= speed;
      }else if(keyCode == RIGHT){
        x+= speed;
      }else if(keyCode == UP){
        y-=speed;
      }else if(keyCode == DOWN){
        y+=speed;
      }
    }
    
    float roadLeft = width*0.2;
    float roadRight = width*0.8-w*0.1;
    if (x < roadLeft || x + w > roadRight){
      resetPosition();
    }
  }
  
  /**
   * Method: resetPosition  
   * Resets the player to the center bottom of the screen.
   * pre: width and height represent screen dimensions; w is player width.  
   * post: Player’s position is reset to start position.
   */
  void resetPosition(){
    x = width/2-w*0.05;
    y = height-100;
  }
}
