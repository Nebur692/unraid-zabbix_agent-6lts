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
- Added a webGUI Settings page (Unraid → Settings → Utilities → Zabbix Agent) for the most commonly changed
  options: `Server` (allowed hosts for passive checks), `ServerActive`, `Hostname`, `Timeout`, disabling
  passive checks entirely, and enabling TLS PSK. **Once saved, `zabbix_agentd.custom.conf` becomes generated
  by this page** — manual edits to it will be overwritten on the next Apply. The page shows English or
  Spanish automatically based on Unraid's webGUI language (any `es_*` locale shows Spanish, everything else
  falls back to English).
- Added a live log viewer: an opt-in "Log to a dedicated file" checkbox, and once enabled, a "View live
  logs" link that opens Unraid's native live terminal (same mechanism as Docker/VMs/NUT) on the agent's log.
- Added a second, zero-setup live log viewer that follows the agent's existing syslog output directly —
  no need to enable file logging first.
- The plugin now links directly to its Settings page when clicked from the Plugins tab.

### Compatibility

Developed and tested on **Unraid 7.3.2**. The plugin only relies on long-standing Dynamix webGUI mechanisms
(`.page` files, `/update.php`, `dynamix.cfg`) that have been present throughout the Unraid 6.x and 7.x line,
so it should work on any reasonably recent 6.x/7.x install — it just hasn't been verified below 7.3.2 by this
fork's maintainer. The pre-fork upstream project is known to have run on at least Unraid 6.12.6. If you try
it on an older or newer release, please open an issue with the result.

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
- Añadida una página de Settings en el webGUI (Unraid → Settings → Utilities → Zabbix Agent) con las
  opciones más comunes: `Server` (hosts permitidos para passive checks), `ServerActive`, `Hostname`,
  `Timeout`, desactivar del todo los passive checks, y activar TLS PSK. **Al guardarla una vez,
  `zabbix_agentd.custom.conf` pasa a generarse desde esta página** — las ediciones manuales se
  sobrescribirán en el siguiente Aplicar. La página muestra inglés o español automáticamente según el
  idioma del webGUI de Unraid (cualquier locale `es_*` muestra español, el resto cae a inglés).
- Añadido un visor de logs en vivo: una casilla opcional "Log a un fichero propio", y una vez activada, un
  enlace "Ver logs en vivo" que abre el terminal en vivo nativo de Unraid (mismo mecanismo que Docker/VMs/NUT)
  sobre el log del agente.
- Añadido un segundo visor de logs en vivo sin configurar nada: sigue directamente lo que el agente ya manda
  a syslog, sin necesidad de activar antes el log a fichero.
- El plugin ahora enlaza directamente a su página de Settings al hacer clic desde la pestaña Plugins.

### Compatibilidad

Desarrollado y probado en **Unraid 7.3.2**. El plugin solo depende de mecanismos del webGUI Dynamix que
llevan presentes desde hace mucho en toda la línea 6.x y 7.x de Unraid (ficheros `.page`, `/update.php`,
`dynamix.cfg`), así que debería funcionar en cualquier instalación 6.x/7.x razonablemente reciente — solo
que no se ha verificado por debajo de 7.3.2 por parte del mantenedor de este fork. El proyecto original
(antes del fork) se sabe que funcionaba al menos en Unraid 6.12.6. Si lo pruebas en una versión más antigua
o más nueva, abre un issue contando el resultado.

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
