package com.inoah.ro.characters
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.ActSprBodyView;
    import com.inoah.ro.displays.ActSprHeadView;
    import com.inoah.ro.displays.ActSprWeaponView;
    import com.inoah.ro.displays.valueBar.ValueBarView;
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.structs.CACT;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    /**
     * 
     * @author inoah
     * 
     */    
    public class CharacterView extends Sprite
    {
        protected var _charInfo:CharacterInfo;
        protected var _bodyView:ActSprBodyView;
        protected var _headView:ActSprHeadView;
        protected var _weaponView:ActSprWeaponView;
        
        protected var _headLoader:ActSprLoader;
        protected var _bodyLoader:ActSprLoader;
        protected var _speed:Number;
        /**
         * 0 stand, 8 walk,  
         */        
        protected var _currentIndex:uint;
        /**
         * 0,下,1左下.....7 
         */        
        protected var _dirIndex:uint;
        protected var _targetPoint:Point;
        protected var _isMoving:Boolean;
        
        protected var _x:Number;
        protected var _y:Number;
        protected var _moveTime:Number;
        protected var _isAttacking:Boolean;
        
        protected var _headTopContainer:Sprite;
        protected var _label:TextField;
        protected var _hpValBar:ValueBarView;
        protected var _spValBar:ValueBarView;
        protected var _weaponLoader:ActSprLoader;
        protected var _isHiting:Boolean;
        protected var _isDead:Boolean;
        
        public function CharacterView( charInfo:CharacterInfo = null )
        {
            _isMoving = false;
            _targetPoint = new Point( 0, 0 );
            _speed = 140;
            if( charInfo )
            {
                _charInfo = charInfo;
                init();
            }
        }
        
        public function get headTopContainer():Sprite
        {
            return _headTopContainer;
        }
        
        public function get isDead():Boolean
        {
            return _isDead;
        }
        
        public function get charInfo():CharacterInfo
        {
            return _charInfo;
        }
        public function setCharInfo( charInfo:CharacterInfo ):void
        {
            _charInfo = charInfo;
            init();
        }
        
        override public function set x( x:Number ):void
        {
            _x = x;
            super.x = _x;
        }
        override public function set y( y:Number ):void
        {
            _y = y;
            super.y = _y;
        }
        
        protected function init():void
        {
            if(_headTopContainer == null)
            {
                _headTopContainer = new Sprite();
                _headTopContainer.y = -100;
                addChild( _headTopContainer );
            }
            _label = new TextField();
            _label.mouseEnabled = false;
            _label.filters = [new DropShadowFilter(0,0,0,1,2,2,8)];
            _label.alpha = 0.7;
            _label.autoSize = TextFieldAutoSize.LEFT;
            var tf:TextFormat = new TextFormat();
            tf.font = "宋体";
            tf.size = 12;
            tf.color = 0xffffff;
            _label.defaultTextFormat = tf;
            _label.text = _charInfo.name;
            _label.x = -_label.width / 2;
            _headTopContainer.addChild( _label );
            
            _hpValBar = new ValueBarView( 0x33ff33 , 0x333333 );
            _hpValBar.x = -_hpValBar.width / 2;
            _hpValBar.y = 15;
            addChild( _hpValBar );
            _hpValBar.update( 1, 100 );
            
            _spValBar = new ValueBarView( 0x2868FF , 0x333333 );
            _spValBar.x = -_spValBar.width / 2;
            _spValBar.y = 20;
            addChild( _spValBar );
            _spValBar.update( 1, 100 );
            
            updateCharInfo( _charInfo );
            
            updateValues();
        }
        
        public function updateCharInfo( charInfo:CharacterInfo ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            if( !_bodyLoader || _bodyLoader.actUrl != _charInfo.bodyRes )
            {
                assetMgr.getRes( _charInfo.bodyRes, onBodyLoadComplete );
            }
            if( _charInfo.headRes )
            {
                assetMgr.getRes( _charInfo.headRes, onHeadLoadComplete );
            }
            if( _charInfo.weaponRes )
            {
                assetMgr.getRes( _charInfo.weaponRes, onWeaponLoadComplete );
            }
        }
        
        protected function onBodyLoadComplete( bodyLoader:ActSprLoader ):void
        {
            //            _bodyLoader.removeEventListener( Event.COMPLETE, onBodyLoadComplete );
            _bodyLoader = bodyLoader;
            if( !_bodyView )
            {
                _bodyView = new ActSprBodyView();
            }
            _bodyView.initAct( _bodyLoader.actData );
            _bodyView.initSpr( _bodyLoader.sprData );
            _bodyView.addEventListener( ActSprViewEvent.NEXT_FRAME , onNextFrameHandler );
            //noah
            addChild( _bodyView );
        }
        
        protected function onNextFrameHandler( e:Event):void
        {
            if( _headView )
            {
                _headView.currentFrame = _bodyView.currentFrame
                _headView.updateFrame();
            }
            if( _weaponView )
            {
                _weaponView.currentFrame = _bodyView.currentFrame
                _weaponView.updateFrame();
            }
        }
        
        protected function onHeadLoadComplete( headLoader:ActSprLoader ):void
        {
            //            _headLoader.removeEventListener( Event.COMPLETE, onHeadLoadComplete );
            _headLoader = headLoader;
            if( !_headView )
            {
                _headView = new ActSprHeadView( _bodyView );
            }
            _headView.initAct( _headLoader.actData );
            _headView.initSpr( _headLoader.sprData );
            _headView.actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _headView );
        }
        
        protected function onWeaponLoadComplete( weaponLoader:ActSprLoader ):void
        {
            //            _weaponLoader.removeEventListener( Event.COMPLETE, onWeaponLoadComplete );
            _weaponLoader = weaponLoader;
            if( !_weaponView )
            {
                _weaponView = new ActSprWeaponView( _bodyView );
            }
            _weaponView.initAct( _weaponLoader.actData );
            _weaponView.initSpr( _weaponLoader.sprData );
            _weaponView.actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _headView );
            addChild( _weaponView );
        }
        
        public function tick( delta:Number ):void
        {
            if( _bodyView )
            {
                _bodyView.tick( delta );
            }
            if( _isDead )
            {
                return;   
            }
            if( _isAttacking )
            {
                actionAttack();
            }
            else
            {
                if( _isHiting )
                {
                    actionHit();
                    if( _isMoving )
                    {
                        _targetPoint = new Point( x, y );
                    }
                }
                else if( _isMoving )
                {
                    actionWalk();
                }
                else
                {
                    actionStand();
                }
            }
            if( _isHiting || _isAttacking )
            {
                updateValues();
            }
        }
        
        private function updateValues():void
        {
            _hpValBar.update( _charInfo.curHp, _charInfo.maxHp );
            _spValBar.update( _charInfo.curSp, _charInfo.maxSp );
            if( _charInfo.isDead )
            {
                actionDead();
                dispatchEvent( new ActSprViewEvent( ActSprViewEvent.ACTION_DEAD_START ) );
                _isDead = true;
            }
        }
        
        private function actionDead():void
        {
            _currentIndex = 56;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
        
        public function actionStand():void
        {
            //            _currentIndex = 0;
            _currentIndex = 32;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
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
        
        public function actionWalk():void
        {
            _currentIndex = 8;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
        
        public function actionAttack():void
        {
            _currentIndex = 80;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0.27;
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
        
        public function actionHit():void
        {
            _currentIndex = 48;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
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
        
        public function get bodyView():ActSprBodyView
        {
            return _bodyView;
        }
        
        public function get actionIndex():uint
        {
            return _currentIndex;
        }
        
        public function setActionIndex( value:uint ):void
        {
            _currentIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
            if( _headView )
            {
                _headView.actionIndex = _currentIndex + _dirIndex;
            }
            if( _weaponView )
            {
                _weaponView.actionIndex = _currentIndex + _dirIndex;
            }
        }
        
        public function setDirIndex( value:uint ):void
        {
            _dirIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
            if( _headView )
            {
                _headView.actionIndex = _currentIndex + _dirIndex;
            }
            if( _weaponView )
            {
                _weaponView.actionIndex = _currentIndex + _dirIndex;
            }
        }
        
        public function get actions():CACT
        {
            return _bodyView.actions;
        }
        
        public function set isMoving( value:Boolean ):void
        {
            _isMoving = value;
        }
        
        public function get isMoving():Boolean
        {
            return _isMoving;
        }
        
        public function set isHiting( value:Boolean ):void
        {
            _isHiting = value;
            _bodyView.currentFrame = 0;
            if( _headView )
            {
                _headView.currentFrame = 0;
            }
            if( _weaponView )
            {
                _weaponView.currentFrame = 0;
            }
        }
        
        public function get isHiting():Boolean
        {
            return _isHiting;
        }
        
        public function set isAttacking( value:Boolean ):void
        {
            _isAttacking = value;
        }
        
        public function get isAttacking():Boolean
        {
            return _isAttacking;
        }
        
        public function set dirIndex( value:uint ):void
        {
            _dirIndex = value;
        }
        
        public function get dirIndex():uint
        {
            return _dirIndex;
        }
        
        public function get speed():uint
        {
            return _speed;
        }
    }
}