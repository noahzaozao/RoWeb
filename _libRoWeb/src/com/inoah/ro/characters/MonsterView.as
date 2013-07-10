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
            _speed = 30;
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
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
        
        private function abc():int
        {
            var result:int = uint(Math.random() * 2) >0?1:-1;
            return result;
        }
        
        private function checkDir():void
        {
            if( _targetPoint.x - x == 0  )
            {
                if( _targetPoint.y - y > 0 )
                {
                    _dirIndex = 0;
                }
                else if( _targetPoint.y - y < 0 )
                {
                    _dirIndex = 4;
                }
            }
            else if( _targetPoint.y - y == 0 )
            {
                if( _targetPoint.x - x > 0 )
                {
                    _dirIndex = 6;
                }
                else if( _targetPoint.x - x < 0 )
                {
                    _dirIndex = 2;
                }
            }
            else if( _targetPoint.x - x > 0 ) 
            {
                if( _targetPoint.y - y > 0 )
                {
                    _dirIndex = 7;
                }
                else
                {
                    _dirIndex = 5;
                }
            }
            else if( _targetPoint.x - x < 0 )
            {
                if( _targetPoint.y - y > 0 ) 
                {
                    _dirIndex = 1;
                }
                else
                {
                    _dirIndex = 3;
                }
            }
        }
        
        protected function attackCheck( delta:Number ):void
        {
            
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
    }
}