package source.stanosky.swaptris.game.sound;

/**
 * ...
 * @author ...
 */
class SoundManager
{
	
	private var _swapSound:FlxSound;
	
	public function new() 
	{
		FlxG.sound.load(AssetPaths.swap__ogg);
	}
	
	public static function playSwapSound():Void {
		
	}
}