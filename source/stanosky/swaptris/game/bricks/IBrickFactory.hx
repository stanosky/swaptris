package stanosky.swaptris.game.bricks;

/**
 * @author Krzysztof Stano
 */
interface IBrickFactory 
{
	public function getBrick(column:Int,row:Int):IBrick;
}