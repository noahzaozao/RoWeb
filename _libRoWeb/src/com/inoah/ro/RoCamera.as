package com.inoah.ro
{
    import com.inoah.ro.maps.BaseMap;
    import com.inoah.ro.objects.BaseObject;
    
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    /**
     * 摄像机控制类
     */ 
    public class RoCamera
    {
        /**
         * 当游戏对象进出场景时，是否进行Alpha效果渐变
         */ 
        public static var AlphaEffect:Boolean=false;
        
        /**
         * 当游戏对象进出场景时，是否进行Alpha效果渐变
         */ 
        public static var ZorderTime:uint = 150;
        
        /**
         * 分布渲染时间限制。每次渲染的最大允许占用时间，单位毫秒
         */ 
        public static var RenderMaxTime:uint = 10;
        
        /**
         * 摄像机可视区域
         */ 
        private static var _cameraView:Rectangle;
        
        /**
         * 是否需要重新裁剪
         */ 
        private static var _needReCut:Boolean;
        
        private var _cameraCutView:Rectangle;
        
        /**
         * 视口左上角对应的世界坐标X
         */ 
        protected var _zeroX:Number;
        /**
         * 视口左上角对应的世界坐标Y
         */ 
        protected var _zeroY:Number;
        
        /**
         * 主场景
         */ 
        protected var _map:BaseMap;
        /**
         * 镜头注视
         */ 
        protected var _focus:BaseObject;
        
        protected var _timer:Timer;
        
        protected var _moveSpeed:uint;
        
        private var _moveStart:Point;
        private var _moveEnd:Point;
        private var _moveAngle:Number=0;
        private var _moveCallBack:Function;
        
        public static function set needReCut( value:Boolean ):void
        {
            _needReCut = value;
        }
        public static function get needReCut():Boolean
        {
            return _needReCut;
        }
        
        public function RoCamera( map:BaseMap )
        {
            _map = map;
            if(_cameraView==null)
            {
                _cameraView = new Rectangle();
            }
            _cameraCutView = new Rectangle();
        }
        
        public function get zeroX():Number
        {
            return _zeroX;
        }
        
        public function get zeroY():Number
        {
            return _zeroY;
        }
        
        public function setZero(x:int,y:int):void
        {
            _zeroX = x;
            _zeroY = y;
            
            var value:Number = RoGlobal.MAP_W-RoGlobal.W;
            _zeroX = _zeroX<0 ? 0 : _zeroX;
            _zeroX = _zeroX>value ? value : _zeroX;
            
            value = RoGlobal.MAP_H-RoGlobal.H;
            _zeroY = _zeroY<0 ? 0 : _zeroY;
            _zeroY = _zeroY>value ? value : _zeroY;
        }
        
        public function update():void
        {
            if(_focus)
            {
                _zeroX = _focus.posX - (RoGlobal.W>>1);
                _zeroY = _focus.posY - (RoGlobal.H>>1);
                
                var value:Number = RoGlobal.MAP_W-RoGlobal.W;
                _zeroX = _zeroX<0 ? 0 : _zeroX;
                _zeroX = _zeroX>value ? value : _zeroX;
                
                value = RoGlobal.MAP_H-RoGlobal.H;
                _zeroY = _zeroY<0 ? 0 : _zeroY;
                _zeroY = _zeroY>value ? value : _zeroY;
            }
            
            _cameraView.x = _zeroX;
            _cameraView.y = _zeroY;
            
            _cameraView.width = RoGlobal.W;
            _cameraView.height = RoGlobal.H;
        }
        
        /**
         * 镜头注视
         */ 
        public function focus(o:BaseObject=null):void
        {
            _focus = o;
            update();
            _map.ReCut();
        }
        
        public function get focusObject():BaseObject
        {
            return _focus;
        }
        
        /**
         * 镜头移动速度
         */ 
        public function set moveSpeed(s:uint):void
        {
            _moveSpeed = s;
        }
        
        /**
         * 镜头视野矩形
         * 返回镜头在世界地图内测区域
         */ 
        public static function get cameraView():Rectangle
        {
            return _cameraView;
        }
        
        /**
         * 镜头裁剪视野
         */ 
        public function get cameraCutView():Rectangle
        {
            var zero_x:int = _zeroX;
            var zero_y:int = _zeroY;
            
            zero_x-=RoGlobal.TILE_W*2;
            zero_y-=zero_y-RoGlobal.TILE_H*2;
            
            zero_x = zero_x<0 ? 0 : zero_x;
            zero_y = zero_y<0 ? 0 : zero_y;
            
            
            _cameraCutView.x = zero_x;
            _cameraCutView.y = zero_y;
            _cameraCutView.width = RoGlobal.W+RoGlobal.TILE_W*2;
            _cameraCutView.height = RoGlobal.H+RoGlobal.TILE_H*2;
            
            return _cameraCutView;
        }
        
        /**
         * 镜头向上
         * @param	k	倍率
         */ 
        public function moveNorth(k:uint=1):void
        {
            if(_moveSpeed==0 || _zeroY==0) return;
            this.focus(null);
            setZero(_zeroX,_zeroY-_moveSpeed*k);
            _map.ReCut();
        }
        /**
         * 镜头向下
         */
        public function moveSourth(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX,_zeroY+_moveSpeed*k);
            _map.ReCut();
        }
        /**
         * 镜头向左
         */
        public function moveWest(k:uint=1):void
        {
            if(_moveSpeed==0 || _zeroX==0) return;
            this.focus(null);
            setZero(_zeroX-_moveSpeed*k,_zeroY);
            _map.ReCut();
        }
        /**
         * 镜头向右
         */
        public function moveEast(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX+_moveSpeed*k,_zeroY);
            _map.ReCut();
        }
        
        public function move(xdir:int,ydir:int,k:uint=1):void
        {
            this.focus(null);
            setZero(_zeroX+_moveSpeed*xdir*k,_zeroY+_moveSpeed*ydir*k);
            _map.ReCut();
        }
        
        /**
         * 镜头观察某点
         */ 
        public function lookAt(x:uint,y:uint):void
        {
            this.focus(null);
            setZero(x-(RoGlobal.W>>1),y-(RoGlobal.H>>1));
            _map.ReCut();
        }
        
        public function flyTo(x:uint,y:uint,callback:Function=null):void
        {
            if(_timer!=null)
            {
                trace("[D5Camera] Camera is moving,can not do this operation.");
                return;
            }
            this.focus(null);
            _moveCallBack = callback;
            
            _moveStart = new Point(_zeroX-(RoGlobal.W>>1),_zeroY-(RoGlobal.H>>1));
            
            _moveEnd = new Point(x-(RoGlobal.W>>1),y-(RoGlobal.H>>1));
            
            _timer = new Timer(50);
            _timer.addEventListener(TimerEvent.TIMER,moveCamera);
            _timer.start();
        }
        
        protected function moveCamera(e:TimerEvent):void
        {
            var xspeed:Number = (_moveEnd.x-_moveStart.x)/5;
            var yspeed:Number = (_moveEnd.y-_moveStart.y)/5;
            _moveStart.x += xspeed;
            _moveStart.y += yspeed;
            setZero(_moveStart.x,_moveStart.y);
            if((xspeed>-.5 && xspeed<.5) && (yspeed>-.5 && yspeed<.5))
            {
                //_scene.Map.$Center = _moveEnd;
                _moveEnd = null;
                _timer.stop();
                _timer.removeEventListener(TimerEvent.TIMER,moveCamera);
                _timer = null;
                _map.ReCut();
                if(_moveCallBack!=null) _moveCallBack();
            }
        }
    }
}