package inoah.interfaces
{
    /**
     * 可以由时间推动
     */    
    public interface ITickable
    {
        
        /**
         * 时间推动
         * @param delta     从上一帧到当前帧所经过的时间(毫秒)
         */        
        function tick(delta:Number):void
        
        /**
         * 可以被时间推动 
         */ 
        function get couldTick():Boolean
        
    }
}