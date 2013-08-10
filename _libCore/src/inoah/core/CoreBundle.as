package inoah.core
{
    import robotlegs.bender.extensions.assetMgrExtension.AssetMgrExtension;
    import robotlegs.bender.extensions.displayMgrExtension.DisplayerMgrExtension;
    import robotlegs.bender.extensions.keyMgrExtension.KeyMgrExtension;
    import robotlegs.bender.extensions.mapMgrExtension.MapMgrExtension;
    import robotlegs.bender.extensions.sprMgrExtension.SprMgrExtension;
    import robotlegs.bender.extensions.textureMgrExtension.TextureMgrExtension;
    import robotlegs.bender.framework.api.IBundle;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.LogLevel;
    
    public class CoreBundle implements IBundle
    {
        public function extend(context:IContext):void
        {
            context.logLevel = LogLevel.DEBUG;
            
            context.install(
                AssetMgrExtension,
                TextureMgrExtension,
                SprMgrExtension,
                DisplayerMgrExtension,
                KeyMgrExtension,
                MapMgrExtension
            );
            
            context.configure(CoreConfig);
        }
    }
}

