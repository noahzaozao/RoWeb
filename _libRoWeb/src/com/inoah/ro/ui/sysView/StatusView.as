package com.inoah.ro.ui.sysView
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.infos.UserInfo;
    import com.inoah.ro.utils.UserData;
    
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
        }
        
        private function updateInfo():void
        {
            var userInfo:UserInfo = (Global.userdata as UserData).userInfo;
            
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
    }
}