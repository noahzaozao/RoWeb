package com.D5Power
{
    import com.D5Power.Objects.BuildingObject;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.Objects.Effects.RoadPoint;
    import com.D5Power.events.ChangeMapEvent;
    import com.D5Power.loader.MutiLoader;
    import com.D5Power.map.WorldMap;
    import com.D5Power.ns.NSCamera;
    import com.D5Power.scene.BaseScene;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display3D.Context3D;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    
    use namespace NSCamera;
    
    public class D5Game extends Sprite
    {
        
        public static var configPath:String = 'config/';
        
        private var loader:URLLoader;
        
        /**
         * Stage3D对象
         */ 
        private var _gpuContext0:Context3D;
        
        /**
         * 是否开启硬件加速
         */ 
        private var _gpuMode:Boolean;
        /**
         * 是否尝试使用GPU加速
         */ 
        private var _gpuTry:Boolean;
        
        /**
         * 切换地图时的识别码
         */ 
        protected var _id:uint;
        
        /**
         * 主游戏场景
         */ 
        protected var _scene:BaseScene;
        
        protected var _camera:D5Camera;
        
        protected var _config:String;
        
        protected var _stg:Stage;
        
        protected var _loadData:Array=[];
        
        protected var _mtLoader:MutiLoader;
        
        protected var _data:XML;
        
        /**
         * 角色出现的起始位置X
         */ 
        protected var _startX:uint;
        
        /**
         * 角色出现的起始位置Y
         */ 
        protected var _startY:uint;
        
        protected var _nextStep:Function;
        
        protected var _readyBack:Function;
        
        private static var _me:D5Game;
        
        public static function get me():D5Game
        {
            return _me;
        }
        /**
         * @param	config	配置文件地址
         * @param	stg		舞台
         * @param	openGPU	是否开启GPU加速
         */ 
        public function D5Game(config:String,stg:Stage,openGPU:uint=0)
        {
            if(_me) error();
            
            _me = this;
            
            super();
            
            _config = config;
            _stg = stg;
            _gpuTry = openGPU !=0;
            
            Global.W = _stg.stageWidth;
            Global.H = _stg.stageHeight;
            
            addEventListener(Event.ADDED_TO_STAGE,install);
            
        }
        
        public function get gpuMode():Boolean
        {
            return _gpuMode;
        }
        
        protected function install(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE,install);
            
            if(_gpuTry)
            {
                // 尝试请求Stage3D
                stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onCreateStage3D);
                stage.stage3Ds[0].requestContext3D();
            }else{
                installStart();
            }
        }
        
        
        public function get camera():D5Camera
        {
            return _camera;
        }
        
        public function get scene():BaseScene
        {
            return _scene;
        }
        
        public function clear():void
        {
            stop();
            
            var timer:Timer = new Timer(500);
            timer.addEventListener(TimerEvent.TIMER,autoUnsetup);
            timer.start();
        }
        
        protected function installStart():void
        {
            if(_config!='')
            {
                loadConfig();
            }else{
                setupMySelf();
            }
            
            addEventListener(Event.DEACTIVATE,onDeactivete);
            _stg.addEventListener(ChangeMapEvent.CHANGE,onChangeMap);
            _stg.addEventListener(Event.RESIZE,onResize);
        }
        
        protected function onCreateStage3D(e:Event):void
        {
            _gpuContext0 = stage.stage3Ds[0].context3D;
            _gpuMode = true;
        }
        
        /**
         * 加载配置文件
         */ 
        protected function loadConfig():void
        {
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.load(new URLRequest(Global.httpServer+configPath+_config+'.d5'));
            loader.addEventListener(IOErrorEvent.IO_ERROR,onConfigIO);
            loader.addEventListener(Event.COMPLETE,parseData);
        }
        
        protected function onChangeMap(e:ChangeMapEvent):void
        {
            if(e.isAutoSetup)
            {
                if(e.sameMapNotChange && _id==e.toMap) return; // 同地图不切换
                clear();
                _config = '';
                _id = e.toMap;
                _nextStep = setupMySelf;
            }else{
                
                if(e.sameMapNotChange && _config=='map'+e.toMap) return; // 同地图不切换
                
                _config = 'map'+e.toMap;
                _id = e.toMap;
                _nextStep =  loadConfig;
                
                clear();
            }
            
            _data = null;
            _startX = e.toX;
            _startY = e.toY;
            
            if(_scene.Player) _scene.Player.visible=false;
        }
        
        /**
         * 当FP失去焦点时候的处理函数
         */ 
        protected function onDeactivete(e:Event):void
        {
            
        }
        
        protected function onConfigIO(e:IOErrorEvent):void
        {
            trace("D5Game load config io error");	
        }
        
        /**
         * 创建游戏场景
         */ 
        protected function buildScene():void
        {
            if(_scene==null) _scene = new BaseScene(_stg,this);
        }
        
        /**
         * 解析配置文件
         */ 
        protected function parseData(e:Event):void
        {
            loader.removeEventListener(Event.COMPLETE,parseData);
            var by:ByteArray = loader.data as ByteArray;
            by.uncompress();
            var configXML:String = by.readUTFBytes(by.bytesAvailable);
            setup(configXML);
        }
        
        protected function setupMySelf():void
        {
            throw new Error("[D5Game]看到这个错误，是因为您选择了自己初始化D5RPG，但又没有覆写setupMySelf方法。当前的操作识别码为"+_id);
        }
        
        /**
         * 根据配置文件进行场景的数据初始化
         */ 
        protected function setup(s:String):void
        {
            _data = new XML(s);
            
            Global.TILE_SIZE.x = _data.tileX;
            Global.TILE_SIZE.y = _data.tileY;
            Global.MAPSIZE.x = _data.mapW;
            Global.MAPSIZE.y = _data.mapH;
            
            var loadArr:Array = [];
            var libArr:Array = [];
            
            if(Global.characterLib==null && Global.LIBNAME!='')
            {
                loadArr.push(Global.LIBNAME);
                libArr.push('characterLib');
            }
            
            buildScene();
            
            if(WorldMap.me) WorldMap.me.removeEventListener(Event.COMPLETE,init);
            _scene.setupMap(_data.id,_data.hasTile,_data.tileFormat);
            _camera = new D5Camera(_scene);
            
            
            if(_data.loopbg!='') WorldMap.me.loopBG = _data.loopbg;
            
            if(loadArr.length>0)
            {
                configMLoader(loadArr,libArr);
            }else{
                start();
            }
        }
        
        protected function configMLoader(loadArr:Array,libArr:Array):void
        {
            // 自动加载资源库
            _mtLoader = new MutiLoader(_loadData);
            _mtLoader.addEventListener(Event.COMPLETE,onLoadComplate);
            addChild(_mtLoader);
            _mtLoader.load(loadArr,libArr);
            
        }
        
        /**
         * 资源库加载完成后进行素材处理
         */ 
        protected function onLoadComplate(e:Event):void
        {
            _mtLoader.clear();
            _mtLoader.removeEventListener(Event.COMPLETE,onLoadComplate);
            
            if(_mtLoader.libList==null)
            {
                if(_loadData.length==1)
                {
                    Global.mapLib = _loadData[1] as ApplicationDomain;
                }else{
                    Global.characterLib = _loadData[0] as ApplicationDomain;
                    Global.mapLib = _loadData[1] as ApplicationDomain;
                }
            }else{
                for(var i:uint = 0;i<_mtLoader.libList.length;i++)
                {
                    Global[_mtLoader.libList[i]] = _loadData[i];
                }
            }
            
            removeChild(_mtLoader);
            _mtLoader=null;
            start();
        }
        
        /**
         * 开始运行
         */ 
        protected function start():void
        {
            if(WorldMap.me.smallMap==null)
            {
                WorldMap.me.addEventListener(Event.COMPLETE,init);
            }else{
                init();
            }
        }
        
        protected function init(e:Event=null):void
        {
            if(e!=null) WorldMap.me.removeEventListener(Event.COMPLETE,init);
            
            buildObjects();
            buildPlayer();
            
            play();
            
            Global.GC();
            
            if(_scene.Player)
            {
                _scene.Player.setPos(_startX,_startY);
            }else{
                _camera.lookAt(_startX,_startY);
            }
            
            if(_readyBack!=null)
            {
                _readyBack();
                _readyBack = null;
            }
            
            
            //if(stage.stageWidth>Global.MAPSIZE.x) x = int((stage.stageWidth-Global.MAPSIZE.x)>>1);
            
        }
        
        protected function buildPlayer():void
        {
            
        }
        
        /**
         * 根据配置文件构建场景所有游戏对象
         */ 
        protected function buildObjects():void
        {
            
            if(_data!=null)
            {
                if(_data.music!=null) Global.bgMusic.play(_data.music);
                
                for each(var npclist:* in _data.npc.obj)
                {
                    var obj:NCharacterObject = _scene.createNPC(npclist.res,WorldMap.me.mapid+"_"+npclist.res,npclist.name,new Point(npclist.posx,npclist.posy));
                    obj.uid = npclist.uid;
                    obj.loadMissionScript();
                }
                
                for each(var buildList:* in _data.build.obj)
                {
                    if(buildList.res=='') continue;
                    var bld:BuildingObject = _scene.createBuilding(Global.httpServer+WorldMap.LIB_DIR+'map/map'+WorldMap.me.mapid+'/'+buildList.res,WorldMap.me.mapid+"_"+buildList.res,new Point(buildList.posx,buildList.posy));
                    bld.zero=new Point(buildList.centerx,buildList.centery);
                    bld.canBeAtk = buildList.canBeAtk=='true' ? true : false;
                    bld.zOrderF = buildList.zorder;
                }
                
                for each(var roadList:* in _data.roadpoint.obj)
                {
                    if(roadList.posx=='') continue;
                    var road:RoadPoint = _scene.createRoad(roadList.posx,roadList.posy);
                    road.toMap = roadList.toMap;
                    road.toX = roadList.toX;
                    road.toY = roadList.toY;
                    road.canBeAtk=false;
                }
            }
        }
        
        protected function autoUnsetup(e:Event):void
        {
            var timer:Timer = e.target as Timer;
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,autoUnsetup);
            
            if(_scene)_scene.clear();
            _scene = null;
            
            if(_nextStep!=null) _nextStep();
            _nextStep=null;
        }
        
        /**
         * 停止运行
         */ 
        public function stop():void
        {
            removeEventListener(Event.ENTER_FRAME,render);
            removeEventListener(Event.DEACTIVATE,onDeactivete);
            if(_scene && _scene.Player!=null) _scene.Player.controler.unsetupListener();
        }
        
        public function play():void
        {
            if(hasEventListener(Event.ENTER_FRAME)) return;
            addEventListener(Event.ENTER_FRAME,render);
            if(_scene.Player!=null) _scene.Player.controler.setupListener();
        }
        
        /**
         * 渲染
         */ 
        protected function render(e:Event):void
        {
            if(_scene.isReady) _scene.render();
        }
        
        private function onResize(e:Event):void
        {
            if(_stg.stageWidth>0)
            {
                Global.W = _stg.stageWidth;
                Global.H = _stg.stageHeight;
                if(WorldMap.me) WorldMap.me.resize();
            }
        }
        
        private function error():void
        {
            throw new Error(this," can only build once.");
        }
    }
}