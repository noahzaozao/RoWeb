package inoah.core
{
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    public class CoreConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var mediatorMap:IMediatorMap;
        
        [Inject]
        public var commandMap:IEventCommandMap;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var contextView:ContextView;
        
        public function configure():void
        {
            //model
            //command
            //mdeiator
            //singleton
            //
            logger.info("configure CoreConfig");
        }
    }
}