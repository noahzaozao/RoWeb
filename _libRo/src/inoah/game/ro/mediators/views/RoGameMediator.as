package inoah.game.ro.mediators.views
{
    import flash.display.Stage;
    
    import inoah.core.Global;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.consts.commands.GameCommands;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.IMgr;
    import inoah.core.interfaces.ITickable;
    import inoah.core.managers.AssetMgr;
    import inoah.game.ro.managers.BattleMgr;
    import inoah.core.managers.DisplayMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.mediators.GameMediator;
    import inoah.game.ro.RoMain;
    import inoah.core.infos.UserInfo;
    import inoah.game.ro.managers.MapMgr;
    import inoah.game.ro.mediators.maps.BattleMapMediator;
    import inoah.game.ro.ui.MainView;
    
    import pureMVC.interfaces.IMediator;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class RoGameMediator extends GameMediator
    {
        protected var _mainViewMediator:ITickable;
        protected var _mapMgr:ITickable;
        protected var _battleMgr:ITickable;
        
        public function RoGameMediator(stage:Stage, viewComponent:Object=null)
        {
            super(stage, viewComponent);
        }
        
        override protected function initStarling():void
        {
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( RoMain, _stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
        }
        
        override protected function onInitLoadComplete( loader:ILoader = null ):void
        {
            super.onInitLoadComplete( loader );
            
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
        
        override protected function onLoginHandler( username:String ):void
        {
            super.onLoginHandler( username );
            
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
        
        override protected function initUserinfo( username:String ):void
        {
            super.initUserinfo( username );
            
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
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            
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
    }
}