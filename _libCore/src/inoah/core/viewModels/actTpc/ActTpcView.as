package inoah.core.viewModels.actTpc
{
    import flash.display.BitmapData;
    
    import inoah.core.viewModels.actSpr.structs.CACT;
    import inoah.core.viewModels.actSpr.structs.acth.AnyActAnyPat;
    import inoah.core.viewModels.actSpr.structs.acth.AnyPatSprV0101;
    import inoah.core.events.ActTpcEvent;
    import inoah.utils.Counter;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;
    
    public class ActTpcView extends Sprite
    {
        protected static const NULL_TEXTURE:Texture = Texture.fromBitmapData(new BitmapData(1,1,true,0));
        
        protected var _act:CACT;
        protected var _textureAtlas:TextureAtlas;
        
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
        
        public function get textureAtlas():TextureAtlas
        {
            return _textureAtlas;
        }
        public function get texture():Texture
        {
            return _animationDisplay.texture;
        }
        
        public function ActTpcView()
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
            _textureAtlas = textureAtlas;
            onInited( _textureAtlas );
        }
        
        protected function onInited( textureAtlas:TextureAtlas = null ):void
        {
            _textureAtlas = textureAtlas;
            
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
                if( _act.aall.aa.length <= _actionIndex )
                {
                    _actionIndex = 0;
                    return;
                }
                if( _currentFrame >= _act.aall.aa[_actionIndex].aaap.length - 1 )
                {
                    if( _loop )
                    {
                        _currentFrame = 0;
                    }
                    dispatchEvent(new ActTpcEvent( ActTpcEvent.MOTION_FINISHED, true ));
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
                var mTexture:Texture = _textureAtlas.getTexture( apsv.sprNo.toString() );
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
            _textureAtlas.dispose();
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