package inoah.game.ro.ui
{
    import flash.events.MouseEvent;
    
    import game.ui.mainViewUI;
    
    import inoah.core.Global;
    import inoah.core.consts.commands.GameCommands;
    import inoah.core.infos.UserInfo;
    import inoah.game.ro.ui.mainViewChildren.MapView;
    
    import pureMVC.patterns.facade.Facade;
    
    public class MainView extends mainViewUI
    {
        private var _mapView:MapView;
        
        public function MainView()
        {
            super();
            
            _mapView = new MapView( mapView );
            
            updateInfo();
            
            this.btnStatus.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnSkill.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnItem.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnMap.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnTask.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnOption.addEventListener( MouseEvent.CLICK , onOpenHandler );
        }
        
        public function updateHp():void
        {
            var userInfo:UserInfo = Global.userInfo;
            hpBar.value = userInfo.hpPer;
            hpBar.barLabel.text = userInfo.hpCurrent + " / " + userInfo.hpMax;
            labHpPer.text = uint(userInfo.hpPer * 100) + "%";
        }
        public function updateSp():void
        {
            var userInfo:UserInfo = Global.userInfo;
            spBar.value = userInfo.spPer;
            spBar.barLabel.text = userInfo.spCurrent + " / " + userInfo.spMax;
            labSpPer.text = uint(userInfo.spPer * 100) + "%";
        }
        public function updateExp():void
        {
            var userInfo:UserInfo = Global.userInfo;
            baseExpBar.value = userInfo.baseExp / Math.pow( userInfo.baseLv + 1 , 3 );
            jobExpBar.value = userInfo.jobExp / Math.pow( userInfo.jobLv + 1 , 3 );
        }
        public function updateLv():void
        {
            updateInfo();
        }
        public function updateStatusPoint():void
        {
            updateInfo();
        }
        private function updateInfo():void
        {
            var userInfo:UserInfo = Global.userInfo;
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
        public function updateMapView():void
        {
            _mapView.update();   
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