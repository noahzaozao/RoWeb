/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class mapViewUI extends Dialog {
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.blank" x="0" y="0" width="190" height="190" alpha="0.2"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}