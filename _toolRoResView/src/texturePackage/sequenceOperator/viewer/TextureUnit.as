package texturePackage.sequenceOperator.viewer
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    
    import format.Sequence;
    
    public class TextureUnit extends Shape
    {
        private var _sequence:Sequence;
        private var _position:Rectangle;
        
        public function TextureUnit(sequence:Sequence, position:Rectangle):void
        {
            _sequence = sequence;
            _position = position;
            
            graphics.clear();
            var data:BitmapData = sequence.bitmapData;
            graphics.beginBitmapFill(data,null, false);
            graphics.drawRect(0, 0, position.width, position.height);
            graphics.endFill();
            
//            graphics.lineStyle(.1,0xff0000);
//            graphics.drawRect(0, 0, position.width, position.height);
            
            x = position.left;
            y = position.top;
        }
        
        public function get sequence():Sequence
        {
            return _sequence;
        }
        
        public function get texturePosition():Rectangle
        {
            return _position;
        }
        
        public function dispose():void
        {
            _sequence = null;
            _position = null;
            graphics.clear();
            
        }
    }
}