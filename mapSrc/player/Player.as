package cg.game.map.player 
{
	import cg.game.core.data.warp.MapWarpInfo;
	import cg.com.extra.DataLite;

	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;

	import cg.game.core.GlobalSet;
	import cg.com.extra.AstarFinder;

	import flash.display.Bitmap; 

	import cg.game.map.sorter.SortPane;

	import flash.geom.Point; 

	import cg.game.core.Core;  

	/**
	 * @author Administrator
	 */
	public class Player extends SortPane
	{  

		public var dir : int = 0; //面朝方向  
		public var body : Bitmap; //人物身体种类   
		protected var moving : Boolean = false; //是否在行动 
		protected var path : Array = []; //路径数组   
		private var focusDir : int = -1; 

		public function Player() 
		{       
			this.mouseEnabled = false;    
			 
		 
			this.body = new Bitmap();
			this.body.bitmapData = DataLite.getBmpFromSwf("base/base.swf", "tile_0");
			//			this.body.x = 32;
			//			this.body.y = 24; 
			this.addChild(this.body);
			
 
//			this.chatBubble = new ChatBubble();
//			this.chatBubble.x = 56;
//			this.chatBubble.y = 12;
//			this.tagPane.addChild(this.chatBubble );  
		}

		//瞬间移动
		public function flyTo(x : int, y : int,ani : Boolean = false) : void
		{ 
			trace("瞬間移動：" + x + "," + y);
            
			this.stopWalk(); 
            
			this.mx = x;
			this.my = y;   
			var pt : Point = Core.map.absToRel(x, y);  
		 
			this.x = pt.x;
			this.y = pt.y;
		 
			//重新加入  
			Core.map.syncCamera();
			Core.map.updateMap();
			//Core.map.sortObjIndex(this ); 
            
             
            //Core.stg.uiMaster.guideMapForm.syncMapPositon(true ); 
		}

		//转指定点
		public function turnTo(x : int, y : int) : void
		{
			if (this.mx == x && this.my == y)
			{ 
				return; 
			}    
			var d : int = this.getDir(x, y);
			if (this.moving)
			{
				//这里需要预转身，然后清掉行走
				this.focusDir = d; 
				this.path.length && (this.path = []);  
			}
			else
			{ 
				this.setDir(d);
			} 
		}

		//想要调查某个玩家,如需要
		public function goToTarget(target : SortPane) : void
		{   
		}

		//移动到指定点
		public function goTo(x : int, y : int) : void
		{   
 
			//如果是当前点就不动了
			if(this.mx == x && this.my == y)
			{
				return;
			}

         
			if (Core.map.mapData.hinder[x + "," + y]) 
			{   
				var pt : Point = Core.astar.getNearlyPt(this.mx, this.my, x, y);
				if(!pt)
				{  
					return;
				} 
				x = pt.x;
				y = pt.y;
			}  
          
			//开始寻路并行走 
			var p : Array = Core.astar.find(this.mx, this.my, x, y);  
			if (!p.length) 
			{ 
				return ; 
			}
			this.path = p;   
			if (this.moving) 
			{ 
				return; 
			} 
			this.moving = true;
			//Core.map.startTraceCamera();
			this.walk();
		}  

		//键盘行走
		public function keyGo(dir : int) : void
		{  
			if(Core.map.locked)
			{
				return;
			}
			var pt : Point = this.getDirPt(dir); 
			if(Core.map.mapData.hinder[pt.x + "," + pt.y])
			{
				this.moving || this.turnTo(pt.x, pt.y);
				return;
			}
			this.path = [[pt.x,pt.y]];
			//Core.map.showTileMark(pt.x, pt.y );
			if(!this.moving)
			{
				this.moving = true;
				this.walk();
			}
		}

		//行走行为
		private function walk(slow : Boolean = false ) : void
		{  
			//更新到服务器，但不广播（仅为新进入玩家能正确看到朝向）,否则会出现“抖动现象”
			if (!this.path.length) 
			{ 
				this.stopWalk(); 
				return; 
			} 
			//             
			var np : Array = this.path.shift(); //取出第一个路径 
			var d : int = this.getDir(np[0], np[1]); //获取下个目标的方向   
			//this.setDir(d ) && CS_MAP_CHARACTER_SET_DIR.send(d ) ; //转身,如果有变化则发给服务端 
			var mt : Number = (d % 2 == 0 ? 1 : 1.4) * GlobalSet.MoveSpeed / (slow ? 950 : 1000); //计算行走时间 
			var pt : Point = Core.map.absToRel(np[0], np[1]);   
			//在更新 新的坐标前发给队员
			//  (this.inGp && this.leader) && Core.stg.mapMaster.gpLeaderGo(this);
			this.mx = np[0];
			this.my = np[1];      
			Core.map.sortObjIndex(this); 
			TweenMax.to(this, mt, {  x: pt.x, y: pt.y, ease:Linear.easeNone, onUpdate:this.onUpdatePos, onComplete:this.walkOver });
            //
		}  

		private function onUpdatePos() : void
		{
			this.x >>= 0;
			this.y >>= 0;
			Core.map.syncCamera();
		}

		//行走结束
		private function walkOver() : void
		{
			//检查是否到了目标旁边
			//this.chkFocusTarget();
            
			//同步到小地图
			//Core.ui.guideMap.syncPos();
             
         
			//测试用的切换地图
			if(Core.map.mapData.warpDict[this.mx + "," + this.my])
			{
				this.moving = false;  
				this.path.length && (this.path = []); 
				var w : MapWarpInfo = Core.map.mapData.warpDict[this.mx + "," + this.my];
				//Core.map.loadMap(w.toMapId, w.toX, w.toY);
				Core.map.locked = true; 
				Core.mask.effect.showAlphaEffect(true, Core.map.loadMap, [w.toMapId, w.toX, w.toY]); 
				//TweenMax.to(Core.map, 0.2, {alpha:0, onComplete:Core.map.loadMap, onCompleteParams:[w.toMapId, w.toX, w.toY]});
			}
			Core.map.updateMap();
			this.walk();
		}

		//检查是否可以与焦点交互
		//		private function chkFocusTarget(): Boolean
		//		{ 
		//			if( this.focusTarget && this.chkNearMe(this.focusTarget.mx, this.focusTarget.my ))
		//			{ 
		//				if(this.focusTarget is OthPlayer)
		//				{
		//					Core.ui.actionBar.show(); 
		//				}
		//				else
		//				{
		//					Core.ui.npcTalkBar.showTalk(Npc(this.focusTarget ).data.id, "你好，年轻的冒险家～ 欢迎来到美丽的村庄沐风，这里是你冒险的起点。\n如果有什么困难的话，我将会尽力解决你的所有烦恼喔～ \n那么，你现在有什么疑问吗？", [] );
		//                    //CS_NPC_START_TALK.send(Npc(this.focusTarget ).data.id );
		//				}
		//                 
		//				this.turnTo(this.focusTarget.mx, this.focusTarget.my ); 
		//				return true;
		//			}
		//			return false;
		//		}

		//停止走路
		private function stopWalk() : void
		{
			//TweenLite.killTweensOf(this, false );
			this.moving = false;  
			//this.setAct(AvatarAction.Stand );
			this.path.length && (this.path = []);  
			if(this.focusDir > -1)
			{
				this.setDir(this.focusDir);
				this.focusDir = -1; 
			}
			//this.focusTarget = null;
		} 

		//返回登陆时做的清理
		public function clearBody() : void
		{    
		}

		//		//设定动作 返回是否成功更新动作
		//		public function setAct(act: String,chk: Boolean = true): Boolean
		//		{
		//			if (chk && this.act == act) 
		//			{ 
		//				return false; 
		//			} 
		//			this.act = act;
		//			this.update();
		//			return true;
		//		} 

		//设定方向 返回是否成功更新动作
		public function setDir(dir : int,chk : Boolean = true) : Boolean
		{
			if (chk && this.dir == dir) 
			{ 
				return false; 
			}
			this.dir = dir; 
			this.update();
			return true;
		} 

		//		//更新自身动作
		private function update() : void
		{
			//this.body.setAction(this.act, this.dir );
		}

		//获取某个坐标相对自己的方向
		public function getDir(x : int, y : int) : int
		{
			var nx : int = x - this.mx; 
			var ny : int = y - this.my; 
			if (nx == 0 && ny > 0)
			{
				return 0;
			}
			if (nx > 0 && ny > 0)
			{
				return 1;
			}            
			if (nx > 0 && ny == 0)
			{
				return 2;
			}
			
			if (nx > 0 && ny < 0)
			{
				return 3;
			}
			if (nx == 0 && ny < 0) 
			{ 
				return 4; 
			}
			if (nx < 0 && ny < 0)
			{
				return 5;
			}           
			if (nx < 0 && ny == 0)
			{
				return 6;
			}
			if (nx < 0 && ny > 0)
			{
				return 7;
			} 
 
			return -1;
		}

		//获取某个方向对应的坐标
		public function getDirPt(dir : int) : Point
		{
			var pt : Point = new Point(this.mx, this.my);
			switch(dir)
			{ 
				case 0:  
					pt.y++; 
					break;
				case 1: 
					pt.x++; 
					pt.y++; 
					break;
				case 2:   
					pt.x++; 
					break;
				case 3: 
					pt.x++; 
					pt.y--; 
					break;
				case 4:  
					pt.y--; 
					break;
				case 5: 
					pt.x--; 
					pt.y--; 
					break;
				case 6: 
					pt.x--;  
					break;
				case 7: 
					pt.x--;
					pt.y++; 
					break;
			}
			return pt;
		}

		//获取某个坐标相对自己的距离
		public function getLen(x : int, y : int) : int
		{
			return Math.abs(x - this.mx) + Math.abs(y - this.my);
		} 

		//检查是否在自己周围
		public function chkNearMe(x : int, y : int) : Boolean
		{
			var lx : int = Math.abs(x - this.mx);
			var ly : int = Math.abs(y - this.my);
			
			if((lx == 1 && ly == 1) || (lx == 1 && ly == 0) || (lx == 0 && ly == 1))
			{
				return true;
			}
			return false;
		}

		//说话
		public function showChat(text : String) : void
		{
			//this.chatBubble.showChat(text );
		}
	}
}
