project('writer', 'vala', 'c')

i18n = import('i18n')
add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language:'c'
)

subdir('data')

executable(
    meson.project_name(),
        'src/Utils/Document.vala',
        'src/Utils/FileChooser.vala',
        'src/Utils/Stylesheet.vala',
        'src/Utils/TextEditor.vala',
        'src/Utils/TextRange.vala',
        'src/Utils/ZeitgeistLogger.vala',
        'src/Widgets/ButtonGroup.vala',
        'src/Widgets/EditorView.vala',
        'src/Widgets/ImageToolBar.vala',
        'src/Widgets/TableChooser.vala',
        'src/Widgets/TableToolBar.vala',
        'src/Widgets/TextToolBar.vala',
        'src/Widgets/TitleBar.vala',
        'src/Widgets/ToolBar.vala',
        'src/Widgets/WelcomeView.vala',
        'src/Writer.vala',
        'src/MainWindow.vala',
    dependencies: [
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0', version: '>=3.22'),
        dependency('gtksourceview-3.0'),
        dependency('zeitgeist-2.0'),
    ],
    install: true
)

meson.add_install_script('meson/post_install.py')
