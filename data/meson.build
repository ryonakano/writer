icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
  install_data(
    'main_icons' / i / meson.project_name() + '.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
  )
endforeach

i18n.merge_file(
  input: meson.project_name() + '.desktop.in',
  output: meson.project_name() + '.desktop',
  po_dir: meson.project_source_root() / 'po' / 'extra',
  type: 'desktop',
  install: true,
  install_dir: get_option('datadir') / 'applications',
)

metainfo_file = i18n.merge_file(
  input: meson.project_name() + '.metainfo.xml.in',
  output: meson.project_name() + '.metainfo.xml',
  po_dir: meson.project_source_root() / 'po' / 'extra',
  install: true,
  install_dir: get_option('datadir') / 'metainfo',
)

install_data(
  meson.project_name() + '.gschema.xml',
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

# Validate MetaInfo file
ascli_exe = find_program('appstreamcli', required: false)
if ascli_exe.found()
  test('validate metainfo file',
        ascli_exe,
        args: ['validate',
               '--no-net',
               '--pedantic',
               metainfo_file]
  )
endif
