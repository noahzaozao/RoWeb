package inoah.game.ro.viewModels.actSpr
{
    import inoah.game.ro.viewModels.actSpr.structs.acth.AnyPatSprV0101;
    import inoah.game.ro.viewModels.actSpr.structs.sprh.AnySprite;
    
    import flash.display.Bitmap;
    
    public class ActSprWeaponView extends ActSprOtherView
    {
        public function ActSprWeaponView(bodyView:ActSprBodyView)
        {
            super(bodyView);
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
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
                    _bitmap.x = -_bitmap.width / 2 + apsv.xOffs - _currentAaap.ExtXoffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs - _currentAaap.ExtYoffs;
                    _bitmap.scaleX = 1;
                }
                else
                {
                    _bitmap.x = _bitmap.width / 2 + apsv.xOffs - _currentAaap.ExtXoffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs - _currentAaap.ExtYoffs;
                    _bitmap.scaleX = -1;
                }
                
            }
        }
    }
}