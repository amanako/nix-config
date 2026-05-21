{
  nixvim.keymaps.homeManager.programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>s";
      action = ":w<CR>";
      options = {
        desc = "Write file";
      };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = ":q<CR>";
      options = {
        desc = "Close file";
      };
    }
    {
      mode = "n";
      key = "<leader>w";
      action = ":wa<CR>";
      options = {
        desc = "Write all files";
      };
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = ":qa!<CR>";
      options = {
        desc = "Close all files";
      };
    }
    {
      mode = "n";
      key = "<leader>sf";
      action = "<cmd>Telescope find_files<CR>";
      options = {
        desc = "Search files";
      };
    }
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>Yazi<CR>";
      options = {
        desc = "Open Yazi";
      };
    }
    {
      mode = "n";
      key = "<leader>lp";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      options = {
        desc = "Preview gitsigns";
      };
    }
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "Open lazygit";
      };
    }
    {
      mode = "n";
      key = "<leader>zm";
      action = "<cmd>ZenMode<CR>";
      options = {
        desc = "Go zen-mode";
      };
    }
    {
      mode = "n";
      key = "<leader>lf";
      action = "<cmd>Format<CR>";
      options = {
        desc = "Format file";
      };
    }
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>BufferLineCycleNext<CR>";
      options = {
        desc = "Go to next buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options = {
        desc = "Go to previous buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>n";
      action = "<cmd>NoiceSnacks<CR>";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>ClaudeCode<CR>";
      options = {
        silent = true;
      };
    }
  ];
}
