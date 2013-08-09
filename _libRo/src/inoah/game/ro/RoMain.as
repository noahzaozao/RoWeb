package inoah.game.ro
{
    import inoah.core.starlingMain;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.loaders.AtfLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.DisplayMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.managers.TextureMgr;
    
    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class RoMain extends starlingMain
    {
        protected var _bgImage:Image;
        
        public function RoMain()
        {
            super();
        }
        
        override protected function addedToStageHandler( e:Event ):void
        {
            super.addedToStageHandler( e );
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.initStarling( this );
            
            addBgImage();
        }
        
        protected function addBgImage():void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "loginBg.atf" , onAddBgImage );
        }
        
        protected function onAddBgImage( loader:ILoader ):void
        {
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var texture:Texture = Texture.fromAtfData( (loader as AtfLoader).data, 1 , false );
            _bgImage = new Image( texture );
            _bgImage.touchable = false;
            displayMgr.bgLevel.addChild( _bgImage );
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
        }
    }
}