package com.inoah.ro.displays
{
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.structs.CACT;
    import com.inoah.ro.structs.CSPR;
    import com.inoah.ro.structs.acth.AnyActAnyPat;
    import com.inoah.ro.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.structs.acth.AnyPatSprV0201;
    import com.inoah.ro.structs.acth.AnyPatSprV0204;
    import com.inoah.ro.structs.acth.AnyPatSprV0205;
    import com.inoah.ro.structs.sprh.AnySprite;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    /**
     * base actSpr view 
     * @author inoah
     * 
     */
    public class ActSprView extends Sprite
    {
        protected var _act:CACT;
        protected var _spr:CSPR;
        protected var _actionIndex:uint;
        protected var _currentFrame:uint;
        protected var _currentAaap:AnyActAnyPat;
        protected var _bitmap:Bitmap;
        protected var _baseCounterTarget:Number;
        protected var _counterTarget:Number;
        protected var _counter:Counter;
        protected var _couldTick:Boolean;
        /**
         * 动作速率
         */        
        protected var _currentTargetRate:Number;
        protected var _loop:Boolean;
        
        public function get actions():CACT
        {
            return _act;
        }
        
        public function ActSprView()
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
        
        public function initAct( data:ByteArray ):void
        {
            _couldTick = false;
            if( _act )
            {
                _act.destory();
            }
            var inData:ByteArray = new ByteArray();
            inData.endian = Endian.BIG_ENDIAN;
            data.position = 0;
            data.readBytes( inData );
            _act= new CACT( inData );
            actionIndex = 0;
            currentFrame = 0;
            _counter.initialize();
            _counter.reset( _counterTarget );
        }
        
        public function initSpr( data:ByteArray ):void
        {
            if( _spr )
            {
                _spr.destory();
            }
            var inData:ByteArray = new ByteArray();
            inData.endian = Endian.BIG_ENDIAN;
            data.position = 0;
            data.readBytes( inData );
            _spr = new CSPR( inData , inData.length );
            _counter.initialize();
            _counter.reset( _counterTarget );
            updateFrame();
            _couldTick = true;
        }
        
        //下，左下，左，左上，上，右上，右，右下
        //0 , 1 , 2 , 3 , 4 , 5 , 6 , 7
        //静态 0-7
        //行走 8-15
        //左下 16-23
        //拾取 24-31
        //待机 32-39 
        //攻击 40-47
        //防御 48-55
        //倒下 56-63
        //躺下 64-71
        //未知 72 -29
        //踩脚 80-87
        //未知 88-95
        //魔法 96-103
        
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
                if( _currentFrame >= _act.aall.aa[_actionIndex].aaap.length - 1 )
                {
                    if( _loop )
                    {
                        _currentFrame = 0;
                    }
                    dispatchEvent(new ActSprViewEvent( ActSprViewEvent.ACTION_END, true ));
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
            _currentAaap = _act.aall.aa[_actionIndex].aaap[_currentFrame];
            
            var isExt:Boolean = false;
            var apsv:AnyPatSprV0101 = _currentAaap.apsList[0];
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
                var anySprite:AnySprite;
                anySprite = _spr.imgs[ apsv.sprNo ];
                
                if( !_bitmap )
                {
                    _bitmap = new Bitmap( anySprite.drawbitmap() );
                    addChild( _bitmap );
                }
                else
                {
                    _bitmap.bitmapData = anySprite.drawbitmap();
                }
                if( apsv.mirrorOn == 0 )
                {
                    _bitmap.x = -_bitmap.width / 2 + apsv.xOffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs;
                    _bitmap.scaleX = 1;
                }
                else
                {
                    _bitmap.x = _bitmap.width / 2 + apsv.xOffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs;
                    _bitmap.scaleX = -1;
                }
            }
            if( apsv as AnyPatSprV0201 )
            {
                apsv.color;
                apsv.xyMag;
                //                _bitmap.rotation = 
                apsv.rot;
                apsv.spType;
            }
            if( apsv as AnyPatSprV0204 )
            {
                apsv.xMag;
                apsv.yMag;
            }
            if( apsv as AnyPatSprV0205 )
            {
                apsv.sprW;
                apsv.sprH;
            }
        }
    }
}