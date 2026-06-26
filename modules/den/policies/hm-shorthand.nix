{den, ...}: {
  den.policies.hm-shorthand = {host, ...}: [
    (den.lib.policy.route {
      fromClass = "hm";
      intoClass = "homeManager";
    })
  ];
}
