package com.inoah.lua
{
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    public class LuaConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var logger:ILogger;
        
        public function configure():void
        {
            //
            injector.map(LuaMainMediator).asSingleton();
            //
            logger.info("configure LuaConfig");
        }
    }
}