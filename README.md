# OpenUPS DC UPS for Synology (LiFePO₄) — low idle, measurable tuning

How-to: Build a low-idle **DC UPS** for a Synology NAS using **Mini-Box OpenUPS + 12.8 V LiFePO₄**, with **NUT logging**, **tuning KPIs**, and a **3D-printed enclosure**.

## Build photo
![OpenUPS in 3D-printed enclosure mounted on a 12.8V LiFePO4 pack](./images/openups-enclosure.jpg)
*Reference build: OpenUPS in a 3D-printed enclosure mounted on a 12.8 V LiFePO₄ pack.*

## What this is (and why)
A classic AC UPS chain (AC→DC→AC→DC) often wastes power at idle. This project replaces it with a **DC UPS power-path controller**:

- AC mains → 12 V PSU → **OpenUPS** → 12 V DC bus → NAS / router / switches
- OpenUPS ↔ USB ↔ Synology DSM (NUT) for status + safe shutdown
- Logging + tuning based on **measured KPIs**, not “feelings”

**Goal:** reduce idle power, keep reliable shutdown behavior, and make tuning reproducible.

## Key findings (practical)
- `battery.charge` / SOC reporting can be **unreliable** depending on firmware/driver; treat it as “nice-to-have”.
- Use **voltage + charge events** as your primary KPIs.
- `battery.temperature` is typically **OpenUPS PCB temperature** (not the battery pack).

## Hardware (reference build)
- Synology NAS (DS920+ in the reference setup)
- Mini-Box **OpenUPS** (USB connected to NAS for monitoring)
- 12.8 V LiFePO₄ pack (with integrated BMS)
- 12 V PSU (Synology 100 W adapter used in the reference setup)
- 12 V distribution with **individual fuses per branch**

## Architecture (high level)
AC (mains) → 12 V PSU → OpenUPS → 12 V DC bus → (NAS / router / switches)  
OpenUPS ↔ USB ↔ Synology DSM (NUT) for status + shutdown

## Quick start
1) **DSM UPS integration**
- Control Panel → Hardware & Power → UPS → Enable UPS support
- Ensure the OpenUPS is detected and the NAS can read it.

2) **Verify via SSH**
```sh
upsc -l
upsc ups | head -n 60
```
If your UPS name is not `ups`, use the shown name in the scripts.

3) **Install scripts and schedule logging**
- Copy scripts from `./scripts` to your NAS (e.g., `/volume1/scripts/`)
- Use DSM Task Scheduler to run the loggers periodically

Details: **[docs/logging.md](./docs/logging.md)**

## Tuning (KPIs, not guesses)
This repo focuses on tuning so the battery is **not permanently held at high voltage** (rare top-ups, minimal high-voltage dwell).

Details + KPI definitions: **[docs/tuning.md](./docs/tuning.md)**

## Safety
This is a power system. Do not improvise fusing, wire gauges, or connectors.

Safety notes: **[hardware/safety.md](./hardware/safety.md)**

## Bill of materials
Reference BOM: **[hardware/bom.md](./hardware/bom.md)**

## Repo layout
- `docs/` → logging + tuning
- `hardware/` → safety + BOM
- `scripts/` → DSM/NUT log scripts (JSONL + event logger)
- `images/` → build photos + plots

## Contributing
Lightweight contributions welcome:
- Small PRs (one change per PR)
- For tuning changes, include before/after KPIs

(Optional) See: **[CONTRIBUTING](./CONTRIBUTING.md)**.

## License
MIT. See **[LICENSE](./LICENSE)**.
