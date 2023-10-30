class Collider{
  boolean[] walls = new boolean[height * width]; 
  
  Collider(){
    
    // when game start, read maze_image and save wall's location in 'walls' array
    loadPixels();
    for (int y = 0; y < height; y++ ) {
      for (int x = 0; x < width; x++ ) {
        int loc = x + y * width;
      
        float r = red(pixels[loc]);
        float g = green(pixels[loc]);
        float b = blue(pixels[loc]);
        
        // always wall's color is black, so if fixel is black save 'true' in 'walls' array
        if(r < 10 && g < 10 && b < 10){
          walls[loc] = true;
        }
        else{
          walls[loc] = false;
        }
        
      }
    }
    updatePixels();
    
    
  }
  
  
}
