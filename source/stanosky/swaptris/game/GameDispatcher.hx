package stanosky.swaptris.game;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;

/**
 * ...
 * @author ...
 */
class GameDispatcher 
{

	private static var disp:IEventDispatcher;
	
	public static function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (disp == null) { disp = new EventDispatcher(); }
		disp.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public static function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		if (disp == null) { return; }
		disp.removeEventListener(type, listener, useCapture);
	}
	
	public static function dispatchEvent (event:Event):Bool {
		if (disp == null) { return false; }
		return disp.dispatchEvent(event);
	}		
}

	//public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	//public function dispatchEvent (event:Event):Bool;
	//public function hasEventListener (type:String):Bool;
	//public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	//public function willTrigger (type:String):Bool;