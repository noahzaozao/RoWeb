package inoah.core.base
{
    import flash.geom.Point;
    
    import inoah.core.GameCamera;
    import inoah.core.consts.ConstsActions;
    import inoah.interfaces.IViewObject;
    import inoah.interfaces.base.IBaseController;
    import inoah.interfaces.base.IBaseObject;
    import inoah.interfaces.info.ICharacterInfo;
    import inoah.interfaces.map.IScene;
    import inoah.utils.QTree;
    
    import robotlegs.bender.framework.api.ILogger;
    
    /**
     * 地图物体基类
     * @author inoah
     */    
    public class BaseObject implements IBaseObject
    {
        [Inject]
        public var scene:IScene;
        
        [Inject]
        public var logger:ILogger;
        
        public static var GID_COUNT:uint = 0;
        
        protected var _qTree:QTree;
        /**
         * 地图绝对位置 
         */        
        protected var _posX:Number;
        protected var _posY:Number;
        /**
         * 与左上角偏移 
         */        
        protected var _offsetX:Number;
        protected var _offsetY:Number;
        
        protected var _action:int;
        protected var _direction:int;
        
        protected var _viewObj:IViewObject;
        
        protected var _controller:BaseController;
        
        protected var _info:ICharacterInfo;
        
        protected var _isInScene:Boolean;
        protected var _couldTick:Boolean;
        
        protected var _gid:uint;
        
        public function BaseObject()
        {
            super();
            _gid = GID_COUNT++;
        }
        
        public function get gid():uint
        {
            return _gid;
        }
        
        public function set qTree(q:QTree):void
        {
            _qTree = q;
        }
        
        public function get qTree():QTree
        {
            return _qTree;
        }
        
        public function tick(delta:Number):void
        {
            if( _viewObj )
            {
                if( _viewObj.isPlayEnd && action != ConstsActions.Die )
                {
                    _viewObj.action = ConstsActions.Wait;
                    _viewObj.isPlayEnd = false;
                }
                var x:int = int(_posX + _offsetX);
                var y:int = int(_posY + _offsetY);
                if( _viewObj.x != x )
                {
                    _viewObj.x = x;
                }
                if( _viewObj.y != y )
                {
                    _viewObj.y = y;
                }
                _viewObj.tick( delta );
            }
        }
        
        public function dispose():void
        {
            if( _controller )
            {
                _controller = null;
            }
            if( _viewObj )
            {
                _viewObj.dispose();
            }
        }
        
        public function set playRate( value:Number ):void
        {
            _viewObj.playRate = value;
        }
        
        public function set controller( ctrl:IBaseController ):void
        {
            if(_controller!=null)
            {
                _controller.unsetupListener();
            }
            
            if(ctrl!=null)
            {
                _controller = ctrl as BaseController;
                _controller.me=this;
                _controller.setupListener();
            }
        }
        
        public function get controller():IBaseController
        {
            return _controller as IBaseController;
        }
        
        public function set action(u:int):void
        {
            _action = u;
            _viewObj.action = u;
        }
        
        public function get action():int
        {
            return _action;
        }
        
        public function get direction():int
        {
            return _viewObj.dirIndex;
        }
        
        public function set direction(u:int):void
        {
            if( _direction != u )
            {
                _direction = u;
                _viewObj.dirIndex = u;
            }
        }
        
        public function set viewObject( value:IViewObject ):void
        {
            _viewObj = value;
            _viewObj.gid = _gid;
        }
        
        public function get viewObject():IViewObject
        {
            return _viewObj;
        }
        
        public function set offsetX( value:Number ):void
        {
            _offsetX = value;
        }
        
        public function set offsetY( value:Number ):void
        {
            _offsetY = value;
        }
        
        public function get POS():Point
        {
            return new Point( _posX, _posY );
        }
        
        public function get posX():Number
        {
            return _posX;
        }
        
        public function get posY():Number
        {
            return _posY;
        }
        
        public function setTiledPos( tiledPos:Point ):void
        {
            var pos:Point = scene.GridToView( tiledPos.x, tiledPos.y );
            posX = pos.x;
            posY = pos.y;
            logger.debug( pos );
        }
        
        public function set posX( value:Number ):void
        {
            _posX = value;
            if( !GameCamera.needReCut && GameCamera.cameraView && GameCamera.cameraView.contains( _posX, _posY ) ) 
            {
                GameCamera.needReCut = true;
            }
            if( _qTree )
            {
                _qTree = _qTree.reinsert( this, posX, posY );
            }
        }
        
        public function set posY( value:Number ):void
        {
            _posY = value;
            if( !GameCamera.needReCut && GameCamera.cameraView && GameCamera.cameraView.contains( _posX, _posY ) ) 
            {
                GameCamera.needReCut = true;
            }
            if( _qTree )
            {
                _qTree = _qTree.reinsert( this, posX, posY );
            }
        }
        
        public function set isInScene( value:Boolean ):void
        {
            _isInScene = value;
        }
        
        public function get isInScene():Boolean
        {
            return _isInScene;
        }
        
        public function set info( value:ICharacterInfo ):void
        {
            _info = value;
        }
        
        public function get info():ICharacterInfo
        {
            return _info;
        }
    }
}