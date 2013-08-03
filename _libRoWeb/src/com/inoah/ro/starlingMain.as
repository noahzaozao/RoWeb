package com.inoah.ro
{
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.mediators.GameMediator;
    import com.inoah.ro.ui.LoginView;
    
    import flash.external.ExternalInterface;
    import flash.utils.Dictionary;
    
    import inoah.game.Global;
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.loaders.AtfLoader;
    import inoah.game.loaders.ILoader;
    import inoah.game.managers.AssetMgr;
    import inoah.game.managers.KeyMgr;
    import inoah.game.managers.MainMgr;
    import inoah.game.managers.SprMgr;
    import inoah.game.managers.TextureMgr;
    
    import interfaces.ILuaMain;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class starlingMain extends Sprite
    {
        public static var luascript:String;
        public static function get luaMain():ILuaMain
        {
            return _luaMain;
        }
        public var luastate:int
        private var panicabort:Boolean = false
        
        private var _loginView:LoginView;
        private var _bgImage:Image;
        private static var _luaMain:ILuaMain;
        
        public function starlingMain()
        {
            _luaMain = GameMediator.luaMain;
            
            super();
            
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
            addEventListener(Event.ENTER_FRAME, update)
        }
        
        private function addedToStageHandler(event:Event):void
        {
            // Initialize Lua and load our script
            var err:int = 0
            luastate = _luaMain.luaL_newstate();
            panicabort = false
            _luaMain.lua_atpanic(luastate, atPanic)
            _luaMain.luaL_openlibs(luastate)
            
            err =_luaMain.luaL_loadstring(luastate, luascript)
            if(err) 
            {
                onError("Error " + err + ": " + _luaMain.luaL_checklstring(luastate, 1, 0));
                _luaMain.lua_close(luastate);
                return
            }
            
            try {
                _luaMain.__lua_objrefs = new Dictionary();
                
                // This runs everything in the global scope
                err = _luaMain.lua_pcallk(luastate, 0, _luaMain.LUA_MULTRET, 0, 0, null)
                
                // give the lua code a reference to this and Starling
                _luaMain.lua_getglobal(luastate, "setupGame")
                push_objref(this)
                push_objref(Starling.current.nativeStage.stage3Ds[0].context3D)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.width)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.height)
                _luaMain.lua_callk(luastate, 4, 0, 0, null)
            } 
            catch(e:*) 
            {
                onError("Exception thrown while initializing code:\n" + e + e.getStackTrace());
            }
            
            return;
            //从这里开始，完成了Lua的整合，之后需要映射一些类到Lua中并搭建LuaCore
            
            MainMgr.instance;
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            var displayMgr:DisplayMgr = new DisplayMgr( Starling.current.nativeStage , this );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( Starling.current.nativeStage ) );
            
            addBgImage();
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        
        public function atPanic(e:*): void
        {
            onError("Lua Panic: " + _luaMain.luaL_checklstring(luastate, -1, 0))
            panicabort = true
        }
        
        private function update(e:*):void 
        {
            try 
            {
                _luaMain.lua_getglobal(luastate, "starlingUpdate")
                _luaMain.lua_callk(luastate, 0, 0, 0, null)
            } 
            catch(e:*) 
            {
                if(!panicabort)
                    onError("Exception thrown while calling starlingUpdate:\n" + e + e.getStackTrace());
            }
        }
        
        private function push_objref(o:*):void
        {
            var udptr:int = _luaMain.push_flashref(luastate)
            _luaMain.__lua_objrefs[udptr] = o
        }
        
        public function onError(e:*):void
        {
            trace(e)
            
            if(ExternalInterface.available) {
                ExternalInterface.call("reportError", e.toString())
            }
            
            Starling.current.stop()
        }
        
        private function addBgImage():void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "loginBg.atf" , onAddBgImage );
        }
        
        private function onAddBgImage( loader:ILoader ):void
        {
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var texture:Texture = Texture.fromAtfData( (loader as AtfLoader).data, 1 , false );
            _bgImage = new Image( texture );
            _bgImage.touchable = false;
            displayMgr.bgLevel.addChild( _bgImage );
        }
        
        private function loadComplete():void
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
        private function onInitRes( assetMgr:AssetMgr ):void
        {
            //            var resPathList:Vector.<String> = new Vector.<String>();
            //            assetMgr.getResList( resPathList , function():void{} );
        }
        
        public function tick( delta:Number ):void
        {
            
        }
    }
}