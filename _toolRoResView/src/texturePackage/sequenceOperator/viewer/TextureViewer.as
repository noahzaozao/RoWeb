package texturePackage.sequenceOperator.viewer 
{
    import com.bit101.components.HSlider;
    import com.bit101.components.Label;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    import com.bit101.components.Slider;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.PNGEncoderOptions;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import format.Sequence;
    
    import inoah.core.viewModels.actSpr.ActSprView;
    import inoah.core.viewModels.actSpr.structs.sprh.AnySprite;

    public class TextureViewer extends Panel
    {
        private var _textureList:Vector.<TextureView>;
        private var _currentTextureIndex:int;
        private var _textureDisplay:Panel;
        private var _nextButton:PushButton;
        private var _prevButton:PushButton;
        private var _remainedSequence:Vector.<Sequence>;
        private var _currentDisplayTexture:TextureView;
        private var _textureDisplayRadio:Slider;
        private var _radioNoticeRealSize:Label;
        private var _radioNoticeShowAll:Label;
        private var _currentRadioMin:Number;
        private var _currentDragItem:Sprite;
        
        public function TextureViewer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            
            if(stage)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
            
            _textureDisplay = new Panel(this, 5,5);
            
            _nextButton = new PushButton(null, 0, 0, "下一张贴图");
            _nextButton.addEventListener(MouseEvent.CLICK, onShowNextTexture);
            _nextButton.width = 80;
            _prevButton = new PushButton(null, 0, 0, "上一张贴图");
            _prevButton.addEventListener(MouseEvent.CLICK, onShowPrevTexture);
            _prevButton.width = 80;
            _textureList = new Vector.<TextureView>();
            
            _textureDisplayRadio = new HSlider(this);
            _textureDisplayRadio.maximum = 1;
            _textureDisplayRadio.minimum = 0;
            
            _textureDisplayRadio.addEventListener(Event.CHANGE, onSlideChange);
            _textureDisplayRadio.mouseEnabled=false;
            _textureDisplayRadio.alpha = .5;
            
            _radioNoticeShowAll = new Label(this,0,0,"显示全部");
            var tf:TextFormat = _radioNoticeShowAll.textField.getTextFormat();
            tf.align = TextFormatAlign.RIGHT;
            _radioNoticeShowAll.textField.setTextFormat(tf);
            
            _radioNoticeRealSize = new Label(this,0,0,"实际尺寸");
            shadow = false;
        }
        
        protected function onShowPrevTexture(event:MouseEvent):void
        {
            if(_currentTextureIndex>0)
            {
                _currentTextureIndex--;
                updateTextureDisplay();
            }
        }
        
        protected function onShowNextTexture(event:MouseEvent):void
        {
            if(_currentTextureIndex<_textureList.length-1)
            {
                _currentTextureIndex++;
                updateTextureDisplay();
            }
        }
        
        public function outputBmp( actSprView:ActSprView ):void
        {
            var len:int = actSprView.spr.imgs.length;
            var sequence:Sequence;
            var img:AnySprite;
            
            var file:File;
            var fs:FileStream;
            
            var url:String = actSprView.url.replace( ".act" , "" );
                
            for( var i:int = 0;i<len;i++)
            {
                img = actSprView.spr.imgs[i];
                if( i< 10)
                {
                    file = new File( url + "_0" + i + ".png" );
                }
                else
                {
                    file = new File( url + "_" + i + ".png" );
                }
                fs = new FileStream();
                fs.open( file , FileMode.WRITE );
                fs.writeBytes( img.drawbitmap().encode( new Rectangle(0,0,img.w ,img.h ) ,new PNGEncoderOptions() ) );
                fs.close();
            }
        }
        
        public function updateSequenceList( actSprView:ActSprView ):void
        {
            var aaa:SprTextureAtlas = new SprTextureAtlas();
            aaa.init( actSprView.spr );
            var sequenceList:Vector.<Sequence> = aaa.sequenceList;
            
            _textureDisplay.removeChildren();
            
            if(sequenceList.length == 0)
            {
                return;
            }
            
            _remainedSequence = sequenceList
            _remainedSequence.sort(sortSequence);
            
            var len:int = _textureList.length;
            for(var i:int = 0; i<len; i++)
            {
                _textureList[i].dispose();
                _textureList[i].removeEventListener(MouseEvent.MOUSE_DOWN, onTextureMouseHandle);
                _textureList[i].removeEventListener(MouseEvent.MOUSE_UP,onTextureMouseHandle);
            }
            
            _textureList.length = 0;
            
            initTextures();
        }
        
        private function initTextures():void
        {
            if(_remainedSequence.length>0)
            {
                var _textureView:TextureView = new TextureView();
                _textureList.push(_textureView);
                _currentTextureIndex = 0;
                _textureView.addEventListener(TextureView.INIT, onTextureInitialized);
                _textureView.initialize(_remainedSequence);
                updateTextureDisplay();
            }
            else
            {
                updateTextureDisplay();
            }
            
        }
        
        protected function  onTextureInitialized(e:Event):void
        {
            e.currentTarget.removeEventListener(TextureView.INIT, onTextureInitialized);
            initTextures();
        }
        
        private function updateTextureDisplay():void
        {
            _textureDisplay.content.removeChildren();
            _currentDisplayTexture = _textureList[_currentTextureIndex];
            _currentDisplayTexture.addEventListener(MouseEvent.MOUSE_DOWN, onTextureMouseHandle);
            
            _textureDisplayRadio.value = 0;
            
            _currentDisplayTexture.scaleX = 1;
            _currentDisplayTexture.scaleY = 1;
            _currentDisplayTexture.x = 0;
            _currentDisplayTexture.y = 0;
            
            _textureDisplay.content.addChild(_currentDisplayTexture);
            
            var memoryLen:int=0;
            var textureLen:int = _textureList.length;
            for(var i:int = 0; i<textureLen; i++)
            {
                memoryLen+=_textureList[i].getTextureOccupyMemory(1);
            }
            
            trace("当前贴图的宽度[显存:" + _currentDisplayTexture.textureWidth +
                               " px] 高度[" +
                               _currentDisplayTexture.textureHeight +" px].\t当前动画共占用 "+textureLen+" 张贴图, 预计运行时花费内存:" +
                               memoryLen +"KB");
            
            updateTextureRadio();
            updateViewerBtnState();
            
        }
        
        
        
        protected function onTextureMouseHandle(e:MouseEvent):void
        {
            var target:Sprite = e.target as Sprite;
            if(target == null)
            {
                return;
            }
            switch(e.type)
            {
                case MouseEvent.MOUSE_DOWN:
                {
                    stage.addEventListener(MouseEvent.MOUSE_UP,onTextureMouseHandle);
                    var dragWidth:Number = Math.max(0, target.width - _textureDisplay.width);
                    var dragHeight:Number = Math.max(0, target.height - _textureDisplay.height);
                    _currentDragItem = target;
                    target.startDrag(false, new Rectangle(-dragWidth, -dragHeight, dragWidth,dragHeight));
                    
                    break;
                }
                case MouseEvent.MOUSE_UP:
                {
                    e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,onTextureMouseHandle);
                    if(_currentDragItem!= null)
                    {
                        _currentDragItem.stopDrag();
                        _currentDragItem = null;
                    }
                    break;
                }    
                default:
                {
                    return;
                }
            }
        }
        
        private function sortSequence(sequence_a:Sequence, sequence_b:Sequence):Number
        {
            return (sequence_a.bitmapData.width*2048 + sequence_a.bitmapData.height)-(sequence_b.bitmapData.width*2048 + sequence_b.bitmapData.height)
        }
        
        private function initialize(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initialize);
            addEventListener(Event.RESIZE, onResize);
            
            onResize();
            
        }
        
        private function onSlideChange(e:Event):void
        {
            if(_currentDisplayTexture == null)
            {
                return
            }
            
            var radio:Number = 1-(_textureDisplayRadio.value*(1-_currentRadioMin))
            _currentDisplayTexture.scaleX = radio;
            _currentDisplayTexture.scaleY = radio;
            
            if(_currentDisplayTexture.x<-_currentDisplayTexture.width+_textureDisplay.width)
            {
                _currentDisplayTexture.x=-_currentDisplayTexture.width+_textureDisplay.width;
            }
            if(_currentDisplayTexture.y<-_currentDisplayTexture.height+_textureDisplay.height)
            {
                _currentDisplayTexture.y=-_currentDisplayTexture.height+_textureDisplay.height;
            }
            
            if(_currentDisplayTexture.x>0)
            {
                _currentDisplayTexture.x=0;
            }
            if(_currentDisplayTexture.y>0)
            {
                _currentDisplayTexture.y=0;
            }
            
        }
        
        private function onResize(e:Event = null):void
        {
            _textureDisplay.setSize(width-10, height - 35);
            _textureDisplay.content.graphics.clear();
            _textureDisplay.content.graphics.beginFill(0,0);
            _textureDisplay.content.graphics.drawRect(0,0,width-25, height-30);
            _textureDisplay.content.graphics.endFill();
            
            _textureDisplayRadio.width = _textureDisplay.width-170;
            _textureDisplayRadio.x = 90;
            _textureDisplayRadio.y = height-25;
            _radioNoticeRealSize.x = 86; 
            _radioNoticeRealSize.y = height - 18;
            
            _radioNoticeShowAll.x = _textureDisplay.width-260+130;
            _radioNoticeShowAll.y = height - 18;
            
            updateTextureRadio();
            updateViewerBtnState();
        }
        
        private function updateViewerBtnState():void
        {
            content.addChild(_nextButton);
            content.addChild(_prevButton);
            
            _prevButton.x = 5; 
            _nextButton.x = width-85;
            _nextButton.y = height-25;
            _prevButton.y = height-25;
            
            if(_textureList.length>1)
            {
                _prevButton.enabled = true;
                _nextButton.enabled = true;
                _prevButton.alpha = 1;
                _nextButton.alpha = 1;
            }
            else
            {
                _prevButton.enabled = false;
                _nextButton.enabled = false;
                _prevButton.alpha = .5;
                _nextButton.alpha = .5;
            }
        }
        
        private function updateTextureRadio():void
        {
            if(_currentDisplayTexture != null &&
                (_textureDisplay.width<_currentDisplayTexture.textureWidth ||
                _textureDisplay.height<_currentDisplayTexture.textureHeight))
            {
                _currentRadioMin = Math.min(_textureDisplay.width /( _currentDisplayTexture.width),
                                            _textureDisplay.height/(_currentDisplayTexture.height));
                
                _textureDisplayRadio.mouseEnabled = true;
                _textureDisplayRadio.alpha=1;
            }
            else
            {
                _currentRadioMin=1;
            }
            if(_currentRadioMin>1)
            {
                _currentRadioMin = 1;
            }
            
            
        }
        
        public function get textures():Vector.<TextureView>
        {
            return _textureList;
        }
    }
}