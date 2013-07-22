package com.inoah.ro.mediators
{
    import com.inoah.ro.Main;
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.infos.UserInfo;
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.interfaces.ITickable;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.BattleMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.MapMgr;
    import com.inoah.ro.maps.BattleMap;
    import com.inoah.ro.mediators.views.MainViewMediator;
    import com.inoah.ro.ui.MainView;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import as3.interfaces.IMediator;
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
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
        
        public function GameMediator( stage:Stage , viewComponent:Object=null )
        {
            super( GameConsts.GAME_MEDIATOR , viewComponent);
            _stage = stage;
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( Main, _stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
            
//            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
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
            //            resPathList.push( "data/sprite/牢埃练/赣府烹/咯/2_咯.act" );
            //            resPathList.push( "data/sprite/牢埃练/个烹/咯/檬焊磊_咯.act" );
            //            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八.act" );
            //            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八_八堡.act" );
            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八_八堡.act" );
            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            resPathList.push( "data/sprite/阁胶磐/poporing.act" );
            resPathList.push( "data/sprite/阁胶磐/ghostring.act" );
            
            assetMgr.getResList( resPathList , onInitLoadComplete );
        }
        
        /**
         * 初始化用户数据 
         */        
        private function initUserinfo( username:String ):void
        {
            RoGlobal.userInfo = new UserInfo();
            var userInfo:UserInfo = RoGlobal.userInfo;
            userInfo.init( "data/sprite/牢埃练/赣府烹/巢/2_巢.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act", true );
            userInfo.setWeaponRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八.act" );
            userInfo.setWeaponShadowRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八_八堡.act" );
            //            userInfo.init( "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/咯/檬焊磊_咯.act", true );
            //            userInfo.setWeaponRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八.act" );
            //            userInfo.setWeaponShadowRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八_八堡.act" );
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
        private function onInitLoadComplete( loader:ActSprLoader = null ):void
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