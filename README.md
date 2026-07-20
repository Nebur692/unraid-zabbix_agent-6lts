# unraid-zabbix_agent-6lts

🇬🇧 [English](#english) | 🇪🇸 [Español](#español)

---

## English

Fork of [fabianonline/unraid-zabbix_agent](https://git.schle.nz/fabian/unraid-zabbix_agent), an Unraid plugin
that installs and configures `zabbix_agentd` to monitor an Unraid server from a central Zabbix installation.

This fork exists to keep the bundled agent on the **Zabbix 6.0 LTS** branch and to fix two long-standing bugs.
All credit for the original plugin design goes to fabianonline. No license was declared on the original
repository, so this fork is published with clear credit to the original author rather than any claim of
authorship over the base plugin.

### What changed from upstream

- Updated the bundled `zabbix_agentd` from 5.2.1 (Nov 2020) to the official **6.0.47 LTS** static build.
- Fixed `unraid.temperatures` (`temperatures.sh`): it only matched the literal `"CPU Temp:"` / `"MB Temp:"`
  sensor labels, so on boards using the `coretemp` driver (Intel, `"Package id N:"`) or `k10temp` (AMD,
  `"Tctl:"`/`"Tdie:"`) it always reported `null` for CPU temperature. It now takes the highest reading across
  all matched CPU sensor labels (multi-socket boards included), keeping `"CPU Temp:"` as a fallback.
- Updated `zabbix_template.xml` to the Zabbix 6.0 export schema (uuids, `tags` instead of `applications`,
  host-qualified trigger expressions) — the old file was still in the 5.0 export schema.

### Installing

Plugin URL (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_agent.plg
```

Matching Zabbix template, to import on your Zabbix Server:

```
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_template.xml
```

See the [releases](https://github.com/Nebur692/unraid-zabbix_agent-6lts/releases) page for the full changelog.

---

## Español

Fork de [fabianonline/unraid-zabbix_agent](https://git.schle.nz/fabian/unraid-zabbix_agent), un plugin de
Unraid que instala y configura `zabbix_agentd` para monitorizar un servidor Unraid desde una instalación
central de Zabbix.

Este fork existe para mantener el agente empaquetado en la rama **Zabbix 6.0 LTS** y arreglar dos bugs de
larga duración. Todo el crédito del diseño original del plugin es de fabianonline. El repositorio original no
declara ninguna licencia, así que este fork se publica dejando el crédito claro al autor original, sin
reclamar autoría del plugin base.

### Qué cambia respecto al original

- Actualizado el `zabbix_agentd` empaquetado de 5.2.1 (nov-2020) a la build oficial estática **6.0.47 LTS**.
- Arreglado `unraid.temperatures` (`temperatures.sh`): solo reconocía las etiquetas literales `"CPU Temp:"` /
  `"MB Temp:"`, así que en placas con el driver `coretemp` (Intel, `"Package id N:"`) o `k10temp` (AMD,
  `"Tctl:"`/`"Tdie:"`) siempre devolvía `null` para la temperatura de CPU. Ahora toma la lectura más alta entre
  todas las etiquetas de CPU reconocidas (incluye placas multi-socket), manteniendo `"CPU Temp:"` como último
  recurso.
- Actualizado `zabbix_template.xml` al esquema de exportación de Zabbix 6.0 (uuids, `tags` en vez de
  `applications`, expresiones de trigger con host explícito) — el fichero anterior seguía en el esquema 5.0.

### Instalación

URL del plugin (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_agent.plg
```

Plantilla de Zabbix correspondiente, para importar en tu Zabbix Server:

```
https://raw.githubusercontent.com/Nebur692/unraid-zabbix_agent-6lts/main/zabbix_template.xml
```

Consulta la página de [releases](https://github.com/Nebur692/unraid-zabbix_agent-6lts/releases) para el
changelog completo.
