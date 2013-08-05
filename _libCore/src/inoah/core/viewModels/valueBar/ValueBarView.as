package inoah.core.viewModels.valueBar
{
    import flash.display.Shape;
    import flash.display.Sprite;
    
    public class ValueBarView extends Sprite
    {
        private var _maxValue:uint = 64;
        private var _valueBarBg:Shape;
        private var _valueBar:Shape;
        private var _color:uint;
        
        public function ValueBarView( color:uint , bgColor:uint )
        {
            _color = color;
            _valueBarBg = new Shape();
            _valueBarBg.graphics.lineStyle( 1 );
            _valueBarBg.graphics.beginFill( bgColor, 0.3 );
            _valueBarBg.graphics.drawRect( 0, 0, _maxValue + 2, 5 );
            _valueBarBg.graphics.endFill();
            addChild( _valueBarBg );
            
            _valueBar = new Shape();
            _valueBar.graphics.beginFill( _color, 1 );
            _valueBar.graphics.drawRect( 1, 1, 1, 3 );
            _valueBar.graphics.endFill();
            addChild( _valueBar );
        }
        
        public function update( currentVal:Number, maxVal:Number ):void
        {
            var per:Number = currentVal / maxVal;
            _valueBar.graphics.clear();
            _valueBar.graphics.beginFill( _color, 1 );
            _valueBar.graphics.drawRect( 1, 1, per * _maxValue, 3 );
            _valueBar.graphics.endFill();
        }
    }
}