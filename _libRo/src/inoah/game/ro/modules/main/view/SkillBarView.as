package inoah.game.ro.modules.main.view
{
    import game.ui.mainViewChildren.skillBarViewUI;
    
    public class SkillBarView
    {
        private var _skillBarView:skillBarViewUI
        
//        private var _isColdDown:Boolean;
//        private var _skillMask:Shape;
//        private var _cdX:Number;
//        private var _cdY:Number;
//        private var _cdArea:int;
//        private var _coldDownTime:Number;
//        private var _coldDownStep:Number;

        public function SkillBarView( skillBarView:skillBarViewUI )
        {
            super();
            _skillBarView = skillBarView;
        }
        
        //            _skillBar = new SkillBarUI();
        //            _skillBar.x = 960 - _skillBar.width;
        //            _skillBar.y = 560 - _skillBar.height;
        //            _skillBarItemList = new Vector.<SkillBarItemUI>();
        //            var item:SkillBarItemUI;
        //            for( var i:int=0;i<8;i++)
        //            {
        //                item = new SkillBarItemUI();
        //                item.x = 20 + i * 38;
        //                item.y = 20;
        //                item.txt.text = (i + 1).toString();
        //                item.txt.mouseEnabled = false;
        //                item.txtColdDown.mouseEnabled = false;
        //                item.txtColdDown.visible = false; 
        //                _skillBarItemList[i] = item;
        //                _skillBar.addChild( item );
        //            }
        
        //            var skillIconInfo:CharacterInfo = new CharacterInfo();
        //            skillIconInfo.init( "", "data/sprite/酒捞袍/lk_aurablade.act", "" );
        //            var skillIconView:CharacterView = new CharacterView( skillIconInfo );
        //            skillIconView.width = 32;
        //            skillIconView.height = 32;
        //            _skillBarItemList[0].addChildAt( skillIconView , 1 );
        //            
        //            skillIconInfo = new CharacterInfo();
        //            skillIconInfo.init( "", "data/sprite/酒捞袍/lk_spiralpierce.act", "" );
        //            skillIconView = new CharacterView( skillIconInfo );
        //            skillIconView.width = 32;
        //            skillIconView.height = 32;
        //            _skillBarItemList[1].addChildAt( skillIconView , 1 );
        //            
        //            _skillMask = new Shape();
        //            _skillMask.alpha = 0.7;
        //            _skillMask.x = -16;
        //            _skillMask.y = -16;
        //            _skillBarItemList[0].addChildAt( _skillMask , 2 );
        //            
        //            _stg.addEventListener( KeyboardEvent.KEY_DOWN , onSkill );
        
        //        protected function onSkill( e:KeyboardEvent):void
        //        {
        //            if( e.keyCode == Keyboard.NUMBER_1 )
        //            {
        //                if( !_isColdDown )
        //                {
        //                    _coldDownTime = 2.0;
        //                    _coldDownStep = 128 / _coldDownTime;
        //                    _cdArea = 0;
        //                    _cdX = 16;
        //                    _cdY = 0;
        //                    _skillBarItemList[0].txtColdDown.visible = true;
        //                    _isColdDown = true;
        //                }
        //                else
        //                {
        //                    trace( "skill cold down" );
        //                }
        //            }
        //        }
        
        //tick
        //            if( _isColdDown )
        //            {
        //                _coldDownTime -= delta;
        //                _skillBarItemList[0].txtColdDown.text = _coldDownTime.toFixed( 1 );
        //                
        //                _skillMask.graphics.clear();
        //                _skillMask.graphics.beginFill( 0x0 );
        //                _skillMask.graphics.moveTo( 0, 0 );
        //                _skillMask.graphics.lineTo( 16,0 );
        //                _skillMask.graphics.lineTo( 16,16 );
        //                _skillMask.graphics.lineTo( _cdX,_cdY );
        //                if( _cdArea == 0 )
        //                {
        //                    _cdX += _coldDownStep * delta;
        //                    if( _cdX >= 32 )
        //                    {
        //                        _cdX = 32;
        //                        _cdArea ++;
        //                    }
        //                }
        //                else if( _cdArea == 1 )
        //                {
        //                    _cdY += _coldDownStep * delta;
        //                    if( _cdY >= 32 )
        //                    {
        //                        _cdY = 32;
        //                        _cdArea ++;
        //                    }
        //                }
        //                else if( _cdArea == 2 )
        //                {
        //                    _cdX -= _coldDownStep * delta;
        //                    if( _cdX <= 0 )
        //                    {
        //                        _cdX = 0;
        //                        _cdArea ++;
        //                    }
        //                }
        //                else if( _cdArea == 3 )
        //                {
        //                    _cdY -= _coldDownStep * delta;
        //                    if( _cdY <= 0 )
        //                    {
        //                        _cdY = 0;
        //                        _cdArea ++;
        //                    }
        //                }
        //                else if( _cdArea == 4 )
        //                {
        //                    _cdX += _coldDownStep * delta;
        //                    if( _cdX >= 16 )
        //                    {
        //                        _cdX = 16;
        //                    }
        //                }
        //                
        //                if( _cdArea < 1 )
        //                {
        //                    _skillMask.graphics.lineTo( 32,0 );
        //                }
        //                if( _cdArea < 2 )
        //                {
        //                    _skillMask.graphics.lineTo( 32,32 );
        //                }
        //                if( _cdArea < 3 )
        //                {
        //                    _skillMask.graphics.lineTo( 0,32 );
        //                }
        //                if( _cdArea < 4 )
        //                {
        //                    _skillMask.graphics.lineTo( 0,0 );
        //                }
        //                
        //                if( _coldDownTime <= 0 )
        //                {
        //                    _isColdDown = false;
        //                    _skillMask.graphics.clear();
        //                    _skillBarItemList[0].txtColdDown.visible = false;
        //                }
        //            }
    }
}