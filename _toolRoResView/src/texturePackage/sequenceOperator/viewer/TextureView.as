package texturePackage.sequenceOperator.viewer
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.setTimeout;
    
    import format.Sequence;

    public class TextureView extends Sprite
    {
        public static const INIT:String = "textureViewInit";
        
        private const TEXTURE_SIZE_MAX:int = 2048;
        private const TEXTURE_SIZE_MIN:int = 128;
        private var _unitList:Vector.<TextureUnit>
        private var _view:BitmapData;
        private var _viewCtrl:Bitmap;
        private var _currentInitSequenceList:Vector.<Sequence>;
        private var _sequenceListIndex:Vector.<int>;
        private var _maxRectsBin:RectanglePacker;
        private var _currentWidth:int;
        private var _currentHeight:int;
        
        public function initialize(sequenceList:Vector.<Sequence>):void
        {
            _currentInitSequenceList = sequenceList;
            
            disposeView();
            useHandCursor = true;
            buttonMode = true;
            
            _view = new BitmapData(TEXTURE_SIZE_MAX, TEXTURE_SIZE_MAX, true, 0);
            fillTextureBackgound();
            _viewCtrl = new Bitmap(_view);
            addChild(_viewCtrl);
            
            _unitList = new Vector.<TextureUnit>();
            addEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            addEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
            setTimeout(initSequence,100);
        }
        
        protected function onStageEventHandle(e:Event):void
        {
            switch(e.type)
            {
                case Event.ADDED_TO_STAGE:
                {
                    stage.addEventListener(Event.RESIZE, onStageEventHandle);
                }
                case Event.RESIZE:
                {
                    fillTextureBackgound();
                    break;
                }
                default:return;
            }
        }
        
        protected function disposeView():void
        {
            if(_view!=null)
            {
                _view.dispose();
                _view = null;
            }
                
        }
        
        protected function initSequence():void
        {
            _maxRectsBin = new RectanglePacker(TEXTURE_SIZE_MAX, TEXTURE_SIZE_MAX);
            
            _currentInitSequenceList.sort(sortOnArea);
            
            _view.fillRect(_view.rect,0);
            
            var sequence:Sequence;
            var len:int = _currentInitSequenceList.length;
            var insertSuccess:Boolean = false;
            var insertList:Vector.<Sequence> = new Vector.<Sequence>();
            var insertIndex:Vector.<int> = new Vector.<int>(); 
            
            //insert sequence into texture.
            for(var i:int = 0; i<len; i++)
            {
                sequence = _currentInitSequenceList[i]
                insertSuccess = _maxRectsBin.insertRectangle(sequence.bitmapData.rect);
                
//                trace("currentWidth:"+_currentWidth, "currentHeight:"+_currentWidth, "try insert:", sequence.bitmapData.rect, "result:", insertSuccess);
//                if(insertSuccess == false)
//                {
//                    var couldUpdateFreeRects:Boolean;
//                    
//                    if(couldUpdateFreeRects == false && _currentWidth < TEXTURE_SIZE_MAX && _currentWidth <= _currentHeight)
//                    {
//                        _currentWidth*=2
//                        couldUpdateFreeRects = true;
//                    }
//                    
//                    if(couldUpdateFreeRects == false && _currentHeight < TEXTURE_SIZE_MAX && _currentHeight<_currentWidth)
//                    {
//                        _currentHeight*=2
//                        couldUpdateFreeRects = true;
//                    }
//                    
//                    if(couldUpdateFreeRects == true)
//                    {
//                        _currentInitSequenceList = _currentInitSequenceList.concat(insertList);
//                        setTimeout(initSequence,1);
//                        return;
//                    }
//                }
                if(insertSuccess)
                {
                    insertList.push(sequence);
                    insertIndex.push(i);
                    _currentInitSequenceList.splice(i, 1);
                    i--;
                    len--;
                }
            }
            
            var unit:TextureUnit;
            var drawRect:Rectangle = new Rectangle();
            len = insertIndex.length;
            for(i=0;i<_maxRectsBin.rectangleCount; i++)
            {
                sequence = insertList[i];
                drawRect = _maxRectsBin.getRectangle(i, drawRect);
                
                unit =new TextureUnit(sequence, drawRect);
                _unitList.push(unit);
                _view.draw(unit, new Matrix(1,0,0,1,unit.x,unit.y));
            }
            removeEventListener(Event.ENTER_FRAME, initSequence);
            
            var bounds:Rectangle = _view.getColorBoundsRect(0xffffff,0,false);
            var newData:BitmapData = new BitmapData(bounds.width,bounds.height);
            newData.copyPixels(_view, bounds, new Point());
            
            _viewCtrl.bitmapData = newData;
            disposeView();
            _view = newData;
            
            trace("texture width:", _currentWidth, "height:", _currentHeight);
            
            fillTextureBackgound();
            dispatchEvent(new Event(INIT));
        }
        
        private function sortOnArea(a:Sequence, b:Sequence):Number
        {
            var aRect:Rectangle = a.bitmapData.rect;
            var bRect:Rectangle = b.bitmapData.rect;
            if (aRect.width*aRect.height > bRect.width*bRect.height)
            {
                return -1;
            }
            
            return 1;
        }
        
        protected function fillTextureBackgound():void
        {
            if(_view!=null)
            {
                graphics.clear();
                graphics.beginFill(0,.1);
                graphics.drawRect(0,0,_view.width,_view.height);
                graphics.endFill();
            }
        }
        
        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, initSequence);
            removeEventListener(Event.RESIZE, onStageEventHandle);
            removeEventListener(Event.ADDED_TO_STAGE, onStageEventHandle);
            removeEventListener(Event.REMOVED_FROM_STAGE, onStageEventHandle);
            removeChildren();
            
            var len:int =  _unitList.length
            for(var i:int =0; i<len; i++)
            {
                _unitList[i].dispose();
            }
            
            _unitList.length = 0;
            _unitList = null;
            
            disposeView();
            _viewCtrl = null;
            
        }
        
        public function get textureUnitList():Vector.<TextureUnit>
        {
            return _unitList;
        }
        
        public function get textureHeight():int
        {
            return int(Math.ceil(_view.height/256)*256);
        }
        
        public function get textureWidth():int
        {
            return int(Math.ceil(_view.width/256)*256);
        }
        
        public function getTextureOccupyMemory(level:uint = 0):int
        {
            return int(textureHeight*textureWidth*8/Math.pow(1024,level))
        }
		
		public function get bitmapData():BitmapData
		{
			return _view;
		}
    }
}