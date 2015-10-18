package stanosky.swaptris.game.bricks;

/**
 * @author Krzysztof Stano
 */
interface IBrick 
{
	public function moveBrickTo(X:Float = 0, Y:Float = 0):Void;
	public function destroy():Void;
	public function toString():String;
	//public function setConnected(connection:Connection, value:Bool):Void;
	//public function getConnectionsLen():Int;
	public function setGroup(id:Int):Void;
	public function getGroup():Int;
	public function setTempGroup(id:Int):Void;	
	public function getTempGroup():Int;
	public function getColor():Int;
	public function setCell(columnIndex:Int, rowIndex:Int):Void;
	public function getCol():Int;
	public function getRow():Int;
}