package inoah.modules.core.controller
{
    import inoah.modules.core.service.IExampleService;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class GetSomeTextCommand extends Command
    {
//        [Inject]
//        public var event:GetSomeTextEvent;
        
        [Inject]
        public var service:IExampleService;
        
        override public function execute():void{
            trace("3. Now we're in the command which will then tell the service to load data:::::::::")
            service.load();
        }
    }
}