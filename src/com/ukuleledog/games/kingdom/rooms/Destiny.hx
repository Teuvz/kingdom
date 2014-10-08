package com.ukuleledog.games.kingdom.rooms;

import com.ukuleledog.games.core.Room;
import com.ukuleledog.games.kingdom.elements.Dialog;
import com.ukuleledog.games.kingdom.elements.Sora;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import motion.Actuate;
import openfl.Assets;
import com.ukuleledog.games.kingdom.elements.Riku;
import flash.ui.Keyboard;
import openfl.display.Bitmap;
import flash.geom.Rectangle;
import openfl.geom.Point;

/**
 * ...
 * @author Matt
 */
class Destiny extends Room
{
	
	private var riku:Riku;
	
	public function new() 
	{
		super();
		
		this.alpha = 0;
		
		setBackground( Assets.getBitmapData( 'img/backdrops.png' ), 565, 400, 17, 40, 480, 0 );
		setLogo( Assets.getBitmapData( 'img/backdrops.png' ), 192, 135, 480, 450 );

		limitTop = 40;
		limitBottom = 385;
		limitLeft = 10;
		limitRight = 540;
			
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );

		drawBlockedAreas();
		drawActionAreas();
		
		riku = new Riku();
		riku.x = 300;
		riku.y = 200;
		addChild( riku );
		
		sora = new Sora();
		sora.x = 260;
		sora.y = 210;
		addChild( sora );
		
		displayLogo();
		
		dialog = new Dialog();
		addChild( dialog );
		
		Actuate.tween( this, 5, { alpha: 1 } ).onComplete( function() {
			Actuate.tween( logo, 2, { alpha:0 } ).onComplete( function() {
				dialog.addEventListener( Event.COMPLETE, dialogEndHandler );
				dialog.display( "Hey, you alright?/You seemed far away./I'm fine, I was just daydreaming!/Okay, well Kairi's looking for you./Better hurry up!", 'riku/riku/sora/riku/riku' );
			} );
		} );
		
	}
	
	private function dialogEndHandler( e:Event )
	{
		dialog.removeEventListener( Event.COMPLETE, dialogEndHandler );
		setPlayable();
	}
	
	private function drawBlockedAreas()
	{
		blockedAreas = new Array<Sprite>();
		
		var area1:Sprite = new Sprite();
		area1.graphics.beginFill( 0xFF0000, 0 );
		area1.graphics.lineTo( 10, 30 );
		area1.graphics.lineTo( 485, 250 );
		area1.graphics.lineTo( 485, 0 );
		area1.graphics.endFill();
		area1.x = 100;
		area1.y = 40;
		addChild( area1 );
		
		var area2:Sprite = new Sprite();
		area2.graphics.beginFill( 0xFF0000, 0 );
		area2.graphics.lineTo( 475, 225 );
		area2.graphics.lineTo( 0, 225 );
		area2.graphics.endFill();
		area2.x = 17;
		area2.y = 220;
		addChild( area2 );
		
		var area3:Sprite = new Sprite();
		area3.graphics.beginFill( 0xFF0000, 0 );
		area3.graphics.lineTo( 18, 0 );
		area3.graphics.lineTo( 18, 40 );
		area3.graphics.lineTo( -10, 30 );
		area3.graphics.endFill();
		area3.x = 313;
		area3.y = 200;
		addChild( area3 );
		
		blockedAreas.push( area1 );
		blockedAreas.push( area2 );
		blockedAreas.push( area3 );
		
	}
	
	private function drawActionAreas()
	{
		actionAreas = new Array<Sprite>();
		
		var area1:Sprite = new Sprite();
		area1.graphics.beginFill( 0x00FF00, 0 );
		area1.graphics.drawRect( 0, 0, 40, 60 );
		area1.graphics.endFill();
		area1.x = 290;
		area1.y = 200;
		area1.name = 'talk-riku';
		addChild( area1 );
		
		actionAreas.push( area1 );
	}
	
	override public function doAction( action:String )
	{
		setNotPlayable();
		
		switch( action )
		{
			case 'talk-riku':
				dialog.addEventListener( Event.COMPLETE, stopTalking );
				dialog.display("Kairi's looking for you, better hurry up!", "riku");
		}
		
	}
	
	private function stopTalking( e:Event )
	{
		dialog.removeEventListener( Event.COMPLETE, stopTalking );
		setPlayable();
	}
		
}