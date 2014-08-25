#!/bin/bash

cd ..
echo
echo "BUILDING Writer..."
echo "=================="
echo

valac --pkg gtk+-3.0 --pkg granite --pkg pango -o writer src/config.vala src/Writer.vala src/MainWindow.vala src/Widgets/TitleBar.vala src/Widgets/ToolBar.vala src/Widgets/EditorToolBar.vala src/Widgets/ButtonGroup.vala src/Widgets/EditorView.vala src/Widgets/ImageToolBar.vala src/Widgets/TableToolBar.vala src/Widgets/WelcomeView.vala src/Utils/Editor.vala src/Utils/FileChooser.vala src/Utils/Document.vala src/Utils/TextRange.vala src/Utils/ZeitgeistLogger.vala

RESULT=$?

echo
echo "DONE Building"
echo "===="
echo

exit $RESULT