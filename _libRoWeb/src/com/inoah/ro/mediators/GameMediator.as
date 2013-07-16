package com.inoah.ro.mediators
{
    import com.inoah.ro.RoGame;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.SprMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.ui.LoginView;
    import com.inoah.ro.utils.UserData;
    
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    
    public class GameMediator extends Mediator
    {
        private var _loginView:LoginView;
        private var _game:RoGame;
        private var _starling:Starling;
        private var _noteTxt:TextField;
        
        public function GameMediator( viewComponent:Object=null)
        {
            super( GameConsts.GAME_MEDIATOR , viewComponent);
            
            App.init( mainView );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        private function loadComplete():void
        {
            _loginView = new LoginView();
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.uiLevel.addChild( _loginView );
        }
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.LOGIN );
            return arr;
        }
        override public function handleNotification(notification:INotification):void
        {
            switch ( notification.getName() )
            {
                case GameCommands.LOGIN:
                {
                    onLoginHandler();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function onLoginHandler():void
        {
            _loginView.remove();
            
            _noteTxt = new TextField();
            _noteTxt.defaultTextFormat = new TextFormat( "Arial", 32 , 0xffffff, true );
            _noteTxt.width = 960;
            _noteTxt.mouseEnabled = false;
            _noteTxt.text = "Waiting for resource...";
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.uiLevel.addChild( _noteTxt );
            
            //pretends to be an iPhone Retina screen
            //            DeviceCapabilities.dpi = 326;
            //            DeviceCapabilities.screenPixelWidth = 960;
            //            DeviceCapabilities.screenPixelHeight = 640;
            
            //            Starling.handleLostContext = true;
            //            Starling.multitouchEnabled = true;
            //            _starling = new Starling(Main, stage);
            //            _starling.enableErrorChecking = false;
            //            _starling.showStats = true;
            //            _starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
            //            _starling.start();
            
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
            resPathList.push( "data/sprite/酒捞袍/lk_aurablade.act" );
            resPathList.push( "data/sprite/酒捞袍/lk_spiralpierce.act" );
            assetMgr.getResList( resPathList , onInitLoadComplete );
        }
        private function onInitLoadComplete( loader:ActSprLoader = null ):void
        {
            _noteTxt.parent.removeChild( _noteTxt );
            Global.userdata = new UserData();
            Global.userdata.getCanSeeMission(1);
            _game = new RoGame('map1',mainView.stage , 0 );
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.mapLevel.addChild(_game);
            RoGame.inited = true;
        }
        public function tick( delta:Number ):void
        {
            if( _game )
            {
                _game.tick( delta );
            }
        }
        private function get mainView():Sprite
        {
            return viewComponent as Sprite;
        }
    }
}