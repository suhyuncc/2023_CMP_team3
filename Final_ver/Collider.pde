class Collider{
  boolean[] walls = new boolean[height * width]; 
  
  Collider(){
    
    loadPixels();
    for (int y = 0; y < height; y++ ) {
      for (int x = 0; x < width; x++ ) {
        int loc = x + y * width;
      
        float r = red(pixels[loc]);
        float g = green(pixels[loc]);
        float b = blue(pixels[loc]);

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
