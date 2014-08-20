install(FILES writer.desktop DESTINATION share/applications)

set(FALLBACK_THEME_DIR ${ICON_DIR}/hicolor)

set(ICONS
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