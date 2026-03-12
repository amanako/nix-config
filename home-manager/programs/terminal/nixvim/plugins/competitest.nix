{
	programs.nixvim.plugins.competitest = {
    enable = true;
		settings = {
      compile_command = {
				c = {
				  exec = "clang";
				  args = [ " -Wall -Wextra" "$(FNAME)" "-o" "$(FNOEXT)" ];
			  };
				cpp = {
          exec = "clang++";
					args = [ " -Wall -Wextra" "$(FNAME)" "-o" "$(FNOEXT)" ];
				};
			};
			run_command = {
				c = {
				  exec = "./$(FNOEXT)";
			  };
				cpp = {
					exec = "./$(FNOEXT)";
				};
			};
		};
	};
}
