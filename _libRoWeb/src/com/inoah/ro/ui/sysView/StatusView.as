package com.inoah.ro.ui.sysView
{
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.infos.UserInfo;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.sysViews.statusViewUI;
    
    public class StatusView extends statusViewUI
    {
        public function StatusView()
        {
            super();
            
            updateInfo();
            
            this.btnClose.addEventListener( MouseEvent.CLICK, onCloseHandler );
            this.btnStr.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnAgi.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnVit.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnInt.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnDex.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnLuk.addEventListener( MouseEvent.CLICK, onAddPointHandler );
        }
        
        protected function onAddPointHandler( e:MouseEvent):void
        {
            var userInfo:UserInfo = RoGlobal.userInfo;
            switch( e.currentTarget )
            {
                case btnStr:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.strength += 1;
                    break;
                }
                case btnAgi:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.agile += 1;
                    break;
                }
                case btnVit:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.vit += 1;
                    break;
                }
                case btnInt:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.intelligence += 1;
                    break;
                }
                case btnDex:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.dexterous += 1;
                    break;
                }
                case btnLuk:
                {
                    userInfo.statusPoint -= 1;
                    userInfo.lucky += 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            Facade.getInstance().sendNotification( GameCommands.UPDATE_STATUS_POINT );
        }
        
        private function updateInfo():void
        {
            var userInfo:UserInfo = RoGlobal.userInfo;
            
            this.labStr.text = userInfo.strength + "";
            this.labAgi.text = userInfo.agile + "";
            this.labVit.text = userInfo.vit + "";
            this.labInt.text = userInfo.intelligence + "";
            this.labDex.text = userInfo.dexterous + "";
            this.labLuk.text = userInfo.lucky + "";
            this.labAtk.text = userInfo.atk + "";
            this.labMAtk.text = userInfo.matk + "";
            this.labHit.text = userInfo.hit + "";
            this.labCritical.text = userInfo.critical + "";
            this.labDef.text = userInfo.def + "";
            this.labMDef.text = userInfo.mdef + "";
            this.labFlee.text = userInfo.flee + "";
            this.labAspd.text = userInfo.aspd + "";
            this.labStatusPoint.text = userInfo.statusPoint + "";
            
            var bool:Boolean = userInfo.statusPoint > 0;
            this.btnStr.visible = bool;
            this.btnAgi.visible = bool;
            this.btnVit.visible = bool;
            this.btnInt.visible = bool;
            this.btnDex.visible = bool;
            this.btnLuk.visible = bool;
            
            this.labUpStr.visible = false;
            this.labUpAgi.visible = false;
            this.labUpVit.visible = false;
            this.labUpInt.visible = false;
            this.labUpDex.visible = false;
            this.labUpLuk.visible = false;
        }
        
        protected function onCloseHandler( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.CLOSE_STATUS );
        }
        
        public function refresh():void
        {
            updateInfo();
        }
    }
}