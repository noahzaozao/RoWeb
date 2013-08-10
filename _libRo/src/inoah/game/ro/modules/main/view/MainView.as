package inoah.game.ro.modules.main.view
{
    import flash.events.MouseEvent;
    
    import game.ui.mainViewUI;
    
    import inoah.core.Global;
    import inoah.core.infos.UserInfo;
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.ro.ui.mainViewChildren.MapView;
    
    import interfaces.ILoader;
    
    public class MainView extends mainViewUI
    {
        
        public var mainMapView:MapView;
        
        public function MainView()
        {
            super();
            
            this.btnStatus.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnSkill.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnItem.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnMap.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnTask.addEventListener( MouseEvent.CLICK , onOpenHandler );
            this.btnOption.addEventListener( MouseEvent.CLICK , onOpenHandler );
        }
        
        public function initializeMap( loader:ILoader ):void
        {
            mainMapView = new MapView( mapView , loader );
            mapView.setPosition( Global.SCREEN_W - mapView.width , 0 );
        }
        
        public function updateHp( userModel:UserModel ):void
        {
            var userInfo:UserInfo = userModel.info;
            hpBar.value = userInfo.hpPer;
            hpBar.barLabel.text = userInfo.hpCurrent + " / " + userInfo.hpMax;
            labHpPer.text = uint(userInfo.hpPer * 100) + "%";
        }
        public function updateSp( userModel:UserModel ):void
        {
            var userInfo:UserInfo = userModel.info;
            spBar.value = userInfo.spPer;
            spBar.barLabel.text = userInfo.spCurrent + " / " + userInfo.spMax;
            labSpPer.text = uint(userInfo.spPer * 100) + "%";
        }
        public function updateExp( userModel:UserModel ):void
        {
            var userInfo:UserInfo = userModel.info;
            baseExpBar.value = userInfo.baseExp / Math.pow( userInfo.baseLv + 1 , 3 );
            jobExpBar.value = userInfo.jobExp / Math.pow( userInfo.jobLv + 1 , 3 );
        }
        public function updateLv( userModel:UserModel ):void
        {
            updateInfo( userModel );
        }
        public function updateStatusPoint( userModel:UserModel ):void
        {
            updateInfo( userModel );
        }
        
        public function updateInfo( userModel:UserModel ):void
        {
            var userInfo:UserInfo = userModel.info;
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
            mainMapView.update();   
        }
        
        protected function onOpenHandler( e:MouseEvent):void
        {
            switch( e.currentTarget )
            {
                case btnStatus:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_STATUS ) );
                    break;
                }
                case btnSkill:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_SKILL ) );
                    break;
                }
                case btnItem:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_ITEM ) );
                    break;
                }
                case btnMap:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_MAP ) );
                    break;
                }
                case btnTask:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_TASK ) );
                    break;
                }
                case btnOption:
                {
                    dispatchEvent( new GameEvent( GameEvent.OPEN_OPTION ) );
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




