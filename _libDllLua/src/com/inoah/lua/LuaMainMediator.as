package com.inoah.lua
{
    import flash.utils.Dictionary;
    
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.loaders.LuaLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    
    import interfaces.ILuaMain;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    /**
     *  处理AS3和Lua交互的类
     * @author inoah
     */    
    public class LuaMainMediator extends Mediator
    {
        [Inject]
        public var luaMain:ILuaMain;
        
        public var luaStrList:Vector.<String>;
        protected var luastate:int
        protected var panicabort:Boolean = false
        protected var _luaPathList:Vector.<String>;
        
        public function API_ADD_LUA_PATH( luaPath:String ):void
        {
            _luaPathList.push( luaPath );
        }
        
        public function LuaMainMediator()
        {
            luaStrList = new Vector.<String>();
            _luaPathList = new Vector.<String>();
        }
        
        override public function initialize():void
        {
            var err:int = 0;
            luastate = luaMain.luaL_newstate();
            panicabort = false
            luaMain.lua_atpanic(luastate, atPanic)
            luaMain.luaL_openlibs(luastate)
            
            for( var i:int = 0;i<luaStrList.length;i++)
            {
                if( luaL_loadstring( luastate , luaStrList[i] ) )
                {
                    return;
                }
            }
            
            try 
            {
                luaMain.__lua_objrefs = new Dictionary();
                luaMain.lua_getglobal(luastate, "main")
                push_objref(this)
                luaMain.lua_callk(luastate, 1, 0, 0, null)
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
        }
        
        protected function onLoadLuaScript( loader:ILoader ):void
        {
            var len:int = _luaPathList.length;
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var luaLoader:LuaLoader;
            for( var i:int = 0;i<len;i++)
            {
                luaLoader = assetMgr.getRes( _luaPathList[i] + ".lua" ) as LuaLoader;
                if( luaL_loadstring( luastate , luaLoader.content ) )
                {
                    return;
                }
            }
            _luaPathList = new Vector.<String>();
            luaMain.lua_getglobal(luastate, "onLoadLuaScript");
            luaMain.lua_callk(luastate, 0, 0, 0, null);
        }
        
        public function API_onLoadLuaScriptComplete():void
        {
            trace( "[LuaEngine] API_onLoadLuaScriptComplete" );
        }
        
        protected function luaL_loadstring(luastate:int, luaStr:String):int
        {
            var err:int =luaMain.luaL_loadstring(luastate, luaStr)
            if(err) 
            {
                onError("Error " + err + ": " + luaMain.luaL_checklstring(luastate, 1, 0));
                luaMain.lua_close(luastate);
            }
            else 
            {
                err = luaMain.lua_pcallk(luastate, 0, luaMain.LUA_MULTRET, 0, 0, null);
            }
            return err;
        }
        
        protected function atPanic(e:*): void
        {
            onError("Lua Panic: " + luaMain.luaL_checklstring(luastate, -1, 0))
            panicabort = true
        }
        
        protected function push_objref(o:*):void
        {
            var udptr:int = luaMain.push_flashref(luastate)
            luaMain.__lua_objrefs[udptr] = o
        }
        
        protected function onError(e:*):void
        {
            trace(e)
        }
        
        public function tick(delta:Number):void
        {
            try 
            {
                luaMain.lua_getglobal(luastate, "update")
                luaMain.lua_pushnumber( luastate , delta )
                luaMain.lua_callk(luastate, 1, 0, 0, null)
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