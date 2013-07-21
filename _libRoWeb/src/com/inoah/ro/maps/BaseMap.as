package com.inoah.ro.maps
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.AtfLoader;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.objects.BaseObject;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    
    public class BaseMap extends starling.display.Sprite
    {
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
        protected var _unitContainer:DisplayObjectContainer;
        
        public function BaseMap( unitContainer:DisplayObjectContainer )
        {
            super();
            _unitContainer = unitContainer;
            _unitList = new Vector.<BaseObject>();
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
                addChild( _mapBg );
            }
            else
            {
                _mapBg.texture = texture;
            }
        }
        
        public function addObject( o:BaseObject ):void
        {
            _unitList.push( o );
            _unitContainer.addChild( o.viewObject as DisplayObject );
        }
        
        public function ReCut(update:Boolean=true):void
        {
            //            for each(var obj:BaseObject in _unitList)
            //            {
            //                if(obj==_player) 
            //                {
            //                    continue;
            //                }
            //                if(RoCamera.cameraView.containsPoint(obj.pos))
            //                {
            //                    pushRenderList(obj);
            //                }
            //                else
            //                {
            //                    pullRenderList(obj);
            //                }
            //            }
            //            RoCamera.needReCut = false;
        }
        
        /**
         * 将游戏对象加入渲染列表
         */ 
        public function pushRenderList(o:BaseObject):void
        {
            //            if(_screenObj.indexOf(o)!=-1) return;
            //            
            //            _screenObj.push(o);
            //            
            //            _container.addChild(o);
            //            //            o.$inScene = true;
            //            //            if(RoCamera.AlphaEffect) o.isIning();
        }
        
        /**
         * 将游戏对象移出渲染列表
         * @param	o			要移除的游戏对象
         * @param	deleteAbs	是否绝对删除（从对象列表中彻底删除）
         */ 
        public function pullRenderList(o:BaseObject,deleteAbs:Boolean=false):void
        {
            //            var index:int = _screenObj.indexOf(o);
            //            if(index!=-1) _screenObj.splice(index,1);
            //            
            //            if(_container.contains(o))
            //            {
            //                _container.removeChild(o);
            //                //                o.$inScene = false;
            //                //                if(RoCamera.AlphaEffect) o.isOuting();
            //            }
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
            
            //            var needOrder:Boolean = Global.Timer-_lastZorder>D5Camera.ZorderTime;
            //            
            //            ParticleBox.me.render();
            
            //            for(var i:int = _unitList.length-1;i>=0;i--)
            //            {
            //                if(_unitList[i])
            //                {
            //                    _unitList[i].runPos();
            //                }
            //                else
            //                {
            //                    trace("unvalue object",i);
            //                }
            //        }
            
            
            //            if(needOrder)
            //            {
            //                _screenObj.sortOn("zOrder",Array.NUMERIC);
            //                var child:DisplayObject;	// 场景对象
            //                
            //                var max:uint = _screenObj.length;
            //                var item:GameObject; // 循环对象
            //                
            //                while(max--)
            //                {
            //                    item = _screenObj[max];
            //                    
            //                    if(max<_container.numChildren)
            //                    {
            //                        child = _container.getChildAt(max);
            //                        if(child!=item && _container.contains(item))
            //                        {
            //                            _container.setChildIndex(item,max);
            //                        }
            //                    }
            //                    
            //                }
            //                _container.setChildIndex(_mapGround,0);
            //                _lastZorder = Global.Timer;
            //                
            //                ReCut();
            //            }else if(D5Camera.needReCut){
            //                ReCut();
            //            }
            
            //            var render:GameObject = D5Game.me.camera.focusObject;
            
            //            while(true)
            //            {
            //                render = _screenObj[_nowRend];
            //                
            //                if(render==null)
            //                {
            //                    _nowRend = 0;
            //                    break;
            //                }
            //                _screenObj[_nowRend].renderMe();
            //                _nowRend++;
            //                
            //                if(getTimer()-Global.Timer>D5Camera.RenderMaxTime) break;
            //            }
        }
    }
}