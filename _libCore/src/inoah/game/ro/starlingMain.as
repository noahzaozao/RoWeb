package inoah.game.ro
{
    import flash.external.ExternalInterface;
    import flash.utils.Dictionary;
    
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.ITickable;
    import inoah.core.loaders.AtfLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.KeyMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.managers.SprMgr;
    import inoah.core.managers.TextureMgr;
    import inoah.game.ro.managers.DisplayMgr;
    import inoah.game.ro.mediators.GameMediator;
    import inoah.game.ro.ui.LoginView;
    
    import interfaces.ILuaMain;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class starlingMain extends Sprite implements ITickable
    {
        public static var luaStrList:Vector.<String> = new Vector.<String>();
        
        public var luaStrList:Vector.<String>;
        
        public static function get luaMain():ILuaMain
        {
            return _luaMain;
        }
        public var luastate:int
        protected var panicabort:Boolean = false
        
        protected var _loginView:LoginView;
        protected var _bgImage:Image;
        protected static var _luaMain:ILuaMain;
        
        public function starlingMain()
        {
            _luaMain = GameMediator.luaMain;
            
            super();
            
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        }
        
        protected function addedToStageHandler( e:Event ):void
        {
            this.luaStrList = starlingMain.luaStrList;
            
            var err:int = 0;
            luastate = _luaMain.luaL_newstate();
            panicabort = false
            _luaMain.lua_atpanic(luastate, atPanic)
            _luaMain.luaL_openlibs(luastate)
            
            for( var i:int = 0;i<luaStrList.length;i++)
            {
                if( luaL_loadstring( luastate , luaStrList[i] ) )
                {
                    return;
                }
                err = _luaMain.lua_pcallk(luastate, 0, _luaMain.LUA_MULTRET, 0, 0, null)
            }
                
            try 
            {
                _luaMain.__lua_objrefs = new Dictionary();
                _luaMain.lua_getglobal(luastate, "main")
                push_objref(this)
                push_objref(Starling.current.nativeStage.stage3Ds[0].context3D)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.width)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.height)
                _luaMain.lua_callk(luastate, 4, 0, 0, null)
            } 
            catch(e:*) 
            {
                onError("Exception thrown while initializing code:\n" + e + e.getStackTrace() );
            }
            
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
        
        private function luaL_loadstring(luastate:int, luaStr:String):int
        {
            var err:int =_luaMain.luaL_loadstring(luastate, luaStr)
            if(err) 
            {
                onError("Error " + err + ": " + _luaMain.luaL_checklstring(luastate, 1, 0));
                _luaMain.lua_close(luastate);
            }
            return err;
        }
        
        public function atPanic(e:*): void
        {
            onError("Lua Panic: " + _luaMain.luaL_checklstring(luastate, -1, 0))
            panicabort = true
        }
        
        protected function push_objref(o:*):void
        {
            var udptr:int = _luaMain.push_flashref(luastate)
            _luaMain.__lua_objrefs[udptr] = o
        }
        
        public function onError(e:*):void
        {
            trace(e)
            if(ExternalInterface.available) 
            {
                ExternalInterface.call("reportError", e.toString())
            }
            Starling.current.stop()
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
            try 
            {
                _luaMain.lua_getglobal(luastate, "update")
                _luaMain.lua_pushnumber( luastate , delta )
                _luaMain.lua_callk(luastate, 1, 0, 0, null)
            } 
            catch(e:*) 
            {
                if(!panicabort)
                {
                    onError("Exception thrown while calling starlingUpdate:\n" + e + e.getStackTrace());
                }
            }
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}