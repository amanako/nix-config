{
  den.aspects.security.pi-hole = {
    nixos.services = {
      pihole-ftl = {
        enable = true;
        openFirewallDNS = true;
        openFirewallWebserver = true;
        settings = {
          dns = {
            upstreams = [
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
            ];
            reply.host.force6 = true;
          };

          dhcp.ipv6 = true;
        };

        lists = [
          {
            url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt";
            type = "block";
            enabled = true;
            description = "hagezi pro++";
          }
        ];
      };

      pihole-web = {
        enable = true;
        ports = ["443s"];
      };
    };
  };
}
