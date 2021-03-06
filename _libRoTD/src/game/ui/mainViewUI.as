/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class mainViewUI extends View {
		public var backBtn:Image;
		public var settingBtn:Image;
		public var startBtn:Button;
		public var chooseBg:Image;
		protected var uiXML:XML =
			<View height="100">
			  <Image url="png.td_interface.topBg" x="0" y="0"/>
			  <Image url="png.td_interface.backBtn" x="8" y="8" var="backBtn" name="backBtn"/>
			  <Image url="png.td_interface.settingBtn" x="904" y="8" var="settingBtn" name="settingBtn"/>
			  <Button skin="png.td_interface.btn_start" x="390" y="518" var="startBtn" name="startBtn"/>
			  <Image url="png.td_interface.chooseBg" x="256" y="166" var="chooseBg" name="chooseBg"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}