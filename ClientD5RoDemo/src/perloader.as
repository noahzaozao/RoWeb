package
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.filters.DropShadowFilter;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    [SWF(width="960", height="560", backgroundColor="0x0")]
    public class perloader extends VersionSprite
    {
        private var _gameLoader:Loader;
        
        public function perloader()
        {
            if(stage)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
        }
        
        protected function initialize(event:Event = null):void
        {
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorHandle)
            //初始化舞台配置
            stage.frameRate = 60;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            tabChildren = false;
            tabEnabled = false;
            
            _gameLoader = new Loader();
            _gameLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onGameLoaded );
            _gameLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onGameLoadProgress );
            _gameLoader.contentLoaderInfo.addEventListener( ErrorEvent.ERROR , onGameLoadError );
            _gameLoader.load( new URLRequest("ClientD5RoDemo.swf" ) );
        }
        
        protected function onUncaughtErrorHandle(event:UncaughtErrorEvent):void
        {
            trace("perloader catch uncaught error:", event.toString());
        }
        
        protected function onGameLoadError( e:Event ):void
        {
            var _error:TextField = new TextField();
            _error.text = "加载游戏失败,请按'F5'刷新重试";
            _error.mouseEnabled = false;
            
            var tf:TextFormat = new TextFormat();
            tf.size = 18;
            tf.color= 0xffffff;
            tf.bold =true;
            tf.font="Arial";
            _error.setTextFormat(tf);
            _error.autoSize = TextFieldAutoSize.LEFT;
            _error.x = (stage.stageWidth-_error.textWidth)>>1;
            _error.y = 50+(stage.stageHeight-_error.textHeight)>>1;
            _error.filters = [new DropShadowFilter(0,0,0,1,3,3,8)];
            addChild(_error);
        }
        
        protected function onGameLoadProgress( e:ProgressEvent ):void
        {
            var stageWidth:int = stage.stageWidth;
            var stageHeight:int = stage.stageHeight;
            
            graphics.beginFill(0x666666);
            graphics.drawRect((stageWidth-200)*.5,(stageHeight-20)*.5,200,20);
            graphics.beginFill(0x333333);
            graphics.drawRect((stageWidth-196)*.5,(stageHeight-16)*.5,196,16);
            graphics.beginFill(0xaaaaaa);
            
            if(_gameLoader!=null)
            {
                graphics.drawRect((stageWidth-196)*.5,(stageHeight-16)*.5,196*(_gameLoader.contentLoaderInfo.bytesLoaded / _gameLoader.contentLoaderInfo.bytesTotal),16);
            }
            graphics.endFill();
        }
        
        protected function onGameLoaded(e:Event):void
        {
            var gameInitializer:DisplayObject = _gameLoader.content;
            stage.addChildAt(gameInitializer, 0);
            stage.removeChild(this);
        }
    }
}