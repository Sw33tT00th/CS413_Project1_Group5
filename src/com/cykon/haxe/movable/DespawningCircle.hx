package com.cykon.haxe.movable;
/**
  * This class is meant to represent a circle instance
  * which will despawn after exiting the screen area.
  * The circle may start outside of the screen.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
  
import starling.textures.Texture;

class DespawningCircle extends Circle {
	var stageWidth:Float;
	var stageHeight:Float;
	var prevDist:Float = Math.POSITIVE_INFINITY;
	var despawnMe:Bool = false;
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float, stageWidth:Float, stageHeight:Float){
		super(texture,x,y,radius);
		this.stageWidth = stageWidth;
		this.stageHeight = stageHeight;
	}
	
	public override function applyVelocity(modifier:Float){
		if(despawnMe)
			return;
			
		super.applyVelocity(modifier);
		
		var distance = getDistance();
		if(distance > prevDist && isOutOfBounds()){
			despawnMe = true;
			this.removeFromParent();
			//trace("DESPAWNED");
		}
			
		prevDist = distance;
	}
	
	public function hasDespawned():Bool{
		return despawnMe;
	}
	
	private function isOutOfBounds():Bool{
		var x = getX();
		var y = getY();
		return( x <= -radius || x >= stageWidth+radius || y <= -radius || y >= stageHeight+radius );
	}
	
	private function getDistance():Float{
		return Math.sqrt(Math.pow( getX()-stageWidth/2, 2) + Math.pow(getY()-stageHeight/2, 2) );
	}
}