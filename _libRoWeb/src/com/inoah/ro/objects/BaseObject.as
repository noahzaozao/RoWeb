package com.inoah.ro.objects
{
    import com.inoah.ro.RoCamera;
    import com.inoah.ro.characters.Actions;
    import com.inoah.ro.controllers.BaseController;
    import com.inoah.ro.interfaces.IViewObject;
    import com.inoah.ro.maps.QTree;
    
    import flash.geom.Point;
    
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
        public static var DEFAULT_DIRECTION:Direction=new Direction();
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
            if( _viewObj.isPlayEnd && action != Actions.Die )
            {
                _viewObj.action = Actions.Wait;
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
        
        public function get directions():Direction
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
            if( !RoCamera.needReCut && RoCamera.cameraView && RoCamera.cameraView.contains( _posX, _posY ) ) 
            {
                RoCamera.needReCut = true;
            }
            if( _qTree )
            {
                _qTree = _qTree.reinsert( this, posX, posY );
            }
        }
        
        public function set posY( value:Number ):void
        {
            _posY = value;
            if( !RoCamera.needReCut && RoCamera.cameraView && RoCamera.cameraView.contains( _posX, _posY ) ) 
            {
                RoCamera.needReCut = true;
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
    }
}