/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.scene
{
    import com.D5Power.D5Camera;
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Perception;
    import com.D5Power.GMath.data.qTree.QTree;
    import com.D5Power.Objects.BuildingObject;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.Objects.Effects.RoadPoint;
    import com.D5Power.Render.RenderCharacter;
    import com.D5Power.Render.RenderEffect;
    import com.D5Power.Render.RenderNCharacter;
    import com.D5Power.Render.RenderParticleCont;
    import com.D5Power.Render.RenderStatic;
    import com.D5Power.events.ChangeMapEvent;
    import com.D5Power.graphics.Swf2d;
    import com.D5Power.graphicsManager.GraphicsResource;
    import com.D5Power.map.WorldMap;
    import com.D5Power.mission.EventData;
    import com.D5Power.mission.MissionData;
    import com.D5Power.ns.NSCamera;
    import com.D5Power.ns.NSGraphics;
    import com.D5Power.particle.ParticleBox;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    
    use namespace NSCamera;
    use namespace NSGraphics;
    
    public class BaseScene
    {
        /**
         * 建筑渲染器
         */ 
        protected var render_building:RenderStatic;
        /**
         * NPC渲染器
         */ 
        protected var render_npc:RenderNCharacter;
        /**
         * 角色渲染器
         */
        protected var render_pc:RenderCharacter;
        /**
         * 效果渲染器
         */ 
        protected var render_effect:RenderEffect;
        
        /**
         * 粒子容器渲染器
         */ 
        protected var render_particle:RenderParticleCont;
        
        /**
         * 感知器
         */
        public var perc:Perception;
        
        /**
         * 游戏内的显示对象
         */
        protected var _objects:Array;
        
        /**
         * 地图
         */ 
        protected var map:WorldMap;
        
        /**
         * 双缓冲区
         */ 
        //public var doubleBuffer:BitmapData;
        
        protected var _mapGround:Shape;
        
        /**
         * 游戏对象四叉树
         */ 
        protected var qTree:QTree;
        
        /**
         * 效果缓冲区，本缓冲区位于最上层
         */ 
        //public var effectBuffer:BitmapData;		
        
        protected var _stage:Stage;
        
        protected var _isReady:Boolean=false;
        
        /**
         * 主角
         */ 
        protected static var player:CharacterObject;
        
        
        
        protected var _container:DisplayObjectContainer;
        
        protected var _layer_effect:Sprite;
        
        
        /**
         * 上一次的排序时间
         */ 
        private var _lastZorder:uint;
        /**
         * 深度使用列表
         */ 
        private static var _deepList:Vector.<uint>;
        
        /**
         * 当前正在渲染的对象
         */ 
        private var _nowRend:uint;
        
        /**
         * 当前正在计算的屏幕外控制器
         */ 
        private var _nowRunOutSceneCtrl:uint;
        
        
        private var _screenObj:Array;
        
        
        /**
         * @param	stg			舞台
         * @param	container	渲染容器，若为NULL则指定为舞台
         */ 
        public function BaseScene(stg:Stage,container:DisplayObjectContainer)
        {
            if(_deepList!=null)
            {
                _deepList.splice(0,_deepList.length)
            }else{
                _deepList = new Vector.<uint>;
            }
            
            perc = new Perception(this);
            _stage=stg;
            _container = container;
            
            _objects = new Array();
            _screenObj = new Array();
            
            
            _layer_effect = new Sprite();
            
            _container.addChild(_layer_effect);
            
            
            buildBuffer();
            
            
            render_effect = new RenderEffect();
            render_npc = new RenderNCharacter();
            render_pc = new RenderCharacter();
            render_building = new RenderStatic();
            render_particle = new RenderParticleCont();
        }
        
        /**
         * 初始化地图
         * @param	mapid		地图ID
         * @param	hasTile		是否地砖地图（分块加载）
         * @param	tileFormat	地砖格式
         */ 
        public function setupMap(mapid:uint,hasTile:uint,tileFormat:String):void
        {
            map = new WorldMap(mapid);
            map.hasTile = hasTile;
            map.tileFormat = tileFormat;
            map.dbuffer = _mapGround;
            map.install();
            
            
            _container.addChild(_mapGround);
            _isReady = true;
        }
        
        /**
         * 获得角色渲染器
         */ 
        public function get renderPC():RenderCharacter
        {
            return render_pc;
        }
        
        /**
         * 获得NPC渲染器
         */ 
        public function get renderNPC():RenderNCharacter
        {
            return render_npc;
        }
        
        /**
         * 获得建筑渲染器
         */ 
        public function get renderBuilding():RenderStatic
        {
            return render_building;
        }
        
        /**
         * 粒子容器渲染器
         */ 
        public function get renderParticleCont():RenderParticleCont
        {
            return render_particle;
        }
        /**
         * 点击了有任务的NPC后的处理
         * @param	say		NPC默认说的话
         * @param	miss	可见任务列表
         */ 
        public function missionCallBack(name:String,say:String,event:EventData,miss:Vector.<MissionData>,obj:NCharacterObject):void
        {
            
        }
        
        public function buildQtree():void
        {
            qTree = new QTree(new Rectangle(0,0,Global.MAPSIZE.x,Global.MAPSIZE.y),4);
        }
        
        /**
         * 创建NPC
         * @param	s			位图资源名
         * @param	resname		缓冲池资源名
         * @param	name		NPC姓名
         * @param	pos			目前所在位置
         * @param	dirConfig	方向配置参数，若为NULL，则为静态1帧
         */
        public function createNPC(s:String,resname:String,name:String='',pos:Point=null,dirConfig:Object=null):NCharacterObject
        {
            var displayer:Swf2d = new Swf2d();
            displayer.changeSWF('asset/mapRes/'+s);
            
            var npc:NCharacterObject = new NCharacterObject(null);
            npc.displayer = displayer;
            npc.setName(name);
            npc.setDirectionNum(npc.directions.Stop);
            
            
            if(pos!=null) npc.setPos(pos.x,pos.y);
            
            addObject(npc);
            
            return npc;
        }
        /**
         * 创建路点
         * @param	s		资源路径
         * @param	frame	路点素材帧数
         * @param	pos		坐标
         */ 
        public function createRoad(posx:uint=0,posy:uint=0):RoadPoint
        {
            var g:GraphicsResource = new GraphicsResource(null);
            g.addLoadResource([WorldMap.LIB_DIR+'Road.png'],0,5,1,15);
            var obj:RoadPoint = new RoadPoint(this);
            obj.graphicsRes = g;
            obj.setPos(posx,posy);
            
            createEffect(obj,true);
            return obj;
        }
        
        /**
         * 创建建筑
         * @param	resList
         * @param	pos		目前所在位置
         */ 
        public function createBuilding(resource:String,resname:String,pos:Point=null):BuildingObject
        {
            var displayer:Swf2d = new Swf2d();
            displayer.changeSWF('asset/mapRes/'+resource);
            
            var house:BuildingObject = new BuildingObject(this);
            if(pos!=null)
            {
                house.setPos(pos.x,pos.y);
                
            }
            house.displayer = displayer;
            
            if(pos!=null) house.setPos(pos.x,pos.y);
            
            addObject(house);
            
            return house;
        }
        
        /**
         * 创建玩家
         * @param	s		位图资源
         * @param	name	玩家姓名
         * @param	pos		目前所在位置
         * @param	ctrl	专用控制器，如果为空，则使用默认的角色控制器
         */ 
        public function createPlayer(p:CharacterObject):void
        {
            if(player==null) player = p;
            
            // 更新感知器为当前场景的感知器。由于player为静态变量，因此当场景重建后，其感知器依然指向已不存在的旧感知器
            p.controler.perception = perc; 
            player.alphaCheck=true;
            addObject(player);
            pushRenderList(player);
        }
        
        /**
         * 创建效果
         * @param	b					要创建的效果
         * @param	checkView			创建时是否检测视口，若为false，则无条件添加。否则，物品必须在视野范围内才会添加
         * @param	userEffectBuffer	是否使用EFFECT缓存
         */ 
        public function createEffect(b:GameObject,useEffectBuffer:Boolean=false):void
        {			
            //b.render=useEffectBuffer ? render_effect : render_building;
            addObject(b);
        }
        
        /**
         * 重新裁剪
         * 更新目前屏幕内的游戏对象
         * 
         * @param	update		是否更新摄像头可视区域
         */ 
        NSCamera function ReCut(update:Boolean=true):void
        {
            //if(update) D5Camera.cameraView = Map.cameraView;
            for each(var obj:GameObject in _objects)
            {
                if(obj==player) continue;
                if(D5Camera.cameraView.containsPoint(obj._POS))
                {
                    pushRenderList(obj);
                }else{
                    pullRenderList(obj);
                }
            }
            D5Camera.$needReCut = false;
        }
        
        
        public function get Player():CharacterObject
        {
            return player;
        }
        
        /**
         * 初始化缓冲区
         */ 
        public function buildBuffer():void
        {
            //doubleBuffer = new BitmapData(Global.W,Global.H,false,0);
            //effectBuffer = new BitmapData(Global.W,Global.H,false,0);
            
            _mapGround = new Shape();
            //_mapGround.cacheAsBitmap=true;
        }
        
        /**
         * 确认某指定目标是否在当前的镜头视野中
         */ 
        public function inScene(obj:GameObject):Boolean
        {
            if(qTree==null) return true;
            return qTree.isIn(obj.PosX,obj.PosY);
        }
        
        /**
         * 向场景中添加游戏对象
         */ 
        public function addObject(o:GameObject):void
        {
            if(_objects.indexOf(o)!=-1) return;
            _objects.push(o);
            if(qTree!=null)
            {
                o.qTree = qTree.add(o,o.PosX,o.PosY);
            }
            
            if(D5Game.me.camera.cameraCutView.containsPoint(o._POS))
            {
                pushRenderList(o);
            } 
        }
        /**
         * 
         */ 
        public function removeObject(o:GameObject):void
        {
            var i:int = _objects.indexOf(o);
            
            if(i!=-1) _objects.splice(i,1);
            
            if(qTree!=null)
            {
                qTree.remove(o);
            }
            
            pullRenderList(o);
            
            o.dispose();
            o=null;
        }
        
        /**
         * 将游戏对象加入渲染列表
         */ 
        public function pushRenderList(o:GameObject):void
        {
            if(_screenObj.indexOf(o)!=-1) return;
            
            _screenObj.push(o);
            
            _container.addChild(o);
            o.$inScene = true;
            
            if(D5Camera.AlphaEffect) o.isIning();
        }
        
        /**
         * 将游戏对象移出渲染列表
         * @param	o			要移除的游戏对象
         * @param	deleteAbs	是否绝对删除（从对象列表中彻底删除）
         */ 
        public function pullRenderList(o:GameObject,deleteAbs:Boolean=false):void
        {
            var index:int = _screenObj.indexOf(o);
            if(index!=-1) _screenObj.splice(index,1);
            
            if(_container.contains(o))
            {
                _container.removeChild(o);
                o.$inScene = false;
                if(D5Camera.AlphaEffect) o.isOuting();
            }
        }
        
        /**
         * 获得特定的游戏对象
         * @param	i	索引
         */ 
        public function getObject(i:uint):GameObject
        {
            if(i>ObjectsNumber)
                return null;
            else
                return _objects[i] as GameObject;	
        }
        
        /**
         * 获得特定的角色对象
         * 
         * @param	i	索引
         */ 
        public function getCharacter(i:uint):CharacterObject
        {
            if(i>ObjectsNumber)
                return null;
            else
                return _objects[i] as CharacterObject;
        }
        
        /**
         * 得到所有游戏对象
         */
        public function get objList():Array
        {
            return _objects;
        }
        
        /**
         * 获得目前舞台中的
         * 
         */ 
        public function get ObjectsNumber():uint
        {
            return _objects.length;
        }
        
        /**
         * 记忆工作区
         */ 
        public function set stage(s:Stage):void
        {
            _stage=s;
        }
        
        /**
         * 获取工作区
         */ 
        public function get stage():Stage
        {
            return _stage;
        }
        
        /**
         * 是否加载完成
         */ 
        public function get isReady():Boolean
        {
            return _isReady;
        }
        
        /**
         * 更换场景
         * @param	id		目的场景ID
         * @param	startx	起始坐标X
         * @param	starty	起始坐标Y
         */ 
        public function changeScene(id:uint,startx:uint,starty:uint):void
        {
            _stage.dispatchEvent(new ChangeMapEvent(id,startx,starty));
        }
        
        /**
         * 渲染输出
         * 
         */ 
        public function render():void
        {
            updateTime();			
            draw();
        }
        
        protected function updateTime():void
        {
            Global.Timer = getTimer();
        }
        
        protected function draw():void
        {
            map.render();
            
            if(_objects.length==0) return;
            
            var needOrder:Boolean = Global.Timer-_lastZorder>D5Camera.ZorderTime;
            
            ParticleBox.me.render();
            
            for(var i:int = _objects.length-1;i>=0;i--)
            {
                if(_objects[i])
                {
                    _objects[i].runPos();
                }else{
                    trace("unvalue object",i);
                }
            }
            
            
            if(needOrder)
            {
                _screenObj.sortOn("zOrder",Array.NUMERIC);
                var child:DisplayObject;	// 场景对象
                
                var max:uint = _screenObj.length;
                var item:GameObject; // 循环对象
                
                while(max--)
                {
                    item = _screenObj[max];
                    
                    if(max<_container.numChildren)
                    {
                        child = _container.getChildAt(max);
                        if(child!=item && _container.contains(item))
                        {
                            _container.setChildIndex(item,max);
                        }
                    }
                    
                }
                _container.setChildIndex(_mapGround,0);
                _lastZorder = Global.Timer;
                
                ReCut();
            }else if(D5Camera.needReCut){
                ReCut();
            }
            
            var render:GameObject = D5Game.me.camera.focusObject;
            
            while(true)
            {
                render = _screenObj[_nowRend];
                
                if(render==null)
                {
                    _nowRend = 0;
                    break;
                }
                _screenObj[_nowRend].renderMe();
                _nowRend++;
                
                if(getTimer()-Global.Timer>D5Camera.RenderMaxTime) break;
            }
            
            D5Game.me.camera.update();
        }
        
        public function get container():DisplayObjectContainer
        {
            return _container;
        }
        
        public function clear():void
        {
            _objects.splice(0,_objects.length);
            
            while(_layer_effect.numChildren) _layer_effect.removeChildAt(0);
            while(_container.numChildren) _container.removeChildAt(0);
            
            _mapGround.graphics.clear();
            _mapGround = null;
            
            if(player)
            {
                player.controler.perception.Scene=null;
                player.controler.perception=null;
                player=null;
            }
            //doubleBuffer.dispose();
        }
    }
}