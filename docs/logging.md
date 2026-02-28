# Logging (Synology DSM / NUT / OpenUPS)

This project uses Synology DSM's UPS integration (NUT) and periodically reads values via `upsc`.

## 1) Verify UPS visibility
Enable SSH in DSM and run:

```sh
upsc -l
upsc ups | head -n 60
```

If your UPS name is not `ups`, replace it in the commands and scripts below.

## 2) Full variable logging (JSONL)
Use [`scripts/openups_log_all.sh`](../scripts/openups_log_all.sh). It writes one JSON object per sample and includes **all** `upsc` key/value pairs.

### Manual test
```sh
/volume1/scripts/openups_log_all.sh ups
tail -n 3 /volume1/ups-logs/openups_$(date +%F).jsonl
```

### DSM Task Scheduler
- Control Panel → Task Scheduler → Create → Scheduled task → User-defined script
- Run as: `root` (or an admin with the needed permissions)
- Schedule: every **60 seconds**
- Command:
```sh
/volume1/scripts/openups_log_all.sh ups
```

## 3) Event logging to Log Center (optional)
Use [`scripts/openups_log_events.sh`](../scripts/openups_log_events.sh). It logs only important state changes to syslog via `logger` (e.g., OL → OB).
This is useful for DSM Log Center, but **do not** push per-minute full dumps to Log Center.

Schedule every **30–60 seconds**:
```sh
/volume1/scripts/openups_log_events.sh ups
```

## 4) Retention / cleanup
`openups_log_all.sh` can delete old JSONL log files by age.

- Default: `RETENTION_DAYS=180`
- Disable cleanup: set `RETENTION_DAYS=0`

Example (in Task Scheduler "Run command" field):
```sh
RETENTION_DAYS=90 /volume1/scripts/openups_log_all.sh ups
```

## Notes / caveats
- `battery.charge` can be stuck at 100% depending on firmware/driver; rely on **voltage + CHRG events** as primary KPIs.
- `battery.temperature` is typically **OpenUPS PCB temperature**, not the battery pack temperature.
- If your DSM build of `upsc` does not support `-j` (JSON), this repo’s logger converts `key: value` output into JSONL.
