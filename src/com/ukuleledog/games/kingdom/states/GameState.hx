package com.ukuleledog.games.kingdom.states;
import com.ukuleledog.games.core.Room;
import com.ukuleledog.games.core.State;
import com.ukuleledog.games.kingdom.elements.Sora;
import com.ukuleledog.games.kingdom.rooms.Destiny;
import com.ukuleledog.games.kingdom.rooms.Intro;
import flash.events.Event;

/**
 * ...
 * @author Matt
 */
class GameState extends State
{

	private var room:Room;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		room = new Intro();
		room.addEventListener( Event.COMPLETE, loadDestinyIsland );
		addChild( room );
	}
	
	private function loadDestinyIsland( e:Event )
	{
		room.removeEventListener( Event.COMPLETE, loadDestinyIsland );
		removeChild( room );
		
		room = new Destiny();
		addChild( room );
	}
	
}