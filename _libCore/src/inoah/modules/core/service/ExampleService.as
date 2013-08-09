package inoah.modules.core.service
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.modules.core.model.BaseModel;
    import inoah.modules.core.model.ExampleModel;
    
    public class ExampleService extends BaseModel implements IExampleService{
        private var urlLoader:URLLoader;
        
        [Inject]
        public var exampleModel:ExampleModel;
        
        public function ExampleService() 
        {
            super();
        }
        
        public function load():void 
        {
            var urlRequest:URLRequest = new URLRequest("./assets/json/example.json");
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, onLoadTreeComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadTreeIOError);
            urlLoader.load(urlRequest);
            
        }
        
        private function onLoadTreeComplete(event:Event):void 
        {
            if (urlLoader.data) {
                logger.debug("4. We're now in the service onComplete::::::::");
                // this import collides with the Flex SDK's implementation of JSON support for AIR apps
                // we're using as3corelib to support json
                var jsonObject:Object = JSON.parse(urlLoader.data);
                exampleModel.createMessage(jsonObject);
            }
        }
        
        private function onLoadTreeIOError(event:IOErrorEvent):void 
        {
            logger.error("ERROR")
        }
        
    }
}