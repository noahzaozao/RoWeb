package com.inoah.ro.ui
{
    import com.D5Power.BitmapUI.D5TLFText;
    
    /**
     * 逐字显示文本
     * 可能用到的标签 停顿[ms1000] <ms100>间隔</ms>  <#000000>颜色</#> <size12>字体大小</size> <b>加粗</b> 换行<br/>
     */
    public class ESayBox
    {
        public var content:String; //内容
        public var contenter:D5TLFText;
        
        //public var textfield:TextField;   //目标文本框
        
        public function ESayBox():void
        {
            
        }
        
        public function play( cont:String = ''):void 
        {
            content = cont;
            contenter.htmlText = content;
        }
        
        public function clear():void
        {
            contenter.htmlText = '';
        }
    }
}