package
{
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.mission.EventData;
    import com.inoah.ro.RoGame;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.uis.TopText;
    import com.inoah.ro.utils.UserData;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends Sprite
    {
        private var _topTxt:TopText;
        private static var _me:ClientD5RoDemo;
        private var _game:RoGame;
        //        private var npcDialogBox:NPCDialog;
        private var lastTimeStamp:int;
        
        public static function get me():ClientD5RoDemo
        {
            return _me;
        }
        
        public function ClientD5RoDemo()
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
            stage.removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
            lastTimeStamp = getTimer();
            
            MainMgr.instance;
            var assetMgr:AssetMgr = new AssetMgr();
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, assetMgr );
            
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_1207.act" );
            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            resPathList.push( "data/sprite/阁胶磐/poporing.act" );
            resPathList.push( "data/sprite/阁胶磐/ghostring.act" );
            assetMgr.getResList( resPathList , onInitLoadComplete );
            
            TopText.init();
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onRightClick( e:MouseEvent):void
        {
            
        }
        
        private function onInitLoadComplete( loader:ActSprLoader = null ):void
        {
//            var keyMgr:KeyMgr = new KeyMgr( stage );
//            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, keyMgr );
//            MainMgr.instance.addMgr( MgrTypeConsts.BATLLE_MGR, new BattleMgr( this ) );
            
//            _mapController = new MapController( this );
//            _playerController = new PlayerController( _mapController.currentContainer );
//            _monsterController = new MonsterController( _mapController.currentContainer );
//            
//            _playerController.targetList = _monsterController.monsterViewList;;
            
            Global.userdata = new UserData();
            Global.userdata.getCanSeeMission(1);
            _me = this;
            _game = new RoGame('map1',stage);
            addChild(_game);
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            TopText.tick( delta );
            if( _game )
            {
                _game.tick( delta );
            }
        }
        
        public function npcWindow(say:String,event:EventData,npc:NCharacterObject,misid:uint,type:uint=0,complate:Boolean=false):void
        {
            //            if(npcDialogBox==null)
            //            {
            //                npcDialogBox = new NPCDialog();
            //            }
            //            
            //            npcDialogBox.config(say,npc,misid,type,complate);
            //            if(!contains(npcDialogBox)) addChild(npcDialogBox);
        }
    }
}