package com.inoah.ro.maps
{
    import com.inoah.ro.RoCamera;
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.AtfLoader;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.objects.BaseObject;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    
    import as3.patterns.mediator.Mediator;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.Texture;
    
    public class BaseMap extends Mediator
    {
        protected var _qTree:QTree;
        
        protected var _mapBg:Image;
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
        protected var _unitContainer:flash.display.DisplayObjectContainer;
        protected var _mapContainer:starling.display.DisplayObjectContainer;
        /**
         * 排序计时器 
         */        
        protected var _orderCounter:Counter;
        
        public function BaseMap( unitContainer:flash.display.DisplayObjectContainer, mapContainer:starling.display.DisplayObjectContainer )
        {
            super();
            _orderCounter = new Counter();
            _orderCounter.initialize();
            _orderCounter.reset( RoGlobal.ORDER_TIME );
            _unitContainer = unitContainer;
            _mapContainer = mapContainer;
            _unitList = new Vector.<BaseObject>();
            _screenObj = new Vector.<BaseObject>();
            _qTree = new QTree(new Rectangle(0,0,RoGlobal.MAP_W,RoGlobal.MAP_H), 3 );
        }
        
        public function init( mapId:uint ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "map/" + mapId + ".atf" , onMapLoadComplete );
        }
        
        private function onMapLoadComplete( loader:ILoader ):void
        {
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var texture:Texture = textureMgr.getTexture( "1" , (loader as AtfLoader).data );
            if( !_mapBg )
            {
                _mapBg = new Image( texture );
                _mapContainer.addChild( _mapBg );
            }
            else
            {
                _mapBg.texture = texture;
            }
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
            
            if(RoCamera.cameraView.containsPoint( o.POS ) )
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
                if(RoCamera.cameraView.containsPoint( obj.POS ))
                {
                    pushRenderList(obj);
                }
                else
                {
                    pullRenderList(obj);
                }
            }
            RoCamera.needReCut = false;
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
            if(RoCamera.AlphaEffect) 
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
                if(RoCamera.AlphaEffect)
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
            if( _mapBg )
            {
                _mapBg.pivotX = -int(_offsetX);
                _mapBg.pivotY = -int(_offsetY);
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
                
                _orderCounter.reset( RoGlobal.ORDER_TIME );
                ReCut();
            }
            else if( RoCamera.needReCut )
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