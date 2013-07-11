package com.inoah.ro.ui
{
    import com.D5Power.D5Game;
    import com.D5Power.BitmapUI.D5IVfaceButton;
    import com.D5Power.BitmapUI.D5TLFText;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.net.D5StepLoader;
    import com.inoah.ro.RoGame;
    import com.inoah.ro.scenes.MainScene;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class NPCDialog extends Sprite
    {
        private var npcTitle:D5TLFText;
        private var npcSay:D5TLFText;
        private var npcHead:Sprite;
        private var npc:Array = ['','village head'];
        private var fontController:ESayBox;
        private var boxWidth:uint = 400;
        private var boxHeight:uint = 200;
        
        private var _say:String;
        private var _misid:uint;
        private var _type:uint;
        private var _complate:Boolean;
        private var _npc:NCharacterObject;
        
        private var btn1:D5IVfaceButton;
        private var btn2:D5IVfaceButton;
        
        public function NPCDialog()
        {
            super();
            buildUI();
        }
        
        public function config(say:String,nco:NCharacterObject,misid:uint,type:uint,complate:Boolean):void
        {
            visible = false;
            if(npcHead.numChildren) npcHead.removeChildren(0,npcHead.numChildren-1);
            D5StepLoader.me.addLoad('asset/mapRes/npc_face/'+nco.uid+'.swf',showNpcFace,false,D5StepLoader.TYPE_SWF);
            
            _say = say;
            _misid = misid;
            _type = type;
            _complate = complate;
            _npc = nco;
            
            if(btn2)
            {
                btn2.lable=_type==0 ? 'accept' : 'ok';
                if(_type==1 && !complate) btn2.enabled=false;
                btn2.visible=misid>0 ? true : false;
            }
            
            npcTitle.text = npc[nco.uid];
        }
        
        private function showNpcFace(data:DisplayObject):void
        {
            npcHead.addChild(data);
            
            npcTitle.x = npcHead.x+npcHead.width+10;
            
            npcSay.x = npcTitle.x;
            
            npcSay.width = boxWidth-npcHead.width-10;
            npcTitle.width = npcSay.width;
            
            if(stage)
            {
                x = (stage.stageWidth - boxWidth) >> 1;
                y = (stage.stageHeight - boxHeight) >>1 ;
                stage.addEventListener(MouseEvent.CLICK,onClear);
            }
            
            _say = _say.replace(/{/g,'<');
            _say = _say.replace(/}/g,'>');
            
            fontController.play(_say , 10);
            
            visible = true;
        }
        
        private function onClear(e:MouseEvent):void
        {
            if(parent && !hitTestPoint(e.stageX,e.stageY,true))
            {
                stage.removeEventListener(MouseEvent.CLICK,onClear);
                if(parent) parent.removeChild(this);
                fontController.clear();
            }
        }
        
        private function buildUI():void
        {
            graphics.beginFill(0,.8);
            graphics.lineStyle(1,0);
            graphics.drawRect(0,0,boxWidth,boxHeight);
            
            npcHead = new Sprite();
            npcHead.y -= 20;
            npcHead.x -= 20;
            npcHead.mouseEnabled=false;
            npcHead.mouseChildren=false;
            
            npcTitle = new D5TLFText('',0x00ff00);
            npcTitle.fontBorder=0;
            npcTitle.fontSize = 14;
            npcTitle.height = 25;
            npcTitle.x = 100;
            npcTitle.y = 10;
            
            
            npcSay = new D5TLFText('',0xbdbdbd);
            npcSay.fontBorder = 0;
            npcSay.multiline=true;
            npcSay.height = 90;
            npcSay.x = npcTitle.x;
            npcSay.y = npcTitle.y+npcTitle.height+10;
            
            fontController = new ESayBox();
            fontController.contenter = npcSay;
            
            
            
            
            addChild(npcHead);
            addChild(npcTitle);
            addChild(npcSay);
            
            
            D5StepLoader.me.addLoad('asset/ui/demoButton.png',buildBtn,true);
        }
        
        private function buildBtn(data:Bitmap):void
        {
            var res:Vector.<BitmapData> = D5IVfaceButton.makeResource(data.bitmapData);
            var btnBox:Sprite = new Sprite();
            
            btn1 = new D5IVfaceButton(res,onClick);
            btn1.lable='accept';
            btn1.id = 1;
            btn1.setLableBorder(0);
            
            btn2 = new D5IVfaceButton(res,onClick);
            btn2.lable='ok';
            btn2.id= 2;
            btn2.setLableBorder(0);
            
            btn1.x = btn2.width+10;
            
            btnBox.addChild(btn1);
            btnBox.addChild(btn2);
            
            btnBox.x = boxWidth-btnBox.width-10;
            btnBox.y = boxHeight-btnBox.height-10;
            
            if(_misid>0)
            {
                btn2.lable=_type==0 ? 'accept' : 'ok';
                if(_type==1 && !_complate) btn2.enabled=false;
            }else{
                btn2.visible=false;
            }
            
            addChild(btnBox);
        }
        
        private function onClick(id:uint):void
        {
            if(id==2)
            {
                _npc.missionConfig.complateMission(_misid,Global.userdata);
                if(_misid==3)
                {
                    // 3号任务生成怪物
                    (D5Game.me.scene as MainScene).createMonser(D5Game.me.scene.Player.PosX+300,D5Game.me.scene.Player.PosY);
                }
                
                if(_misid==6)
                {
//                    (D5Game.me as RoGame).openRob();
                }
            }
            
            stage.removeEventListener(MouseEvent.CLICK,onClear);
            if(parent) parent.removeChild(this);
            fontController.clear();
        }
    }
}