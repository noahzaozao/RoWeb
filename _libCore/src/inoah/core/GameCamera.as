package inoah.core
{
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    import inoah.core.base.BaseObject;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.ISceneMediator;
    
    /**
     * 摄像机控制类
     */ 
    public class GameCamera implements ICamera
    {
        [Inject]
        public var sceneMediator:ISceneMediator;
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
        
        public function GameCamera()
        {
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
            
            var value:Number = Global.MAP_W-Global.SCREEN_W;
            _zeroX = _zeroX<0 ? 0 : _zeroX;
            _zeroX = _zeroX>value ? value : _zeroX;
            
            value = Global.MAP_H-Global.SCREEN_H;
            _zeroY = _zeroY<0 ? 0 : _zeroY;
            _zeroY = _zeroY>value ? value : _zeroY;
        }
        
        public function update():void
        {
            if(_focus)
            {
                _zeroX = _focus.posX - (Global.SCREEN_W>>1);
                _zeroY = _focus.posY - (Global.SCREEN_H>>1);
                
                var value:Number = Global.MAP_W-Global.SCREEN_W;
                _zeroX = _zeroX<0 ? 0 : _zeroX;
                _zeroX = _zeroX>value ? value : _zeroX;
                
                value = Global.MAP_H-Global.SCREEN_H;
                _zeroY = _zeroY<0 ? 0 : _zeroY;
                _zeroY = _zeroY>value ? value : _zeroY;
            }
            
            _cameraView.x = _zeroX;
            _cameraView.y = _zeroY;
            
            _cameraView.width = Global.SCREEN_W;
            _cameraView.height = Global.SCREEN_H;
        }
        
        /**
         * 镜头注视
         */ 
        public function focus(o:BaseObject=null):void
        {
            _focus = o;
            update();
            sceneMediator.ReCut();
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
            
            zero_x-=Global.TILE_W*2;
            zero_y-=zero_y-Global.TILE_H*2;
            
            zero_x = zero_x<0 ? 0 : zero_x;
            zero_y = zero_y<0 ? 0 : zero_y;
            
            
            _cameraCutView.x = zero_x;
            _cameraCutView.y = zero_y;
            _cameraCutView.width = Global.SCREEN_W+Global.TILE_W*2;
            _cameraCutView.height = Global.SCREEN_H+Global.TILE_H*2;
            
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
            sceneMediator.ReCut();
        }
        /**
         * 镜头向下
         */
        public function moveSourth(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX,_zeroY+_moveSpeed*k);
            sceneMediator.ReCut();
        }
        /**
         * 镜头向左
         */
        public function moveWest(k:uint=1):void
        {
            if(_moveSpeed==0 || _zeroX==0) return;
            this.focus(null);
            setZero(_zeroX-_moveSpeed*k,_zeroY);
            sceneMediator.ReCut();
        }
        /**
         * 镜头向右
         */
        public function moveEast(k:uint=1):void
        {
            if(_moveSpeed==0) return;
            this.focus(null);
            setZero(_zeroX+_moveSpeed*k,_zeroY);
            sceneMediator.ReCut();
        }
        
        public function move(xdir:int,ydir:int,k:uint=1):void
        {
            this.focus(null);
            setZero(_zeroX+_moveSpeed*xdir*k,_zeroY+_moveSpeed*ydir*k);
            sceneMediator.ReCut();
        }
        
        /**
         * 镜头观察某点
         */ 
        public function lookAt(x:uint,y:uint):void
        {
            this.focus(null);
            setZero(x-(Global.SCREEN_W>>1),y-(Global.SCREEN_H>>1));
            sceneMediator.ReCut();
        }
        
        public function flyTo(x:uint,y:uint,callback:Function=null):void
        {
            if(_timer!=null)
            {
                trace("[ROCamera] Camera is moving,can not do this operation.");
                return;
            }
            this.focus(null);
            _moveCallBack = callback;
            
            _moveStart = new Point(_zeroX-(Global.SCREEN_W>>1),_zeroY-(Global.SCREEN_H>>1));
            
            _moveEnd = new Point(x-(Global.SCREEN_W>>1),y-(Global.SCREEN_H>>1));
            
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
                sceneMediator.ReCut();
                if(_moveCallBack!=null) _moveCallBack();
            }
        }
    }
}