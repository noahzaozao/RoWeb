package inoah.game.ro.modules.map.view
{
    import inoah.interfaces.IViewObject;
    
    import starling.display.Image;
    import starling.textures.Texture;
    
    public class TileImage extends Image implements IViewObject
    {
        public var id: int = 0;
        
        public function TileImage( id:int , texture:Texture )
        {
            this.id = id;
            super( texture );
        }
        
        override public function get x():Number
        {
            return super.x;
        }
            
        override public function get y():Number
        {
            return super.y;
        }
        
        public function get action():int
        {
            return 0;
        }
        
        public function get isPlayEnd():Boolean
        {
            return false;
        }
        
        override public function set x( value:Number ):void
        {
            super.x = value;
        }
        
        override public function set y( value:Number ):void
        {
            super.y = value;
        }
        
        public function set action( value:int ):void
        {
            
        }
        
        public function set isPlayEnd( value:Boolean ):void
        {
            
        }
        
        public function set gid( value:uint ):void
        {
            
        }
        
        public function set playRate( value:Number ):void
        {
            
        }
        
        public function setChooseCircle( value:Boolean ):void
        {
            
        }
        
        override public function dispose():void
        {
            super.dispose();
            
            if( this.parent )
            {
                this.parent.removeChild( this );
            }
        }
        
        public function set dirIndex( value:uint ):void
        {
            
        }
        
        public function get dirIndex():uint
        {
            return 0;
        }
        
        public function tick(delta:Number):void
        {
            
        }
        
        /**
         * 可以被时间推动 
         */ 
        public function get couldTick():Boolean
        {
            return false;
        }
    }
}