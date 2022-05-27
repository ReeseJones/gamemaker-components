function FileGetSaveDirectory() {
	switch (os_type)
	{
	  case os_windows: {
	    var appdata = environment_get_variable("LOCALAPPDATA");
	    var final_directory = appdata + "\\" + game_project_name + "\\";
	    return final_directory;
	  }
	  case os_android: return working_directory;
	  case os_linux: return working_directory;
	  case os_macosx: return working_directory;
	  case os_ios: return working_directory;
	  case os_winphone: return working_directory;
	  default: return working_directory;
	}
}