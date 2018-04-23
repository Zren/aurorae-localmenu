import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.taskmanager 0.1 as TaskManager


import org.kde.plasma.private.localmenu 1.0 as AppMenuPrivate


PlasmaCore.Dialog {
	id: page
	flags: Qt.WindowStaysOnTopHint

	mainItem: Item {
		width: 400 * units.devicePixelRatio
		height: 40 * units.devicePixelRatio

		AppMenuPrivate.AppMenuThing {
			id: appMenuThing
		}

		AppMenuPrivate.AppMenuModel {
			id: appMenuModel
			onRequestActivateIndex: appMenuThing.requestActivateIndex(index)
			Component.onCompleted: {
				appMenuThing.model = appMenuModel
			}
		}

		GridLayout {
			id: buttonGrid

			anchors.centerIn: parent

			//when we're not enabled set to active to show the configure button
			//Plasmoid.status: buttonRepeater.count > 0 ?
			//                 PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.HiddenStatus
			Layout.minimumWidth: implicitWidth
			//Layout.minimumHeight: implicitHeight
			
			flow: GridLayout.LeftToRight
			rowSpacing: units.smallSpacing
			columnSpacing: units.smallSpacing

			Component.onCompleted: {
				appMenuThing.buttonGrid = buttonGrid

				// using a Connections {} doesn't work for some reason in Qt >= 5.8
				appMenuThing.requestActivateIndex.connect(function (index) {
					var idx = Math.max(0, Math.min(buttonRepeater.count - 1, index))
					var button = buttonRepeater.itemAt(index)
					if (button) {
						button.clicked()
					}
				});
			}

			// So we can show mnemonic underlines only while Alt is pressed
			PlasmaCore.DataSource {
				id: keystateSource
				engine: "keystate"
				connectedSources: ["Alt"]
			}

			Repeater {
				id: buttonRepeater
				model: appMenuModel

				PlasmaComponents.ToolButton {
					readonly property int buttonIndex: index

					Layout.preferredWidth: minimumWidth
					Layout.fillHeight: true
					text: {
						var text = activeMenu;

						var alt = keystateSource.data.Alt;
						if (!alt || !alt.Pressed) {
							// StyleHelpers.removeMnemonics
							text = text.replace(/([^&]*)&(.)([^&]*)/g, function (match, p1, p2, p3) {
								return p1.concat(p2, p3);
							});
						}

						return text;
					}
					// fake highlighted
					checkable: appMenuThing.currentIndex === index
					checked: checkable
					onClicked: {
						appMenuThing.trigger(this, index)
					
					}
				}
			}
		}
	}
	
}
