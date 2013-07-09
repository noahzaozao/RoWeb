package com.D5Power.Controler
{
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    /**
     * 由电脑控制的玩家对象的控制器
     * 
     */ 
    public class NCharacterControler extends BaseControler
    {
        /**
         * 移动路径
         */ 
        protected var _path:Array;
        /**
         * 移动步骤
         */ 
        protected var _step:uint = 1;
        /**
         * 是否循环移动
         */ 
        private var _isloop:Boolean=false;
        
        /**
         * 移动弧度值
         */ 
        protected var _moveRadian:Number;
        
        
        public function NCharacterControler(pec:Perception)
        {
            super(pec);
        }
        protected var _callback:Function;
        public function moveTo(x:Number,y:Number,callback:Function=null):void
        {
            if(x==_me.PosX && y==_me.PosY) return;
            _callback = callback;
            
            _endTarget = new Point(x,y);
            
            // 计算格子数
            var end:Point   = WorldMap.me.Postion2Tile(_endTarget.x,_endTarget.y).clone();
            
            var start:Point = WorldMap.me.Postion2Tile(_me.PosX,_me.PosY).clone();
            
            //_me.action = Actions.Stop;
            
            // 得出路径
            //			_path = AStar.startSearch(m.roadMap,startX,startY,tileX,tileY);
            _path = new Array(new Array(end.x,end.y));//trace([start.x,start.y],[end.x,end.y]);
            _step=0;
        }
        
        /**
         * 沿某路径移动
         * @param	args	世界地图的坐标点序列，必须为偶数。以x,y,x1,y1,x2,y2的方式排列
         */ 
        public function moveInPath(...args):void
        {
            if(args.length%2!=0)
            {
                Global.msg('路径点必须是偶数');
                return;
            }
            
            var arr:Point;
            
            _path = new Array();
            
            arr = WorldMap.me.Postion2Tile(_me.PosX,_me.PosY);
            
            
            for(var i:uint=0;i<args.length;i+=2)
            {
                arr = WorldMap.me.Postion2Tile(args[i],args[i+1]);
                _path.push(new Array(arr.x,arr.y));
            }
            _step=0;
        }
        
        /**
         * 是否循环移动
         */ 
        public function set loop(b:Boolean):void
        {
            _isloop = b;
        }
        
        /**
         * 立即停止移动
         * @param	turnAction	切换到的目标动作。默认为Wait
         */ 
        public function stopMove(trunAction:int = -1):void
        {
            _nextTarget=null;
            if(_path) _path.splice(0,_path.length);
            _path=null;
            _endTarget=null;
            _step = 0;
            _me.action=trunAction==-1 ? Actions.Wait : trunAction;
            if(_callback!=null)
            {
                _callback(_me);
                _callback = null;
            }
        }
        
        /**
         * 计算行动
         */ 
        override public function calcAction():void
        {
            super.calcAction();
            
            var c:CharacterObject = _me as CharacterObject;
            
            if(_path!=null && _path[_step]!=null){
                // 电脑直接控制类处理
                _nextTarget = _step==_path.length ? _endTarget : WorldMap.me.tile2WorldPostion(_path[_step][0],_path[_step][1]);
            }
            
            
            if(_nextTarget!=null && _nextTarget!=c._POS)
            {
                //                if(!_me.inScene)
                //                {
                //                    _step++;
                //                    _me.setPos(_nextTarget.x,_nextTarget.y);
                //                    if(_step>=_path.length)
                //                    {
                //                        if(_isloop)
                //                        {
                //                            // 循环
                //                            _step = 0;
                //                        }else{
                //                            stopMove();
                //                        }
                //                    }
                //                    return;
                //                }
                
                c.action = Actions.Run;
                
                _moveRadian = GMath.getPointAngle(_nextTarget.x-c.PosX,_nextTarget.y-c.PosY);
                var angle:int = GMath.R2A(_moveRadian)+90;
                
                var xisok:Boolean=false;
                var yisok:Boolean=false;
                
                var xspeed:Number = c.speed*Math.cos(_moveRadian);
                var yspeed:Number = c.speed*Math.sin(_moveRadian);
                
                
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
                
                c.setPos(c.PosX+xspeed,c.PosY+yspeed);
                
                if(xisok && yisok)
                {
                    _step++;
                    c.setPos(_nextTarget.x,_nextTarget.y);
                    if(_step>=_path.length)
                    {
                        if(_isloop)
                        {
                            // 循环
                            _step = 0;
                        }else{
                            stopMove();
                        }
                    }
                }else{
                    changeDirectionByAngle(angle);
                }
            }// if
        }// function calcAction
    }
}