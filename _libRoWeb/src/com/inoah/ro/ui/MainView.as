package com.inoah.ro.ui
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.ui.mainViewChildren.ChatView;
    import com.inoah.ro.ui.mainViewChildren.SkillBarView;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.mainViewUI;
    
    public class MainView extends mainViewUI
    {
        private var _skillBarView:SkillBarView;
        private var _chatView:ChatView;
        
        public function MainView()
        {
            super();
            _skillBarView = new SkillBarView( skillBarView );
            _chatView = new ChatView( chatView );
            
            this.btnStatus.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnSkill.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnItem.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnMap.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnTask.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnOption.addEventListener( MouseEvent.CLICK , onOpenHandler );
        }
        
        protected function onOpenHandler( e:MouseEvent):void
        {
            switch( e.currentTarget )
            {
                case btnStatus:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_STATUS );
                    break;
                }
                case btnSkill:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_SKILL );
                    break;
                }
                case btnItem:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_ITEM);
                    break;
                }
                case btnMap:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_MAP );
                    break;
                }
                case btnTask:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_TASK );
                    break;
                }
                case btnOption:
                {
                    Facade.getInstance().sendNotification( GameCommands.OPEN_OPTION );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
    }
}