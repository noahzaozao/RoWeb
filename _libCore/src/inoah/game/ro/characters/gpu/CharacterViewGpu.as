package inoah.game.ro.characters.gpu
{
    import flash.display.Shape;
    import flash.geom.Point;
    
    import inoah.game.ro.consts.ConstsActions;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.game.ro.viewModels.actSpr.structs.CACT;
    import inoah.game.ro.viewModels.actTpc.ActTpcBodyView;
    import inoah.game.ro.viewModels.actTpc.ActTpcOtherView;
    import inoah.game.ro.viewModels.actTpc.ActTpcPlayerView;
    import inoah.game.ro.viewModels.actTpc.ActTpcWeaponView;
    import inoah.game.ro.events.ActTpcEvent;
    import inoah.game.ro.infos.CharacterInfo;
    import inoah.game.ro.interfaces.IViewObject;
    import inoah.core.loaders.ActTpcLoader;
    import inoah.core.interfaces.ILoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    
    import starling.display.Sprite;
    
    /**
     * 
     * @author inoah
     * 
     */    
    public class CharacterViewGpu extends Sprite implements IViewObject
    {
        protected var _charInfo:CharacterInfo;
        protected var _bodyView:ActTpcBodyView;
        /**
         * 0head, 1weapon, 2weapon, 3head
         */        
        protected var _otherViews:Vector.<ActTpcOtherView>
        
        protected var _headLoader:ILoader;
        protected var _bodyLoader:ILoader;
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
        
        protected var _weaponLoader:ILoader;
        protected var _weaponShadowLoader:ILoader;
        /**
         * 方向转换数组 
         */        
        protected var _dirChangeArr:Array = [4, 5, 6, 7, 8, -7, -6, -5];
        protected var _isPlayEnd:Boolean;
        protected var _action:int;
        /**
         * 动画播放倍率 
         */        
        protected var _playRate:Number = 1;
        protected var _chooseCircle:Shape;
        protected var _cact:CACT;
        
        public function set playRate( value:Number ):void
        {
            _playRate = value;
        }
        
        public function setChooseCircle( bool:Boolean ):void
        {
            //            if( bool )
            //            {
            //                addChildAt( _chooseCircle , 0 );
            //            }
            //            else
            //            {
            //                if( _chooseCircle.parent )
            //                {
            //                    _chooseCircle.parent.removeChild( _chooseCircle );
            //                }
            //            }
        }
        
        public function CharacterViewGpu( charInfo:CharacterInfo = null )
        {
            _otherViews = new Vector.<ActTpcOtherView>( 4 );
            
            _isMoving = false;
            _targetPoint = new Point( 0, 0 );
            if( charInfo )
            {
                _charInfo = charInfo;
                init();
            }
            //            _chooseCircle = new Shape();
            //            _chooseCircle.graphics.lineStyle( 2, 0x00ff00 );
            //            _chooseCircle.graphics.drawEllipse(-25, -15, 50, 30);
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
            updateCharInfo( _charInfo );
        }
        
        public function updateCharInfo( charInfo:CharacterInfo ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            if( !_bodyLoader || _bodyLoader.url != _charInfo.bodyRes )
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
            if( _charInfo.weaponShadowRes )
            {
                assetMgr.getRes( _charInfo.weaponShadowRes, onWeaponShadowLoadComplete );
            }
        }
        
        protected function onBodyLoadComplete( bodyLoader:ILoader ):void
        {
            //            _bodyLoader.removeEventListener( Event.COMPLETE, onBodyLoadComplete );
            _bodyLoader = bodyLoader;
            if( !_bodyView )
            {
                if( charInfo.isPlayer )
                {
                    _bodyView = new ActTpcPlayerView();
                }
                else
                {
                    _bodyView = new ActTpcBodyView();
                }
            }
            _bodyView.initAct( ( (_bodyLoader as ActTpcLoader).cact ) );
            _bodyView.initTpc( _bodyLoader.url , (_bodyLoader as ActTpcLoader).textureAtlas );
            _bodyView.addEventListener( ActTpcEvent.MOTION_FINISHED , onActionEndHandler );
            _bodyView.addEventListener( ActTpcEvent.MOTION_NEXT_FRAME , onNextFrameHandler );
            //noah
            addChild( _bodyView );
        }
        
        protected function onActionEndHandler( e:ActTpcEvent ):void
        {
            if( this is MonsterViewGpu )
            {
                if( _currentIndex != 8 )
                {
                    _isPlayEnd = true;
                }
            }
            else if( this is PlayerViewGpu )
            {
                if( _currentIndex != 8 && _currentIndex != 32 )
                {
                    _isPlayEnd = true;
                }
            }
        }
        
        protected function onNextFrameHandler( e:ActTpcEvent ):void
        {
            var len:int = _otherViews.length;
            for( var i:int = 0;i<len;i++)
            {
                if( _otherViews[i] )
                {
                    _otherViews[i].currentFrame = _bodyView.currentFrame
                    _otherViews[i].updateFrame();
                }
            }
        }
        
        protected function onHeadLoadComplete( headLoader:ILoader ):void
        {
            //            _headLoader.removeEventListener( Event.COMPLETE, onHeadLoadComplete );
            _headLoader = headLoader;
            if( !_otherViews[0] )
            {
                _otherViews[0] = new ActTpcOtherView( _bodyView );
            }
            _otherViews[0].initAct( ( (_headLoader as ActTpcLoader).cact ) );
            _otherViews[0].initTpc( _headLoader.url , (_headLoader as ActTpcLoader).textureAtlas );
            _otherViews[0].actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _otherViews[0] );
        }
        
        protected function onWeaponLoadComplete( weaponLoader:ILoader ):void
        {
            //            _weaponLoader.removeEventListener( Event.COMPLETE, onWeaponLoadComplete );
            _weaponLoader = weaponLoader;
            if( !_otherViews[1] )
            {
                _otherViews[1] = new ActTpcWeaponView( _bodyView );
            }
            _otherViews[1].initAct( ( (_weaponLoader as ActTpcLoader).cact ) );
            _otherViews[1].initTpc( _weaponLoader.url , (_weaponLoader as ActTpcLoader).textureAtlas );
            _otherViews[1].actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _otherViews[0] );
            addChild( _otherViews[1] );
        }
        
        protected function onWeaponShadowLoadComplete( weaponShadowLoader:ILoader ):void
        {
            //            _weaponLoader.removeEventListener( Event.COMPLETE, onWeaponLoadComplete );
            _weaponShadowLoader = weaponShadowLoader;
            if( !_otherViews[2] )
            {
                _otherViews[2] = new ActTpcWeaponView( _bodyView );
            }
            _otherViews[2].initAct( ( (_weaponShadowLoader as ActTpcLoader).cact ) );
            _otherViews[2].initTpc( _weaponShadowLoader.url ,  (_weaponShadowLoader as ActTpcLoader).textureAtlas );
            _otherViews[2].actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _otherViews[0] );
            addChild( _otherViews[2] );
            addChild( _otherViews[1] );
        }
        
        public function tick( delta:Number ):void
        {
            delta = delta * _playRate; 
            if( !_isPlayEnd )
            {
                if( _bodyView )
                {
                    _bodyView.tick( delta );
                }
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].tick( delta );
                    }
                }
            }
        }
        
        public function actionDead():void
        {
            _currentIndex = 56;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
                }
            }
        }
        
        public function actionStand():void
        {
            _currentIndex = 32;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = true;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =true;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
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
                _bodyView.loop = true;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
                }
            }
        }
        
        public function actionAttack():void
        {
            //            _currentIndex = 88;
            _currentIndex = 80;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0.27;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =true;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =true;
                }
            }
        }
        
        public function actionPickup():void
        {
            _currentIndex = 24;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
                }
            }
        }
        
        public function actionSit():void
        {
            _currentIndex = 16;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
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
                _bodyView.loop = false;
                _bodyView.updateFrame();
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                        _otherViews[i].updateFrame();
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
                if( _otherViews[2] )
                {
                    _otherViews[2].visible =false;
                }
            }
        }
        
        public function get bodyView():ActTpcBodyView
        {
            return _bodyView;
        }
        
        override public function dispose():void
        {
            
        }
        
        public function setDirIndex( value:uint ):void
        {
            _dirIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
            var len:int = _otherViews.length;
            for( var i:int = 0;i<len;i++)
            {
                if( _otherViews[i] )
                {
                    _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                }
            }
        }
        
        public function get actions():CACT
        {
            return _cact;
        }
        
        public function set isMoving( value:Boolean ):void
        {
            _isMoving = value;
        }
        
        public function get isMoving():Boolean
        {
            return _isMoving;
        }
        
        public function get currentIndex():uint
        {
            return _currentIndex;
        }
        
        public function set dirIndex( value:uint ):void
        {
            _dirIndex = value;
        }
        
        public function get dirIndex():uint
        {
            return _dirIndex;
        }
        
        public function get action():int
        {
            return _action;
        }
        /**
         * 更换动作接口
         */ 
        public function set action(v:int):void
        {
            _action = v;
            switch( v )
            {
                case ConstsActions.Wait:
                {
                    actionStand();
                    break;
                }
                case ConstsActions.Run:
                {
                    actionWalk();
                    break;
                }
                case ConstsActions.Attack:
                {
                    actionAttack();
                    break;
                }
                case ConstsActions.Pickup:
                {
                    actionPickup();
                    break;
                }
                case ConstsActions.Sit:
                {
                    actionSit();
                    break;
                }
                case ConstsActions.BeAtk:
                {
                    actionHit();
                    break;
                }
                case ConstsActions.Die:
                {
                    actionDead();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        /**
         * 更换方向接口
         */ 
        public function set direction(v:int):void
        {
            dirIndex = _dirChangeArr.indexOf( v );
        }
        public function get direction():int
        {
            return _dirChangeArr[dirIndex];
        }
        
        public function set isPlayEnd( value:Boolean ):void
        {
            _isPlayEnd = value;
        }
        public function get isPlayEnd():Boolean
        {
            return _isPlayEnd;
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}