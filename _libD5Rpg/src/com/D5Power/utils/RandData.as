package com.D5Power.utils
{
    /**
     * 具备随机值的数据类
     */ 
    internal class RandData
    {
        protected var rand:uint;
        public function RandData()
        {
            rand = int(Math.random()*100000);
        }
        
        protected function inData(v:Number):String
        {
            return (v+rand).toString();	
        }
        
        protected function outData(v:String):Number
        {
            return Number(v)-rand;
        }
    }
}