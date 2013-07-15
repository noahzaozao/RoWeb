package com.inoah.ro 
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.Stuff.HSpbar;
    import com.D5Power.mission.EventData;
    import com.inoah.ro.characters.CharacterView;
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.controllers.PlayerController;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.objects.PlayerObject;
    import com.inoah.ro.scenes.MainScene;
    import com.inoah.ro.ui.NPCDialog;
    import com.inoah.ro.uis.TopText;
    
    import flash.display.Shape;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
    
    public class RoGame extends D5Game
    {
        public static var inited:Boolean
        public static var game:RoGame;
        private var _playerView:PlayerView;
        private var _player:CharacterObject;
        private var _skillBar:SkillBarUI;
        private var _skillBarItemList:Vector.<SkillBarItemUI>;
        private var _isColdDown:Boolean;
        private var _skillMask:Shape;
        private var _cdX:Number;
        private var _cdY:Number;
        private var _cdArea:int;
        private var _coldDownTime:Number;
        private var _coldDownStep:Number;
        
        private var _windowBgMc:WindowBgUI;
        private var _closeBtn:CloseBtnUI;
        private var _msgTxt:TextField;
        private var _npcDialogBox:NPCDialog;
        
        public function RoGame(config:String, stg:Stage, openGPU:uint=0)
        {
            super(config, stg, openGPU);
            game = this;
        }
        
        override protected function buildScene():void
        {
            _scene = new MainScene(_stg,this);
        }
        
        override protected function init(e:Event=null):void
        {
            super.init();
            
            _windowBgMc = new WindowBgUI();
            _windowBgMc.x = 560 >> 1;
            _windowBgMc.y = 260 >> 1;
            _windowBgMc.scale9Grid = new Rectangle( 19, 19, 64, 63 );
            _windowBgMc.width = 400;
            _windowBgMc.height = 300;
            
            _closeBtn = new CloseBtnUI();
            _closeBtn.x = 660;
            _closeBtn.y = 145;
            
            _msgTxt = new TextField();
            var tf:TextFormat = new TextFormat( "Arial" , 18 , 0xffffff );
            _msgTxt.defaultTextFormat = tf;
            _msgTxt.text = "\nWelcome to the world of RoWeb!\nWe're now at version demo 0.0.3-1\nEmail: 234082230@qq.com\n";
            _msgTxt.x = (560 >> 1) + 20;
            _msgTxt.y = (260 >> 1) + 20;
            _msgTxt.width = 400;
            _msgTxt.height = 300;
            _msgTxt.mouseEnabled = false;
            _closeBtn.addEventListener( MouseEvent.CLICK, function ( e:MouseEvent):void
            {
                e.currentTarget.removeEventListener( MouseEvent.CLICK, arguments.callee );
                _stg.removeChild( _windowBgMc );
                _stg.removeChild( _closeBtn );
                _stg.removeChild(_msgTxt);
//                var nObj:NCharacterObject =  new NCharacterObject( new NCharacterControler( scene.perc ));
//                nObj.uid = 1;
//                npcWindow( "hey, guys, welcome to my village!" , new EventData(), nObj, 0 );
            });
            
            _skillBar = new SkillBarUI();
            _skillBar.x = 960 - _skillBar.width;
            _skillBar.y = 560 - _skillBar.height;
            _skillBarItemList = new Vector.<SkillBarItemUI>();
            var item:SkillBarItemUI;
            for( var i:int=0;i<8;i++)
            {
                item = new SkillBarItemUI();
                item.x = 20 + i * 38;
                item.y = 20;
                item.txt.text = (i + 1).toString();
                item.txt.mouseEnabled = false;
                item.txtColdDown.mouseEnabled = false;
                item.txtColdDown.visible = false; 
                _skillBarItemList[i] = item;
                _skillBar.addChild( item );
            }
            
            var skillIconInfo:CharacterInfo = new CharacterInfo();
            skillIconInfo.init( "", "data/sprite/酒捞袍/lk_aurablade.act", "" );
            var skillIconView:CharacterView = new CharacterView( skillIconInfo );
            skillIconView.width = 32;
            skillIconView.height = 32;
            _skillBarItemList[0].addChildAt( skillIconView , 1 );
            
            _skillMask = new Shape();
            _skillMask.alpha = 0.7;
            _skillMask.x = -16;
            _skillMask.y = -16;
            _skillBarItemList[0].addChildAt( _skillMask , 2 );
            
            _stg.addEventListener( KeyboardEvent.KEY_DOWN , onSkill );
            
            var charInfo:CharacterInfo = new CharacterInfo();
            charInfo.init( "data/sprite/牢埃练/赣府烹/巢/2_巢.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act", true );
            charInfo.setWeaponRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八.act" );
            charInfo.setWeaponShadowRes( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八_八堡.act" );
            
            //            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_咯.act" );
            _playerView = new PlayerView( charInfo );
            _playerView.x = 400;
            _playerView.y = 400;
            
            _player = new PlayerObject(null);
            _player.changeController( new PlayerController( _scene.perc , CharacterControler.MOUSE ));
            _player.ID=1;
            _player.displayer = _playerView;
            _player.setPos(500,500);
            _player.speed = 4.5;
            _player.setName("player",-1,0,-110);
            _player.action = Actions.Wait;
            
            _player.hp = 150;
            _player.hpMax = 150;
            _player.hpBar = new HSpbar( _player,'hp','hpMax',10 , 0x33ff33 );
            _player.sp = 50;
            _player.spMax = 50;
            _player.spBar = new HSpbar(_player,'sp','spMax',14 , 0x2868FF);
            
            _scene.createPlayer(_player);
            _camera.focus(_player);
            
            //            _scene.container.addChild( _playerView );
            
            for( i = 0;i< 50; i++ )
            {
                (_scene as MainScene).createMonser( 1200 * Math.random() + 100, 1200 * Math.random() + 100 );
            }
            
            addChild( _skillBar );
            
            _stg.addChild( _windowBgMc );
            _stg.addChild( _closeBtn );
            _stg.addChild( _msgTxt );
        }
        
        protected function onSkill( e:KeyboardEvent):void
        {
            if( e.keyCode == Keyboard.NUMBER_1 )
            {
                if( !_isColdDown )
                {
                    _coldDownTime = 2.0;
                    _coldDownStep = 128 / _coldDownTime;
                    _cdArea = 0;
                    _cdX = 16;
                    _cdY = 0;
                    _skillBarItemList[0].txtColdDown.visible = true;
                    _isColdDown = true;
                }
                else
                {
                    TopText.show( "skill cold down" );
                }
            }
        }
        
        public function tick( delta:Number ):void
        {
            if( _isColdDown )
            {
                _coldDownTime -= delta;
                _skillBarItemList[0].txtColdDown.text = _coldDownTime.toFixed( 1 );
                
                _skillMask.graphics.clear();
                _skillMask.graphics.beginFill( 0x0 );
                _skillMask.graphics.moveTo( 0, 0 );
                _skillMask.graphics.lineTo( 16,0 );
                _skillMask.graphics.lineTo( 16,16 );
                _skillMask.graphics.lineTo( _cdX,_cdY );
                if( _cdArea == 0 )
                {
                    _cdX += _coldDownStep * delta;
                    if( _cdX >= 32 )
                    {
                        _cdX = 32;
                        _cdArea ++;
                    }
                }
                else if( _cdArea == 1 )
                {
                    _cdY += _coldDownStep * delta;
                    if( _cdY >= 32 )
                    {
                        _cdY = 32;
                        _cdArea ++;
                    }
                }
                else if( _cdArea == 2 )
                {
                    _cdX -= _coldDownStep * delta;
                    if( _cdX <= 0 )
                    {
                        _cdX = 0;
                        _cdArea ++;
                    }
                }
                else if( _cdArea == 3 )
                {
                    _cdY -= _coldDownStep * delta;
                    if( _cdY <= 0 )
                    {
                        _cdY = 0;
                        _cdArea ++;
                    }
                }
                else if( _cdArea == 4 )
                {
                    _cdX += _coldDownStep * delta;
                    if( _cdX >= 16 )
                    {
                        _cdX = 16;
                    }
                }
                
                if( _cdArea < 1 )
                {
                    _skillMask.graphics.lineTo( 32,0 );
                }
                if( _cdArea < 2 )
                {
                    _skillMask.graphics.lineTo( 32,32 );
                }
                if( _cdArea < 3 )
                {
                    _skillMask.graphics.lineTo( 0,32 );
                }
                if( _cdArea < 4 )
                {
                    _skillMask.graphics.lineTo( 0,0 );
                }

                if( _coldDownTime <= 0 )
                {
                    _isColdDown = false;
                    _skillMask.graphics.clear();
                    _skillBarItemList[0].txtColdDown.visible = false;
                }
            }
            if( _playerView )
            {
                _playerView.x = _player.x;
                _playerView.y = _player.y;
                _playerView.tick( delta );
                (_player.controler as PlayerController).tick( delta );
            }
            if( _scene )
            {
                (_scene as MainScene).tick( delta );
            }
        }
        
        public function npcWindow(say:String,event:EventData,npc:NCharacterObject,misid:uint,type:uint=0,complate:Boolean=false):void
        {
            if(_npcDialogBox==null)
            {
                _npcDialogBox = new NPCDialog();
            }
            
            _npcDialogBox.config(say,npc,misid,type,complate);
            if(!contains(_npcDialogBox))
            {
                _stg.addChild(_npcDialogBox);
            }
        }
    }
}