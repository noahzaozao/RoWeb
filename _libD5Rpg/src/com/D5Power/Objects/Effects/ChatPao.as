package com.D5Power.Objects.Effects
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.display.D5TextField;
    import com.D5Power.scene.BaseScene;
    
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class ChatPao extends EffectObject
    {
        /**
         * 样式控制
         * color,border,background,alpha,size
         */ 
        public static var config:Object = {
            color:0xffffff,
            border:0x000000,
            background:0x000000,
            alpha:.6,
            size:12,
            padding:2
        };
        /**
         * 聊天泡泡生存时间
         */ 
        protected var _lifeTime:uint=5000;
        /**
         * 产生时间
         */ 
        protected var _createTime:uint;
        
        /**
         * 聊天发送人
         */ 
        protected var _target:GameObject;
        
        /**
         * X坐标调整
         */ 
        protected var xChange:int;
        /**
         * Y坐标调整
         */ 
        protected var yChange:int;
        
        /**
         * 聊天泡泡
         * @param	scene	主场景引用
         * @param	target	聊天的发送目标，泡泡将跟随目标
         * @param	context	聊天内容
         */
        public function ChatPao(scene:BaseScene,target:GameObject,context:String)
        {
            super(scene);
            _zOrderF = 999;
            _target = target;
            createBuffer(context);
            
            
        }
        /**
         * 设置聊天泡泡的剩余时间
         */ 
        public function set leftTime(v:uint):void
        {
            _lifeTime = v;
        }
        
        /**
         * 
         */ 
        public function createBuffer(context:String):void
        {
            var textF:D5TextField = new D5TextField('',config.color);
            
            textF.fontBorder = config.border;
            textF.fontSize = config.size;
            textF.text = context;
            textF.autoGrow();
            
            buildBuffer(textF);
            textF=null;
        }
        
        protected function buildBuffer(t:D5TextField):void
        {
            var sp:Sprite = new Sprite();
            sp.graphics.beginFill(config.background,config.alpha);
            sp.graphics.drawRect(0,0,t.width+config.padding*2,t.height+config.padding*2);
            sp.graphics.endFill();
            xChange = -int(sp.width/2);
            yChange = -int(_target.displayer.monitor.height);
            sp.addChild(t);
            t.x = config.padding;
            t.y = config.padding;
            _buffer = new BitmapData(sp.width,sp.height,true,0x00000000);
            _buffer.draw(sp);
            
            _renderBuffer.bitmapData = _buffer;
            _renderBuffer.x = xChange;
            _renderBuffer.y = yChange;
            _target.addChild(_renderBuffer);
            
            sp.removeChild(t);
            sp.graphics.clear();
            sp = null;
            t = null;
            
            Global.GC();
            _createTime = Global.Timer;
            
            if(!hasEventListener(Event.ENTER_FRAME))addEventListener(Event.ENTER_FRAME,renderPao);
        }
        
        private function renderPao(e:Event):void
        {
            if(Global.Timer-_createTime>_lifeTime)
            {
                _target.removeChild(_renderBuffer);
                removeEventListener(Event.ENTER_FRAME,renderPao);
            }
        }
    }
}