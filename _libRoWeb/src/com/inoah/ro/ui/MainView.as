package com.inoah.ro.ui
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.infos.UserInfo;
    import com.inoah.ro.utils.UserData;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.mainViewUI;
    
    public class MainView extends mainViewUI
    {
        public function MainView()
        {
            super();
            
            updateBaseInfo();
            
            this.btnStatus.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnSkill.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnItem.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnMap.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnTask.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnOption.addEventListener( MouseEvent.CLICK , onOpenHandler );
        }
        
        private function updateBaseInfo():void
        {
            var userInfo:UserInfo = (Global.userdata as UserData).userInfo;
            labName.text = userInfo.name;
            labJob.text = userInfo.job;
            hpBar.value = userInfo.hpPer;
            hpBar.barLabel.text = userInfo.hpCurrent + " / " + userInfo.hpMax;
            labHpPer.text = userInfo.hpPer * 100 + "%";
            spBar.value = userInfo.spPer;
            spBar.barLabel.text = userInfo.spCurrent + " / " + userInfo.spMax;
            labSpPer.text = userInfo.spPer * 100 + "%";
            labLv.text = "Base Lv." + userInfo.baseLv;
            baseExpBar.value = userInfo.baseExp / Math.pow( userInfo.baseLv + 1 , 3 );
            labJobLv.text = "Job Lv." + userInfo.jobLv;
            jobExpBar.value = userInfo.jobExp / Math.pow( userInfo.jobLv + 1 , 3 );
            labWeightZeny.text = "Weight: " + userInfo.weightCurrent + " / " + userInfo.weightMax + " Zeny: " + userInfo.zeny;
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