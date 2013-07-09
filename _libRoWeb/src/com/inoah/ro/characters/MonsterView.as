package com.inoah.ro.characters
{
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.utils.Counter;
    
    import flash.geom.Point;
    
    public class MonsterView extends CharacterView
    {
        private var _moveCounter:Counter;
        
        public function MonsterView(charInfo:CharacterInfo=null)
        {
            super(charInfo);
            _headTopContainer.y = -60;
            _speed = 30;
            _moveCounter = new Counter();
            _moveCounter.initialize();
            _moveCounter.reset( 2 );
        }
        
        override protected function init():void
        {
            super.init();
            _spValBar.visible = false;
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
            _currentIndex = 48;
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
        
        protected function moveCheck( delta:Number ):void
        {
            if( !_isMoving && !_isHiting )
            {
                _moveCounter.tick( delta );
            }
            if( _moveCounter.expired )
            {
                _targetPoint = new Point( int(x + abc() * Math.random() * 100 + 5 ), int(y + abc() * Math.random() * 100 + 5 ) );
                if( _targetPoint.x > 900 || _targetPoint.x < 50 )
                {
                    _targetPoint.x = x;
                }
                if( _targetPoint.y > 500 || _targetPoint.y < 50 )
                {
                    _targetPoint.y = y;
                }
                checkDir();
                _isMoving = true;
                _moveCounter.reset( 2 );
            }
            if( _targetPoint.x == 0 )
            {
                return;
            }
            if( _targetPoint.x == x && _targetPoint.y == y )
            {
                _isMoving = false;
                return;
            }
            if( _targetPoint.x != x )
            {
                if( _targetPoint.x > x )
                {
                    x += delta * speed;
                }
                else
                {
                    x -= delta * speed;
                }
                if( (Math.abs(_targetPoint.x - x) < 2 ) )
                {
                    x = _targetPoint.x;
                }
            }
            if( _targetPoint.y != y )
            {
                if( _targetPoint.y > y )
                {
                    y += delta * speed;
                }
                else
                {
                    y -= delta * speed;
                }
                if( (Math.abs(_targetPoint.x - y) < 2 ) )
                {
                    y = _targetPoint.y;
                }
            }
        }

        protected function attackCheck( delta:Number ):void
        {
            
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            if( _isDead )
            {
                return;   
            }
            moveCheck( delta );
        }
    }
}