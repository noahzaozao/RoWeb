package com.D5Power
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.map.WorldMap;
    import com.D5Power.ns.NSCamera;
    import com.D5Power.scene.BaseScene;
    
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    use namespace NSCamera;
    
    /**
     * 摄像机控制类
     */ 
    public class D5Camera
    {
        /**
         * 当游戏对象进出场景时，是否进行Alpha效果渐变
         */ 
        public static var AlphaEffect:Boolean=false;
        
        /**
         * 当游戏对象进出场景时，是否进行Alpha效果渐变
         */ 
        public static var ZorderTime:uint = 1000;
        
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
        NSCamera static var $needReCut:Boolean;
        
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
        protected var _scene:BaseScene;
        /**
         * 镜头注视
         */ 
        protected var _focus:GameObject;
        
        protected var _timer:Timer;
        
        protected var _moveSpeed:uint;
        
        private var _moveStart:Point;
        private var _moveEnd:Point;
        private var _moveAngle:Number=0;
        private var _moveCallBack:Function;
        
        public static function get needReCut():Boolean
        {
            return $needReCut;
        }
        
        public function D5Camera(scene:BaseScene)
        {
            _scene = scene;
            if(_cameraView==null) _cameraView = new Rectangle();
            _cameraCutView = new Rectangle();
        }
        
        public function get zeroX():uint
        {
            return _zeroX;
        }
        
        public function get zeroY():uint
        {
            return _zeroY;
        }
        
        public function setZero(x:int,y:int):void
        {
            _zeroX = x;
            _zeroY = y;
            
            var value:Number = Global.MAPSIZE.x-Global.W;
            _zeroX = _zeroX<0 ? 0 : _zeroX;
            _zeroX = _zeroX>value ? value : _zeroX;
            
            value = Global.MAPSIZE.y-Global.H;
            _zeroY = _zeroY<0 ? 0 : _zeroY;
            _zeroY = _zeroY>value ? value : _zeroY;
        }
        
        public function update():void
        {
            if(_focus)
            {
                _zeroX = _focus.PosX - (Global.W>>1);
                _zeroY = _focus.PosY - (Global.H>>1);
                
                var value:Number = Global.MAPSIZE.x-Global.W;
                _zeroX = _zeroX<0 ? 0 : _zeroX;
                _zeroX = _zeroX>value ? value : _zeroX;
                
                value = Global.MAPSIZE.y-Global.H;
                _zeroY = _zeroY<0 ? 0 : _zeroY;
                _zeroY = _zeroY>value ? value : _zeroY;
            }
            
            _cameraView.x = _zeroX;
            _cameraView.y = _zeroY;
            
            _cameraView.width = Global.W;
            _cameraView.height = Global.H;
        }
        
        /**
         * 镜头注视
         */ 
        public function focus(o:GameObject=null):void
        {
            _focus = o;
            update();
            _scene.ReCut();
            WorldMap.me.render(true);
        }
        
        public function get focusObject():GameObject
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
            
            zero_x-=Global.TILE_SIZE.x*2;
            zero_y-=zero_y-Global.TILE_SIZE.y*2;
            
            zero_x = zero_x<0 ? 0 : zero_x;
            zero_y = zero_y<0 ? 0 : zero_y;
            
            
            _cameraCutView.x = zero_x;
            _cameraCutView.y = zero_y;
            _cameraCutView.width = Global.W+Global.TILE_SIZE.x*2;
            _cameraCutView.height = Global.H+Global.TILE_SIZE.y*2;
            
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
            _scene.ReCut();
        }
        /**
         * 镜头向下
         */
        public function moveSourth(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX,_zeroY+_moveSpeed*k);
            _scene.ReCut();
        }
        /**
         * 镜头向左
         */
        public function moveWest(k:uint=1):void
        {
            if(_moveSpeed==0 || _zeroX==0) return;
            this.focus(null);
            setZero(_zeroX-_moveSpeed*k,_zeroY);
            _scene.ReCut();
        }
        /**
         * 镜头向右
         */
        public function moveEast(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX+_moveSpeed*k,_zeroY);
            _scene.ReCut();
        }
        
        public function move(xdir:int,ydir:int,k:uint=1):void
        {
            this.focus(null);
            setZero(_zeroX+_moveSpeed*xdir*k,_zeroY+_moveSpeed*ydir*k);
            _scene.ReCut();
        }
        
        /**
         * 镜头观察某点
         */ 
        public function lookAt(x:uint,y:uint):void
        {
            this.focus(null);
            setZero(x-(Global.W>>1),y-(Global.H>>1));
            _scene.ReCut();
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
            
            _moveStart = new Point(_zeroX-(Global.W>>1),_zeroY-(Global.H>>1));
            
            _moveEnd = new Point(x-(Global.W>>1),y-(Global.H>>1));
            
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
                _scene.ReCut();
                if(_moveCallBack!=null) _moveCallBack();
            }
        }
    }
}