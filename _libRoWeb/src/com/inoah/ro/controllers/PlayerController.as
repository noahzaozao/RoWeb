package com.inoah.ro.controllers
{
    import com.inoah.ro.characters.CharacterView;
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.consts.DirIndexConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.managers.BattleMgr;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    
    public class PlayerController
    {
        private var _root:Sprite;
        private var _playerView:PlayerView;
        private var _currentTargetView:CharacterView;
        private var _targetList:Vector.<MonsterView>;
        private var _isCheckTarget:Boolean;
        private var _checkTargetCounter:Counter;
        
        public function set targetView( value:CharacterView ):void
        {
            _currentTargetView = value;
        }
        
        public function set targetList( value:Vector.<MonsterView> ):void
        {
            _targetList = value;
        }
        
        public function PlayerController( root:Sprite )
        {
            _root = root;
            var charInfo:CharacterInfo = new CharacterInfo();
            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/巢/2_巢.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act", "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_1207.act" );
            //            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_咯.act" );
            _playerView = new PlayerView( charInfo );
            _playerView.x = 400;
            _playerView.y = 400;
            _root.addChild( _playerView );
            
            _checkTargetCounter = new Counter();
            _checkTargetCounter.initialize();
            _checkTargetCounter.reset( 1 );
        }
        
        public function tick( delta:Number ):void
        {
            if( _playerView )
            {
                moveCheck( delta );
                attackCheck( delta );
                _playerView.tick( delta );
            }
        }
        /**
         * 攻击判定
         * @param delta
         */        
        private function attackCheck(delta:Number):void
        {
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
            if( !keyMgr )
            {
                return;
            }
            if( _playerView.isAttacking )
            {
                return;
            }
            _checkTargetCounter.tick( delta );
            if( _checkTargetCounter.expired )
            {
                _isCheckTarget = false;
                _checkTargetCounter.reset( 1 );
            }
            if( keyMgr.isDown( Keyboard.J )  )
            {
                if( !_currentTargetView )
                {
                    if( !_isCheckTarget )
                    {
                        _isCheckTarget = true;
                        chooseTarget();
                    }
                }
                if( _currentTargetView  )
                {
                    var dis:Number = Point.distance( new Point( _playerView.x, _playerView.y ), new Point( _currentTargetView.x, _currentTargetView.y ) );
                    if( dis > 80 || _currentTargetView.isDead == true )
                    {
                        _currentTargetView.removeEventListener( ActSprViewEvent.ACTION_END, onHitingEndHandler );
                        _currentTargetView.isHiting = false;
                        _currentTargetView = null;
                    }
                    else
                    {
                        var battleMgr:BattleMgr = MainMgr.instance.getMgr( MgrTypeConsts.BATLLE_MGR ) as BattleMgr;
                        battleMgr.attack( _playerView, _currentTargetView );
                        _playerView.isAttacking = true;
                        _playerView.addEventListener( ActSprViewEvent.ACTION_END, onActionEndHandler );
                        
                        if( _currentTargetView )
                        {
                            if( _currentTargetView.isHiting )
                            {
                                _currentTargetView.isHiting = true;
                            }
                            else
                            {
                                _currentTargetView.addEventListener( ActSprViewEvent.ACTION_END, onHitingEndHandler );
                                _currentTargetView.isHiting = true;
                            }
                        }
                    }
                }
                return;
            }
        }
        
        /**
         * 移动判定 
         * @param delta
         */        
        protected function moveCheck( delta:Number ):void
        {
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
            if( !keyMgr )
            {
                return;
            }
            
            _playerView.isMoving = false;

            if( _playerView.isAttacking )
            {
                return;
            }
            
            if( keyMgr.isDown( Keyboard.W ) )
            {
                _playerView.dirIndex = DirIndexConsts.UP;
                _playerView.y -= delta * _playerView.speed;
                _playerView.isMoving = true;
            }
            else if( keyMgr.isDown( Keyboard.S ) )
            {
                _playerView.dirIndex = DirIndexConsts.DOWN;
                _playerView.y += delta * _playerView.speed;
                _playerView.isMoving = true;
            }
            if( keyMgr.isDown( Keyboard.A ) )
            {
                if( _playerView.dirIndex == DirIndexConsts.UP )
                {
                    _playerView.dirIndex = DirIndexConsts.UP_LIFT;
                    _playerView.x -= delta * _playerView.speed ;
                }
                else if( _playerView.dirIndex == DirIndexConsts.DOWN )
                {
                    _playerView.dirIndex = DirIndexConsts.DOWN_LEFT;
                    _playerView.x -= delta * _playerView.speed ;
                }
                else
                {
                    _playerView.dirIndex = DirIndexConsts.LEFT;
                    _playerView.x -= delta * _playerView.speed;
                }
                _playerView.isMoving = true;
            }
            else if( keyMgr.isDown( Keyboard.D ) )
            {
                if( _playerView.dirIndex == DirIndexConsts.UP )
                {
                    _playerView.dirIndex = DirIndexConsts.UP_RIGHT;
                    _playerView.x += delta * _playerView.speed ;
                }
                else if( _playerView.dirIndex == DirIndexConsts.DOWN )
                {
                    _playerView.dirIndex = DirIndexConsts.DOWN_RIGHT;
                    _playerView.x += delta * _playerView.speed ;
                }
                else
                {
                    _playerView.dirIndex = DirIndexConsts.RIGHT;
                    _playerView.x += delta * _playerView.speed;
                }
                _playerView.isMoving = true;
            }
        }
        
        private function chooseTarget():void
        {
            if( !_currentTargetView )
            {
                var distanceList:Vector.<Point> = new Vector.<Point>();
                var len:int = _targetList.length;
                for( var i:int = 0;i<len;i++)
                {
                    distanceList[i] = new Point();
                    distanceList[i].x = i;
                    distanceList[i].y = Point.distance( new Point( _playerView.x, _playerView.y ), new Point( _targetList[i].x, _targetList[i].y ) );
                }
                distanceList.sort( sortDistanceFunc );
                _currentTargetView = _targetList[ distanceList[0].x ];
            }
        }
        
        private function sortDistanceFunc( a:Point, b:Point ):Number
        {
            return a.y - b.y;
        }
        
        protected function onActionEndHandler( e:Event):void
        {
            _playerView.removeEventListener( ActSprViewEvent.ACTION_END, onActionEndHandler );
            _playerView.isAttacking = false;
        }
        
        protected function onHitingEndHandler(event:Event):void
        {
            _currentTargetView.removeEventListener( ActSprViewEvent.ACTION_END, onHitingEndHandler );
            _currentTargetView.isHiting = false;
        }
    }
}