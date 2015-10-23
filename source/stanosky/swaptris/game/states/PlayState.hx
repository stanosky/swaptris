package stanosky.swaptris.game.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import haxe.Timer;
import stanosky.swaptris.game.Board;
import stanosky.swaptris.game.bricks.IBrick;
import stanosky.swaptris.game.bricks.IBrickFactory;
import stanosky.swaptris.game.bricks.Pattern;
import stanosky.swaptris.game.bricks.PatternBrickFactory;
import stanosky.swaptris.game.bricks.RandomBrickFactory;
import stanosky.swaptris.game.engine.ILoop;
import stanosky.swaptris.game.engine.LoopIdle;
import stanosky.swaptris.game.engine.LoopInput;
import stanosky.swaptris.game.engine.LoopWait;
import stanosky.swaptris.game.GameEvent;

import flixel.input.mouse.FlxMouse;



/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _brickSize:Int = 44;
	private var _board:Board;
	private var _boardX:Int = 20;
	private var _boardY:Int = 64;
	private var _boardColumns:Int = 10;
	private var _boardRows:Int = 12;
	private var _boardWidth:Int;
	private var _boardHeight:Int;
	private var _randomFactory:IBrickFactory;
	private var _patternFactory:IBrickFactory;
	private var _boardHolder:FlxSpriteGroup;
	private var _background:FlxSprite;
	
	//loop states
	private var _loop:ILoop;
	private var _loopIdle:ILoop;
	private var _loopInput:ILoop;
	private var _loopWait:ILoop;
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_background = new FlxSprite(0, 0, AssetPaths.playView__png);
		//_swapSound = FlxG.sound.load(AssetPaths.swap__wav);
		_boardHolder = new FlxSpriteGroup();
		_boardWidth = _brickSize * _boardColumns;
		_boardHeight = _brickSize * _boardRows;
		GameDispatcher.addEventListener(GameEvent.BOARD_READY, onBoardReady);
		GameDispatcher.addEventListener(GameEvent.BOARD_BUSY, onBoardBusy);
		_board = new Board(_boardX,_boardY, _boardColumns, _boardRows, _brickSize, _boardHolder);
		_randomFactory = new RandomBrickFactory(_brickSize);
		_patternFactory = new PatternBrickFactory(_brickSize);
		//cast(_patternFactory, PatternBrickFactory).setPattern(Pattern.GROUPS);
		//_board.setBrickFactory(_patternFactory);
		_board.setBrickFactory(_randomFactory);
		_board.fillTempGrid();
		//_board.setBrickFactory(_randomFactory);
		//_board.fillMainGrid();
		_boardHolder.x = _boardX;// (FlxG.width - _boardHolder.width) * .5;
		_boardHolder.y = _boardY;// (FlxG.height - _boardHolder.height) * .5;		
		add(_background);
		add(_boardHolder);
		
		_board.findBrickGroups();
		_loopIdle = new LoopIdle();
		_loopInput = new LoopInput(_board, _boardX, _boardY, _boardWidth, _boardHeight, _brickSize);
		_loopWait = new LoopWait();
		_loop = _loopInput;
		super.create();
	}
	
	private function onBoardReady(event:GameEvent):Void {
		_loop = _loopInput;
	}
	
	private function onBoardBusy(event:GameEvent):Void {
		_loop = _loopWait;
	}	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_loop.update();
		super.update();
	}	
	
}