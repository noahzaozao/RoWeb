package com.inoah.ro.displays
{
    import com.inoah.ro.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.structs.acth.AnyPatSprV0201;
    import com.inoah.ro.structs.acth.AnyPatSprV0204;
    import com.inoah.ro.structs.acth.AnyPatSprV0205;
    import com.inoah.ro.structs.sprh.AnySprite;
    
    import flash.display.Bitmap;
    
    /**
     * 
     * @author inoah
     * 
     */    
    public class ActSprHeadView extends ActSprView
    {
        private var _bodyView:ActSprBodyView;
        
        public function ActSprHeadView( bodyView:ActSprBodyView )
        {
            super();
            _bodyView = bodyView;
        }
        
        override public function tick(delta:Number):void
        {
            
        }
        
        override public function updateFrame():void
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