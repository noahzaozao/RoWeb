/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class skillBarViewUI extends Dialog {
		private var uiXML:XML =
			<Dialog dragArea="0,0,900,500">
			  <Image url="png.basic_interface.shortitem_bg" x="0" y="0"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}