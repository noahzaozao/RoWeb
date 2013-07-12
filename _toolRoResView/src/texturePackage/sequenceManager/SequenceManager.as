package texturePackage.sequenceManager 
{
    import com.bit101.components.List;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.FileListEvent;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.net.FileFilter;
    
    import format.Sequence;
    import format.TexturePackageProjectFile;
    
    public class SequenceManager extends Panel
    {
        public static const SEQUENCE_LIST_UPDATE:String = "sequenceListUpdate";
        
        private const _fileFilters:Array = [ new FileFilter("PNG序列或者无代码的SWF动画", "*.png;*.swf")];
        
        private var _addPNGSequenceButton:PushButton;

        private var _removePNGSequenceButton:PushButton;

        private var _sequenceListView:List;
        
        private var _sequenceIdList:Vector.<String>;
        
        private var _sequenceList:Vector.<Sequence>;

        private var _currentAddCount:int;

        private var _currentInitCount:int;

        private var _currentProject:TexturePackageProjectFile;
        
        public function SequenceManager(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            
            shadow = false;
            
            _addPNGSequenceButton = new PushButton(this,5,5, "添加PNG帧序列");
            _addPNGSequenceButton.addEventListener(MouseEvent.CLICK, onAddFiles);
            
            _sequenceListView = new List(this);
            _sequenceListView.listItemClass = SequenceListItem;
            _sequenceListView.listItemHeight = 50;
            _sequenceListView.autoHideScrollBar = true;
            _sequenceListView.addEventListener(SequenceListItem.SEQUENCE_REMOVE, onSequenceRemove);
            
            if(stage)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
        }
        
        protected function initialize(event:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initialize);
            stage.addEventListener(Event.RESIZE, onResize);
            onResize();
        }
        
        protected function onSequenceRemove(e:Event):void
        {
            var sequence:Sequence = (e.target as SequenceListItem).sequence;
            _sequenceListView.removeItem(sequence);
            _currentProject.removeSequence(sequence.sequenceName);
            updateList();
        }
        
        protected function onAddFiles(event:MouseEvent):void
        {
            if(fileBrowser != null)
            {
                fileBrowser.removeEventListener(Event.SELECT, onFileBrowserHandle);
                fileBrowser.removeEventListener(Event.OPEN, onFileBrowserHandle);
                fileBrowser.removeEventListener(Event.COMPLETE, onFileBrowserHandle);
                fileBrowser = null;
            }
            
            var fileBrowser:File = new File();
            fileBrowser.addEventListener(FileListEvent.SELECT_MULTIPLE, onFileBrowserHandle);
            fileBrowser.browseForOpenMultiple("Select File to add:", _fileFilters);
        }
        
        protected function onFileBrowserHandle(event:FileListEvent):void
        {
            event.currentTarget.removeEventListener(FileListEvent.SELECT_MULTIPLE, onFileBrowserHandle);
            
            var filesQueue:Vector.<File> = Vector.<File>(event.files);
            var len:int = filesQueue.length;
            var index:int;
            var fileName:String;
            var filePath:String;
            var sequence:SequenceFiles;
            
            _currentAddCount = 0;
            _currentInitCount = 0;
            
            for(var i:int = 0; i<len; i++)
            {
                filePath = filesQueue[i].nativePath
                fileName = getFileName(filePath);
                
                _currentAddCount ++;
                sequence = new SequenceFiles(fileName);
                sequence.open(new File(filePath), null);
                sequence.addEventListener(SequenceFiles.IMAGE_INITIALIZE, onSequenceImageReady);
                sequence.initialize();
            }
            
            checkIsBusy();
            
        }
        
        protected function onSequenceImageReady(event:Event):void
        {
            var sequenceLoader:SequenceFiles = event.currentTarget as SequenceFiles;
            sequenceLoader.removeEventListener(SequenceFiles.IMAGE_INITIALIZE, onSequenceImageReady);
            
            var sequence:Sequence = new Sequence(sequenceLoader.bitmapData, sequenceLoader.realRect, sequenceLoader.colorRect, sequenceLoader.fileName);
            sequenceLoader.dispose();
            
            _sequenceListView.removeItem(_currentProject.getSequenceBySequenceName(sequence.sequenceName));
            _sequenceListView.addItem(sequence);
            _currentInitCount ++;
            _currentProject.addSequenceFile(sequence);
            checkIsBusy();
        }
        
        protected function checkIsBusy():void
        {
            if(_currentAddCount == _currentInitCount)
            {
                updateList();
            }
        }
        
        protected function getFileName(filePath:String):String
        {
            var fileNameArr:Array = filePath.split("\\");
            return fileNameArr[fileNameArr.length-1]
        }
        
        protected function onResize(event:Event = null):void
        {
            _sequenceListView.x = 5;
            _sequenceListView.y = 30;
            _sequenceListView.setSize(width-10, height-35);
            
        }
        
        protected function updateList():void
        {
            _sequenceListView.items.sortOn("sequenceName", Array.UNIQUESORT);
            _sequenceListView.draw();
            
        }
        
        public function setProject(currentProject:TexturePackageProjectFile):void
        {
            _sequenceListView.removeAll();
            _currentProject = currentProject;
            if(currentProject == null)
            {
                return;
            }
            
            var list:Vector.<Sequence> = currentProject.sequenceList;
            
            var len:int = list.length;
            for(var i:int = 0; i<len; i++)
            {
                _sequenceListView.addItem(list[i]);
            }
            
            updateList();
            
        }
    }
}