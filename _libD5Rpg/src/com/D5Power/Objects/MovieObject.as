package com.D5Power.Objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Objects.Effects.Shadow;
    import com.D5Power.graphicsManager.GraphicsResource;
    import com.D5Power.ns.NSCamera;
    
    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    use namespace NSCamera;
    
    public class MovieObject extends GameObject implements IFrameRender
    {
        public static const BOTTOM:uint = 1;
        
        public static const LEFTTOP:uint = 0;
        
        public static const CENTER:uint = 2;
        
        /**
         * 图形资源
         */ 
        protected var _graphics:GraphicsResource;
        //		protected var _graphics:GraphicsResource;
        
        /**
         * 主渲染
         */ 
        protected var _renderBuffer:Bitmap;
        
        /**
         * 显示阴影
         */ 
        protected var _shadow:Shadow;
        
        /**
         * 是否使用alpha通道
         */ 
        protected var _allowAlpha:Boolean=true;
        
        /**
         * 渲染矩阵
         */ 
        protected var _renderRect:Rectangle;
        
        /**
         * 方向配置
         */ 
        protected var _directionConfig:Direction;
        
        /**
         * 行动方向  默认为8个方向 配置见Directions对象
         */			
        protected var _directionNum:int=1;
        
        /**
         * 当前帧数
         */ 
        protected var _currentFrame:uint=0;
        
        /**
         * 上一帧数
         */ 
        protected var _lastFrame:uint=0;
        
        /**
         * 动画最大帧数
         */ 
        protected var _FrameTotal:uint = 0;
        
        /**
         * 是否循环
         */ 
        protected var _loop:Boolean = true;
        
        /**
         * 非循环动作是否播放完毕
         */ 
        protected var loopPlayEnd:Boolean=false;
        
        /**
         * 播放时间间隔
         */ 
        protected var _playTime:uint;
        
        /**
         * 渲染方式
         */ 
        protected var _renderPos:uint;
        
        /**
         * 上一帧的播放时间，用于计算两帧间的时间差
         */ 
        private var _lastFrameTime:uint;
        
        private var _needChangeFrame:Boolean=false;
        
        public function MovieObject(ctrl:BaseControler=null,dir:Direction=null)
        {
            _directionConfig = dir==null ? DEFAULT_DIRECTION : dir;
            _lastFrameTime = Global.Timer;
            _renderRect = new Rectangle();
            _renderPos = LEFTTOP;
            setupBuffer();
            super(ctrl);
        }
        
        public function set currentFrame(value:int):void
        {
            _currentFrame=value;
        }
        
        public function get currentFrame():int
        {
            return _currentFrame;
        }
        
        
        public function get lastFrame():int
        {
            return _lastFrame;
        }
        
        public function set Loop(b:Boolean):void
        {
            _loop = b;
            loopPlayEnd = false;
        }
        
        public function get isKeepStatic():Boolean
        {
            return !_loop && loopPlayEnd;
        }
        
        public function get needChangeFrame():Boolean
        {
            return _needChangeFrame;
        }
        
        public function set needChangeFrame(v:Boolean):void
        {
            _needChangeFrame = v;
        }
        
        /**
         * 影子
         */ 
        public function get shadow():Shadow
        {
            return _shadow;
        }
        
        /**
         * 面向角度
         */ 
        override public function get Angle():uint
        {
            switch(_directionNum)
            {
                case _directionConfig.Up:
                    return 0;
                    break;
                case _directionConfig.LeftUp:
                    return 315;
                    break;
                case _directionConfig.Left:
                    return 270;
                    break;
                case _directionConfig.LeftDown:
                    return 215;
                    break;
                case _directionConfig.Down:
                    return 180;
                    break;
                case _directionConfig.RightDown:
                    return 135;
                    break;
                case _directionConfig.Right:
                    return 90;
                    break;
                case _directionConfig.RightUp:
                    return 45;
                    break;
                default:
                    return 0;
                    break;
            }
        }
        
        public function set directions(v:Direction):void
        {
            _directionConfig = v;
            _directionNum = v.Down;
        }
        
        override public function get directions():Direction
        {
            return _directionConfig;
        }
        
        /**
         * 图形资源
         */ 
        public function get graphicsRes():GraphicsResource
        {
            return _graphics;
        }
        
        /**
         * 图形资源
         */ 
        public function set graphicsRes(value:GraphicsResource):void
        {
            _graphics=value;
            if(_graphics.frameWidth==0)
            {
                var timer:Timer = new Timer(500);
                timer.addEventListener(TimerEvent.TIMER,waitResLoad);
                timer.start();
            }else{
                build();
            }
        }
        
        /**
         * 方向值
         */ 
        override public function get directionNum():int
        {
            return _directionNum;
        }
        
        override public function setDirectionNum(v:int):void
        {
            _directionNum=v;
            RenderUpdated = false;
        }
        
        /**
         * 是否中央渲染
         */ 
        override public function get renderPos():uint
        {
            return _renderPos;
        }
        
        /**
         * 渲染矩形
         */
        public function get renderRect():Rectangle
        {
            if(_graphics.framesTotal==1)
            {
                _renderRect.x = 0;
                _renderRect.y = 0;
                _renderRect.width = _graphics.frameWidth;
                _renderRect.height = _graphics.frameHeight;
            }else{
                _renderRect.x = currentFrame*_graphics.frameWidth;
                _renderRect.y = Math.abs(directionNum)*_graphics.frameHeight;
                _renderRect.width = _graphics.frameWidth;
                _renderRect.height = _graphics.frameHeight;
            }
            return _renderRect;
        }
        
        
        /**
         * 清除
         */ 
        override public function dispose():void
        {
            if(_graphics!=null)
            {
                _graphics.clear();
                _graphics=null;
            }
            
            super.dispose();
        }
        
        override public function get renderLine():uint
        {
            return Math.abs(_directionNum);
        }
        
        override public function get renderFrame():uint
        {
            return _currentFrame;
        }
        
        /**
         * 创建主渲染缓冲区
         */ 
        override protected function build():void
        {
            if(!contains(_renderBuffer)) addChild(_renderBuffer);
            RenderUpdated=false;
            flyPos();
            updateFPS()
        }
        
        protected function updateFPS():void
        {
            _FrameTotal = _graphics.getFrameTotal();
            _playTime = 1000/_graphics.fps;
        }
        
        protected function enterFrame():Boolean
        {
            if(_graphics==null || _graphics.fps==0) return false;
            if(Global.Timer-_lastFrameTime>=_playTime && !loopPlayEnd)
            {
                _lastFrameTime = Global.Timer;
                _lastFrame = _currentFrame;
                
                if(_currentFrame>=_FrameTotal-1)
                {
                    _loop ? _currentFrame=0 : loopPlayEnd=true;
                }else{
                    _currentFrame++;
                }
                
                _needChangeFrame = true;
            }
            return true;
        }
        
        override protected function renderAction():void
        {
            enterFrame();
        }
        
        protected function waitResLoad(e:TimerEvent):void
        {
            var target:Timer = e.target as Timer;
            if(_graphics!=null && _graphics.frameWidth!=0)
            {
                target.stop();
                target.removeEventListener(TimerEvent.TIMER,waitResLoad);
                target = null;
                build();
            }
        }
        
        /**
         * 设置相对坐标
         */ 
        protected function flyPos(px:Number=NaN,py:Number=NaN):void
        {
            if(px && py)
            {
                _renderBuffer.x = -px;
                _renderBuffer.y = -py;
            }else if(_graphics!=null){
                _renderBuffer.x = -_graphics.frameWidth/2;
                _renderBuffer.y = -_graphics.frameHeight;
            }
        }
        
        protected function setupBuffer():void
        {
            _renderBuffer = new Bitmap();
        }
        
    }
}