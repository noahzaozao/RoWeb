package com.inoah.ro.ui
{
    import com.D5Power.BitmapUI.D5TLFText;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    /**
     * 逐字显示文本
     * 可能用到的标签 停顿[ms1000] <ms100>间隔</ms>  <#000000>颜色</#> <size12>字体大小</size> <b>加粗</b> 换行<br/>
     */
    public class ESayBox
    {
        /**
         * 默认间隔时间(ms)
         */ 
        public var ndelay:int;
        private var position:int=0; //扫描位置
        private var num1:int;   //存储用
        private var num2:int;   //存储用
        private var str1:String;   //存储用
        private var str2:String;   //存储用
        public var playing:Boolean; //是否在播放
        
        public var content:String; //内容
        public var discontent:String; //自动换行
        public var contenter:D5TLFText;
        
        //public var textfield:TextField;   //目标文本框
        
        public var mytimer:Timer;
        private var timer1:Timer;    //sp1停顿用timer
        
        
        public function ESayBox():void
        {
            
        }
        
        /**
         * 逐字显示文本 
         * @param	cont		需要显示的文本
         * @param	getbreak	间隔时间
         */
        public function play(cont:String = '',getbreak:int = 100):void 
        {
            if (playing != true)
            {
                playing=true;
                content = cont;
                ndelay = getbreak;
                contenter.htmlText="";
                discontent="";
                position=0;
                mytimer=new Timer(ndelay,content.length);
                mytimer.addEventListener(TimerEvent.TIMER,go);
                mytimer.start();
            }
        }
        
        private function go(evt:TimerEvent):void
        {
            discontent += content.substr(position++, 1);
            
            contenter.htmlText = discontent;
            
            while (content.substr(position, 1) == "<" || content.substr(position, 1) == "[")
            {
                checksp1();
                checksp2();
                checksp3();
                checksp4();
                checksp5();
                checksp6();
            }
            
            if (content.substr(position, 3) == "")
            {
                mytimer.removeEventListener(TimerEvent.TIMER,go);
                playing = false;
            }
        }
        
        public function clear():void
        {
            playing = false;
            position = 0;
            if(mytimer!=null) mytimer.stop();
            contenter.htmlText = '';
        }
        
        //=================检测各种标签、状态=================
        
        /**
         * 检测停顿用[ms]标签
         */
        private function checksp1():void
        {
            if (content.substr(position, 3) == "[ms")
            {
                num1=content.indexOf("]",position+3); //标签头结尾位置
                str1=content.substr(position+3,num1-position-3); //获得毫秒数
                position=num1+1;
                mytimer.stop();
                timer1=new Timer(Number(str1),1);
                timer1.addEventListener(TimerEvent.TIMER,mytimerplay);
                timer1.start();
            }
        }
        
        private function go2(e:TimerEvent):void
        {
            trace(1);
        }
        
        /**
         * 检测停顿范围<ms></ms>标签
         */
        private function checksp2():void
        {
            if (content.substr(position, 3) == "<ms")
            {
                num1=content.indexOf(">",position); //标签头结尾位置
                str1=content.substr(position+3,num1-position-3); //获得毫秒数
                num2=content.indexOf("</ms>",position);   //获得标签尾开头位置
                position=num1+1;
                mytimer.delay=Number(str1);
            }
            else if (content.substr(position, 5) == "</ms>")
            {
                mytimer.delay = ndelay;
                position += 5;
            }
        }
        
        /**
         * 检测字体大小标签
         */
        private function checksp3():void
        {
            if (content.substr(position, 5) == "<size")
            {
                num1=content.indexOf(">",position+4); //标签头结尾位置
                str1=content.substr(position+5,num1-position-5); //获得字体大小
                position=num1+1;
                discontent+="<font size='"+str1+"'>";
            }
            else if(content.substr(position,7)=="</size>"){
                discontent+="</font>";
                position+=7;
            }
        }
        
        /**
         * 检测颜色标签
         */
        private function checksp4():void
        {
            if (content.substr(position, 2) == "<#")
            {
                num1=content.indexOf(">",position+1); //标签头结尾位置
                str1=content.substr(position+1,num1-position-1); //获得颜色
                position=num1+1;
                discontent=discontent+"<font color='"+str1+"'>";
                
                while(content.substr(position,4)!="</#>")
                {
                    discontent+=content.substr(position,1);
                    position++;
                }
                
                discontent+="</font>";
            }
            else if(content.substr(position,4)=="</#>"){
                discontent+="</font>";
                position+=4;
            }
        }
        
        /**
         * 检测加粗<b>标签
         */
        private function checksp5():void
        { 
            if(content.substr(position,3)=="<b>"){
                discontent+="<b>";
                position+=3;
            }
            else if(content.substr(position,4)=="</b>"){
                discontent+="</b>";
                position+=4;
            }
        }
        
        /**
         * 检测换行<br/>标签
         */
        private function checksp6():void
        {
            if (content.substr(position, 5) == "<br/>")
            {
                discontent+="<br/>";
                position+=5;
            }
        }
        
        private function mytimerplay(evt:TimerEvent):void
        {
            mytimer.start();
        }
        
    }
}