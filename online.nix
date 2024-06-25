{ config, pkgs, ... } : 

let 
  tokens = import /etc/nixos/secrets/tokens.nix;
in
{


  networking.firewall.allowedTCPPorts = [ 22 80 418 ];
  networking.firewall.allowedUDPPorts = [ 3333 ];

#  networking.bonds.bond0 = {
#    interfaces = [ "enp5s0" "wlp4s0" ];
#    driverOptions = {
#      primatry = "enp5s0";
#      miimon = "100";
#      mode = "active-backup";
#    };
#  };

  

  systemd.targets.sleep.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.poweroff.enable = false;
  systemd.targets.halt.enable = false;

  networking.interfaces.enp5s0 = {
    wakeOnLan.enable = true;
  };
 
  boot.extraModprobeConfig = "options usbcore autosuspend=-1";
  boot.kernelParams = [
    "intel_idle.max_cstate=0"
    "amd_pstate=active"
    "processor.max_cstate=1"
    "idle=poll"
  ];  

  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "performance";
  };
 
  system.autoUpgrade.enable = false;


  systemd.timers.checkSshd = {
    description = "Run sshd checker";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
  };

  systemd.services.checkSshd = {
    description = "Check sshd status and reboot if inactive";
    script = ''
      if ! systemctl is-active sshd; then
        systemctl reboot
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  systemd.services.updateIp = {
    description = "Update dns with ip";
    path = [ pkgs.curl ];
    script = ''
	ip4=$(curl -4 "https://ip.thalheim.io")
	ip6=$(curl -6 "https://ip.thalheim.io")
        if [[ -z "$ip4" && -z "$ip6" ]]; then
	  exit 0
	fi
        curl -s -S "https://www.duckdns.org/update?domains=largemonkey&token=${tokens.duckey}&ip=$ip4&ip6=$ip6"
    '';
    serviceConfig.Type = "oneshot";
  };
  
  systemd.timers.updateIp = {
    description = "Update ip address";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "45min";
    };
  };

}


