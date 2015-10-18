package stanosky.swaptris.game.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import stanosky.swaptris.game.states.PlayState;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var currentPolicy:FlxText;
	private var fill:FillScaleMode;
	private var ratio:RatioScaleMode;
	private var relative:RelativeScaleMode;
	private var fixed:FixedScaleMode;	
	
	private var _btnsGroup:FlxSpriteGroup;
	private var _btnPlay:FlxButton;
	private var _btnSettings:FlxButton;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//fill = new FillScaleMode();
		ratio = new RatioScaleMode();
		//relative = new RelativeScaleMode(0.75, 0.75);
		fixed = new FixedScaleMode();
		FlxG.scaleMode = ratio;
		//currentPolicy = new FlxText(0, 10, FlxG.width, "ratio");
		//currentPolicy.alignment = "center";
		//currentPolicy.size = 16;
		//add(currentPolicy);
		//
		//var info:FlxText = new FlxText(0, FlxG.height - 40, FlxG.width, "press space or click to change the scale mode");
		//info.setFormat(null, 14, FlxColor.WHITE, "center");
		//info.alpha = 0.75;
		//add(info);	
		
		_btnsGroup = new FlxSpriteGroup();
		add(_btnsGroup);
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.setGraphicSize(200);
		//_btnPlay.updateHitbox();
		_btnsGroup.add(_btnPlay);
		_btnSettings = new FlxButton(0, 0, "Settings", clickSettings);
		_btnSettings.setGraphicSize(200);
		//_btnSettings.updateHitbox();
		_btnSettings.y = 50;
		_btnsGroup.add(_btnSettings);
		_btnsGroup.screenCenter();
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void	{
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
		_btnSettings = FlxDestroyUtil.destroy(_btnSettings);
		_btnsGroup = FlxDestroyUtil.destroy(_btnsGroup);
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		//if (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed)
		//{
			//switch (currentPolicy.text)
			//{
				//case "fill":
					//FlxG.scaleMode = ratio;
					//currentPolicy.text = "ratio";
				//
				//case "ratio":
					//FlxG.scaleMode = fixed;
					//currentPolicy.text = "fixed";
					//
				//case "fixed":
					//FlxG.scaleMode = relative;
					//currentPolicy.text = "relative 75%";
				//
				//default:
					//FlxG.scaleMode = fill;
					//currentPolicy.text = "fill";
			//}
		//}		
		

		super.update();
	}	
	
	private function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
	
	private function clickSettings():Void {
		FlxG.switchState(new SettingsState());
	}	
}