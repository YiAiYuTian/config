vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO YiAiYuTian/YiaLite
    REF "v${VERSION}"
    SHA512 fcd5d7462124af3afa3e881c1c795068cf985f7aa876c24f293e0a9c86add71ccefdcfc5f1c29ebc95a27c08ba7bb768046371636626063dcd1289e94e41cee4
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME "YiaLite" CONFIG_PATH "lib/cmake/YiaLite")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")