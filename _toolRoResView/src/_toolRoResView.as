package
{
    import com.bit101.components.Style;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.BattleMgr;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.getTimer;
    
    import consts.AppConsts;
    
    import panels.DisplayEvent;
    import panels.SidePanel;
    import panels.ViewPanel;
    
    
    [SWF(width="1024",height="620",frameRate="60",backgroundColor="#2f2f2f")]
    public class _toolRoResView extends Sprite
    {
        private var sidePanel:SidePanel;
        private var viewPanel:ViewPanel
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
            Style.embedFonts = false;
            Style.fontSize =  14;
            Style.setStyle( Style.DARK );
            
            MainMgr.instance;
            var keyMgr:KeyMgr = new KeyMgr( stage );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, keyMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.BATLLE_MGR, new BattleMgr( this ) );
            
            initMenu();
            initData();
            sidePanel = new SidePanel( this, 0, 0 );
            sidePanel.addEventListener( DisplayEvent.SHOW, onShowHandler )
            viewPanel = new ViewPanel( this, AppConsts.SIDE_PANEL_WIDTH, 0 );
            
            lastTimeStamp = getTimer();
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onEnterFrameHandler(e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            viewPanel.tick( delta );
        }
        
        protected function onShowHandler(e:DisplayEvent):void
        {
            viewPanel.showAct( e.data, e.switchType );
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