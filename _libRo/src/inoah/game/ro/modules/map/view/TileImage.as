package inoah.game.ro.modules.map.view
{
    import starling.display.Image;
    import starling.textures.Texture;
    
    public class TileImage extends Image
    {
        public var id: int = 0;
        
        public function TileImage( id:int , texture:Texture )
        {
            this.id = id;
            super( texture );
        }
    }
}