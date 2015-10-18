package stanosky.swaptris.game.bricks;
import stanosky.swaptris.game.bricks.IBrick;

/**
 * ...
 * @author Krzysztof Stano
 */
class AbstractBrickFactory implements IBrickFactory
{
	private var _brickSize:Int;

	public function new(brickSize:Int) {
		_brickSize = brickSize;
	}
	
	/* INTERFACE data.bricks.IBrickFactory */
	
	public function getBrick(row:Int,column:Int):IBrick {
		return null;
	}
	
}