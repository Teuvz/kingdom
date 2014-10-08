package com.ukuleledog.games.kingdom.elements;

import com.ukuleledog.games.core.AnimatedObject;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class DialogKey extends AnimatedObject
{

	public function new() 
	{
		super();
		
		this.bmd = Assets.getBitmapData( 'img/dialog.png' );
		
		createAnimation( 'idle', 300, 0, 6, 20, 25, 0.2 );
		animate();
		
		this.scaleX = 1.5;
		this.scaleY = 1.5;
		
	}
	
}