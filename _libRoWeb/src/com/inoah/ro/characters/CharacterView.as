package com.inoah.ro.characters
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.graphics.ISwfDisplayer;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.actspr.ActSprBodyView;
    import com.inoah.ro.displays.actspr.ActSprOtherView;
    import com.inoah.ro.displays.actspr.ActSprPlayerView;
    import com.inoah.ro.displays.actspr.ActSprWeaponView;
    import com.inoah.ro.displays.actspr.structs.CACT;
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 
     * @author inoah
     * 
     */    
    public class CharacterView extends Sprite implements ISwfDisplayer
    {
        protected var _charInfo:CharacterInfo;
        protected var _bodyView:ActSprBodyView;
        /**
         * 0head, 1weapon, 2weapon, 3head
         */        
        protected var _otherViews:Vector.<ActSprOtherView>
        
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
        
        protected var _bmd:Bitmap;
        
        /**
         * 方向转换数组 
         */        
        protected var _dirChangeArr:Array = [4, 5, 6, 7, 8, -7, -6, -5];
        protected var _isPlayEnd:Boolean;
        protected var _chooseCircle:Shape;
        
        public function setChooseCircle( bool:Boolean ):void
        {
            if( bool )
            {
                addChildAt( _chooseCircle , 0 );
            }
            else
            {
                if( _chooseCircle.parent )
                {
                    _chooseCircle.parent.removeChild( _chooseCircle );
                }
            }
        }
        public function CharacterView( charInfo:CharacterInfo = null )
        {
            _otherViews = new Vector.<ActSprOtherView>( 4 );
            
            _bmd = new Bitmap();
            _isMoving = false;
            _targetPoint = new Point( 0, 0 );
            if( charInfo )
            {
                _charInfo = charInfo;
                init();
            }
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
            _chooseCircle = new Shape();
            _chooseCircle.graphics.lineStyle( 2, 0x00ff00 );
            _chooseCircle.graphics.drawEllipse(-25, -15, 50, 30);
            
            //            _bodyLoader.removeEventListener( Event.COMPLETE, onBodyLoadComplete );
            _bodyLoader = bodyLoader;
            if( !_bodyView )
            {
                if( charInfo.isPlayer )
                {
                    _bodyView = new ActSprPlayerView();
                }
                else
                {
                    _bodyView = new ActSprBodyView();
                }
            }
            _bodyView.initAct( (_bodyLoader as ActSprLoader).actData );
            _bodyView.initSpr( (_bodyLoader as ActSprLoader).sprData , _bodyLoader.url );
            _bodyView.addEventListener( ActSprViewEvent.ACTION_END , onActionEndHandler );
            _bodyView.addEventListener( ActSprViewEvent.NEXT_FRAME , onNextFrameHandler );
            //noah
            addChild( _bodyView );
        }
        
        protected function onActionEndHandler( e:Event):void
        {
            if( this is MonsterView )
            {
                if( _currentIndex != 8 )
                {
                    _isPlayEnd = true;
                }
            }
            else if( this is PlayerView )
            {
                if( _currentIndex != 8 && _currentIndex != 32 )
                {
                    _isPlayEnd = true;
                }
            }
        }
        
        protected function onNextFrameHandler( e:Event):void
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
                _otherViews[0] = new ActSprOtherView( _bodyView );
            }
            _otherViews[0].initAct( (_headLoader as ActSprLoader).actData );
            _otherViews[0].initSpr( (_headLoader as ActSprLoader).sprData , _headLoader.url );
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
                _otherViews[1] = new ActSprWeaponView( _bodyView );
            }
            _otherViews[1].initAct( (_weaponLoader as ActSprLoader).actData );
            _otherViews[1].initSpr( (_weaponLoader as ActSprLoader).sprData , _weaponLoader.url );
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
                _otherViews[2] = new ActSprWeaponView( _bodyView );
            }
            _otherViews[2].initAct( (_weaponShadowLoader as ActSprLoader).actData );
            _otherViews[2].initSpr( (_weaponShadowLoader as ActSprLoader).sprData , _weaponShadowLoader.url );
            _otherViews[2].actionIndex = _bodyView.actionIndex;
            addChild( _bodyView );
            addChild( _otherViews[0] );
            addChild( _otherViews[2] );
            addChild( _otherViews[1] );
        }
        
        public function tick( delta:Number ):void
        {
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
        
        public function get bodyView():ActSprBodyView
        {
            return _bodyView;
        }
        
        public function get actionIndex():uint
        {
            return _currentIndex;
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
        
        public function set dirIndex( value:uint ):void
        {
            _dirIndex = value;
        }
        
        public function get dirIndex():uint
        {
            return _dirIndex;
        }
        
        /**
         * 渲染接口
         */ 
        public function render():void
        {
            if( _otherViews[0] && _otherViews[1] )
            {
                _bmd.bitmapData = new BitmapData( width * 2 , height * 3 , true , 0x0 );
                _bmd.x = - width;
                _bmd.y = - height * 2;
                var matrix:Matrix;
                matrix = new Matrix();
                matrix.translate( width , height * 2 );
                _bmd.bitmapData.draw( this , matrix , null, null, new Rectangle( 0, 0, width * 2 , height * 3 ) , false );
            }
        }
        /**
         * 更换SWF接口
         */ 
        public function changeSWF(f:String,needMirror:Boolean=false):void
        {
            
        }
        
        /**
         * 更换动作接口
         */ 
        public function set action(v:int):void
        {
            switch( v )
            {
                case Actions.Wait:
                {
                    actionStand();
                    break;
                }
                case Actions.Run:
                {
                    actionWalk();
                    break;
                }
                case Actions.Attack:
                {
                    actionAttack();
                    break;
                }
                case Actions.Pickup:
                {
                    actionPickup();
                    break;
                }
                case Actions.Sit:
                {
                    actionSit();
                    break;
                }
                case Actions.BeAtk:
                {
                    actionHit();
                    break;
                }
                case Actions.Die:
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
        
        public function set isPlayEnd( value:Boolean ):void
        {
            _isPlayEnd = value;
        }
        public function get isPlayEnd():Boolean
        {
            return _isPlayEnd;
        }
        /**
         * 更换方向接口
         */ 
        public function set direction(v:int):void
        {
            dirIndex = _dirChangeArr.indexOf( v );
        }
        
        
        public function get monitor():Bitmap
        {
            if( !_otherViews[0] && !_otherViews[1] )
            {
                return _bodyView.bitmap;
            }
            return _bmd;
        }
        
        public function get shadow():Shape
        {
            return null;
        }
    }
}