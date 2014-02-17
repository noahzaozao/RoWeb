package
{
    import inoah.core.events.ActTpcEvent;
    import inoah.core.viewModels.actSpr.structs.CACT;
    import inoah.core.viewModels.actSpr.structs.acth.AnyActAnyPat;
    import inoah.core.viewModels.actSpr.structs.acth.AnyPatSprV0101;
    import inoah.interfaces.base.IDisposable;
    import inoah.interfaces.base.ITickable;
    import inoah.utils.Counter;
    
    import starling.animation.IAnimatable;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;
    
    public class TextureClip extends Sprite implements ITickable, IAnimatable, IDisposable
    {
        public static var NULL_TEXTURE:Texture;
        
        protected var _act:CACT;
        
        protected var _animationDisplay:Image;
        
        public function get animationDisplay():Image
        {
            return _animationDisplay;
        }

        protected var _animation:TextureAtlas;
        
        public function get animation():TextureAtlas
        {
            return _animation;
        }
        
        protected var _actionIndex:uint;
        protected var _currentFrame:uint;
        protected var _currentAaap:AnyActAnyPat;
        protected var _baseCounterTarget:Number;
        protected var _counterTarget:Number;
        protected var _counter:Counter;
        protected var _couldTick:Boolean;
        /**
         * 动作速率
         */        
        protected var _currentTargetRate:Number;
        protected var _loop:Boolean;
        
        protected var _currentFrameRate:Number = 1 / 15;
        
        protected var _isPlay:Boolean;
        
        protected var _motionFinishedStop:Boolean;
        
        protected var _motionIsFinished:Boolean;
        
        protected var _isDisposed:Boolean;
        
        public function TextureClip()
        {
            super();
            
            _counter = new Counter();
            _baseCounterTarget = 0.075 ;
            _counterTarget = _baseCounterTarget;
        }
        
        public function get currentAaap():AnyActAnyPat
        {
            return _currentAaap;
        }
        
        public function get counterTargetRate():Number
        {
            return _currentTargetRate;
        }
        
        public function set counterTargetRate( value:Number ):void
        {
            _currentTargetRate = value;
            if( _currentTargetRate >= 1 )
            {
                _currentTargetRate = 0.8;
            }
            _counterTarget = _baseCounterTarget * ( 1-  _currentTargetRate );
        }
        
        public function set actionIndex( value:uint ):void 
        {
            if( _actionIndex != value )
            {
                _actionIndex = value;
                currentFrame = 0;
            }
        }
        
        public function get actionIndex():uint
        {
            return   _actionIndex;
        }
        
        public function get currentFrame():uint
        {
            return _currentFrame;
        }
        
        public function set currentFrame( value:uint ):void
        {
            _currentFrame = value;
        }
        
        public function set loop( value:Boolean ):void
        {
            _loop = value;
        }
        
        public function initAct( cact:CACT  ):void
        {
            _couldTick = false;
            _act = cact;
            actionIndex = 0;
            currentFrame = 0;
            _counter.initialize();
            _counter.reset( _counterTarget );
        }
        
        public function initTpc( resId:String , textureAtlas:TextureAtlas ):void
        {
            _couldTick = false;
            _animation = textureAtlas;
            onInited( _animation );
        }
        
        protected function onInited( textureAtlas:TextureAtlas = null ):void
        {
            _animation = textureAtlas;
            
            actionIndex = 0;
            currentFrame = 0;
            _counter.initialize();
            _counter.reset( _counterTarget );
            
            _animationDisplay = new Image(NULL_TEXTURE);
            _animationDisplay.smoothing = TextureSmoothing.TRILINEAR;
            addChildAt(_animationDisplay, 0);
            _animationDisplay.touchable = true;
            
            _counter.initialize();
            _counter.reset( _counterTarget );
            updateFrame();
            addEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            _couldTick = true;
        }
        
        protected function onStageEventHandle(e:Event = null):void
        {
            switch(e.type)
            {
                case Event.REMOVED_FROM_STAGE:
                {
                    removeEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
                    addEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
                    
                    onRemovedFromStage();
                    break;
                }
                    
                case Event.ADDED_TO_STAGE:
                {
                    removeEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
                    addEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
                    onAddToStage();
                    break;
                }
            }
        }
        
        protected function onAddToStage():void { }
        
        protected function onRemovedFromStage():void  { }
        
        public function advanceTime(time:Number):void
        {
            if(_couldTick == false || _isPlay == false)
            {
                return;
            }
            
            _counter.tick(time);
            var couldRender:Boolean;
            while(_counter.expired == true) //判断是否距离上一帧渲染后已经过了多帧
            {
                if( _act.aall.aa.length <= _actionIndex )
                {
                    _actionIndex = 0;
                    return;
                }
                if(checkMotionIsFinished())
                {
                    if(_motionFinishedStop == true)
                    {
                        if(_motionIsFinished == false)
                        {
                            _motionIsFinished = true;
                            stop();
                            dispatchEvent(new ActTpcEvent( ActTpcEvent.MOTION_FINISHED, true ));
                        }
                        return;
                    }
                    _currentFrame = 0;
                }
                else
                {
                    _currentFrame += 1;
                }
                couldRender = true;
                _counter.reset(_currentFrameRate);
            }
            
            if(couldRender == true)
            {
                updateFrame();
            }
        }
        
        protected function checkMotionIsFinished():Boolean
        {
            return _currentFrame >= _act.aall.aa[_actionIndex].aaap.length - 1;
        }
        
        public function stop():void
        {
            _isPlay = false;
        }
        
        public function play():void
        {
            _isPlay = true;
            _counter.initialize();
            _counter.reset(_currentFrameRate);
            if(_motionIsFinished == true)
            {
                _motionIsFinished = false;
                _currentFrame = 0;
            }
        }
        
        protected function updateFrame():void
        {
            if(_isDisposed == true)
            {
                return;
            }
            
            _currentAaap = _act.aall.aa[_actionIndex].aaap[_currentFrame];
            
            var isExt:Boolean = false;
            if( _currentAaap.apsList.length == 0 )
            {
                return;
            }
            var apsv:AnyPatSprV0101 = _currentAaap.apsList[0];
            if( !apsv )
            {
                return;
            }
            if( apsv.sprNo == 0xffffffff )
            {
                if( _currentAaap.apsList.length > 1)
                {
                    apsv = _currentAaap.apsList[1];
                    isExt = true;
                }
            }
            if( apsv as AnyPatSprV0101 && apsv.sprNo != 0xffffffff )
            {
                var mTexture:Texture = _animation.getTexture( apsv.sprNo.toString() );
                if( mTexture )
                {
                    _animationDisplay.texture = mTexture ;
                }
                if( apsv.mirrorOn == 0 )
                {
                    _animationDisplay.x = int(-_animationDisplay.texture.width / 2 + apsv.xOffs);
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs);
                    _animationDisplay.scaleX = 1;
                }
                else
                {
                    _animationDisplay.x = int(_animationDisplay.texture.width / 2 + apsv.xOffs);
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs);
                    _animationDisplay.scaleX = -1;
                }
                _animationDisplay.readjustSize();
            }
        }
        
        public function tick(delta:Number):void
        {
            advanceTime(delta);
        }
        
        protected function distruct():void
        {
            _animation.dispose();
            _animationDisplay.removeFromParent(true);
            _animationDisplay = null;
            _couldTick = false;
            super.dispose();
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
        
        override public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                distruct();
            }
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
    }
}