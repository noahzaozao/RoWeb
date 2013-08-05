package inoah.game.ro.mediators.maps
{
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.core.Global;
    import inoah.core.interfaces.IMapMediator;
    import inoah.core.objects.BaseObject;
    import inoah.core.utils.Counter;
    import inoah.data.map.MapInfo;
    import inoah.core.GameCamera;
    import inoah.core.QTree;
    import inoah.game.ro.mapModels.BaseMapModel;
    
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    
    public class BaseMapMediator extends Mediator implements IMapMediator
    {
        protected var _qTree:QTree;
        
        protected var _baseMapModel:BaseMapModel;
        /**
         * 屏幕对象列表 
         */        
        protected var _screenObj:Vector.<BaseObject>;
        /**
         * 对象列表 
         */        
        protected var _unitList:Vector.<BaseObject>;
        /**
         * 玩家自己 
         */        
        protected var _player:BaseObject;
        
        protected var _offsetY:Number;
        protected var _offsetX:Number;
        /**
         *  显示对象容器
         */        
        protected var _unitContainer:starling.display.DisplayObjectContainer;
        protected var _mapContainer:starling.display.DisplayObjectContainer;
        /**
         * 排序计时器 
         */        
        protected var _orderCounter:Counter;
        
        public function BaseMapMediator( unitContainer:starling.display.DisplayObjectContainer, mapContainer:starling.display.DisplayObjectContainer )
        {
            super();
            _orderCounter = new Counter();
            _orderCounter.initialize();
            _orderCounter.reset( Global.ORDER_TIME );
            _unitContainer = unitContainer;
            _mapContainer = mapContainer;
            _unitList = new Vector.<BaseObject>();
            _screenObj = new Vector.<BaseObject>();
            _qTree = new QTree(new Rectangle(0,0,Global.MAP_W,Global.MAP_H), 3 );
        }
        
        public function init( mapId:uint ):void
        {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener( flash.events.Event.COMPLETE , onMapLoadComplete );
            loader.load( new URLRequest( "map/map002.json" ));
        }
        
        private function onMapLoadComplete( e:flash.events.Event):void
        {
            var loader:URLLoader = e.currentTarget as URLLoader;
            loader.removeEventListener( flash.events.Event.COMPLETE , onMapLoadComplete );
            var jsonStr:String = loader.data as String;
            var jsonObj:Object = JSON.parse( jsonStr );
            var mapInfo:MapInfo = new MapInfo( jsonObj );
            var mapBase:BaseMapModel = new BaseMapModel( _mapContainer );
            mapBase.init( mapInfo ); 
        }
        
        public function addObject( o:BaseObject ):void
        {
            if( _unitList.indexOf( o ) != -1 )
            {
                return;
            }
            _unitList.push( o );
            if(_qTree!=null)
            {
                o.qTree = _qTree.add(o,o.posX,o.posY);
            }
            
            if(GameCamera.cameraView.containsPoint( o.POS ) )
            {
                pushRenderList(o);
            }
        }
        
        public function removeObject(o:BaseObject):void
        {
            var i:int = _unitList.indexOf(o);
            
            if(i!=-1) 
            {
                _unitList.splice(i,1);
            }
            
            if(_qTree!=null)
            {
                _qTree.remove(o);
            }
            
            pullRenderList(o);
            
            o.dispose();
            o=null;
        }
        
        public function ReCut(update:Boolean=true):void
        {
            for each(var obj:BaseObject in _unitList)
            {
                if(obj==_player) 
                {
                    continue;
                }
                if(GameCamera.cameraView.containsPoint( obj.POS ))
                {
                    pushRenderList(obj);
                }
                else
                {
                    pullRenderList(obj);
                }
            }
            GameCamera.needReCut = false;
        }
        
        /**
         * 将游戏对象加入渲染列表
         */ 
        public function pushRenderList(o:BaseObject):void
        {
            if(_screenObj.indexOf(o)!=-1) 
            {
                return;
            }
            _screenObj.push(o);
            
            _unitContainer.addChild( o.viewObject as DisplayObject );
            o.isInScene = true;
            if(GameCamera.AlphaEffect) 
            {
                //                o.isIning();
            }
            
        }
        
        /**
         * 将游戏对象移出渲染列表
         * @param	o			要移除的游戏对象
         * @param	deleteAbs	是否绝对删除（从对象列表中彻底删除）
         */ 
        public function pullRenderList(o:BaseObject,deleteAbs:Boolean=false):void
        {
            var index:int = _screenObj.indexOf(o);
            if(index!=-1)
            {
                _screenObj.splice(index,1);
            }
            
            if(_unitContainer.contains( o.viewObject as DisplayObject))
            {
                _unitContainer.removeChild( o.viewObject as DisplayObject );
                o.isInScene = false;
                if(GameCamera.AlphaEffect)
                {
                    //                    o.isOuting();
                }
            }
        }
        
        public function set offsetX( value:Number ):void
        {
            _offsetX = value;
        }
        
        public function set offsetY( value:Number ):void
        {
            _offsetY = value;
        }
        
        public function tick(delta:Number):void
        {
            if( _mapContainer )
            {
                _mapContainer.x = int(_offsetX);
                _mapContainer.y = int(_offsetY);
            }
            
            if(_unitList.length==0) 
            {
                return;
            }
            
            var len:int = _unitList.length;
            for ( var i:int = 0; i<len;i++)
            {
                if( _unitList[i] )
                {
                    _unitList[i].offsetX = _offsetX;
                    _unitList[i].offsetY = _offsetY;
                }
            }
            
            _orderCounter.tick( delta );
            if( _orderCounter.expired )
            {
                _screenObj.sort( sortFunc );
                var child:DisplayObject;	// 场景对象
                
                var max:uint = _screenObj.length;
                var item:BaseObject; // 循环对象
                
                while(max--)
                {
                    item = _screenObj[max];
                    
                    if(max<_unitContainer.numChildren)
                    {
                        child = _unitContainer.getChildAt(max);
                        if(child!=item.viewObject && _unitContainer.contains( item.viewObject as DisplayObject) )
                        {
                            _unitContainer.setChildIndex( item.viewObject as DisplayObject ,max);
                        }
                    }
                }
                
                _orderCounter.reset( Global.ORDER_TIME );
                ReCut();
            }
            else if( GameCamera.needReCut )
            {
                ReCut();
            }
        }
        
        protected function sortFunc( a:BaseObject, b:BaseObject):Number
        {
            return a.posY - b.posY;
        }
    }
}