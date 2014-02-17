package cg.game.map.player 
{	
	import cg.game.net.clientToServer.npc.CS_NPC_START_TALK;
	import cg.game.map.npc.Npc;
	import cg.game.enums.AvatarType;
	import cg.game.net.clientToServer.map.CS_MAP_CHARACTER_SET_DIR;
	import cg.game.net.clientToServer.map.CS_MAP_CHARACTER_MOVE;
	import cg.game.map.player.data.PlayerInfo;
	import cg.game.map.sorter.SortPane;
	import cg.com.lib.ColorLib;
	import cg.game.map.player.data.MyPlayerInfo; 

	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;

	import cg.game.enums.AvatarAction;
	import cg.game.core.GlobalSet;
	import cg.game.core.Core;

	import flash.geom.Point;

	/**
	 * @author Administrator
	 */
	public class MyPlayer extends Player
	{    

		public var focusTarget: SortPane = null; //想要与某个目标交互，包括NPC或者其他玩家
		public var focusDir: int = - 1;
		public var attr: MyPlayerInfo;

		public function MyPlayer(info: MyPlayerInfo) 
		{    
			this.attr = info;
			super(info );
			this.nameTag.textColor = ColorLib.blueGreen;
			this.mouseChildren = false;
			trace("MyPlayer -> 主角已经初始化:" + info.name );
			//同步状态 
		}

		
	}
}
