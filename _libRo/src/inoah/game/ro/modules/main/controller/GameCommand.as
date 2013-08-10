package inoah.game.ro.modules.main.controller
{
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.interfaces.IUserModel;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class GameCommand extends Command
    {
        [Inject]
        public var event:GameEvent;
        
        [Inject]
        public var model:IUserModel;
        
        override public function execute():void
        {
            
        }
    }
}