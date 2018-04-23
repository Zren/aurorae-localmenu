# Aurorae Locally Integrated Menu

This is an **experimental** proof of concept to add Locally integrated menues to Plasma.

This is nowhere near ready for use.

* https://bugs.kde.org/show_bug.cgi?id=375951

### Notes

* `appmenuapplet.h` was refactored to be a QObject instead of an Applet. It's renamed `appmenuthing.h`.
* `appmenuapplet.h`'s onDestroyed code was removed to compile. Which means it never unregisters the kappmenu service.

### TodoList

* The model needs to populate the menu based any another `windowId` (add writable `AppMenuModel.windowId` property).
  * Because we haven't done this, all windows show the menu for the active window. If we try to open 
* ~~The model needs to open the menu when triggered without `plasmoid.nativeInterface`.~~
