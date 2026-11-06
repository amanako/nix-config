{
  nixvim.plugins.snacks-dashboard = {
    hm.programs.nixvim = let
      pickProject = ''
        function()
          Snacks.picker.projects({
            dev = { "~/Dev/Projects", "~/Faks/Semestri" },
            patterns = { ".jj", ".git", "flake.nix" },
            recent = false,
            confirm = { "tcd", "picker_files" },
          })
        end
      '';

      newProject = ''
        function()
          vim.ui.input({ prompt = "New project name: " }, function(name)
            if not name or name == "" then return end
            local dir = vim.fn.expand("~/Dev/Projects/") .. name
            vim.fn.mkdir(dir, "p")
            vim.system({ "jj", "git", "init", dir }):wait()
            vim.cmd.tcd(dir)
            Snacks.picker.files()
          end)
        end
      '';
    in {
      keymaps = [
        {
          mode = "n";
          key = "<leader>fp";
          action.__raw = pickProject;
          options.desc = "Projects";
        }
      ];
      plugins.snacks.settings.dashboard = {
        enabled = true;
        preset.keys = [
          {
            icon = " ";
            key = "p";
            desc = "Projects";
            action.__raw = pickProject;
          }
          {
            icon = " ";
            key = "n";
            desc = "New project";
            action.__raw = newProject;
          }
          {
            icon = " ";
            key = "f";
            desc = "Find file";
            action.__raw = "function() Snacks.picker.files() end";
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent files";
            action.__raw = "function() Snacks.picker.recent() end";
          }
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
        ];
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            section = "projects";
            title = "Projects";
            limit = 5;
            padding = 1;
          }
          {
            section = "recent_files";
            title = "Recent in this directory";
            cwd = true;
            limit = 5;
          }
        ];
      };
    };
  };
}
