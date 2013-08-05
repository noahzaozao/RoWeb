package inoah.game.ro.mediators
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.IMgr;
    import inoah.core.interfaces.ITickable;
    import inoah.core.loaders.LuaLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    import inoah.game.ro.Global;
    import inoah.game.ro.starlingMain;
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.consts.commands.GameCommands;
    import inoah.game.ro.infos.UserInfo;
    import inoah.game.ro.managers.BattleMgr;
    import inoah.game.ro.managers.DisplayMgr;
    import inoah.game.ro.managers.MapMgr;
    import inoah.game.ro.mediators.maps.BattleMapMediator;
    import inoah.game.ro.mediators.views.MainViewMediator;
    import inoah.game.ro.ui.MainView;
    
    import interfaces.ILuaMain;
    
    import pureMVC.interfaces.IMediator;
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class GameMediator extends Mediator implements ITickable
    {
        public static var luaMain:ILuaMain;

        protected var _stage:Stage;
        protected var _starling:Starling;
        protected var _noteTxt:TextField;
        
        protected var _mainViewMediator:ITickable;;
        protected var _mapMgr:ITickable;
        protected var _battleMgr:ITickable;
        
        protected var _couldTick:Boolean;
        protected var _starlingMain:ITickable;
        
        public function GameMediator( stage:Stage , viewComponent:Object=null )
        {
            super( ConstsGame.GAME_MEDIATOR , viewComponent);
            _stage = stage;
            
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
        
        protected function onLuaLoaded( loader:ILoader ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            
            starlingMain.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            starlingMain.luaStrList.push( (assetMgr.getRes( "libPlayer.lua" , null ) as LuaLoader).content );
            starlingMain.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            
            initStarling();
        }
        
        protected function initStarling():void
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
                default:
                {
                    break;
                }
            }
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
        
        /**
         * 初始化用户数据 
         */        
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
        
        /**
         * 必备资源加载完毕 ，进入游戏主体
         * @param loader
         */        
        protected function onInitLoadComplete( loader:ILoader = null ):void
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
            _battleMgr = new BattleMgr( (_mapMgr as MapMgr).scene as BattleMapMediator );
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