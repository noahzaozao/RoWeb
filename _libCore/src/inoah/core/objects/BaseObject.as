package inoah.core.objects
{
    import flash.geom.Point;
    
    import inoah.core.consts.ConstsActions;
    import inoah.core.consts.ConstsDirection;
    import inoah.core.controllers.BaseController;
    import inoah.core.infos.CharacterInfo;
    import inoah.core.interfaces.IViewObject;
    import inoah.core.GameCamera;
    import inoah.core.QTree;
    
    /**
     * 地图物体基类
     * @author inoah
     */    
    public class BaseObject
    {
        protected var _qTree:QTree;
        /**
         * 默认方向配置
         */ 
        public static var DEFAULT_DIRECTION:ConstsDirection=new ConstsDirection();
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
        
        protected var _info:CharacterInfo;
        
        protected var _isInScene:Boolean;
        protected var _couldTick:Boolean;
        
        public function BaseObject()
        {
            super();
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
        
        public function dispose():void
        {
            _viewObj.dispose();
        }
        
        public function set playRate( value:Number ):void
        {
            _viewObj.playRate = value;
        }
        
        public function set controller( ctrl:BaseController ):void
        {
            if(_controller!=null)
            {
                _controller.unsetupListener();
            }
            
            if(ctrl!=null)
            {
                _controller = ctrl;
                _controller.me=this;
                _controller.setupListener();
            }
        }
        
        public function get controller():BaseController
        {
            return _controller;
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
        
        public function set direction(u:int):void
        {
            if( _direction != u )
            {
                _direction = u;
                _viewObj.direction = u;
            }
        }
        
        public function get directions():ConstsDirection
        {
            return DEFAULT_DIRECTION;
        }
        
        public function set viewObject( value:IViewObject ):void
        {
            _viewObj = value;
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
        
        public function set info( value:CharacterInfo ):void
        {
            _info = value;
        }
        
        public function get info():CharacterInfo
        {
            return _info;
        }
    }
}