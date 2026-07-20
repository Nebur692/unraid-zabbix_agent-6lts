**zabbix_agent (6lts fork)**

This plugin installs and configures zabbix_agentd which can be used to monitor this Unraid server using a central Zabbix server.

This is a fork of [fabianonline/unraid-zabbix_agent](https://git.schle.nz/fabian/unraid-zabbix_agent) (no license was declared on the
original repo, so this fork keeps clear credit to the original author rather than claiming authorship of the base plugin). Changes
in this fork:

- Bundled zabbix_agentd updated from 5.2.1 (2020) to the official 6.0.47 LTS static build.
- Fixed unraid.temperatures so it correctly reads multi-socket Intel `coretemp` (`Package id N:`) and AMD `k10temp`
  (`Tctl:`/`Tdie:`) sensor labels, not just the literal `CPU Temp:` label the original script expected.

You can download a matching zabbix template at https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_template.xml
