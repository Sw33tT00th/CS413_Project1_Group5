package com.cykon.haxe.movable;
/**
  * This class is meant to represent a player controlled instance
  * of the Circle class, it takes input and based off of the input
  * the circle will have velocities applied accordingly.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
  
import starling.textures.Texture;

class PlayerCircle extends Circle {
	// Numerical key mappings to different directions
	private var K_UP : Int		= 87;
	private var K_LEFT : Int	= 65;
	private var K_DOWN : Int	= 83;
	private var K_RIGHT : Int	= 68;
	
	// Map to contain whether or not a key is pressed at any moment
	private var keyMap : Map<Int, Bool> = new Map<Int, Bool>();
	
	// Move speed the player will move at
	private var moveSpeed : Float;
	
	// Angle speed the player will move at
	private var angleSpeed : Float;
	
    public function new(texture:Texture, x:Float, y:Float, radius:Float, moveSpeed:Float){
        super(texture, x, y, radius);
		keyMap.set(K_UP, false); 	// W (up)
		keyMap.set(K_LEFT, false); 	// A (left)
		keyMap.set(K_DOWN, false); 	// S (down)
		keyMap.set(K_RIGHT, false); // D (right)
		
		this.moveSpeed = moveSpeed;
		this.angleSpeed = Math.sqrt((moveSpeed*moveSpeed)/2);
	}
	
	/** Function to be called when a particular key is pressed down */
	public function keyDown( keyCode : Int ){
		keyMap.set(keyCode, true);
	}
	
	/** Function to be called when a particular key is unpressed */
	public function keyUp( keyCode : Int ){
		keyMap.set(keyCode, false);
	}
	
	/** Overriden version of the default apply velocity, here we can examine the key pressed */
	public override function applyVelocity(modifier:Float){
		// Reset the velocities
		vx = vy = 0;
		
		// Apply velocities based on the values in the keyMap
		if( keyMap.get( K_UP ) )
			vy += -moveSpeed;
		if( keyMap.get( K_LEFT ) )
			vx += -moveSpeed;
		if( keyMap.get( K_DOWN ) )
			vy += moveSpeed;
		if( keyMap.get( K_RIGHT ) )
			vx += moveSpeed;
	
		// Multiple keys are pressed, normalize and apply the angle speed
		// This ensures the player will -always- move at moveSpeed
		if(vx * vy != 0){
			vx = vx / moveSpeed * angleSpeed;
			vy = vy / moveSpeed * angleSpeed;			
		}
		
		// Call the default applyVelocity method
		super.applyVelocity(modifier);
	}
}