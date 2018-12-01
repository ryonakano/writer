project('com.github.ryonakano.writer', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')
add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language:'c'
)

asresources = gnome.compile_resources(
    'as-resources',
    'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
config_header = configure_file(
    input: 'src/config.vala.in',
    output: 'config.vala',
    configuration: conf_data
)

subdir('data')

executable(
    meson.project_name(),
    asresources,
    config_header,
    'src/Utils/Document.vala',
    'src/Utils/TextEditor.vala',
    'src/Utils/TextRange.vala',
    'src/Utils/ZeitgeistLogger.vala',
    'src/Views/EditorView.vala',
    'src/Views/WelcomeView.vala',
    'src/Widgets/Choosers/TableChooser.vala',
    'src/Widgets/ToolBars/ImageToolBar.vala',
    'src/Widgets/ToolBars/TableToolBar.vala',
    'src/Widgets/ToolBars/TextToolBar.vala',
    'src/Widgets/TitleBar.vala',
    'src/Widgets/ToolBar.vala',
    'src/MainWindow.vala',
    'src/Writer.vala',
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
