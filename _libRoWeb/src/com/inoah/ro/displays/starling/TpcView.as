package com.inoah.ro.displays.starling
{
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.displays.starling.structs.TPAnimation;
    import com.inoah.ro.displays.starling.structs.TPSequence;
    import com.inoah.ro.events.TPAnimationEvent;
    import com.inoah.ro.events.TPMovieClipEvent;
    import com.inoah.ro.interfaces.ITickable;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    
    public class TpcView extends Sprite implements ITickable, IAnimatable
    {
        protected static const NULL_TEXTURE:Texture = Texture.fromBitmapData(new BitmapData(1,1,true,0));
        protected var _tpAnimation:TPAnimation;
        protected var _animationDisplay:Image;
        protected var _counter:Counter;
        protected var _animationUnitList:Object;
        protected var _currentFrame:int;
        protected var _couldTick:Boolean;
        protected var _isDisposed:Boolean;
        protected var _motionFinishedStop:Boolean;
        protected var _threshold:int;
        protected var _isPlay:Boolean;
        protected var _motionIsFinished:Boolean;
        protected var _currentFrameRate:Number;
        protected var _currentActionFrames:Vector.<TPSequence>;;
        protected var _currentAction:int = -1
        
        public function TpcView()
        {
            
        }
        
        public function init( data:ByteArray ):void
        {
            var cactData:ByteArray = new ByteArray();
            _tpAnimation = new TPAnimation();
            _tpAnimation.addEventListener( TPAnimationEvent.INITIALIZED, onInited );
            _tpAnimation.decode( data );
        }
        
        protected function onInited( e:Event):void
        {
            _counter = new Counter();
            _animationUnitList = new Vector.<IAnimatable>();
            //初始化第1帧
            _currentFrame = 0;
            _animationDisplay = new Image(NULL_TEXTURE);
            _animationDisplay.smoothing = TextureSmoothing.TRILINEAR;
            switchAction();
            addChildAt(_animationDisplay, 0);
            _animationDisplay.touchable = true;
            //            addEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            _couldTick = true;
        }
        
        public function switchAction( actionIndex:uint = 0, force:Boolean = false):Boolean
        {
            if(_currentAction == actionIndex && force == false)
            {
                return false;
            }
            
            var nextActionFrames:Vector.<TPSequence> = _tpAnimation.getAnimation( actionIndex );
            if(!nextActionFrames)
            {
                return false;
            }
            var len:int = nextActionFrames.length;
            for(var i:int = 0; i<len; i++)
            {
                if(nextActionFrames[i] == null)
                {
                    nextActionFrames.splice(i,1);
                    len--;
                    i--;
                }
            }
            _currentAction = actionIndex;
            
            if(nextActionFrames == null || 
                nextActionFrames.length == 0 )
            {
                trace("try to switch unknow action{"+actionIndex+"}!");
                return false
            }
            
            _currentActionFrames = nextActionFrames;
            _currentFrameRate = 0.075;
            _counter.initialize();
            _counter.reset(_currentFrameRate);
            _motionIsFinished = false;
            initNextAction( actionIndex );
            return true;
        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
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
        
        public function updateAnimation(animation:TPAnimation):void
        {
            if(_tpAnimation == animation)
            {
                return;
            }
            
            _tpAnimation = animation;
            switchAction(_currentAction, true);
        }
        
        public function tick(delta:Number):void
        {
            advanceTime( delta ); 
        }
        
        public function advanceTime(time:Number):void
        {
            var len:int = _animationUnitList.length;
            var animateUnit:IAnimatable;
            
            for(var i:int = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime(time);
                
                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
                    animateUnit["isComplete"] == true )
                {
                    _animationUnitList.splice(i,1);
                    len--;
                    i--;
                    continue;
                }
            }
            
            if(_couldTick == false || _isPlay == false)
            {
                return;
            }
            
            _counter.tick(time);
            var couldRender:Boolean;
            while(_counter.expired == true) //判断是否距离上一帧渲染后已经过了多帧
            {
                if(checkMotionIsFinished())
                {
                    if(_motionFinishedStop == true)
                    {
                        if(_motionIsFinished == false)
                        {
                            _motionIsFinished = true;
                            stop();
                            dispatchEvent(new TPMovieClipEvent(TPMovieClipEvent.MOTION_FINISHED));
                        }
                        return;
                    }
                    
                    _currentFrame = 0;
                }
                else
                {
                    _currentFrame += 1
                }
                couldRender = true;
                _counter.reset(_currentFrameRate);
            }
            
            if(couldRender == true)
            {
                updateFrame();
            }
        }
        
        public function stop():void
        {
            _isPlay = false;
        }
        
        override public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                distruct();
            }
        }
        
        protected function killTweensOf(target:Object):void
        {
            var tween:Tween;
            var len:int = _animationUnitList.length;
            for(var i:int = 0; i<len; i++)
            {
                tween = _animationUnitList[i] as Tween;
                if(tween!=null && tween.target == target)
                {
                    _animationUnitList.splice(i,1);
                    return;
                }
            }
        }
        
        protected function distruct():void
        {
            _tpAnimation.disposeTexture();
            _animationDisplay.removeFromParent(true);
            _animationDisplay = null;
            _couldTick = false;
            super.dispose();
        }
        
        protected function initNextAction( actionIndex:uint ):void
        {
            _currentFrame = 0;
            updateFrame();   
        }
        
        protected function checkMotionIsFinished():Boolean
        {
            if(_currentFrame+1 >= _currentActionFrames.length)
            {
                return true
            }
            else
            {
                return false;
            }
        }
        
        protected function updateFrame():void
        {
            if(_isDisposed == true)
            {
                return;
            }
            
            if(_currentActionFrames.length == 0 || _currentActionFrames[_currentFrame] == null)
            {
                _animationDisplay.texture = NULL_TEXTURE;
                _animationDisplay.x = 0;
                _animationDisplay.y = 0;
                dispatchEvent(new TPMovieClipEvent(TPMovieClipEvent.EMPTY_FRAME));
            }
            else
            {
                var apsv:AnyPatSprV0101 = _tpAnimation.getAspv(_currentFrame);
                var actionSequence:TPSequence =_currentActionFrames[_currentFrame];
                _animationDisplay.texture = actionSequence.texture;
                var w:int = _animationDisplay.texture.width;
                var h:int = _animationDisplay.texture.height;
                var offset:Point = new Point( apsv.xOffs , apsv.yOffs );
                if( apsv.mirrorOn == 0 )
                {
                    _animationDisplay.x = -int(w >> 1) + offset.x;
                    _animationDisplay.y = -int(h >> 1) + offset.y;
                    _animationDisplay.scaleX = 1;
                }
                else
                {
                    _animationDisplay.x = int(w >> 1) + offset.x;
                    _animationDisplay.y = -int(h >> 1) + offset.y;
                    _animationDisplay.scaleX = -1;
                }
            }
            
            dispatchEvent(new TPMovieClipEvent(TPMovieClipEvent.MOTION_NEXT_FRAME));
            _animationDisplay.readjustSize();
        }
        
        protected function onAddToStage():void { }
        
        protected function onRemovedFromStage():void  { }
        
        private function onStageEventHandle(e:Event = null):void
        {
            //            switch(e.type)
            //            {
            //                case Event.REMOVED_FROM_STAGE:
            //                {
            //                    removeEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
            //                    addEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            //                    
            //                    onRemovedFromStage();
            //                    break;
            //                }
            //                    
            //                case Event.ADDED_TO_STAGE:
            //                {
            //                    removeEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            //                    addEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
            //                    onAddToStage();
            //                    break;
            //                }
            //            }
        }
        
        public function get tpAnimation():TPAnimation
        {
            return _tpAnimation;
        }
        
        public function set motionFinishedStop(value:Boolean):void
        {
            if(value == false)
            {
                var bool:Boolean = false;
            }
            _motionFinishedStop = value;
        }
        
        public function get motionFinishedStop():Boolean
        {
            return _motionFinishedStop
        }
        
        public function get currentAction():int
        {
            return _currentAction;
        }
        
        public function get currentFrame():int
        {
            return _currentFrame;
        }
        
        public function set currentFrame(value:int):void
        {
            _currentFrame = value;
            var totalFrames:int = _currentActionFrames.length;
            if(value < 0)
            {
                _currentFrame = 0;
            }
            else if(value < totalFrames)
            {
                _currentFrame = value;
            }
            else
            {
                _currentFrame = totalFrames-1;
            }
        }
        
        public function get totalFrames():int
        {
            return _currentActionFrames.length;
        }
        
        public function get color():uint { return _animationDisplay.color; }
        public function set color(value:uint):void
        {
            _animationDisplay.color = value;
        }
        
        public function get currentTexture():Texture
        {
            return _animationDisplay.texture;
        }
        
        public function get animationDisplay():Image
        {
            return _animationDisplay;
        }
        
        public function get threshold():int
        {
            return _threshold;
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
    }
}