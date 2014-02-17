package cg.game.map 
{	
	import cg.game.map.player.Player;

	import flash.geom.Rectangle;

	import cg.game.enums.Keys;
	import cg.com.extra.KeyManager; 
	import cg.com.extra.FrameEventManager; 

	import com.greensock.TweenMax;

	import flash.events.Event;

	import cg.game.core.GlobalSet;
	import cg.game.core.Core;

	import flash.geom.Point;
	import flash.events.MouseEvent;

	import cg.com.extra.EventManager;

	/**
	 * @author Administrator
	 */
	public class MapManager extends MapReader
	{

		private var playerDict : Object = {}; //地图内角色字典

		public function MapManager()
		{    
			 
			EventManager.AddOnceEventFn(this, Event.ADDED_TO_STAGE, init);
		}

		private function init() : void
		{  
			EventManager.AddEventFn(stage, MouseEvent.MOUSE_DOWN, onMouseDown, null, true);
			EventManager.AddEventFn(stage, MouseEvent.MOUSE_UP, onMouseUp, null, true);
			EventManager.AddEventFn(stage, MouseEvent.MOUSE_MOVE, onMouseMove, null, true);
			EventManager.AddEventFn(stage, MouseEvent.CLICK, onMouseClick, null, true);
			//this.startTraceCamera();
		}

		private function onMouseDown(e : MouseEvent) : void
		{ 
			if( this.locked)
			{
				return;
			}
			KeyManager.isDown(Keys.Space) && this.startDrag(false); 
		}

		private function onMouseUp(e : MouseEvent) : void
		{ 
			if( this.locked)
			{
				return;
			} 
			this.stopDrag();
		}

		private function onMouseMove(e : MouseEvent) : void
		{ 
			if( this.locked)
			{
				return;
			}
			var pt : Point = this.relToAbs(this.mouseX, this.mouseY);
			Core.ui.showMapInfo("相对位置:" + this.mouseX + "," + this.mouseY + " 绝对位置:" + pt.x + "," + pt .y);
		}

		private function onMouseClick(e : MouseEvent) : void
		{
			if( this.locked || KeyManager.isDown(Keys.Space))
			{
				return;
			}
			var pt : Point = this.relToAbs(this.mouseX, this.mouseY);
			KeyManager.isDown(Keys.Ctrl) ? Core.me.flyTo(pt.x, pt.y) : Core.me.goTo(pt.x, pt.y);
		}

		override protected function enterMap() : void
		{ 
			super.enterMap();
			this.locked = false; 
			this.actLayer.addChild(Core.me);
			this.sortArr.push(Core.me);
			this.sortAll(); 
			Core.me.flyTo(this.logX, this.logY);
		}	 

		//			trace("Map -> 进入地图" );
		//			for(var a: int = 0;a < AvatarType.allAvatar.length; a ++)
		//			{  
		//				Core.me.body.setAvatar("base", AvatarType.allAvatar[a] ) ;
		//			}
		//			return;
		//			for(var i: int = 0;i < 10; i ++)
		//			{                 
		//				//				var avt:AvatarBody=new AvatarBody();
		//				//				avt.init(0);
		//				//				this.actLayer.addChild(avt);
		//				var nx: int = Math.random() * this.mapData.mapWidth >> 0;
		//				var ny: int = Math.random() * this.mapData.mapHeight >> 0;
		//				if(this.mapData.hinder[nx + "," + ny])
		//				{
		//					continue;
		//				}
		//				var info: PlayerInfo = new PlayerInfo();
		//				info.name = "测试机器人No." + i ;
		//				info.bodyType = 1;
		//				var oth: OthPlayer = new OthPlayer(info );
		//
		//				this.actLayer.addChild(oth );  
		//				for(var j: int = 1;j < 6; j ++)
		//				{  
		//					Math.random() * 100 > 40 && oth.body.setAvatar("base", AvatarType.allAvatar[j] ) ;
		//				}
		//				oth.flyTo(nx, ny );
		//				//oth.startTestGo();
		//			}
		//		}
		//

		//
		//		public function showTileMark(x: int,y: int): void
		//		{ 
		//			var pt: Point = this.absToRel(x, y );
		//			this.cue.x = pt.x;
		//			this.cue.y = pt.y;
		//			this.cue.alpha = 1;
		//			this.cue.visible = true; 
		//			TweenMax.to(this.cue, 1, {visible:false} );
		//		}
		//
		//直接修正到某个位置
		public function syncCamera() : void
		{  
			//scrollRect方案，性能基本没区别
			//this.scrollRect = new Rectangle(- (GlobalSet.CemeraPos.x - Core.me.x) >> 0, - (GlobalSet.CemeraPos.y - Core.me.y) >> 0, 950, 600 );
			this.x = (GlobalSet.CemeraPos.x - Core.me.x) >> 0;
			this.y = (GlobalSet.CemeraPos.y - Core.me.y) >> 0;   
//			this.x > 0 && (this.x = 0);
//			this.x < this.minCameraPos.x && (this.x = this.minCameraPos.x);
//			this.y > 0 && (this.y = 0);
//			this.y < this.minCameraPos.y && (this.y = this.minCameraPos.y);
		} 
//
//		//开始平滑跟踪
//		public function startTraceCamera(): void
//		{
//			FrameEventManager.addEnterFrameFn(updateCamera, "Camera" );
//		}
//
//		//结束平滑跟踪
//		public function stopTraceCamera(): void
//		{
//			FrameEventManager.delEnterFrameFn(updateCamera, "Camera" );
//		}
//
//		//移动镜头跟随主角 
//		public function updateCamera(e: Event = null): void
//		{   
//			var fx: int = (GlobalSet.CemeraPos.x - Core.me.x - this.x) / 10 >> 0;
//			var fy: int = (GlobalSet.CemeraPos.y - Core.me.y - this.y) / 10 >> 0;
//             
//			if(fx)
//			{ 
//				this.x += fx; 
//			}
//			if(fy)
//			{ 
//				this.y += fy; 
//			} 
//		} 
//
//		//获取一个其他玩家
//		public function getOthPlayerById(id: int): OthPlayer
//		{
//			return this.playerDict[id];
//		}
//
//		//获取一个玩家,可能包括自己
//		public function getPlayerById(id: int): Player
//		{
//			return id == Core.me.attr.id ? Core.me:this.playerDict[id];
//		}
	}
}
