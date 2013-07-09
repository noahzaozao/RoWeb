package com.D5Power.graphicsManager
{
    internal class GraphicsData
    {
        internal var action:uint;
        internal var resNameList:Vector.<String>;
        internal var frame:uint;
        internal var line:uint;
        internal var fps:uint;
        
        
        
        public function GraphicsData()
        {
        }
        
        public function toString():String
        {
            return "Action:"+action+" resName:"+resNameList+'\nframe:'+frame+" line:"+line;
        }
    }
}