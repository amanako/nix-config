{
	programs.ssh = {
		enable = true;
		extraConfig = ''
			Host gitlab.io
				HostName 104.21.96.56
		'';
	};
}
