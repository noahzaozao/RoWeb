package inoah.game.td
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import game.ui.loseDialogUI;
    import game.ui.winDialogUI;
    
    import inoah.core.Global;
    import inoah.core.starlingMain;
    import inoah.core.infos.UserInfo;
    import inoah.core.loaders.AtfLoader;
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import inoah.game.ro.modules.main.view.StatusBarView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.td.modules.game.ChooseView;
    import inoah.game.td.modules.game.GameView;
    import inoah.game.td.modules.game.MenuDialog;
    import inoah.interfaces.ISprMgr;
    import inoah.interfaces.IUserModel;
    import inoah.interfaces.base.ILoader;
    import inoah.interfaces.base.ITickable;
    import inoah.interfaces.managers.IAssetMgr;
    import inoah.interfaces.managers.IDisplayMgr;
    import inoah.interfaces.managers.IKeyMgr;
    import inoah.interfaces.managers.IMapMgr;
    import inoah.interfaces.managers.ITextureMgr;
    
    import morn.core.handlers.Handler;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.tdMapMgrExtension.MapEvent;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class TDGameMediator extends Mediator implements ITickable
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
        public var userModel:IUserModel;
        
        protected var _starling:Starling;
        protected var _noteTxt:TextField;
        
        protected var _couldTick:Boolean;
        protected var _starlingMain:ITickable;
        
        protected var _battleMgr:ITickable;
        
        protected var _loginView:LoginView;
        protected var _chooseView:ChooseView;
        
        protected var _bgImage:Image;
        protected var _gameView:GameView;
        protected var _menuDialog:MenuDialog;
        protected var _winDialog:winDialogUI;
        protected var _loseDialog:loseDialogUI;
        protected var _speedRate:int = 1;
        
        public function TDGameMediator()
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
            
            _couldTick = true;
        }
        /**
         * 
         */        
        protected function onStarlingInited():void
        {
            displayMgr.initStarling( _starlingMain as DisplayObject );
            
            initLogin();
        }
        
        /**
         * 
         */        
        protected function initLogin():void
        {
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf","assets/td_interface.swf"] , new Handler( loadComplete ) );
        }
        /**
         * 
         */        
        protected function loadComplete():void
        {
            //            _loginView = new LoginView();
            //            _loginView.x = Global.SCREEN_W / 2 - _loginView.width / 2;
            //            _loginView.y = Global.SCREEN_H / 2 - _loginView.height / 2;
            //            contextView.view.addChild( _loginView );
            
            addBgImage();
            
            onLoginHandler( new LoginEvent( LoginEvent.LOGIN , "" , "" ));
            //            addContextListener( LoginEvent.LOGIN , onLoginHandler , LoginEvent );
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
            _chooseView = new ChooseView();
            displayMgr.uiLevel.addChild( _chooseView );
            _chooseView.addEventListener( GameEvent.BACK , onReturn );
            _chooseView.addEventListener( GameEvent.CHOOSE , onChoose );
            
        }
        
        protected function onReturn( e:GameEvent):void
        {
            _chooseView.removeEventListener( GameEvent.BACK , onReturn );
            _chooseView.removeEventListener( GameEvent.CHOOSE , onChoose );
        }
        
        protected function onChoose( e:Event):void
        {
            _chooseView.removeEventListener( GameEvent.CHOOSE , onChoose );
            
            _gameView = new GameView();
            injector.injectInto( _gameView );
            _gameView.initialize();
            _gameView.addEventListener( GameEvent.SPEED , onSpeed );
            _gameView.addEventListener( GameEvent.OPEN_MENU , onOpenMenu );
            _gameView.addEventListener( GameEvent.OPEN_GAME_RESULT , onGameResult );
            displayMgr.uiLevel.addChild( _gameView );
            
            //初始化地图管理器
            mapMgr.initialize();
            dispatch( new MapEvent( MapEvent.CHANGE_MAP , 1 , 2 ) );
            
            keyMgr.initialize();
            
            _bgImage.removeFromParent(true);
            
            //初始化战斗管理器
            //            _battleMgr = new BattleMgr( (_mapMgr as MapMgr).scene as BattleMapMediator );
            //            MainMgr.instance.addMgr( MgrTypeConsts.BATTLE_MGR, _battleMgr as IMgr );
            //            facade.registerMediator( _battleMgr as IMediator );
            
            //            dispatch( new GameEvent( GameEvent.RECV_CHAT , "\n\n\n\n<font color='#00ff00'>Welcome to roWeb!</font>\n<font color='#00ff00'>WASD to move and J to attack!</font>" ) );
            
        }
        
        protected function onSpeed( e:GameEvent ):void
        {
            if( _speedRate == 1 )
            {
                _speedRate = 2;
            }
            else
            {
                _speedRate = 1;
            }
        }
        
        protected function onGameResult( e:GameEvent ):void
        {
            if( e.msg == "win" )
            {
                if( !_winDialog )
                {
                    _winDialog = new winDialogUI();
                    _winDialog.x = ( Global.SCREEN_W / 2 ) - ( _winDialog.width / 2 );
                    _winDialog.y = ( Global.SCREEN_H / 2 ) - ( _winDialog.height / 2 );
                }
                displayMgr.uiLevel.addChild( _menuDialog );
            }
            else
            {
                if( !_loseDialog )
                {
                    _loseDialog = new loseDialogUI();
                    _loseDialog.x = ( Global.SCREEN_W / 2 ) - ( _loseDialog.width / 2 );
                    _loseDialog.y = ( Global.SCREEN_H / 2 ) - ( _loseDialog.height / 2 );
                }
                displayMgr.uiLevel.addChild( _menuDialog );
            }
        }
        
        protected function onOpenMenu( e:GameEvent):void
        {
            _couldTick = false;
            
            if( !_menuDialog )
            {
                _menuDialog = new MenuDialog();
                _menuDialog.x = ( Global.SCREEN_W / 2 ) - ( _menuDialog.width / 2 );
                _menuDialog.y = ( Global.SCREEN_H / 2 ) - ( _menuDialog.height / 2 );
            }
            _menuDialog.addEventListener( GameEvent.CONTINUE , onContinue );
            _menuDialog.addEventListener( GameEvent.RESTART , onRestart );
            displayMgr.uiLevel.addChild( _menuDialog );
        }
        
        protected function onContinue( e:GameEvent ):void
        {
            _menuDialog.removeEventListener( GameEvent.CONTINUE , onContinue );
            displayMgr.removeFromParent( _menuDialog );
            
            _couldTick = true;
        }
        
        protected function onRestart( e:GameEvent ):void
        {
            dispatch( new GameEvent( GameEvent.RESTART ) );
            _speedRate = 1;
            _couldTick = true;
        }
        
        public function tick( delta:Number ):void
        {
            delta = _speedRate * delta;
            if( !_couldTick )
            {
                return;
            }
            
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