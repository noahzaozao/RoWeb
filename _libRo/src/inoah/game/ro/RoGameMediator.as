package inoah.game.ro
{
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import inoah.core.Global;
    import inoah.core.starlingMain;
    import inoah.core.infos.UserInfo;
    import inoah.core.loaders.AtfLoader;
    import inoah.core.loaders.LuaLoader;
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.modules.main.view.StatusBarView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.interfaces.IUserModel;
    import inoah.interfaces.base.ILoader;
    import inoah.interfaces.base.ITickable;
    import inoah.interfaces.lua.ILuaMainMediator;
    import inoah.interfaces.managers.IAssetMgr;
    import inoah.interfaces.managers.IDisplayMgr;
    import inoah.interfaces.managers.IKeyMgr;
    import inoah.interfaces.managers.IMapMgr;
    import inoah.interfaces.managers.ISprMgr;
    import inoah.interfaces.managers.ITextureMgr;
    
    import morn.App;
    import morn.core.handlers.Handler;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.mapMgrExtension.MapEvent;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;
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
        public var assetMgr:IAssetMgr;
        
        [Inject]
        public var textureMgr:ITextureMgr;
        
        [Inject]
        public var sprMgr:ISprMgr;
        
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var keyMgr:IKeyMgr;
        
        [Inject]
        public var mapMgr:IMapMgr;
        
        [Inject]
        public var luaEngine:ILuaMainMediator;
        
        [Inject]
        public var userModel:IUserModel;
        
        protected var _starling:Starling;
        protected var _noteTxt:TextField;
        
        protected var _couldTick:Boolean;
        protected var _starlingMain:ITickable;
        
        protected var _battleMgr:ITickable;
        
        protected var _loginView:LoginView;
        protected var _mainView:MainView;
        
        protected var _bgImage:Image;
        
        public function RoGameMediator()
        {
            
        }
        /**
         * 
         */        
        override public function initialize():void
        {
            displayMgr.initialize();
            
            //init Starling
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( starlingMain, contextView.view.stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
            
            contextView.view.stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
        }
        /**
         * 
         */        
        protected function onStarlingInited():void
        {
            displayMgr.initStarling( _starlingMain as DisplayObject );
            
            if( Global.ENABLE_LUA )
            {
                var resList:Vector.<String> = new Vector.<String>();
                resList.push( "libCore.lua" );
                resList.push( "main.lua" );
                assetMgr.getResList( resList , onLuaLoaded );
            }
            else
            {
                initLogin();
            }
        }
        
        protected function onLuaLoaded( loader:ILoader ):void
        {
            luaEngine.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            luaEngine.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            luaEngine.initialize();
            
            initLogin();
        }
        /**
         * 
         */        
        private function initLogin():void
        {
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        /**
         * 
         */        
        protected function loadComplete():void
        {
            _loginView = new LoginView();
            _loginView.x = Global.SCREEN_W / 2 - _loginView.width / 2;
            _loginView.y = Global.SCREEN_H / 2 - _loginView.height / 2;
            contextView.view.addChild( _loginView );
            
            addBgImage();
            
            addContextListener( LoginEvent.LOGIN , onLoginHandler , LoginEvent );
        }
        /**
         * 
         */        
        protected function addBgImage():void
        {
            assetMgr.getRes( "loginBg.atf" , onAddBgImage );
        }
        /**
         * 
         * @param loader
         */        
        protected function onAddBgImage( loader:ILoader ):void
        {
            var texture:Texture = Texture.fromAtfData( (loader as AtfLoader).data, 1 , false );
            _bgImage = new Image( texture );
            _bgImage.touchable = false;
            displayMgr.bgLevel.addChild( _bgImage );
        }
        
        protected function onLoginHandler( e:LoginEvent ):void
        {
            initUserinfo( e.username );
            
            _noteTxt = new TextField();
            _noteTxt.defaultTextFormat = new TextFormat( "Arial", 32 , 0xffffff, true );
            _noteTxt.width = 960;
            _noteTxt.mouseEnabled = false;
            _noteTxt.text = "Waiting for resource...";
            displayMgr.uiLevel.addChild( _noteTxt );
            
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
            userModel.info = new UserInfo();
            var userInfo:UserInfo = userModel.info as UserInfo;
            
            userInfo.name = username;
            
            userInfo.init( "data/sprite/characters/head/man/2_man.tpc", "data/sprite/characters/body/man/novice_man.tpc", true );
            userInfo.setWeaponRes( "data/sprite/characters/novice/weapon_man_knife.tpc" );
            userInfo.setWeaponShadowRes( "data/sprite/characters/novice/weapon_man_knife_ef.tpc" );
            
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
            
            //初始化状态栏
            var statusBar:StatusBarView = new StatusBarView();
            displayMgr.topLevel.addChild( statusBar );
            
            //初始化主界面
            _mainView = new MainView();
            displayMgr.uiLevel.addChild( _mainView );
            
            keyMgr.initialize();
            
            //初始化地图管理器
            mapMgr.initialize();
            
            dispatch( new MapEvent( MapEvent.CHANGE_MAP , 1 ) );
            
            //初始化战斗管理器
            //            _battleMgr = new BattleMgr( (_mapMgr as MapMgr).scene as BattleMapMediator );
            //            MainMgr.instance.addMgr( MgrTypeConsts.BATTLE_MGR, _battleMgr as IMgr );
            //            facade.registerMediator( _battleMgr as IMediator );
            
            dispatch( new GameEvent( GameEvent.RECV_CHAT , "\n\n\n\n<font color='#00ff00'>Welcome to roWeb!</font>\n<font color='#00ff00'>WASD to move and J to attack!</font>" ) );
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
                onStarlingInited();
            }
            
            mapMgr.tick( delta );
            
            //            if( _mainView )
            //            {
            //                _mainView.tick( delta )
            //            }
            //            if( _battleMgr )
            //            {
            //                _battleMgr.tick( delta );
            //            }
        }
        
        protected function onRightClick( e:MouseEvent ):void
        {
            
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}