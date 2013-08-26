package inoah.game.td.modules.map.view.mediators
{
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.interfaces.map.IMapInfo;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.QuadBatch;
    
    public class TDScene extends BaseScene
    {
        protected var _bgBatch:QuadBatch;
        
        public function TDScene()
        {
            super();
        }
        
        override public function initScene( container:DisplayObjectContainer , mapInfo:IMapInfo ):void
        {
            super.initScene( container );
            
            _bgBatch = new QuadBatch();
            bgLayer.addChild( _bgBatch );
        }
        
        override protected function addTile( _XX  : int, _YY : int ) : void
        {  
            
        }
    }
}