{
  den.aspects.dev.shells.nushell.completions = {
    hm = {
      pkgs,
      lib,
      ...
    }: {
      programs.carapace.enable = true;

      programs.nushell.extraConfig = ''
        # carapace completions https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
        let carapace_completer = {|spans: list<string>|
            CARAPACE_LENIENT=1 carapace $spans.0 nushell ...$spans | from json
        }

        # some completions are only available through a bridge
        # eg. tailscale
        # https://carapace-sh.github.io/carapace-bin/setup.html#nushell
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

        # fish completions https://www.nushell.sh/cookbook/external_completers.html#fish-completer
        let fish_completer = {|spans|
            ${lib.getExe pkgs.fish} --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
            | from tsv --flexible --noheaders --no-infer
            | rename value description
            | update value {|row|
              let value = $row.value
              let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
              if ($need_quote and ($value | path exists)) {
                let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
                $'"($expanded_path | str replace --all "\"" "\\\"")"'
              } else {$value}
            }
        }

        # zoxide completions https://www.nushell.sh/cookbook/external_completers.html#zoxide-completer
        let zoxide_completer = {|spans|
            $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
        }

        # multiple completions
        # the default will be carapace, but you can also switch to fish
        # https://www.nushell.sh/cookbook/external_completers.html#alias-completions
        let multiple_completers = {|spans|
          ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -o 0.expansion

          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }
          ## alias fixer end

          match $spans.0 {
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _ => $carapace_completer
          } | do $in $spans
        }

        $env.config.completions = {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true
            max_results: 100
            completer: $multiple_completers
          }
        }
      '';
    };
  };
}
