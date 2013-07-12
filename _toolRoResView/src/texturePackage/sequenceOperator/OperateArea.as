package texturePackage.sequenceOperator
{
    import com.bit101.components.Component;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.PNGEncoderOptions;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    
    import format.Sequence;
    
    import starling.utils.getNextPowerOfTwo;
    
    import texturePackage.sequenceOperator.viewer.TextureUnit;
    import texturePackage.sequenceOperator.viewer.TextureView;
    import texturePackage.sequenceOperator.viewer.TextureViewer;
    
    public class OperateArea extends Component
    {
        private var menubar:Panel;
        private var _viewerModel:PushButton;
        private var _textureViewer:TextureViewer;
        private var _editorModel:PushButton;
        private var _outPutModel:PushButton;
        
        private var _atfLength:uint;
        private var _cachedByteArrayData:ByteArray;
        private var _atfNow:int;
        
        public function get textures():Vector.<TextureView>
        {
            return _textureViewer.textures;
        }
        
        public function OperateArea(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            
            menubar = new Panel(this);
            menubar.shadow = false;
            menubar.color = 0xfefefe;
            
            _editorModel = new PushButton(menubar, 5,5,"动画编辑器");
            _editorModel.width = 100;
            _editorModel.addEventListener(MouseEvent.CLICK, onSwitchPanelHandle);
            _viewerModel = new PushButton(menubar,110,5,"输出的贴图预览");
            _viewerModel.width = 120;
            _viewerModel.addEventListener(MouseEvent.CLICK, onSwitchPanelHandle);
            _outPutModel = new PushButton( menubar , 235 , 5 , "导出" );
            _outPutModel.width = 40;
            _outPutModel.addEventListener( MouseEvent.CLICK , onSwitchPanelHandle );
            
            _textureViewer = new TextureViewer(null,0,30);
            
            if(stage)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
            
        }
        
        private function initialize(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initialize);
            addEventListener(Event.RESIZE, onResize);
            onResize();
        }
        
        protected function onSwitchPanelHandle(event:MouseEvent):void
        {
            switch(event.currentTarget as PushButton)
            {
                case _outPutModel:
                {
                    doOutput();
                    break;
                }
                case _viewerModel:
                {
                    if(!StarlingMain.actSprView)
                    {
                        return;
                    }
                    addChildAt(_textureViewer, 0);
                    _textureViewer.updateSequenceList( StarlingMain.actSprView );
                    _editorModel.enabled = true;
                    _editorModel.selected = false;
                    _editorModel.alpha = 1;
                    
                    _viewerModel.enabled = false;
                    _viewerModel.selected = true;
                    _viewerModel.alpha = .5;
                    
                    //                    Hy_AvatarTexturePacker.enableExport();
                    
                    break;
                }
                case _editorModel:
                {
                    if(_textureViewer.parent != null)
                    {
                        removeChild(_textureViewer);
                    }
                    
                    _viewerModel.enabled = true;
                    _viewerModel.selected = false;
                    _viewerModel.alpha = 1;
                    
                    _editorModel.enabled = false;
                    _editorModel.selected = true;
                    _editorModel.alpha = .5;
                    
                    //                    Hy_AvatarTexturePacker.disableExport();
                    
                    break;
                }
                default:
                {
                    return;
                }
            }
        }
        
        private function doOutput():void
        {
            _atfLength = textures.length;
            if( textures == null || _atfLength <= 0)
            {
                return;
            }
            var imageData:BitmapData;
            _cachedByteArrayData = new ByteArray();
            if(_atfLength > 0)
            {
                _cachedByteArrayData.writeByte( _atfLength );
                _atfNow = 0;
                encodeAtf();
            }
        }
        
        private function encodeAtf():void
        {
            if(_atfNow < _atfLength)
            {
                var imageData:BitmapData = textures[_atfNow].bitmapData;
                if(imageData.width>2048||imageData.height>2048)
                {
                    return;
                }
                var tempData:BitmapData = new BitmapData(getNextPowerOfTwo(imageData.width), getNextPowerOfTwo(imageData.height), true, 0);
                tempData.setVector(imageData.rect, imageData.getVector(imageData.rect));
                
                var options:PNGEncoderOptions = new PNGEncoderOptions(true);
                var convertData:ByteArray = tempData.encode(tempData.rect, options);
                
                var diskId:String = "c:";
                
                var fs:FileStream = new FileStream();
                var pngFile:File = new File("c:\\atf\\tempTpa.png");
                fs.open(pngFile, FileMode.WRITE);
                fs.writeBytes(convertData);
                fs.close();
                
                var file:File = new File(File.applicationDirectory.nativePath+"\\png2atf.exe");
                file.copyTo(new File("c:\\atf\\png2atf.exe"), true);
                var convertBatStr:String = '"c:\\atf\\png2atf.exe" -c d -r -n 0,0 -i "c:\\atf\\tempTpa.png" -o "c:\\atf\\tempTpa.atf"';
                fs = new FileStream();
                fs.open(new File("c:\\atf\\compress.bat"), FileMode.WRITE);
                fs.writeUTFBytes(convertBatStr);
                fs.close();
                processConvertToATF();
            }
            else
            {
                file = new File( StarlingMain.filePath );
                fileStream = new FileStream();
                fileStream.open( file , FileMode.READ );
                var actBytes:ByteArray = new ByteArray();
                fileStream.position = 0;
                fileStream.readBytes( actBytes );
                fileStream.close();
                
                _cachedByteArrayData.deflate();
                var exportData:ByteArray = new ByteArray();
                exportData.writeInt( actBytes.length );
                exportData.writeBytes( actBytes );
                exportData.writeInt(_cachedByteArrayData.length);
                exportData.writeBytes(_cachedByteArrayData);
                exportData.deflate();
                
                var pathFolder:String = "F:\\RoData\\dataAtf\\" + StarlingMain.filePath;
                pathFolder = pathFolder.replace( "F:\\RoData\\data\\" , "" );
                pathFolder = pathFolder.replace( ".act" , ".tpc" );
                trace("pathFolder:",pathFolder);
                var outFile:File = new File( pathFolder );
                
                var fileStream:FileStream = new FileStream();
                fileStream.open( outFile, FileMode.WRITE );
                fileStream.writeBytes( exportData );
                fileStream.close();
                
                StarlingMain.tpcData = exportData;
            }
        }
        
        public function processConvertToATF():void
        {
            var cmd:File = new File("C:\\windows\\system32\\cmd.exe");
            var nativeProcessInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            nativeProcessInfo.executable = cmd;
            nativeProcessInfo.arguments = Vector.<String>(['/c', 'c: && cd "atf\\" && compress.bat','echo.']);
            trace("processArguments:\n"+ nativeProcessInfo.arguments);
            var nativeProcess:NativeProcess = new NativeProcess();
            nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onConvertProcessHandle);
            nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onConvertProcessHandle);
            nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, onConvertProcessHandle);
            nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onConvertProcessHandle);
            nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onConvertProcessHandle);
            nativeProcess.start(nativeProcessInfo); 
            
            function onConvertProcessHandle(e:Event):void
            {
                var process:NativeProcess = e.currentTarget as NativeProcess;
                var data:IDataInput;
                var info:String;
                switch(e.type)
                {
                    case NativeProcessExitEvent.EXIT:
                    {
                        trace("生成完毕");
                        break;
                    }
                    case Event.STANDARD_ERROR_CLOSE:
                    case IOErrorEvent.STANDARD_OUTPUT_IO_ERROR:
                    case IOErrorEvent.STANDARD_ERROR_IO_ERROR:
                    {
                        info = e.toString();
                        trace(info);
                        return;
                    }
                    default:
                    case ProgressEvent.STANDARD_ERROR_DATA:
                    case ProgressEvent.STANDARD_OUTPUT_DATA:
                    {
                        if(e.type == ProgressEvent.STANDARD_ERROR_DATA)
                        {
                            data = process.standardError;
                        }
                        else
                        {
                            data = process.standardOutput;
                        }
                        info = data.readMultiByte(data.bytesAvailable, File.systemCharset)
                        trace(info);
                        return;
                    }
                }
                
                var file:File = new File("C:\\atf\\tempTpa.atf");
                //emp,emc路径
                var pathFolder:String = "F:\\RoData\\dataAtf\\" + StarlingMain.filePath;
                pathFolder = pathFolder.replace( "F:\\RoData\\data\\" , "" );
                pathFolder = pathFolder.replace( ".act" , ".atf" );
                trace("pathFolder:",pathFolder);
                file.copyTo(new File( pathFolder ) , true);
                
                var fileStream:FileStream = new FileStream();
                fileStream.open( file, FileMode.READ );
                var textureBA:ByteArray = new ByteArray();
                fileStream.position = 0;
                fileStream.readBytes( textureBA );
                fileStream.close();
                
                _cachedByteArrayData.writeInt( textureBA.length );
                _cachedByteArrayData.writeBytes( textureBA );
                _cachedByteArrayData.writeBytes( encodeTextureInfo( textures[_atfNow], _atfNow) );
                
                _atfNow++;
                encodeAtf();
            }
        }
        
        private function encodeTextureInfo( textureView:TextureView, textureId:int ):ByteArray
        {
            var textureUnits:Vector.<TextureUnit>
            var unit:TextureUnit;
            var unitCount:int;
            var sequence:Sequence;
            var source:BitmapData;
            var colorRect:Rectangle;
            var textureInfo:XML;
            var sequenceInfo:XML;
            
            textureInfo = XML('<texture id="'+textureId+'" width="'+2048+'" height="'+2048+'"></texture>');
            textureUnits = textureView.textureUnitList;
            unitCount = textureUnits.length;
            for(var j:int = 0; j<unitCount; j++)
            {
                unit = textureUnits[j];
                sequence = unit.sequence;
                source = sequence.bitmapData;
                colorRect = sequence.colorRect;
                sequenceInfo = <sequence/>
                sequenceInfo.@name = sequence.sequenceName;
                sequenceInfo.@x = unit.x;
                sequenceInfo.@y = unit.y;
                sequenceInfo.@xOffset = colorRect.x;
                sequenceInfo.@yOffset = colorRect.y;
                sequenceInfo.@width = colorRect.width;
                sequenceInfo.@height = colorRect.height;
                textureInfo.appendChild(sequenceInfo);
            }
            var textureInfoStr:String = encodeURI(textureInfo.toXMLString());
            
            var tDatas:ByteArray = new ByteArray();
            tDatas.writeInt(textureInfoStr.length);
            tDatas.writeUTFBytes(textureInfoStr);
            
            return tDatas;
        }
        
        private function onResize(e:Event = null):void
        {
            menubar.height = 30;
            menubar.width = width;
            _textureViewer.setSize(width,height-30);
        }
    }
}