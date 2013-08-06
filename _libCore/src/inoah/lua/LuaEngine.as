package inoah.lua
{
    import flash.external.ExternalInterface;
    import flash.utils.Dictionary;
    
    import inoah.core.consts.ConstsGame;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.loaders.LuaLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    
    import interfaces.ILuaMain;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.core.Starling;
    
    /**
     *  处理AS3和Lua交互的类
     * @author inoah
     */    
    public class LuaEngine extends Mediator
    {
        protected static var _luaMain:ILuaMain;
        
        public var luaStrList:Vector.<String>;
        public var luastate:int
        protected var panicabort:Boolean = false
        protected var _luaPathList:Vector.<String>;
        
        public function API_ADD_LUA_PATH( luaPath:String ):void
        {
            _luaPathList.push( luaPath );
        }
        
        public function LuaEngine( luaMain:ILuaMain )
        {
            super( ConstsGame.LUA_ENGINE );
            luaStrList = new Vector.<String>();
            _luaPathList = new Vector.<String>();
            _luaMain = luaMain;
        }
        
        public function init():void
        {
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
            }
            
            try 
            {
                _luaMain.__lua_objrefs = new Dictionary();
                _luaMain.lua_getglobal(luastate, "main")
                push_objref(this)
                _luaMain.lua_callk(luastate, 1, 0, 0, null)
            } 
            catch(e:*) 
            {
                onError("Exception thrown while initializing code:\n" + e + e.getStackTrace() );
            }
        }
        
        public function API_LoadLuaScript():void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var resList:Vector.<String> = new Vector.<String>();
            var len:int = _luaPathList.length;
            for( var i:int = 0;i<len;i++)
            {
                resList.push( _luaPathList[i] + ".lua" );
            }
            assetMgr.getResList( resList , onLoadLuaScript );
            _luaPathList = new Vector.<String>();
        }
        
        protected function onLoadLuaScript( loader:ILoader ):void
        {
            var luaLoader:LuaLoader = loader as LuaLoader;
            luaStrList.push( luaLoader.content );
            if( luaL_loadstring( luastate , luaLoader.content ) )
            {
                return;
            }
            _luaMain.lua_getglobal(luastate, "onLoadLuaScript");
            _luaMain.lua_callk(luastate, 0, 0, 0, null);
        }
        
        public function API_onLoadLuaScriptComplete():void
        {
            trace( "[LuaEngine] API_onLoadLuaScriptComplete" );
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch( notification.getName() )
            {
                
            }
        }
        
        protected function luaL_loadstring(luastate:int, luaStr:String):int
        {
            var err:int =_luaMain.luaL_loadstring(luastate, luaStr)
            if(err) 
            {
                onError("Error " + err + ": " + _luaMain.luaL_checklstring(luastate, 1, 0));
                _luaMain.lua_close(luastate);
            }
            else 
            {
                err = _luaMain.lua_pcallk(luastate, 0, _luaMain.LUA_MULTRET, 0, 0, null);
            }
            return err;
        }
        
        protected function atPanic(e:*): void
        {
            onError("Lua Panic: " + _luaMain.luaL_checklstring(luastate, -1, 0))
            panicabort = true
        }
        
        protected function push_objref(o:*):void
        {
            var udptr:int = _luaMain.push_flashref(luastate)
            _luaMain.__lua_objrefs[udptr] = o
        }
        
        protected function onError(e:*):void
        {
            trace(e)
            if(ExternalInterface.available) 
            {
                ExternalInterface.call("reportError", e.toString())
            }
            Starling.current.stop()
        }
        
        public function tick(delta:Number):void
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
                    onError("Exception thrown while calling update:\n" + e + e.getStackTrace());
                }
            }
        }
    }
}