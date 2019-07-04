project('com.github.ryonakano.writer', 'vala', 'c')

no_zeitgeist = get_option('no_zeitgeist')

dependencies = [
    dependency('gee-0.8'),
    dependency('glib-2.0'),
    dependency('granite', version: '>=5.2.0'),
    dependency('gtk+-3.0', version: '>=3.22'),
    dependency('gtksourceview-3.0')
]

if no_zeitgeist == false
    dependencies += dependency('zeitgeist-2.0')
    add_project_arguments(['--define', 'HAVE_ZEITGEIST'], language: 'vala')
endif

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

executable(
    meson.project_name(),
    asresources,
    config_header,
    'src/Utils/RTFParser.vala',
    'src/Utils/RTFWriter.vala',
    'src/Utils/TextEditor.vala',
    'src/Utils/TextRange.vala',
    'src/Utils/ZeitgeistLogger.vala',
    'src/Views/EditorView.vala',
    'src/Views/WelcomeView.vala',
    'src/Widgets/Choosers/TableChooser.vala',
    'src/Widgets/ToolBars/ImageToolBar.vala',
    'src/Widgets/ToolBars/TableToolBar.vala',
    'src/Widgets/ToolBars/TextToolBar.vala',
    'src/Widgets/PreferenceWindow.vala',
    'src/Widgets/TitleBar.vala',
    'src/Widgets/ToolBar.vala',
    'src/MainWindow.vala',
    'src/Writer.vala',
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
