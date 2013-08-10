package inoah.core
{
    import interfaces.IAssetMgr;
    import interfaces.IDisplayMgr;
    import interfaces.IKeyMgr;
    import interfaces.ISprMgr;
    import interfaces.ITextureMgr;
    
    import robotlegs.bender.extensions.assetMgrExtension.AssetMgr;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.displayMgrExtension.DisplayMgr;
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import robotlegs.bender.extensions.keyMgrExtension.KeyMgr;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.sprMgrExtension.SprMgr;
    import robotlegs.bender.extensions.textureMgrExtension.TextureMgr;
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