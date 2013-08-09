package  inoah.modules.core.model
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import robotlegs.bender.framework.api.ILogger;
    
    public class BaseModel 
    {
        [Inject]
        public var eventDispatcher:IEventDispatcher;

        [Inject]
        public var logger:ILogger;
        
        protected function dispatch(e:Event):void 
        {
            if (eventDispatcher.hasEventListener(e.type))
            {
                eventDispatcher.dispatchEvent(e);
            }
        }
    }
}