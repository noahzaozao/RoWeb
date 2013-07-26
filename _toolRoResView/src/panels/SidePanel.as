package panels
{
    import com.bit101.components.List;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    
    import consts.AppConsts;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    public class SidePanel extends Panel
    {
        private var fileList:List;
        private var fileDir:File;
        private var fileArray:Array;
        private var _headBtn:PushButton;
        private var _bodyBtn:PushButton;
        private var _weaponBtn:PushButton;
        private var _switchType:uint;
        
        public function SidePanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function init():void
        {
            super.init();
            
            setSize( AppConsts.SIDE_PANEL_WIDTH, AppConsts.HEIGHT );
            
            _switchType = 0;
            _bodyBtn = new PushButton( this, 0, 0, "body" );
            _bodyBtn.setSize( 40, 20 );
            _bodyBtn.toggle = true;
            _bodyBtn.selected = true;
            _bodyBtn.addEventListener( MouseEvent.CLICK, onSwitchHandler );
            _headBtn = new PushButton( this , 40, 0 , "head");
            _headBtn.setSize( 40, 20 );
            _headBtn.toggle = true;
            _headBtn.addEventListener( MouseEvent.CLICK, onSwitchHandler );
            _weaponBtn = new PushButton( this , 80, 0 , "weapon");
            _weaponBtn.setSize( 40, 20 );
            _weaponBtn.toggle = true;
            _weaponBtn.addEventListener( MouseEvent.CLICK, onSwitchHandler );
            
            //列出文件
            fileList = new List( this, 0, 50 );
            fileList.listItemClass = FileListItem;
            fileList.listItemHeight = 20;
            fileList.setSize( _width , _height - 100 );
            fileList.addEventListener( Event.SELECT , onListSelected );
            
            fileDir = new File( AppConsts.filePath + "\\sprite" );
            if( fileDir.isDirectory )
            {
                refreshList( fileDir );
            }
        }
        
        protected function onSwitchHandler(e:MouseEvent):void
        {
            switch( e.currentTarget )
            {
                case _weaponBtn:
                {
                    _switchType = 2;
                    _bodyBtn.selected = false;
                    _headBtn.selected = false;
                    break;
                }
                case _headBtn:
                {
                    _switchType = 1;
                    _bodyBtn.selected = false;
                    _weaponBtn.selected = false;
                    break;
                }
                case _bodyBtn:
                {
                    _switchType = 0;
                    _headBtn.selected = false;
                    _weaponBtn.selected = false;
                    break;
                }
            }
        }
        
        protected function onListSelected(e:Event):void
        {
            var tmpFile:File;
            if( fileList.selectedItem.path == "{return}" )
            {
                var tmpPathStr:String = fileDir.nativePath;
                if( tmpPathStr == AppConsts.filePath + "\\sprite" )
                {
                    return;
                }
                var lastindex:uint = tmpPathStr.lastIndexOf( "\\" );
                tmpPathStr = tmpPathStr.substring( 0 , lastindex );
                tmpFile = new File( tmpPathStr );
                fileDir = tmpFile;
                refreshList( fileDir );
            }
            else
            {
                tmpFile = new File( fileList.selectedItem.path );
                if( tmpFile.isDirectory )
                {
                    fileDir = tmpFile;
                    refreshList( fileDir );
                }
                else
                {
                    dispatchEvent( new DisplayEvent( DisplayEvent.SHOW,  tmpFile.nativePath , _switchType ));
                }
            }
        }
        
        override public function draw():void
        {
            super.draw();
        }
        
        private function refreshList(file:File):void  
        {  
            if(file.isDirectory)  
            {
                var arr:Array=file.getDirectoryListing();
                var path:String;
                var vo:Object;
                fileArray = [];
                fileArray.push( {path:"{return}",label:".."} );
                for each(var f:File in arr)
                {
                    vo = {};
                    if(!f.isDirectory) 
                    {  
                        if( f.extension == "act" )
                        {
                            path=f.nativePath;  
                            vo.path=path; 
                            vo.label=f.name;
                            fileArray.push(vo);  
                        }
                    }
                    else
                    {
                        path=f.nativePath;  
                        vo.path=path;
                        vo.label=f.name;
                        fileArray.push(vo);  
                    }
                }
                
                fileList.items = fileArray;  
                fileList.updateList();
                fileList.draw();
            }  
        }  
    }
}