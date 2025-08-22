/**
* Class: Checkpoint  
* Represents a stationary checkpoint that appears when the boss is defeated.
* pre: Requires x, y coordinates and a loaded PImage.  
* post: Creates a Checkpoint object at the specified position with fixed size and no movement.
*/
class Checkpoint extends Rectangle{
  /**
  * Constructor: Checkpoint  
  * Initializes the checkpoint at a specific position with an image.
  * pre: x, y are float coordinates; img is a loaded PImage.  
  * post: Creates a non-moving checkpoint with fixed size.
  */
  Checkpoint(float x, float y, PImage img){
    super(x, y, 150, 150, 0, img);
  }
  
  /**
  * Method: move  
  * Overrides move; checkpoints do not move.
  * pre: None  
  * post: No changes made to position.
  */
  void move(){
    //checkpoint doesnt move
  }
}
