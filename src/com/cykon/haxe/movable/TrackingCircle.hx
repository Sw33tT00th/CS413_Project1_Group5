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
import com.cykon.haxe.cmath.Vector;

class TrackingCircle extends DespawningCircle {

	private var trackCircle : Circle;

	public override function getMass(){
		return super.getMass()*10;
	}
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float, stageWidth:Float, stageHeight:Float, trackCircle : Circle){
		super(texture, x, y, radius, stageWidth, stageHeight);
		this.trackCircle = trackCircle;
	}
	
	/** Overriden version of the Circle's apply velocity,
	  * If the circle isnt heading towards the center && it's off screen, we despawn it */
	public override function applyVelocity(modifier:Float):Bool{	
		var returnVal = super.applyVelocity(modifier);
		
		var thisVector = new Vector(vx,vy);
		var directVector = Vector.getVector(getX(),getY(),trackCircle.getX(),trackCircle.getY());
		
		directVector.normalize().multiply( thisVector.mag );
		vx = directVector.vx;
		vy = directVector.vy;
		
		return returnVal;
	}
}