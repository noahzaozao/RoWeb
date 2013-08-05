package com.inoah.ro.mediators
{
    import com.adobe.utils.AGALMacroAssembler;
    import com.inoah.ro.LuaDisplayObject;
    import com.inoah.ro.starlingMain;
    import com.inoah.ro.managers.BattleMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.MapMgr;
    import com.inoah.ro.mediators.views.MainViewMediator;
    import com.inoah.ro.ui.MainView;
    
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getDefinitionByName;
    
    import inoah.game.Global;
    import inoah.game.consts.GameCommands;
    import inoah.game.consts.GameConsts;
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.infos.UserInfo;
    import inoah.game.interfaces.IMgr;
    import inoah.game.interfaces.ITickable;
    import inoah.game.loaders.ILoader;
    import inoah.game.loaders.LuaLoader;
    import inoah.game.managers.AssetMgr;
    import inoah.game.managers.MainMgr;
    import inoah.game.maps.BattleMap;
    
    import interfaces.ILuaMain;
    
    import pureMVC.interfaces.IMediator;
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class GameMediator extends Mediator implements ITickable
    {
        private var _stage:Stage;
        private var _starling:Starling;
        private var _noteTxt:TextField;
        
        private var _mainViewMediator:ITickable;;
        private var _mapMgr:ITickable;
        private var _battleMgr:ITickable;
        
        private var _couldTick:Boolean;
        private var _luaDllLoader:Loader;
        public static var luaMain:ILuaMain;
        private var _starlingMain:ITickable;
        
        public function GameMediator( stage:Stage , viewComponent:Object=null )
        {
            super( GameConsts.GAME_MEDIATOR , viewComponent);
            _stage = stage;
            
            var loaderContext:LoaderContext = new LoaderContext( false , ApplicationDomain.currentDomain );
            loaderContext.applicationDomain = ApplicationDomain.currentDomain;
            _luaDllLoader = new Loader();
            _luaDllLoader.contentLoaderInfo.addEventListener( Event.COMPLETE , onLuaDllLoaded );
            _luaDllLoader.load( new URLRequest( "dll/dllLua.swf" ) , loaderContext );
        }
        
        protected function onLuaDllLoaded( e:Event ):void
        {
            _luaDllLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE , onLuaDllLoaded );
            var classLuaMain:Class = getDefinitionByName( "LuaMain" ) as Class;
            LuaDisplayObject;
            AGALMacroAssembler;
            luaMain = new classLuaMain();
            
            MainMgr.instance;
            var assetMgr:AssetMgr = new AssetMgr();
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, assetMgr );
            
            var resList:Vector.<String> = new Vector.<String>();
            resList.push( "libCore.lua" );
            resList.push( "libPlayer.lua" );
            resList.push( "main.lua" );
            assetMgr.getResList( resList , onLuaLoaded );
            
            //            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
        }
        
        private function onLuaLoaded( loader:ILoader ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            
            starlingMain.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            starlingMain.luaStrList.push( (assetMgr.getRes( "libPlayer.lua" , null ) as LuaLoader).content );
            starlingMain.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            
            initStarling();
        }
        
        private function initStarling():void
        {
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( starlingMain, _stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
        }
        
        protected function onRightClick( e:MouseEvent):void
        {
            facade.sendNotification( GameCommands.RIGHT_CLICK , [e] );
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.LOGIN );
            arr.push( GameCommands.RUN_LUA_SCRIPT );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch ( notification.getName() )
            {
                case GameCommands.LOGIN:
                {
                    arr = notification.getBody() as Array;
                    onLoginHandler( arr[0] );
                    break;
                }
                case GameCommands.RUN_LUA_SCRIPT:
                {
                    arr = notification.getBody() as Array;
                    luaMain.runScript( arr[0] );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function onLoginHandler( username:String ):void
        {
            initUserinfo( username );
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            
            _noteTxt = new TextField();
            _noteTxt.defaultTextFormat = new TextFormat( "Arial", 32 , 0xffffff, true );
            _noteTxt.width = 960;
            _noteTxt.mouseEnabled = false;
            _noteTxt.text = "Waiting for resource...";
            displayMgr.uiLevel.addChild( _noteTxt );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/sprite/characters/body/man/novice_man.tpc" );
            resPathList.push( "data/sprite/characters/head/man/2_man.tpc" );
            resPathList.push( "data/sprite/characters/novice/weapon_man_knife.tpc" );
            resPathList.push( "data/sprite/characters/novice/weapon_man_knife_ef.tpc" );
            resPathList.push( "data/sprite/monsters/poring.tpc" );
            resPathList.push( "data/sprite/monsters/poporing.tpc" );
            resPathList.push( "data/sprite/monsters/ghostring.tpc" );
            
            assetMgr.getResList( resPathList , onInitLoadComplete );
        }
        
        /**
         * 初始化用户数据 
         */        
        private function initUserinfo( username:String ):void
        {
            Global.userInfo = new UserInfo();
            var userInfo:UserInfo = Global.userInfo;
            userInfo.init( "data/sprite/characters/head/man/2_man.tpc", "data/sprite/characters/body/man/novice_man.tpc", true );
            userInfo.setWeaponRes( "data/sprite/characters/novice/weapon_man_knife.tpc" );
            userInfo.setWeaponShadowRes( "data/sprite/characters/novice/weapon_man_knife_ef.tpc" );
            userInfo.name = username;
            userInfo.job = "Novice";
            userInfo.strength = 1;
            userInfo.agile = 1;
            userInfo.vit = 1;
            userInfo.intelligence = 1;
            userInfo.dexterous = 1;
            userInfo.lucky = 1;
            userInfo.baseLv = 1;
            userInfo.baseExp = 0;
            userInfo.jobLv = 1;
            userInfo.jobExp = 0;
            userInfo.weightCurrent = 0;
            userInfo.weightMax = 1000;
            userInfo.zeny = 10000;
            userInfo.hpCurrent = userInfo.hpMax;
            userInfo.spCurrent = userInfo.spMax;
        }
        
        /**
         * 必备资源加载完毕 ，进入游戏主体
         * @param loader
         */        
        private function onInitLoadComplete( loader:ILoader = null ):void
        {
            _noteTxt.parent.removeChild( _noteTxt );
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            
            //初始化主界面
            var mainView:MainView = new MainView();
            _mainViewMediator = new MainViewMediator( mainView );
            facade.registerMediator( _mainViewMediator as IMediator );
            displayMgr.uiLevel.addChild( mainView );
            
            //初始化地图管理器
            _mapMgr = new MapMgr( displayMgr.unitLevel , displayMgr.mapLevel );
            MainMgr.instance.addMgr( MgrTypeConsts.MAP_MGR, _mapMgr as IMgr );
            facade.registerMediator( _mapMgr as IMediator );
            
            facade.sendNotification( GameCommands.CHANGE_MAP , [ 1 ] );
            
            //初始化战斗管理器
            _battleMgr = new BattleMgr( (_mapMgr as MapMgr).scene as BattleMap );
            MainMgr.instance.addMgr( MgrTypeConsts.BATTLE_MGR, _battleMgr as IMgr );
            facade.registerMediator( _battleMgr as IMediator );
            
            facade.sendNotification( GameCommands.RECV_CHAT , [ "\n\n\n\n\n<font color='#00ff00'>Welcome to roWeb!</font>" ] );
            facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#00ff00'>WASD to move and J to attack!</font>" ] );
        }
        
        public function tick( delta:Number ):void
        {
            if( _starlingMain )
            {
                _starlingMain.tick( delta );
            }
            else if( Starling.current && Starling.current.root )
            {
                _starlingMain = Starling.current.root as ITickable;
            }
            if( _mainViewMediator )
            {
                _mainViewMediator.tick( delta )
            }
            if( _mapMgr )
            {
                _mapMgr.tick( delta );
            }
            if( _battleMgr )
            {
                _battleMgr.tick( delta );
            }
        }
        
        public function get mainView():Sprite
        {
            return viewComponent as Sprite;
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}