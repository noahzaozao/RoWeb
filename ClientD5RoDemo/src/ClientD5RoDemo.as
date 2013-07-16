package
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.SprMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.mediators.GameMediator;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    
    import as3.interfaces.IFacade;
    import as3.patterns.facade.Facade;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends Sprite
    {
        //        private var npcDialogBox:NPCDialog;
        private var lastTimeStamp:int;
        
        private var _gameMediator:GameMediator;
        
        public function ClientD5RoDemo()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            lastTimeStamp = getTimer();
            
            var facade:IFacade = Facade.getInstance();
            _gameMediator = new GameMediator( this );
            facade.registerMediator( _gameMediator );
            
            MainMgr.instance;
            var assetMgr:AssetMgr = new AssetMgr();
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, assetMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , new DisplayMgr( stage ) );
            
            onInitRes( assetMgr );
            
            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        private function onInitRes( assetMgr:AssetMgr ):void
        {
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/sprite/牢埃练/赣府烹/咯/2_咯.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/咯/檬焊磊_咯.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_咯_窜八_八堡.act" );
            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八_八堡.act" );
            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            resPathList.push( "data/sprite/阁胶磐/poporing.act" );
            resPathList.push( "data/sprite/阁胶磐/ghostring.act" );
            resPathList.push( "data/sprite/酒捞袍/lk_aurablade.act" );
            resPathList.push( "data/sprite/酒捞袍/lk_spiralpierce.act" );
            assetMgr.getResList( resPathList , function():void{} );
        }
        
        protected function onRightClick( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.RIGHT_CLICK , [e] );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            if( _gameMediator )
            {
                _gameMediator.tick( delta );
            }
        }
    }
}