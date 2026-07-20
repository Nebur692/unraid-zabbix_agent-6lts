**zabbix_agent (6lts fork)**

🇬🇧 English

This plugin installs and configures zabbix_agentd, which can be used to monitor this Unraid server using a
central Zabbix server.

This is a fork of [fabianonline/unraid-zabbix_agent](https://git.schle.nz/fabian/unraid-zabbix_agent) (no
license was declared on the original repo, so this fork keeps clear credit to the original author rather than
claiming authorship of the base plugin). Changes in this fork:

- Bundled zabbix_agentd updated from 5.2.1 (2020) to the official 6.0.47 LTS static build.
- Fixed unraid.temperatures so it correctly reads multi-socket Intel `coretemp` (`Package id N:`) and AMD
  `k10temp` (`Tctl:`/`Tdie:`) sensor labels, not just the literal `CPU Temp:` label the original script
  expected.

Matching Zabbix template (Zabbix 6.0 export schema):
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_template.xml

---

🇪🇸 Español

Este plugin instala y configura zabbix_agentd, que se puede usar para monitorizar este servidor Unraid desde
un servidor Zabbix central.

Es un fork de [fabianonline/unraid-zabbix_agent](https://git.schle.nz/fabian/unraid-zabbix_agent) (el repo
original no declara licencia, así que este fork mantiene el crédito claro al autor original en vez de
reclamar autoría del plugin base). Cambios en este fork:

- zabbix_agentd empaquetado actualizado de 5.2.1 (2020) a la build oficial estática 6.0.47 LTS.
- Arreglado unraid.temperatures para que lea correctamente las etiquetas de sensor Intel `coretemp`
  multi-socket (`Package id N:`) y AMD `k10temp` (`Tctl:`/`Tdie:`), no solo la etiqueta literal `CPU Temp:`
  que esperaba el script original.

Plantilla de Zabbix correspondiente (esquema de exportación de Zabbix 6.0):
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_template.xml
