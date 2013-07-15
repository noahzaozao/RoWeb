package
{
    import com.bit101.components.Style;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.SprMgr;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.getTimer;
    
    import consts.AppConsts;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    
    [SWF(width="1024",height="620",frameRate="60",backgroundColor="#2f2f2f")]
    public class _toolRoResView extends Sprite
    {
        private var _starling:Starling;
        private var lastTimeStamp:int;
        
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
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
        }
        
        protected function loaderInfo_completeHandler( e:Event):void
        {
            Style.embedFonts = false;
            Style.fontSize =  14;
            Style.setStyle( Style.DARK );
            
            MainMgr.instance;
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            initMenu();
            initData();
            
            lastTimeStamp = getTimer();
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling(StarlingMain, stage);
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
            _starling.start();
        }
        
        protected function onEnterFrameHandler(e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            
            var root:StarlingMain =    Starling.current.root as StarlingMain;
            if( root )
            {
                root.tick( delta );
            }
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