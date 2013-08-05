package inoah.core.mediators
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import inoah.core.consts.ConstsGame;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.consts.commands.GameCommands;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.ITickable;
    import inoah.core.loaders.LuaLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.DisplayMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.starlingMain;
    import inoah.lua.LuaEngine;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.facade.Facade;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class GameMediator extends Mediator implements ITickable
    {
        protected var _stage:Stage;
        protected var _starling:Starling;
        protected var _noteTxt:TextField;
        
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
            
            var luaEngine:LuaEngine = Facade.getInstance().retrieveMediator( ConstsGame.LUA_ENGINE ) as LuaEngine;
            
            luaEngine.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            luaEngine.luaStrList.push( (assetMgr.getRes( "libPlayer.lua" , null ) as LuaLoader).content );
            luaEngine.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            
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
        }
        
        /**
         * 初始化用户数据 
         */        
        protected function initUserinfo( username:String ):void
        {
            //            Global.userInfo = new UserInfo();
            //            var userInfo:UserInfo = Global.userInfo;
            //            userInfo.name = username;
        }
        
        /**
         * 必备资源加载完毕 ，进入游戏主体
         * @param loader
         */        
        protected function onInitLoadComplete( loader:ILoader = null ):void
        {
            _noteTxt.parent.removeChild( _noteTxt );
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