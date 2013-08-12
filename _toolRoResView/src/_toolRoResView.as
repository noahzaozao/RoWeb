package
{
    import com.bit101.components.Style;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import consts.AppConsts;
    
    import inoah.core.CoreBundle;
    import inoah.core.Global;
    import inoah.game.ro.RoConfig;
    import inoah.interfaces.base.ITickable;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    
    [SWF(width="1024",height="620",frameRate="60",backgroundColor="#2f2f2f")]
    public class _toolRoResView extends Sprite
    {
        private var _starling:Starling;
        
        private var _context:IContext;
        
        private var _lastTimeStamp:Number;
        private var _starlingMain:StarlingMain;
        
        public function _toolRoResView()
        {
            if( stage )
            {
                init();
            }
            else
            {
                stage.addEventListener( Event.ADDED_TO_STAGE , init );
            }
        }
        
        private function init( e:Event = null ):void
        {
            stage.frameRate = 60;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            tabChildren = false;
            tabEnabled = false;
            
            loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
        }
        
        protected function loaderInfo_completeHandler( e:Event):void
        {
            Style.embedFonts = false;
            Style.fontSize =  14;
            Style.setStyle( Style.DARK );
            
            Global.IS_MOBILE = true;
            Global.ENABLE_LUA = true;
            Global.SCREEN_W = stage.stageWidth;
            Global.SCREEN_H = stage.stageHeight;
            
            _context = new Context()
                .install( MVCSBundle )
                .install( CoreBundle )
//                .install( LuaExtension )
                .configure( RoConfig )
                .configure( new ContextView( this ) );
            _context.initialize( onInitialize );
        }
        
        private function onInitialize():void
        {
            initMenu();
            initData();
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling(StarlingMain, stage);
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
            _starling.start();
            
            _lastTimeStamp = new Date().time;
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
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
                _starlingMain = Starling.current.root as StarlingMain;
                onStarlingInited();
            }
        }
        
        private function onStarlingInited():void
        {
            _context.injector.injectInto(_starlingMain);
            _starlingMain.initialize();
        }
        private function initMenu():void
        {
            stage.nativeWindow.menu = new EditorMenu();
        }
        
        private function initData():void
        {
            var pathStr:String = File.applicationStorageDirectory.nativePath;
            var pathFile:File = new File( pathStr + "pathFile.dat"  );
            var fs:FileStream = new FileStream();
            if( pathFile.exists )
            {
                fs.open( pathFile, FileMode.READ );
                var str:String = fs.readUTF();
                fs.close();
                AppConsts.filePath = str;
                trace( "[filePath]: " + str );
            }
        }
    }
}