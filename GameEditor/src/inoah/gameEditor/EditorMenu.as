package inoah.gameEditor
{
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import inoah.gameEditor.consts.GameConsts;
    
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    
    public class EditorMenu extends NativeMenu implements IMediator
    {
        [Inject]
        public var eventMap:IEventMap;
        
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        private var _viewComponent:Object;
        
        public function set viewComponent(view:Object):void
        {
            _viewComponent = view;
        }
        
        private static var MENU_ITEM:Vector.<String>;
        private static var SUBMENU_ITEM:Vector.<Vector.<String>>;
        private static var SUBMENU_ITEM_NAME:Vector.<Vector.<String>>;
        
        public function EditorMenu()
        {
            super();
            
            MENU_ITEM = new Vector.<String>();
            SUBMENU_ITEM = new Vector.<Vector.<String>>();
            SUBMENU_ITEM_NAME = new Vector.<Vector.<String>>();
            
            configMenu( "文件" , "新建工程" , "newProject" );
            configMenu( "文件" , "打开工程" , "openProject" );
            configMenu( "文件" , "关闭工程" , "closeProject" );
            configMenu( "文件" , "保存工程" , "saveProject" );
            configMenu( "编辑" , "撤销" , "revert" );
            configMenu( "编辑" , "剪切" , "cut" );
            configMenu( "编辑" , "复制" , "copy" );
            configMenu( "编辑" , "粘贴" , "prase" );
            configMenu( "编辑" , "删除" , "delete" );
            configMenu( "地图预览" , "" , GameConsts.MAP_VIEWER );
            configMenu( "角色" , "" , GameConsts.CHARACTER_EDITOR );
            configMenu( "职业" , "" , GameConsts.JOB_EDITOR );
            configMenu( "技能" , "" , "skillEditor" );
            configMenu( "物品" , "" , "itemEditor" );
            configMenu( "武器" , "" , "weaponEditor" );
            configMenu( "防具" , "" , "equipEditor" );
            configMenu( "怪物" , "" , "monsterEditor" );
            configMenu( "怪组" , "" , "monsterGroupEditor" );
            configMenu( "状态" , "" , "statusEditor" );
            configMenu( "系统" , "" , "systemEditor" );
            configMenu( "关于" , "" , "about" );
            
            var rootMenu:NativeMenu;
            var menuItem:NativeMenuItem;
            var isRootMenu:Boolean;
            for( var i:int = 0;i < MENU_ITEM.length;i++ )
            {
                isRootMenu = false;
                rootMenu = new NativeMenu();
                for( var j:int = 0;j<SUBMENU_ITEM[i].length;j++)
                {
                    menuItem = new NativeMenuItem( SUBMENU_ITEM[i][j] );
                    menuItem.name = SUBMENU_ITEM_NAME[i][j];
                    if( SUBMENU_ITEM[i][j] == "" )
                    {
                        menuItem.label = MENU_ITEM[i];
                        addItem( menuItem );
                    }
                    else
                    {
                        isRootMenu = true;
                        rootMenu.addItem( menuItem );
                    }
                }
                if( isRootMenu )
                {
                    addSubmenu( rootMenu, MENU_ITEM[i] );
                }
            }
            
            addEventListener(Event.SELECT, selectHandler);
        }
        
        protected function selectHandler(e:Event):void
        {
            dispatch( new EditorEvent( EditorEvent.OPEN_EDITOR , e.target.name ) );
        }
        
        private function configMenu( menuName:String , menuItemStr:String, menuItemNameStr:String):void
        {
            var index:int = MENU_ITEM.indexOf( menuName );
            if( index == -1 )
            {
                MENU_ITEM.push( menuName );
                index = MENU_ITEM.indexOf( menuName );
            }
            var subMenu:Vector.<String>;
            if( index < SUBMENU_ITEM.length )
            {
                subMenu = SUBMENU_ITEM[index];
            }
            if( subMenu == null )
            {
                subMenu = SUBMENU_ITEM[index] = new Vector.<String>();
            }
            subMenu.push( menuItemStr );
            
            subMenu = null;
            if( index < SUBMENU_ITEM_NAME.length )
            {
                subMenu = SUBMENU_ITEM_NAME[index];
            }
            if( subMenu == null )
            {
                subMenu = SUBMENU_ITEM_NAME[index] = new Vector.<String>();
            }
            subMenu.push( menuItemNameStr );
        }
        
        public function initialize():void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function destroy():void
        {
        }
        
        /**
         * Runs after the mediator has been destroyed.
         * Cleans up listeners mapped through the local EventMap.
         */
        public function postDestroy():void
        {
            eventMap.unmapListeners();
        }
        
        /*============================================================================*/
        /* Protected Functions                                                        */
        /*============================================================================*/
        
        protected function addViewListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.mapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
        }
        
        protected function addContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
        }
        
        protected function removeViewListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.unmapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
        }
        
        protected function removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
        }
        
        protected function dispatch(event:Event):void
        {
            if (eventDispatcher.hasEventListener(event.type))
                eventDispatcher.dispatchEvent(event);
        }
    }
}