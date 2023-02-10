function file_get_save_directory() {
    switch (os_type)
    {
      case os_windows: {
        var _appdata = environment_get_variable("LOCALAPPDATA");
        var _finalDirectory = _appdata + "\\" + game_project_name + "\\";
        return _finalDirectory;
      }
      case os_android: return working_directory;
      case os_linux: return working_directory;
      case os_macosx: return working_directory;
      case os_ios: return working_directory;
      case os_winphone: return working_directory;
      default: return working_directory;
    }
}