package com.inoah.ro.displays.starling
{
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    
    import starling.textures.Texture;
    

    public class TpcWeaponView extends TpcOtherView
    {
        public function TpcWeaponView(bodyView:TpcBodyView)
        {
            super(bodyView);
        }
        
        override public function tick(delta:Number):void
        {
            
        }
        
        override public function updateFrame():void
        {
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
                    _animationDisplay.x = int(-_animationDisplay.texture.width / 2 + apsv.xOffs - _currentAaap.ExtXoffs );
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs - _currentAaap.ExtYoffs);
                    _animationDisplay.scaleX = 1;
                }
                else
                {
                    _animationDisplay.x = int(_animationDisplay.texture.width / 2 + apsv.xOffs - _currentAaap.ExtXoffs );
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs - _currentAaap.ExtYoffs );
                    _animationDisplay.scaleX = -1;
                }
                _animationDisplay.readjustSize();
            }
        }
    }
}