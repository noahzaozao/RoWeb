package utils
{
	/**
	 * 游戏对象数据类
	 * 场景中以GameObjData来存储游戏对象。当游戏对象进入视野后，才开始将游戏对象
	 * 映射到实际的GameObject来进行渲染。当游戏对象移出视野后，GameObject回收到
	 * 资源池，但是GameObjData将持续侦听运行。
	 */ 
	public class GameObjData
	{
		public var type:uint=0;
		public var x:uint;
		public var y:uint;
		public var name:String = '';
		
		public function GameObjData()
		{
			
		}
	}
}