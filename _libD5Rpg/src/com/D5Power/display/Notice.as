package com.D5Power.display
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    
    /**
     * 公告类效果
     */ 
    public class Notice extends Sprite
    {
        protected var delete_fun:Function;
        internal var _stayTime:int;
        
        public static var STARTY:uint = 100;
        
        private static var noticeMap:Array = [0,0,0,0,0,0];
        private static var autoShift:uint = 0;
        
        /**
         * @param	content	公告内容
         * @param	config	样式配置器，可包含以下属性：color 字体颜色 borderColor 描边颜色 size 字体颜色
         */ 
        public function Notice(stg:Stage,content:String,dfun:Function=null,config:Object=null)
        {
            super();
            delete_fun = dfun;
            _stayTime=120;
            buildBuffer(content,config);
            
            // 开始自动寻找位置
            var fond:Boolean=false;
            for(var i:uint = 0,j:int=noticeMap.length;i<j;i++)
            {
                if(noticeMap[i]==0)
                {
                    noticeMap[i] = this;
                    x = (stg.stageWidth - width)*.5;
                    y = STARTY+i*(height+5);
                    fond = true;
                    break;
                }
            }
            
            if(!fond)
            {
                (noticeMap[autoShift] as Notice)._stayTime = 0;
                noticeMap[autoShift] = this;
                x = (stg.stageWidth - width)*.5;
                y = STARTY+autoShift*(height+5);
                autoShift++;
                if(autoShift>=noticeMap.length) autoShift=0;
            }
            
            stg.addChild(this);
        }
        
        protected function buildBuffer(content:String,config:Object):void
        {
            var color:uint = config==null || config.color==null ? 0xFFFFFF : config.color;
            var padding:uint = 1;
            
            var lable:D5TextField = new D5TextField('',color);
            lable.htmlText = content;
            lable.fontBorder = config==null || config.borderColor==null ? 0x000000 : config.borderColor;
            lable.fontSize = config==null || config.size==null ? 14 : config.size;
            if(config!=null && config.width!=null) lable.maxWidth = config.width;
            lable.x = lable.y = padding;
            lable.autoGrow();
            
            if(config!=null && config.bgcolor!=null)
            {
                graphics.beginFill(config.bgcolor,(config!=null && config.bgalpha!=null ? .6 : config.bgalpha));
                graphics.drawRect(0,0,lable.width+padding*2,lable.height+padding*2);
                graphics.endFill();
            }
            
            addChild(lable);
            
            cacheAsBitmap=true;
            
            addEventListener(Event.ENTER_FRAME,onEnterFrameHander);
            
        }
        
        protected function onEnterFrameHander(e:Event):void
        {
            if(_stayTime<=0)
            {
                if(alpha>0)
                {
                    alpha-=0.05;
                }else{
                    if(delete_fun!=null) delete_fun(this);
                    removeEventListener(Event.ENTER_FRAME,onEnterFrameHander);
                    stage.removeChild(this);
                    var id:int = noticeMap.indexOf(this);
                    if(id!=-1)
                    {
                        noticeMap[id] = 0;
                    }
                    return;
                }
                return;
            }
            _stayTime--;
        }
    }
}