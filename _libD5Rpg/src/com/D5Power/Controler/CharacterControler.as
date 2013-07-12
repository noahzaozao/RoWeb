/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.Controler
{
    import com.D5Power.D5Game;
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.map.WorldMap;
    import com.D5Power.mission.MissionData;
    
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    /**
     * 角色控制器
     * 
     */
    public class CharacterControler extends BaseControler
    {
        protected var target:Point;
        
        protected var _step:uint;
        
        protected var _path:Array;
        
        /**
         * 是否正在主观控制状态
         */ 
        protected var onControl:Boolean=false;
        
        protected var contrlSwitch:uint;
        
        public static const KEY:uint=1;
        public static const KEY_AND_MOUSE:uint=2;
        public static const MOUSE:uint=0;
        
        /**
         * 各按键按下状态
         */ 
        protected var wKey:int;
        protected var aKey:int;
        protected var sKey:int;
        protected var dKey:int;
        /**
         * 根据按键产生的XY轴行走方向
         */ 
        protected var xKey:int;
        protected var yKey:int;
        
        protected var _k:Number = Math.sin(Math.PI*45/180);
        
        protected var _listnerSetuped:Boolean=false;
        
        /**
         * 移动到某点后的触发函数
         */ 
        protected var _onWalkComplate:Function;
        /**
         * 移动到某点后触发函数的参数
         */ 
        protected var _onWalkParams:Array;
        
        public function CharacterControler(pec:Perception,ctrl:uint = KEY_AND_MOUSE)
        {
            super(pec);
            
            _step = 1;
            contrlSwitch = ctrl;
            
            
            setupListener();
        }
        
        override public function clearPath():void
        {
            if(_path==null) return;
            (_me as CharacterObject).action = Actions.Wait;
            _path.splice(0,_path.length);
            _path=null;
        }
        
        /**
         * 根据控制方式的不同设置不同的侦听
         */ 
        override public function setupListener():void
        {
            if(_listnerSetuped) return;
            
            var s:Stage = perception.Scene.stage;
            switch(contrlSwitch)
            {
                case KEY:
                    keyOpertion(s);
                    break;
                case MOUSE:
                    onlyMouseOption(s);
                    break;
                case KEY_AND_MOUSE:
                    mouseOpertion(s);
                    keyOpertion(s);
                    break;
            }
            _listnerSetuped = true;
        }
        
        private function onlyMouseOption(s:Stage):void
        {
            D5Game.me.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
        }
        
        
        private function mouseOpertion(s:Stage):void
        {
            s.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        }
        
        
        private function keyOpertion(s:Stage):void
        {
            s.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
            s.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
            s.addEventListener(MouseEvent.CLICK,onDo,false,0,true);
        }
        
        
        /**
         * 反安装控制器
         */ 
        override public function unsetupListener():void
        {
            if(!_listnerSetuped) return;
            
            var s:Stage = perception.Scene.stage;
            
            switch(contrlSwitch)
            {
                case KEY:
                    removeKeyListener(s);
                    break;
                case MOUSE:
                    s.removeEventListener(MouseEvent.CLICK,onClick);
                    break;
                case KEY_AND_MOUSE:
                    s.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
                    removeKeyListener(s);
                    break;
            }
            _listnerSetuped = false;
        }
        
        private function removeKeyListener(s:Stage):void
        {
            s.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            s.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
            s.removeEventListener(MouseEvent.CLICK,onDo);
        }
        
        
        /**
         * 计算行动
         */ 
        override public function calcAction():void
        {
            super.calcAction();
            
            switch(contrlSwitch)
            {
                case KEY:
                    calcActionKey();
                    break;
                case MOUSE:
                    calcActionMouse();
                    break;
                case KEY_AND_MOUSE:
                    calcActionBoth();
                    break;
            }
        }
        
        /**
         * 触发鼠标动作
         */ 
        protected function onDo(e:MouseEvent):void
        {
            
        }
        
        /**
         * 是否静止
         * 处于死亡状态返回是
         */ 
        protected function get isStatic():Boolean
        {
            if(_me==null) return false;
            if((_me as CharacterObject).action==Actions.Die) return true;
            
            return false;
        }
        
        /**
         * 全控制状态下的动作计算
         */ 
        protected function calcActionBoth():void
        {
            if(isStatic) return;
            
            var me:CharacterObject = _me as CharacterObject;
            var nextX:Number=me.PosX;
            var nextY:Number=me.PosY;
            
            /**
             * 根据按键移动角色方向
             */ 
            switch(xKey)
            {
                case 1:
                    if(yKey==1)
                    {
                        nextX+=me.speed*_k;
                        nextY+=me.speed*_k;
                    }else if(yKey==-1){
                        nextX+=me.speed*_k;
                        nextY-=me.speed*_k;
                    }else{
                        nextX=me.PosX+me.speed;
                    }
                    break;
                case -1:
                    if(yKey==1)
                    {
                        nextX-=me.speed*_k;
                        nextY+=me.speed*_k;
                    }else if(yKey==-1){
                        nextX-=me.speed*_k;
                        nextY-=me.speed*_k;
                    }else{
                        nextX=me.PosX-me.speed;
                    }
                    break;
                case 0:
                    if(yKey==1)
                    {
                        nextY=me.PosY+me.speed;
                    }else if(yKey==-1){
                        nextY=me.PosY-me.speed;
                    }else{
                        if(me.action==Actions.Run) me.action = Actions.Wait;
                        return;
                    }
                    break;
            }
            nextCanMove(nextX,nextY,me);
        }
        
        /**
         * 鼠标控制状态下的计算行动
         */ 
        protected function calcActionMouse():void
        {
            if(isStatic) return;
            
            var c:CharacterObject = _me as CharacterObject;
            
            if(_path!=null && _path[_step]!=null)
            {
                if(c.action==Actions.Wait) c.action = Actions.Run;
                
                _nextTarget = _step==_path.length ? _endTarget : WorldMap.me.tile2WorldPostion(_path[_step][0],_path[_step][1]);
                
                
                var radian:Number = GMath.getPointAngle(_nextTarget.x-c.PosX,_nextTarget.y-c.PosY);
                var angle:int = GMath.R2A(radian)+90;
                
                var xisok:Boolean=false;
                var yisok:Boolean=false;
                
                var xspeed:Number = c.speed*Math.cos(radian);
                var yspeed:Number = c.speed*Math.sin(radian);
                
                
                if(Math.abs(c.PosX-_nextTarget.x)<=xspeed)
                {
                    xisok=true;
                    xspeed=0;
                }
                
                if(Math.abs(c.PosY-_nextTarget.y)<=yspeed)
                {
                    yisok=true;
                    yspeed=0;
                }
                
                moveTo(c.PosX+xspeed,c.PosY+yspeed,c);
                
                if(xisok && yisok)
                {
                    // 走到新的位置点 更新区块坐标					
                    _step++;
                    if(_step>=_path.length)
                    {
                        
                        stopMove();
                        if(_onWalkComplate!=null) _onWalkComplate.apply(null,_onWalkParams);
                        clearWalkComplate();
                    }
                }else{
                    changeDirectionByAngle(angle);
                }
            }
        }
        
        protected function stopMove(trunAction:int = -1):void
        {
            _me.action=trunAction==-1 ? Actions.Wait : trunAction;
            _path=null;
            _step=1;
        }
        
        protected function clearWalkComplate():void
        {
            _onWalkComplate = null;
            if(_onWalkParams)
            {
                _onWalkParams.splice(0,_onWalkParams.length);
                _onWalkParams = null;
            }
        }
        
        /**
         * 键盘控制状态下的动作计算
         */ 
        protected function calcActionKey():void
        {
            if(isStatic) return;
            
            var me:CharacterObject = _me as CharacterObject;
            var nextX:Number=me.PosX;
            var nextY:Number=me.PosY;
            
            
            /**
             * 根据按键状态修改角色朝向，并修改移动方向
             */ 
            switch(xKey)
            {
                case 1:
                    if(yKey==1)
                    {
                        me.setDirectionNum(_me.directions.RightDown);
                        nextX+=me.speed*_k;
                        nextY+=me.speed*_k;
                    }else if(yKey==-1){
                        me.setDirectionNum(_me.directions.RightUp);
                        nextX+=me.speed*_k;
                        nextY-=me.speed*_k;
                    }else{
                        me.setDirectionNum(_me.directions.Right);
                        nextX=me.PosX+me.speed;
                    }
                    break;
                case -1:
                    if(yKey==1)
                    {
                        me.setDirectionNum(_me.directions.LeftDown);
                        nextX-=me.speed*_k;
                        nextY+=me.speed*_k;
                    }else if(yKey==-1){
                        me.setDirectionNum(_me.directions.LeftUp);
                        nextX-=me.speed*_k;
                        nextY-=me.speed*_k;
                    }else{
                        me.setDirectionNum(_me.directions.Left);
                        nextX=me.PosX-me.speed;
                    }
                    break;
                case 0:
                    if(yKey==1)
                    {
                        me.setDirectionNum(_me.directions.Down);
                        nextY=me.PosY+me.speed;
                    }else if(yKey==-1){
                        nextY=me.PosY-me.speed;
                        me.setDirectionNum(_me.directions.Up);
                    }else{
                        if(me.action==Actions.Run) me.action = Actions.Wait;
                        return;
                    }
                    break;
            }
            
            nextCanMove(nextX,nextY,me);
        }
        
        /**
         * 下一目标点是否可以移动
         * for 键盘控制
         */ 
        protected function nextCanMove(nextX:Number,nextY:Number,me:CharacterObject):void
        {
            // 不可移出屏幕
            if(nextX>Global.MAPSIZE.x || nextX<0) return;
            if(nextY>Global.MAPSIZE.y || nextY<0) return;
            
            // 不可移动到地图非0区域
            var p:Point = WorldMap.me.Postion2Tile(nextX,nextY);
            if(WorldMap.me.roadMap && WorldMap.me.roadMap[p.y][p.x]!=0) return;
            
            moveTo(nextX,nextY,me);
        }
        /**
         * 移动主角
         */ 
        protected function moveTo(nextX:Number,nextY:Number,me:CharacterObject):void
        {
            me.setPos(nextX,nextY);
            if(me.action!=Actions.Attack)me.action = Actions.Run;
        }
        
        
        
        
        /**
         * 通知服务器已发生了移动
         * @param	p	移动坐标
         */ 
        protected function tellServerMove(p:Point):void
        {
            // do some thing
        }
        
        /**
         * 点击到了某对象
         * @param	o	触发点击事件的GameObject
         */ 
        protected function clickSomeBody(o:GameObject):void
        {
            // mission click
            var to:NCharacterObject = o as NCharacterObject;
            if(to!=null && to.missionConfig!=null)
            {
                var list:Vector.<MissionData> = to.missionConfig.getList(Global.userdata);
                _perception.Scene.missionCallBack(to.missionConfig.npcname,to.missionConfig.say,to.missionConfig.event,list,to);
            }
            
            // do some thing
        }
        
        /**
         * 鼠标移动侦听，使角色始终面向鼠标
         */ 
        public function onMouseMove(e:MouseEvent):void
        {
            if(isStatic) return;
            
            if(_me==null) return;
            var p:Point = WorldMap.me.getScreenPostion(_me.PosX,_me.PosY);
            var radian:Number = GMath.getPointAngle(e.stageX-p.x,e.stageY-p.y);
            var angle:int = GMath.R2A(radian)+90;
            changeDirectionByAngle(angle);
        }
        /**
         * 鼠标响应驱动
         */ 
        protected function onClick(e:MouseEvent):void
        {
            if(isStatic) return;
            
            // 检查是否点到某对象
            var clicker:GameObject = perception.getClicker(e.stageX,e.stageY);
            if(clicker!=null)
            {
                clickSomeBody(clicker);
                return;
            }
            
            // 计算世界坐标
            _endTarget = WorldMap.me.getWorldPostion(e.stageX,e.stageY).clone();
            
            // 自动清掉后续动作，因为是在控制移动
            clearWalkComplate();
            
            walk2Target();
            
        }
        
        /**
         * 控制角色走向某点
         * 请在本方法执行前设置_endTarget
         * 
         * @return	移动成功，则返回true，移动失败返回false(目标点无法到达)
         */ 
        protected function walk2Target():Boolean
        {
            var me:CharacterObject = _me as CharacterObject;
            //me.action = Actions.Wait;
            
            if(_path==null)
            {
                _path = new Array()
            }else{
                _path.splice(0,_path.length);
            }
            
            // 检查目标点是否可移动
            if(WorldMap.AStar==null)
            {
                var p2:Point = WorldMap.me.Postion2Tile(me.PosX,me.PosY);
                _path.push([p2.x,p2.y]);
                p2 = WorldMap.me.Postion2Tile(_endTarget.x,_endTarget.y);
                _path.push([p2.x,p2.y]);
            }else{
                var p:Point = WorldMap.me.Postion2Tile(_endTarget.x,_endTarget.y);
                if(WorldMap.me.roadMap[p.y][p.x]!=0)
                {
                    _me.action = Actions.Wait;
                    return false;
                }
                // 得出路径
                var nodeArr:Array = WorldMap.AStar.find(me.PosX,me.PosY,_endTarget.x,_endTarget.y);
                if(nodeArr==null)
                {
                    _me.action = Actions.Wait;
                    return false;
                }
                else
                {
                    for(var i:int=0,j:int=nodeArr.length;i<j;i++)
                    {
                        _path.push([nodeArr[i].x,nodeArr[i].y]);
                    }
                }
            }
            _step=1;
            
            // 向服务器发送同步数据
            tellServerMove(_endTarget);
            
            return true;
        }
        
        /**
         * 重置按键状态
         */ 
        protected function resetKeyStatus():void
        {
            wKey = 0;
            aKey = 0;
            sKey = 0;
            dKey = 0;
            xKey = 0;
            yKey = 0;
        }
        
        /**
         * 按键按下侦听
         * 设置不同按键的按下状态
         */ 
        protected function onKeyDown(e:KeyboardEvent):void
        {
            switch(e.keyCode)
            {
                case 87:
                case 38:
                    // W & UP
                    wKey = -1;
                    yKey = -1;
                    break;
                case 65:
                case 37:
                    // A & LEFT
                    aKey = -1;
                    xKey = -1;
                    break;
                case 83:
                case 40:
                    // S & DOWN
                    sKey = 1;
                    yKey = 1;
                    break;
                case 68:
                case 39:
                    // D & RIGHT
                    dKey = 1;
                    xKey = 1;
                    break;
            }
        }
        
        /**
         * 键盘弹起
         */ 
        protected function onKeyUp(e:KeyboardEvent):void
        {
            //if(isStatic) return;
            if((_me as GameObject).action==Actions.Die)
            {
                resetKeyStatus();
                return;
            }
            
            switch(e.keyCode)
            {
                case 87:
                case 38:
                    // W & UP
                    wKey = 0;
                    yKey = 0;
                    break;
                case 65:
                case 37:
                    // A & LEFT
                    aKey = 0;
                    xKey = 0;
                    break;
                case 83:
                case 40:
                    // S & DOWN
                    sKey = 0;
                    yKey = 0;
                    break;
                case 68:
                case 39:
                    // D & RIGHT
                    dKey = 0;
                    xKey = 0;
                    break;
            }
            
            /**
             * 处理相反键触发
             * 防止同时修改x或y的移动状态
             */ 
            if(wKey!=0) yKey = wKey;
            if(sKey!=0) yKey = sKey;
            if(aKey!=0) xKey = aKey;
            if(dKey!=0) xKey = dKey;
        }
        
    }
}