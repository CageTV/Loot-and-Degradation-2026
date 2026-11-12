#pragma once
// The on-screen widget that shows the health of the equipped gear (the original's iWant widget, drawn natively through SKSE Menu Framework).
namespace Widget
{
	void Refresh();  // game thread: reads the player's worn gear into the snapshot the widget draws; called about once a second
	void Draw();     // render thread: draws the snapshot as part of the HUD; called every frame by the Menu Framework
	void Touch();    // gear just changed or wore: keeps a "contextual" widget visible for a few more seconds
}
