#!/bin/bash

clear
valac --pkg gtk+-3.0 --pkg granite -o Writer src/config.vala src/Writer.vala src/MainWindow.vala src/Widgets/TitleBar.vala src/Widgets/ToolBar.vala src/Widgets/EditorView.vala src/Widgets/WelcomeView.vala src/Utils/Editor.vala

if [ $? -eq 0 ]; then
    ./Writer
else
    echo 'Compilation Failed!'
fi