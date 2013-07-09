package com.D5Power.particle
{
    import com.D5Power.map.WorldMap;
    
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    /**
     * 粒子
     */ 
    public class Particle extends Shape
    {
        
        private static const ALPHA_MODE:uint=1;
        private static const DISTANCE_MODE:uint=2;
        
        private var _workMode:uint;
        /**
         * 移动角度(弧度)
         */ 
        private var _moveAngle:Number;
        /**
         * 移动距离
         */ 
        internal var _moveDistance:uint;
        
        /**
         * alpha速度
         */ 
        internal var _alphaSpeed:Number;
        
        /**
         * 移动速度
         */ 
        internal var _moveSpeed:Number;
        
        /**
         * 缩放速度
         */ 
        internal var _zoomSpeed:Number=1;
        
        /**
         * 游戏对象
         */ 
        internal var _goMode:Boolean;
        
        /**
         * 链表
         */ 
        internal var next:Particle;
        /**
         * 链表
         */
        internal var prev:Particle;
        
        private var _speedX:Number = 0;
        
        private var _speedY:Number = 0;
        
        private var _runx:Number;
        
        private var _runy:Number;
        
        private var _nowBitmap:BitmapData;
        
        /**
         * 飞行距离
         */
        private var _flyDistance:Number;
        
        /**
         * 飞行起始坐标
         */ 
        private var _startx:Number;
        /**
         * 飞行起始坐标
         */
        private var _starty:Number;
        
        
        public function Particle()
        {
            super();
        }
        
        public function render():void
        {
            run();
        }
        
        public function set flyDistance(dis:Number):void
        {
            _flyDistance = dis*dis;
            _workMode = DISTANCE_MODE;
        }
        
        /**
         * 运行速度
         */ 
        public function set moveSpeed(v:Number):void
        {
            _moveSpeed = v;
        }
        
        public function set GOMode(v:Boolean):void
        {
            _goMode = v;
        }
        
        /**
         * 运行角度
         */ 
        public function set moveAngle(v:int):void
        {
            _moveAngle = v/180*Math.PI;
        }
        
        /**
         * 运行弧度
         */ 
        public function set moveRadian(v:Number):void
        {
            _moveAngle = v;
        }
        
        /**
         * 缩放
         */ 
        public function set zoomSpeed(v:Number):void
        {
            if(v<0)
            {
                trace("[D5Particle] 粒子的缩放速度必须大于0");
                return;
            }
            _zoomSpeed = v;
        }
        
        public function set alphaSpeed(v:Number):void
        {
            if(v>0) v = -v;
            
            _alphaSpeed = v;
            _workMode = ALPHA_MODE;
        }
        
        /**
         * 开始运行
         */ 
        public function start():void
        {		
            _runx = x;
            _runy = y;
            
            if(_workMode==DISTANCE_MODE)
            {
                _startx = _runx;
                _starty = _runy;
            }
            
            _speedX = _moveSpeed*Math.cos(_moveAngle);
            _speedY = _moveSpeed*Math.sin(_moveAngle);
            run();
        }
        
        public function set bitmapFace(b:BitmapData):void
        {
            if(b==_nowBitmap) return;
            
            _nowBitmap = null;
            
            graphics.clear();
            graphics.beginBitmapFill(b,new Matrix(1,0,0,1,-b.width>>1,-b.height>>1),false);
            graphics.drawRect(-int(b.width>>1),-int(b.height>>1),b.width,b.height);
            graphics.endFill();
        }
        
        /**
         * 粒子运转
         */ 
        internal function run():void
        {
            _runx+=_speedX;
            _runy+=_speedY;
            if(_zoomSpeed!=1)
            {
                scaleX = scaleX*_zoomSpeed;
                scaleY = scaleY*_zoomSpeed;
            }
            
            if(_alphaSpeed) alpha+=_alphaSpeed;
            
            if(_goMode)
            {
                // 游戏对象模式
                var target:Point = WorldMap.me.getScreenPostion(_runx,_runy);
                x = target.x;
                y = target.y;
            }else{
                x = int(_runx);
                y = int(_runy);
            }
            
            
            switch(_workMode)
            {
                case ALPHA_MODE:
                    if(alpha<=0) die();
                    break;
                case DISTANCE_MODE:
                    var cx:int = _startx-_runx;
                    var cy:int = _starty-_runy;
                    
                    if(cx*cx+cy*cy >= _flyDistance) die();
                    break;
            }
        }
        
        /**
         * 检查动作是否结束
         */ 
        protected function checkOver():void
        {
            
        }
        
        protected function die():void
        {
            if(parent) parent.removeChild(this);
            ParticleBox.me.remove(this);
        }
        
        protected function dispose():void
        {
            _nowBitmap = null;
            graphics.clear();
        }
    }
}