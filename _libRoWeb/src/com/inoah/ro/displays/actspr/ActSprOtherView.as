package com.inoah.ro.displays.actspr
{
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0201;
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0204;
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0205;
    import com.inoah.ro.displays.actspr.structs.sprh.AnySprite;
    import com.inoah.ro.events.ActSprViewEvent;
    
    import flash.display.Bitmap;
    
    /**
     *
     * weapon, headEquip 
     * @author inoah
     * 
     */    
    public class ActSprOtherView extends ActSprView
    {
        protected var _bodyView:ActSprBodyView;
        
        public function ActSprOtherView( bodyView:ActSprBodyView )
        {
            super();
            _bodyView = bodyView;
        }
        
        override public function tick(delta:Number):void
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
        
        override public function updateFrame():void
        {
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
                    _bitmap.x = -_bitmap.width / 2 + apsv.xOffs + _bodyView.currentAaap.ExtXoffs - _currentAaap.ExtXoffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs + _bodyView.currentAaap.ExtYoffs - _currentAaap.ExtYoffs;
                    _bitmap.scaleX = 1;
                }
                else
                {
                    _bitmap.x = _bitmap.width / 2 + apsv.xOffs + _bodyView.currentAaap.ExtXoffs - _currentAaap.ExtXoffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs + _bodyView.currentAaap.ExtYoffs - _currentAaap.ExtYoffs;
                    _bitmap.scaleX = -1;
                }
            }
        }
    }
}