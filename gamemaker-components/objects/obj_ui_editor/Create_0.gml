
root = new UIElement({
    name: "root",
    direction: "ltr",
    position: "relative",
    width: "100%",
    height: "100%",
    flexDirection: "row",
    flexGrow: 1,
    flexShrink: 1,
    padding: 0,
    margin: 0,
});

uiElementListContainer = new UIElement({
    name: "uiElementListContainer",
    direction: "ltr",
    position: "relative",
    width: "30%",
    height: "100%",
    flexDirection: "column",
    padding: 0,
    margin: 0,
});
uiElementListContainer.spriteIndex = spr_bg_slate;

uiElementListTitle = new UIElement({
    name: "uiElementListTitle",
    direction: "ltr",
    position: "relative",
    width: "100%",
    flexDirection: "column",
    padding: 0,
    margin: 0,
});
uiElementListTitle.textDescription.font = font_ui_small;
uiElementListTitle.textDescription.halign = fa_center;
uiElementListTitle.textDescription.valign = fa_middle;
uiElementListTitle.setText("UI Element List", true);
uiElementListTitle.spriteIndex = spr_bg_panel_clear_1;

uiElementListScrollContainer = new UIScrollContainer({
    name: "uiElementListScrollContainer",
    direction: "ltr",
    position: "relative",
    width: "100%",
    height: flexpanel_unit.auto,
    flexDirection: "column",
    flexGrow: 1,
    flexShrink: 1,
    padding: 0,
    margin: 0,
});
uiElementListScrollContainer.spriteIndex = spr_bg_slate;

uiRenderingContainer = new UIElement({
    name: "uiRenderingContainer",
    direction: "ltr",
    position: "relative",
    //width: flexpanel_unit.auto,
    height: "100%",
    flexDirection: "column",
    flexGrow: 1,
    flexShrink: 1,
    padding: 0,
    margin: 0,
});

uiRenderingContainer.spriteIndex = spr_mask_rectangle;
uiRenderingContainer.blendColor = merge_color(c_white, c_black, 0.9);

root.append(uiRenderingContainer, uiElementListContainer);
uiElementListContainer.append(uiElementListTitle, uiElementListScrollContainer);


for(var i = 0; i < 100; i += 1) {
    var _temp = new UIElement({
        name: "_temp",
        direction: "ltr",
        position: "relative",
        width: "100%",
        flexDirection: "column",
        padding: 0,
        margin: 0,
    });
    _temp.textDescription.font = font_ui_small;
    _temp.textDescription.halign = fa_center;
    _temp.textDescription.valign = fa_middle;
    _temp.setText("UI Element List", true);
    _temp.spriteIndex = spr_bg_panel_clear_1;
    uiElementListScrollContainer.contentContainer.append(_temp);
 }