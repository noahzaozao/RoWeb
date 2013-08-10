package inoah.game.ro.modules.map.controller
{
    import inoah.game.ro.modules.map.view.events.SceneEvent;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class BaseSceneCommand extends Command
    {
        [Inject]
        public var sceneEvent:SceneEvent;
        
        override public function execute():void
        {
            
        }
    }
}