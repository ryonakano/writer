install(FILES writer.desktop DESTINATION share/applications)

set(FALLBACK_THEME_DIR ${ICON_DIR}/hicolor)

set(ICONS
    icons/format-indent-less-symbolic.svg
    icons/format-indent-more-symbolic.svg
    icons/format-justify-center-symbolic.svg
    icons/format-justify-fill-symbolic.svg
    icons/format-justify-left-symbolic.svg
    icons/format-justify-right-symbolic.svg
    icons/format-text-bold-symbolic.svg
    icons/format-text-italic-symbolic.svg
    icons/format-text-strikethrough-symbolic.svg
    icons/format-text-underline-symbolic.svg
)

install(FILES ${ICONS} DESTINATION ${FALLBACK_THEME_DIR}/16x16/actions)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/16/writer.svg DESTINATION ${HICOLOR_DIR}/16x16/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/24/writer.svg DESTINATION ${HICOLOR_DIR}/24x24/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/32/writer.svg DESTINATION ${HICOLOR_DIR}/32x32/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/48/writer.svg DESTINATION ${HICOLOR_DIR}/48x48/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/64/writer.svg DESTINATION ${HICOLOR_DIR}/64x64/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/main_icons/128/writer.svg DESTINATION ${HICOLOR_DIR}/128x128/apps/)