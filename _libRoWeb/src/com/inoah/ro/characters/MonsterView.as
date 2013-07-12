package com.inoah.ro.characters
{
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.utils.Counter;
    
    public class MonsterView extends CharacterView
    {
        private var _moveCounter:Counter;
        
        public function MonsterView(charInfo:CharacterInfo=null)
        {
            super(charInfo);
            _moveCounter = new Counter();
            _moveCounter.initialize();
            _moveCounter.reset( 2 );
        }
        
        override protected function init():void
        {
            super.init();
        }
        
        override public function actionStand():void
        {
            _currentIndex = 0;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = true;
                if( _headView )
                {
                    _headView.actionIndex = _currentIndex + _dirIndex;
                }
                if( _weaponView )
                {
                    _weaponView.actionIndex = _currentIndex + _dirIndex;
                    _weaponView.visible =true;
                }
            }
        }
        
        override public function actionAttack():void
        {
            _currentIndex = 16;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0.8;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                if( _headView )
                {
                    _headView.actionIndex = _currentIndex + _dirIndex;
                }
                if( _weaponView )
                {
                    _weaponView.actionIndex = _currentIndex + _dirIndex;
                    _weaponView.visible =true;
                }
            }
        }
        
        override public function actionHit():void
        {
            _currentIndex = 24;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                if( _headView )
                {
                    _headView.actionIndex = _currentIndex + _dirIndex;
                }
                if( _weaponView )
                {
                    _weaponView.actionIndex = _currentIndex + _dirIndex;
                    _weaponView.visible =true;
                }
            }
        }
        
        override public function actionDead():void
        {
            _currentIndex = 32;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                if( _headView )
                {
                    _headView.actionIndex = _currentIndex + _dirIndex;
                }
                if( _weaponView )
                {
                    _weaponView.actionIndex = _currentIndex + _dirIndex;
                    _weaponView.visible =false;
                }
            }
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
    }
}