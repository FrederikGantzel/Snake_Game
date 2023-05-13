
//Initializing some static values here.
//We need one World object.
World world;
//I found that a cell size of 10 pixels was a good looking number.
int cell_size = 10;
//This "movement_counter" value is used to determine when to move the Snakes.
int movement_counter = 0;
//The "pause_speed" value is used to pause the game.
int pause_speed = 0;
//The "player_count" will be either 1 or 2.
int player_count = 1;
//The "scene" String is used to navigate between the three "scenes"
String scene = "Player_select";
//These two images is used for some grafics in the scenes.
PImage whiteImg;
PImage pauseImg;
//These two Strings are used to keep track of the directions the Snakes are going.
String snake1_dir = "up";
String snake2_dir = "up";
//These two values are used to determine if the AI is turned on, and what difficulty it is set to.
Boolean AI = false;
String difficulty;


void setup() {
  //I chose a screen size of 520x520 because i thoiught it would be a nice size.
  //The size of the field for the actual game will be 500x500, surrounded by a wall 10 pixels wide on all sides.
  size(520, 520);
  whiteImg = loadImage("White.png");
  pauseImg = loadImage("Pause.png");
  world = new World(1, "None");
  difficulty = "Easy";
}

//The draw() functuon is build in to Processing, and is used once every frame to draw everything on screen.
void draw() {
  
  //I control what scene we are on by checking what the "scene" value is.
  //It can be one of three values, one for each of the three scenes.
  if (scene == "Player_select") {
    noTint();
    background(50);
    stroke(0);
    fill(230);
    
    //I draw the buttons here. I use the "MouseOver" functions to check if the buttons are being moused over,
    //and turn them a lighter color if that is the case.
    if (MouseOver_1p_button()) {
      fill(255);
    }
    rect(160, 110, 200, 100);
    fill(200);
    
    if (MouseOver_2p_button()) {
      fill(255);
    }
    rect(160, 310, 200, 100);
    fill(200);
    
    if (MouseOver_AI_button()) {
      fill(255);
    }
    rect(160, 420, 25, 25);
    
    //I put some text on the buttons here.
    fill(0);
    textSize(50);
    text("1 Player", 180, 175);
    text("2 Players", 170, 375);
    fill(255);
    textSize(25);
    text("AI player 2", 195, 441);
    
    //I want the "Easy" "Medium" and "Hard" boxes to show up only if the "AI player 2" box is checked.
    //I use the mouseClicked() function further down to change the values when the mouse is clicked.
    if (AI) {
      fill(0);
      textSize(60);
      
      //I use a big "X" character to check off the box if it is clicked.
      text("x", 160, 448);
      fill(200);
      
      //these boxes work pretty much the same way as the other buttons.
      if (MouseOver_Easy_button()) {
        fill(255);
      }
      rect(50, 470, 25, 25);
      fill(200);
      
      if (MouseOver_Medium_button()) {
        fill(255);
      }
      rect(220, 470, 25, 25);
      fill(200);
      
      if (MouseOver_Hard_button()) {
        fill(255);
      }
      rect(390, 470, 25, 25);
      
      fill(255);
      textSize(25);
      text("Easy", 80, 491);
      text("Medium", 250, 491);
      text("Hard", 420, 491);
      
      fill(0);
      textSize(60);
      //again, I use a big "X" character to check off the box if it is clicked.
      if(difficulty == "Easy") {
        text("x", 50, 498);
      } else if (difficulty == "Medium") {
        text("x", 220, 498);
      } else if (difficulty == "Hard") {
        text("x", 390, 498);
      }
    
    }
  
  //The next scene is for the actual gameplay.
  } else if (scene == "Playing_game") {
    
    //I use the pause_speed value to see if the game is paused.
    //The movement_counter value will not increase if the game is paused, and thus the Snakes will not move.
    if(pause_speed == 0) {
    movement_counter++;
    }
    
    //I use the Draw_world() function to draw the world here.
    world.Draw_world();
    
    //This is the part that moves the snakes around.
    //A move happens when the movement_counter value reaches a third of the framerate,
    //and thus, there will be 3 moves every second. I found this to be a reasonable speed.
    if(movement_counter > frameRate/3) {
      //The Move_all() function is used to move the Snakes.
      world.Move_all();
      
      //I use the snake1_dir and snake2_dir values later in the keyPressed() function,
      //to prevent the players from changing directions in a way that would make the Snake go direcrtly backwards into it's own tail.
      snake1_dir = world.Snakes.get(0).direction;
      if (player_count == 2) {
        snake2_dir = world.Snakes.get(1).direction;
      }
      movement_counter = 0;
    }
    
    
    //If the Alive_Status() function doesn't return one of these two values,
    //a Snake must have died, and thus we change the scene.
    if(player_count == 1) {
      if(world.Alive_Status() != "Snake is alive") {
        scene = "Death_screen";
      }
    } else {
      if(world.Alive_Status() != "Both Snakes Alive") {
        scene = "Death_screen";
      }
    }
    
    //If the game is paused, we gray out the entire screen, and display a pause sympol.
    //I found that the easiest way to gray out the screen was to display a big white image over the entire screen,
    //and then tint it gray and make it transparent. The pause symbol will also be transparent,
    //allowing the players to still see where the Snakes are when the game is paused.
    if(pause_speed != 0) {
      tint(100, 150);
      image(whiteImg, 0, 0);
      image(pauseImg, 160, 160);
      noTint();
    }
  
  //The final scene, displayed if a snake dies.
  } else if (scene == "Death_screen") {
    
    //We still want to draw the world, so the players can see how the Snake(s) died.
    world.Draw_world();
    
    //We gray out the world again with a white image that's tinted gray and made transparent.
    tint(100, 150);
    image(whiteImg, 0, 0);
    noTint();
    
    //Here we display "Game over", and some info about who won, if there was more than 1 player.
    fill(0);
    textSize(75);
    text("Game Over!", 80, 100);
    textSize(40);
    text(world.Alive_Status(), 150, 150);
    
    //We use another MouseOver function to see if the "Restart" button is being moused over.
    if (MouseOver_reset_button()) {
      fill(255);
    } else {
      fill(230);
    }
    rect(185, 420, 150, 70);
    fill(0);
    text("Restart", 200, 468);
    
    
  }
  
}

void mouseClicked() {
  
  //We check for mouse clicks only on specific buttons depending on which scene we are on.
  if (scene == "Player_select") {
    
    //If the "1 Player" or "2 Players" buttons are pressed, we create the World according to the players specifications,
    //and move on to the next scene. The world is created with no AI, unless the player has checked the AI box, and selects "2 Players".
    if(MouseOver_1p_button()) {
      player_count = 1;
      world = new World(player_count, "None");
      scene = "Playing_game";
      movement_counter = 0;
    } else if (MouseOver_2p_button()) {
      player_count = 2;
      if (AI) {
        world = new World(player_count, difficulty);
      } else {
        world = new World(player_count, "None");
      }
      scene = "Playing_game";
      movement_counter = 0;
    
    //If the AI box is pressed, we turn the AI on/off.
    } else if (MouseOver_AI_button()) {
      if (AI) {
        AI = false;
      } else {
        AI = true;
      }
    }
    
    //If the AI box is checked, and one of the difficulty boxes are pressed, we check off that box.
    if(AI) {
      if (MouseOver_Easy_button()) {
        difficulty = "Easy";
      } else if (MouseOver_Medium_button()) {
        difficulty = "Medium";
      } else if (MouseOver_Hard_button()) {
        difficulty = "Hard";
      }
    }
    
  //There are no buttons on the "Playing_game" scene, so we just check for the "Death_screen" scene next.
  } else if (scene == "Death_screen") {
    
    //The only button on this scene is the "Restart" button, and if it is pressed, we go back to the "Player_select" scene.
    if(MouseOver_reset_button()) {
      scene = "Player_select";
      difficulty = "Easy";
      AI = false;
    }
  }
  
}

void keyPressed() {
  
  //Here we check if the arrow keys are pressed. Pressing any of the arrow kays makes the snake change direction.
  //The Change_snake_direction() function takes the snakes number (0 for player 1, 1 for player 2) as input,
  //as well as the requested direction, and the snakes current direction (snake1_dir/snake2_dir).
  // this is to prevent the players from changing directions in a way that would make the Snake go direcrtly backwards into it's own tail.
  if (key == CODED) {
    if (keyCode == RIGHT) {
      world.Change_snake_direction(0, "right", snake1_dir);
    } else if (keyCode == LEFT) {
      world.Change_snake_direction(0, "left", snake1_dir);
    } else if (keyCode == UP) {
      world.Change_snake_direction(0, "up", snake1_dir);
    } else if (keyCode == DOWN) {
      world.Change_snake_direction(0, "down", snake1_dir);
    }
  }
  
  //The second Snake is controlled with the WASD keys.
  //We only check for these imputs if there is more that 1 player, and the AI is turned off.
  if (player_count == 2 && AI == false) {
    if (key == 'd') {
      world.Change_snake_direction(1, "right", snake2_dir);
    } else if (key == 'a') {
      world.Change_snake_direction(1, "left", snake2_dir);
    } else if (key == 'w') {
      world.Change_snake_direction(1, "up", snake2_dir);
    } else if (key == 's') {
      world.Change_snake_direction(1, "down", snake2_dir);
    }
  }
  
  //The spacebar key can be pressed in order to pause the game.
  //This only has an effect on the "Playing_game" scene.
  if (key == ' ') {
    int swapper = movement_counter;
    movement_counter = pause_speed;
    pause_speed = swapper;
  }
  
}



//I use these MouseOver functions to check if a specific button or box is being moused over.
//I do this by simply checking if the coordinates of the mouse overlap with the coordinates and dimentions of the button or box.
Boolean MouseOver_1p_button() {
  if(mouseX > 160 && mouseX < 360 && mouseY > 110 && mouseY < 210) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_2p_button() {
  if(mouseX > 160 && mouseX < 360 && mouseY > 310 && mouseY < 410) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_AI_button() {
  if(mouseX > 160 && mouseX < 185 && mouseY > 420 && mouseY < 445) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_Easy_button() {
  if(mouseX > 50 && mouseX < 75 && mouseY > 470 && mouseY < 495) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_Medium_button() {
  if(mouseX > 220 && mouseX < 245 && mouseY > 470 && mouseY < 495) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_Hard_button() {
  if(mouseX > 390 && mouseX < 415 && mouseY > 470 && mouseY < 495) {
    return true;
  } else {
    return false;
  }
}

Boolean MouseOver_reset_button() {
  if(mouseX > 185 && mouseX < 335 && mouseY > 420 && mouseY < 490) {
    return true;
  } else {
    return false;
  }
}
