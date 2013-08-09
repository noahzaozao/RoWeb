package inoah.game.ro.mediators.views
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import inoah.core.Global;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.infos.UserInfo;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.ITickable;
    import inoah.core.loaders.LuaLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.DisplayMgr;
    import inoah.core.managers.KeyMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.managers.SprMgr;
    import inoah.core.managers.TextureMgr;
    import inoah.game.ro.RoMain;
    import inoah.game.ro.StatusBar;
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import com.inoah.lua.LuaMainMediator;
    
    import morn.App;
    import morn.core.handlers.Handler;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class RoGameMediator extends Mediator implements ITickable
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var context:IContext;
        
        [Inject]
        public var contextView:ContextView;
        
        [Inject]
        public var luaEngine:LuaMainMediator;
        
        protected var _stage:Stage;
        protected var _starling:Starling;
        protected var _noteTxt:TextField;
        
        protected var _couldTick:Boolean;
        protected var _starlingMain:ITickable;
        
        protected var _mapMgr:ITickable;
        protected var _battleMgr:ITickable;
        
        protected var _loginView:LoginView;
        protected var _mainView:MainView;
        
        public function RoGameMediator()
        {
            
        }
        
        public function init( stage:Stage ):void
        {
            _stage = stage;
            
            MainMgr.instance;
            var assetMgr:AssetMgr = new AssetMgr();
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, assetMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            var displayMgr:DisplayMgr = new DisplayMgr( stage );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( stage ) );
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
            
            if( Global.ENABLE_LUA )
            {
                var resList:Vector.<String> = new Vector.<String>();
                resList.push( "libCore.lua" );
                resList.push( "main.lua" );
                assetMgr.getResList( resList , onLuaLoaded );
            }
            
            //init Starling
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( RoMain, _stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
            
            //            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
        }
        
        protected function loadComplete():void
        {
            _loginView = new LoginView();
            _loginView.x = Global.SCREEN_W / 2 - _loginView.width / 2;
            _loginView.y = Global.SCREEN_H / 2 - _loginView.height / 2;
            contextView.view.addChild( _loginView );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            onInitRes( assetMgr );
            
            addContextListener( LoginEvent.LOGIN , onLoginHandler , null ); 
        }
        
        protected function onInitRes( assetMgr:AssetMgr ):void
        {
            //            var resPathList:Vector.<String> = new Vector.<String>();
            //            assetMgr.getResList( resPathList , function():void{} );
        }
        
        protected function onLuaLoaded( loader:ILoader ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            
            luaEngine.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            luaEngine.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            luaEngine.initialize();
        }
        
        protected function onLoginHandler( username:String ):void
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
        
        protected function initUserinfo( username:String ):void
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
        
        protected function onInitLoadComplete( loader:ILoader = null ):void
        {
            _noteTxt.parent.removeChild( _noteTxt );
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            //初始化状态栏
            var statusBar:StatusBar = new StatusBar();
            //            facade.registerMediator( statusBar as IMediator );
            displayMgr.topLevel.addChild( statusBar );
            
            //初始化主界面
            _mainView = new MainView();
            contextView.view.addChild( _mainView );
            
            //初始化地图管理器
//            _mapMgr = new MapMgr( displayMgr.unitLevel , displayMgr.mapLevel );
//            MainMgr.instance.addMgr( MgrTypeConsts.MAP_MGR, _mapMgr as IMgr );
            //            facade.registerMediator( _mapMgr as IMediator );
            
            //            facade.sendNotification( GameCommands.CHANGE_MAP , [ 1 ] );
            
            //初始化战斗管理器
            //            _battleMgr = new BattleMgr( (_mapMgr as MapMgr).scene as BattleMapMediator );
            //            MainMgr.instance.addMgr( MgrTypeConsts.BATTLE_MGR, _battleMgr as IMgr );
            //            facade.registerMediator( _battleMgr as IMediator );
            
            //            facade.sendNotification( GameCommands.RECV_CHAT , [ "\n\n\n\n\n<font color='#00ff00'>Welcome to roWeb!</font>" ] );
            //            facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#00ff00'>WASD to move and J to attack!</font>" ] );
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
            
//            if( _mainView )
//            {
//                _mainView.tick( delta )
//            }
            
            if( _mapMgr )
            {
                _mapMgr.tick( delta );
            }
            if( _battleMgr )
            {
                _battleMgr.tick( delta );
            }
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}