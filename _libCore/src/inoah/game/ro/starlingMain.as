package inoah.game.ro
{
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.ITickable;
    import inoah.core.loaders.AtfLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.KeyMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.managers.SprMgr;
    import inoah.core.managers.TextureMgr;
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.managers.DisplayMgr;
    import inoah.game.ro.ui.LoginView;
    import inoah.lua.LuaEngine;
    
    import morn.core.handlers.Handler;
    
    import pureMVC.patterns.facade.Facade;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class starlingMain extends Sprite implements ITickable
    {
        protected var _loginView:LoginView;
        protected var _bgImage:Image;
        protected var _luaEngine:LuaEngine;
        
        public function starlingMain()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        }
        
        protected function addedToStageHandler( e:Event ):void
        {
            _luaEngine = Facade.getInstance().retrieveMediator( ConstsGame.LUA_ENGINE ) as LuaEngine;
            _luaEngine.init();
            
            //noah note
            //从这里开始，完成了Lua的整合，之后需要映射一些类到Lua中并搭建LuaCore
            
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            var displayMgr:DisplayMgr = new DisplayMgr( Starling.current.nativeStage , this );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( Starling.current.nativeStage ) );
            
            addBgImage();
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        
        protected function addBgImage():void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "loginBg.atf" , onAddBgImage );
        }
        
        protected function onAddBgImage( loader:ILoader ):void
        {
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var texture:Texture = Texture.fromAtfData( (loader as AtfLoader).data, 1 , false );
            _bgImage = new Image( texture );
            _bgImage.touchable = false;
            displayMgr.bgLevel.addChild( _bgImage );
        }
        
        protected function loadComplete():void
        {
            _loginView = new LoginView();
            
            _loginView.x = Global.SCREEN_W / 2 - _loginView.width / 2;
            _loginView.y = Global.SCREEN_H / 2 - _loginView.height / 2;
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.uiLevel.addChild( _loginView );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            onInitRes( assetMgr );
        }
        
        /**
         * 初始加载，不必等待 作为预缓冲
         * @param assetMgr
         */        
        protected function onInitRes( assetMgr:AssetMgr ):void
        {
            //            var resPathList:Vector.<String> = new Vector.<String>();
            //            assetMgr.getResList( resPathList , function():void{} );
        }
        
        public function tick( delta:Number ):void
        {
            if( _luaEngine )
            {
                _luaEngine.tick( delta );
            }
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}