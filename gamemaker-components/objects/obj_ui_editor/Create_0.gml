
root = new UIElement({
    name: "UiEditorRoot",
    width: "100%",
    height: "100%",
    flexDirection: "column",
    flex: 1,
});

mainContentArea = new UIElement({
    name: "MainContentArea",
    flexDirection: "row",
    flex: 1,
    alignItems: "stretch",
});

sidePanel = new UIElement({
    name: "SidePanel",
    width: "30%",
    flexDirection: "column",
});

uiElementListTitle = new UIElement({
    name: "UiElementListTitle",
    width: "100%",
    flexDirection: "column",
});
uiElementListTitle.textDescription.font = font_ui_small;
uiElementListTitle.textDescription.halign = fa_center;
uiElementListTitle.textDescription.valign = fa_middle;
uiElementListTitle.setText("UI Element List", TEXT_SIZE_METHOD.WRAPPED);
uiElementListTitle.spriteIndex = spr_bg_menu_panel;

uiElementListScrollContainer = new UIScrollContainer({
    name: "uiElementListScrollContainer",
    width: "100%",
    height: flexpanel_unit.auto,
    flexDirection: "column",
    flex: 1,
});

uiRenderingContainer = new UIElement({
    name: "uiRenderingContainer",
    flexDirection: "column",
    flex: 1,
});

uiRenderingContainer.spriteIndex = spr_bg_menu_panel;
uiRenderingContainer.blendColor = merge_color(c_white, c_black, 0.9);


elementCreationPanel = editor_ui_make_creation_controls();

toolBarElement = editor_ui_make_menubar();

root.append(toolBarElement, mainContentArea);
mainContentArea.append(uiRenderingContainer, sidePanel);
sidePanel.append(elementCreationPanel, uiElementListTitle, uiElementListScrollContainer);

focusedElement = uiRenderingContainer;
managedUi = [];