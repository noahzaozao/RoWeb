package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.core.CoreBundle;
    import inoah.core.loaders.ActTpcLoader;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class StarlingAnimationTest extends Sprite
    {
        private var _lastTimeStamp:Number;
        private var _starlingMain:AnimationMain;
        
        private var _context:IContext;
        public static var _tpcLoaderList:Vector.<ActTpcLoader>;
        
        public function StarlingAnimationTest()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
            _tpcLoaderList = new Vector.<ActTpcLoader>();
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            
            stage.frameRate = 60;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            tabChildren = false;
            tabEnabled = false;
            
            _context = new Context()
                .install( MVCSBundle )
                .install( CoreBundle )
                .configure( new ContextView( this ) );
            _context.initialize( onInitialize );
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            var starling:Starling = new Starling( AnimationMain, stage , null , null , "auto", "baseline" );
            starling.enableErrorChecking = false;
            starling.showStats = true;
            starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            starling.start();
            
            _lastTimeStamp = new Date().time;
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        private function onInitialize():void
        {
            // TODO Auto Generated method stub
            
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _starlingMain )
            {
                _starlingMain.tick( delta );
            }
            else if( Starling.current && Starling.current.root )
            {
                _starlingMain = Starling.current.root as AnimationMain;
                onStarlingInited();
            }
        }
        
        private function onStarlingInited():void
        {
//            _starlingMain.initialize();
            var loader:ActTpcLoader = new ActTpcLoader( "poring.tpc" );
            _context.injector.injectInto(loader);
            loader.addEventListener( Event.COMPLETE , onLoaded );
            loader.load();
            loader = new ActTpcLoader( "poporing.tpc" );
            _context.injector.injectInto(loader);
            loader.addEventListener( Event.COMPLETE , onLoaded );
            loader.load();
            loader = new ActTpcLoader( "ghostring.tpc" );
            _context.injector.injectInto(loader);
            loader.addEventListener( Event.COMPLETE , onLoaded );
            loader.load();
        }
        
        protected function onLoaded( e:Event):void
        {
            var loader:ActTpcLoader = e.currentTarget as ActTpcLoader;
            loader.removeEventListener( Event.COMPLETE , onLoaded );
            
            _tpcLoaderList.push( loader );
            
            if( _tpcLoaderList.length == 3)
            {
                _starlingMain.init();
            }
        }
    }
}