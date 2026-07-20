<?
// Spawns a live terminal (same ttyd/websocket mechanism Unraid's own
// openTerminal() uses) that follows syslog filtered to this agent's lines.
// No client input is used to build the command — it's always this one
// fixed script — so there's no injection surface, same trust level as
// the shared /webGui/include/OpenTerminal.php cases.
exec("ttyd-exec -s9 -om1 -i '/var/tmp/zabbix_agent_syslog.sock' /usr/local/emhttp/plugins/zabbix_agent/scripts/tail_syslog_filtered");
?>
