package com.ukuleledog.games.kingdom.rooms;
import com.ukuleledog.games.core.Room;
import com.ukuleledog.games.kingdom.elements.Dialog;
import com.ukuleledog.games.kingdom.elements.Sora;
import flash.display.BitmapData;
import haxe.Timer;
import motion.Actuate;
import openfl.Assets;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;

/**
 * ...
 * @author Matt
 */
class Intro extends Room
{
	
	public function new() 
	{		
		super();
		this.alpha = 0;
		
		this.setBackground( Assets.getBitmapData( 'img/backdrops.png' ), 479, 319, 60, 80 );
		
		dialog = new Dialog();
		addChild( dialog );
		
		sora = new Sora();
		sora.x = 250;
		sora.y = 230;
		addChild( sora );
		sora.scaleX = 2;
		sora.scaleY = 2;
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
	
		sora.setAnimation( 'floating' );
		Actuate.tween( this, 2, {alpha: 1} );
		
		Timer.delay( function() {
			dialog.addEventListener( Event.COMPLETE, fadeOut );
			dialog.display( 'Sora?/Hey, Sora!/Wake up sleepyhead!/...Huh?', 'riku/riku/riku/sora' );
		}, 2000 );
	}
	
	private function fadeOut( e:Event )
	{
		dialog.removeEventListener( Event.COMPLETE, fadeOut );
		Actuate.tween( background, 2, { alpha:0 } ).onComplete( function() {
			Actuate.tween( sora, 2, { alpha:0 } ).onComplete( function() {
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			} );
		} );
	}
	
}