{
  nixvim.plugins.easy-dotnet = {
    hm = {pkgs, ...}: {
      programs.nixvim = {
        # Fallback SDK for when Neovim is not launched from a project devshell.
        extraPackagesAfter = [pkgs.dotnet-sdk_10 pkgs.netcoredbg];

        extraConfigLuaPre = ''
          vim.env.PATH = vim.fn.expand("~/.dotnet/tools") .. ":" .. vim.env.PATH

          local function set_roslyn_dll()
            local dlls = vim.fn.glob(
              vim.fn.expand("~/.dotnet/tools/.store/roslyn-language-server/**/Microsoft.CodeAnalysis.LanguageServer.dll"),
              false,
              true
            )
            if #dlls > 0 then
              vim.env.EASY_DOTNET_ROSLYN_DLL_PATH = dlls[#dlls]
            end
          end

          set_roslyn_dll()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cs", "razor", "xaml" },
            callback = set_roslyn_dll,
          })

          if (vim.env.DOTNET_ROOT or "") == "" then
            vim.env.DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet"
          end
        '';

        plugins.easy-dotnet = {
          enable = true;
          settings = {
            picker = "telescope";
            test_runner = {
              viewmode = "split";
              enable_buffer_test_execution = true;
              noBuild = true;
              noRestore = true;
            };
          };
        };

        plugins.telescope.enable = true;
      };
    };
  };
}
