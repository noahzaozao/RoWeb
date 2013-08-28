package inoah.game.td.modules.map.view.mediators
{
    import inoah.core.Global;
    import inoah.interfaces.managers.ITextureMgr;
    import inoah.interfaces.map.IScene;
    
    import robotlegs.bender.extensions.tdMapMgrExtension.MapEvent;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;
    
    public class TowerSelecter extends Sprite
    {
        [Inject]
        public var injector:IInjector; 
        
        [Inject]
        public var textureMgr:ITextureMgr;
        
        [Inject]
        public var scene:IScene;
        
        protected var _tSelectedBg:Image;
        protected var _tBlockList:Vector.<Image>;
        protected var _tNamekList:Vector.<Image>;
        protected var _tBuildingList:Vector.<Image>;
        protected var _tTxtList:Vector.<TextField>;
        
        public function TowerSelecter()
        {
            super();
            _tBlockList = new Vector.<Image>( 4 );
            _tNamekList = new Vector.<Image>( 4 );
            _tBuildingList = new Vector.<Image>( 4 );
            _tTxtList = new Vector.<TextField>( 4 );
        }
        
        public function initialize():void
        {
            var texture:Texture;
            
            if( !_tSelectedBg )
            {
                texture = textureMgr.getTextureAtlasById( "common" ).getTexture( "tSelectedBg" );
                _tSelectedBg = new Image( texture );
                addChild( _tSelectedBg );
            }
            _tSelectedBg.x = - Global.TILE_W / 2;
            _tSelectedBg.y = - Global.TILE_H / 2;
            _tSelectedBg.touchable = false;
            
            for( var i:int = 0;i<4;i++)
            {
                if( _tBlockList[i] == null )
                {
                    texture = textureMgr.getTextureAtlasById( "common" ).getTexture( "tBlock" );
                    _tBlockList[i] = new Image( texture );
                    addChild( _tBlockList[i] );
                    _tBlockList[i].addEventListener( TouchEvent.TOUCH , onTouch ); 
                    
                    texture = scene.currentTextureAtlasList[1].getTexture( (17+i).toString() );
                    _tBuildingList[i] = new Image( texture );
                    _tBuildingList[i].touchable = false;
                    addChild( _tBuildingList[i] );
                    
                    texture = textureMgr.getTextureAtlasById( "common" ).getTexture( "tNameBg" );
                    _tNamekList[i] = new Image( texture );
                    _tNamekList[i].touchable = false;
                    addChild( _tNamekList[i] );
                    
                    _tTxtList[i] = new TextField( 100 , 30 , "100" , "Verdana" , 16 , 0x693e0b );
                    _tTxtList[i].touchable = false;
                    addChild( _tTxtList[i] );
                }
                _tBlockList[i].x =  - Global.TILE_W / 2 - 135 + i * 100;
                _tBlockList[i].y =  - Global.TILE_H / 2 - 100;
                _tBuildingList[i].x =  - Global.TILE_W / 2 - 122 + i * 100;
                _tBuildingList[i].y =  - Global.TILE_H / 2 - 168;
                _tNamekList[i].x =  - Global.TILE_W / 2 - 125 + i * 100;
                _tNamekList[i].y =  - Global.TILE_H / 2 - 40;
                _tTxtList[i].x =  - Global.TILE_W / 2 - 130 + i * 100;
                _tTxtList[i].y =  - Global.TILE_H / 2 - 42;
            }
        }
        
        private function onTouch( e:TouchEvent ):void
        {
            var touch:Touch = e.touches[0];
            if( touch )
            {
                if( touch.phase == TouchPhase.BEGAN )
                {
                    var index:int = _tBlockList.indexOf( e.currentTarget as Image );
                    dispatchEvent( new Event( MapEvent.BUILD_TOWER , false , index ));
                }
            }
        }
    }
}