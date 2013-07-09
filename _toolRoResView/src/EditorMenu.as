package
{
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    public class EditorMenu extends NativeMenu
    {
        public function EditorMenu()
        {
            super();
            
            var screenMenu:NativeMenu = new NativeMenu();
            var menuItem:NativeMenuItem;
            menuItem = new NativeMenuItem( "选择目录" );
            menuItem.name = "choose";
            screenMenu.addItem( menuItem );
            
            var helpMenu:NativeMenu = new NativeMenu();
            helpMenu.addItem(new NativeMenuItem("关于"));
            
            addSubmenu(screenMenu, "文件");
            addSubmenu(helpMenu, "帮助");
            
            addEventListener(Event.SELECT, selectHandler);
        }
        
        protected function selectHandler(e:Event):void
        {
            switch( e.target.name )
            {
                case "choose":
                {
                    var file:File = new File();
                    file.browseForDirectory( "选择目录" );
                    file.addEventListener(Event.SELECT , onDirectorySelected );
                    break;
                }
            }
        }
        
        protected function onDirectorySelected(e:Event):void
        {
            var pathStr:String = File.applicationStorageDirectory.nativePath;
            var file:File = e.currentTarget as File;
            file.removeEventListener( Event.SELECT, onDirectorySelected );
            var pathFile:File = new File( pathStr + "pathFile.dat"  );
            var fs:FileStream = new FileStream();
            fs.open( pathFile , FileMode.WRITE );
            fs.writeUTF( file.nativePath );
            trace( file.nativePath );
            fs.close();
        }
    }
}