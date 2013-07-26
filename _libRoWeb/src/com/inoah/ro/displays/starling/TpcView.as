package com.inoah.ro.displays.starling
{
    import inoah.game.consts.MgrTypeConsts;
    import com.inoah.ro.displays.actspr.structs.acth.AnyActAnyPat;
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.displays.starling.structs.TPAnimation;
    import com.inoah.ro.events.TPAnimationEvent;
    import com.inoah.ro.events.TPMovieClipEvent;
    import inoah.game.managers.MainMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    
    public class TpcView extends Sprite
    {
        protected static const NULL_TEXTURE:Texture = Texture.fromBitmapData(new BitmapData(1,1,true,0));
        
        protected var _tpAnimation:TPAnimation;
        
        protected var _actionIndex:uint;
        protected var _currentFrame:uint;
        protected var _currentAaap:AnyActAnyPat;
        protected var _animationDisplay:Image;
        protected var _baseCounterTarget:Number;
        protected var _counterTarget:Number;
        protected var _counter:Counter;
        protected var _couldTick:Boolean;
        /**
         * 动作速率
         */        
        protected var _currentTargetRate:Number;
        protected var _loop:Boolean;
        
        public function get tpAnimation():TPAnimation
        {
            return _tpAnimation;
        }
        public function get texture():Texture
        {
            return _animationDisplay.texture;
        }
        
        public function TpcView()
        {
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
        
        public function initTpc( resId:String , data:ByteArray ):void
        {
            _couldTick = false;
            var cactData:ByteArray = new ByteArray();
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            _tpAnimation = textureMgr.getTpAnimation( resId , data , onInited );
        }
        
        protected function onInited( e:TPAnimationEvent , tpAnimation:TPAnimation = null ):void
        {
            if( e != null )
            {
                _tpAnimation = e.tpAnimation;
            }
            else
            {
                _tpAnimation = tpAnimation;
            }
            
            actionIndex = 0;
            currentFrame = 0;
            _counter.initialize();
            _counter.reset( _counterTarget );
            
            _animationDisplay = new Image(NULL_TEXTURE);
            _animationDisplay.smoothing = TextureSmoothing.BILINEAR;
            addChildAt(_animationDisplay, 0);
            _animationDisplay.touchable = true;
            
            _counter.initialize();
            _counter.reset( _counterTarget );
            updateFrame();
            _couldTick = true;
        }
        
        public function tick(delta:Number):void
        {
            if( !_couldTick )
            {
                return;
            }
            _counter.tick( delta );
            var couldRender:Boolean;
            while( _counter.expired == true )
            {
                if( _tpAnimation.act.aall.aa.length <= _actionIndex )
                {
                    _actionIndex = 0;
                    return;
                }
                if( _currentFrame >= _tpAnimation.act.aall.aa[_actionIndex].aaap.length - 1 )
                {
                    if( _loop )
                    {
                        _currentFrame = 0;
                    }
                    dispatchEvent(new TPMovieClipEvent( TPMovieClipEvent.MOTION_FINISHED, true ));
                }
                else
                {
                    _currentFrame++;
                }
                couldRender = true;
                _counter.reset( _counterTarget );
            }
            
            if(couldRender == true)
            {
                updateFrame();
            }
        }
        
        public function updateFrame():void
        {
            //            RoGlobal.debugTxt.appendText( "updateFrame" + _animationDisplay.x + _animationDisplay.y + "\n" );
            
            _currentAaap = _tpAnimation.act.aall.aa[_actionIndex].aaap[_currentFrame];
            
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
                var mTexture:Texture = _tpAnimation.getTexture( apsv.sprNo );
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
        
        protected function distruct():void
        {
            _tpAnimation.disposeTexture();
            _animationDisplay.removeFromParent(true);
            _animationDisplay = null;
            _couldTick = false;
            super.dispose();
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
    }
}