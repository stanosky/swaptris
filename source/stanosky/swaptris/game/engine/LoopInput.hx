package stanosky.swaptris.game.engine;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import stanosky.swaptris.game.Board;
import stanosky.swaptris.game.bricks.IBrick;

/**
 * ...
 * @author k.stano
 */
class LoopInput implements ILoop
{
	private var _board:Board;
	private var _boardX:Int;
	private var _boardY:Int;
	private var _boardWidth:Int;
	private var _boardHeight:Int;	
	private var _brickSize:Int;
	
	private var _mousePressX:Int;
	private var _mousePressY:Int;	
	private var _validPress:Bool = false;
	
	
	//double click stuff
	private var _lastClick:Float=0;
    private var _doubleClickFired:Bool = false;
    private static inline var DOUBLE_CLICK_TIMER = 0.2; //seconds to determine a double click/tap	
	
	public function new(board:Board,boardX:Int,boardY:Int,boardWidth:Int,boardHeight:Int,brickSize:Int) {
		_board = board;
		_boardX = boardX;
		_boardY = boardY;
		_boardWidth = boardWidth;
		_boardHeight = boardHeight;
		_brickSize = brickSize;
		FlxG.stage.doubleClickEnabled = true;
	}
	
	private function onMouseRelease() {
		if(_validPress) {
			var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
			var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
			var colIndex:Int = Math.floor(_mousePressX / _brickSize);
			var rowIndex:Int = Math.floor(_mousePressY / _brickSize);			
			var diffX:Int  = mouseX - _mousePressX;
			var diffY:Int  = mouseY - _mousePressY;
			
			if (Math.abs(diffX) > Math.abs(diffY)) {
				if (diffX > 0) {
					_board.swapBricks(colIndex, rowIndex, colIndex + 1, rowIndex);
				} else {
					_board.swapBricks(colIndex, rowIndex, colIndex - 1, rowIndex);
				}
			} else if (Math.abs(diffX) < Math.abs(diffY)) {
				if (diffY > 0) {
					_board.swapBricks(colIndex, rowIndex, colIndex, rowIndex + 1);
				} else {
					_board.swapBricks(colIndex, rowIndex, colIndex, rowIndex - 1);
				}
			}
			
		}
	}
	
	private function onMousePress():Void {
        if (haxe.Timer.stamp()-_lastClick<DOUBLE_CLICK_TIMER) { //a double click is 2 clicks within 0.3sec
            _lastClick = 0;
            onDoubleClick();
        } else {
            _doubleClickFired = false;
            _lastClick = haxe.Timer.stamp();
			FlxTween.num(0, DOUBLE_CLICK_TIMER + 0.01, DOUBLE_CLICK_TIMER + 0.01, {complete: onSingleClick, type: FlxTween.ONESHOT });
        }			
		var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
		var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
		
		if (mouseX >= 0 && mouseX <= _boardWidth
		//Ta cześć warunku może wydawać sie dziwna ze wzgledu na to, że mouseY musi być wieksze lub równe _boardHeight
		//oraz nie może być wieksze od podwojonego _boardHeight. Wynika to z tego, że Plansz jest podzielona na cześć
		//niewidoczną i cześć widoczną. Cześć niewidoczna znajduje si ponad cześcią widoczną.
		&& mouseY >= _boardHeight && mouseY <= _boardHeight*2) {
			_validPress = true;
			_mousePressX = mouseX;
			_mousePressY = mouseY;
		} else {
			_validPress = false;
		}
	}
	
    private function onSingleClick(tween:FlxTween):Void {
        if (_doubleClickFired) return;
        // STUFF to do on single click/tap
        //trace('single click');
    }

    private function onDoubleClick():Void {
        _doubleClickFired = true;
        // STUFF on double click/tap
        //trace('double click');
		if (_validPress) {
			var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
			var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
			var colIndex:Int = Math.floor(_mousePressX / _brickSize);
			var rowIndex:Int = Math.floor(_mousePressY / _brickSize);
			_board.tryDestroyGroupAt(colIndex, rowIndex);
		}
    }		
	
	/* INTERFACE stanosky.swaptris.game.engine.ILoop */
	
	public function update():Void {
		if (FlxG.mouse.justPressed) onMousePress();
		if (FlxG.mouse.justReleased) onMouseRelease();
	}
	
}