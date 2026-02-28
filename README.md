# openups-synology-dc-ups
How-to: Build a low-idle DC UPS for Synology NAS with OpenUPS + LiFePO₄ (NUT logging, tuning, 3D-printed case)


## Build photo
![OpenUPS in 3D-printed enclosure mounted on a 12.8V LiFePO4 pack](./images/openups-enclosure.jpg)
*OpenUPS in a 3D-printed enclosure mounted on a 12.8V LiFePO₄ pack (reference build).*

# How-to: Low-idle DC UPS for Synology NAS with OpenUPS + LiFePO₄

This repo documents a small homelab project to replace a classic AC UPS with a more efficient **DC UPS** setup:
- **Mini-Box OpenUPS** as DC-UPS / power-path controller
- **12.8 V LiFePO₄** battery pack (with integrated BMS)
- **Synology NAS + router + switches** powered from a 12 V bus
- **Logging + tuning** based on real measurements (NUT/upsc + optional AC plug meter)
- **Minimal 3D-printed enclosure** (FDM, PLA) for OpenUPS + fuse distribution

Goal: **reduce idle power**, keep safe shutdown behavior, and make tuning reproducible.

## Results (example)
- Idle power of the full setup was reduced significantly vs. an AC UPS chain (measured with a plug meter).
- After tuning, the battery is not permanently held at high voltage: **rare top-ups**, no prolonged high-voltage dwell.

> Notes:
> - Values depend on your NAS model, PSU, and load.
> - `battery.charge` from OpenUPS/NUT can be unreliable; use voltage + events as primary KPIs.

## Hardware (reference build)
- Synology NAS (DS920+ in the reference setup)
- Mini-Box **OpenUPS** (USB connected to NAS for monitoring)
- 12.8 V LiFePO₄ pack (e.g., Offgridtec 12.8 V 8 Ah with integrated BMS)
- 12 V DC distribution with **individual fuses per branch**
- 12 V PSU (Synology 100 W adapter used in the reference setup)

## Architecture (high level)
AC (mains) → 12 V PSU → OpenUPS → 12 V DC bus → (NAS / router / switches)  
OpenUPS ↔ USB ↔ Synology DSM (NUT) for status + shutdown

## Quick start
1. **Enable UPS support in DSM** and verify the device is visible via `upsc`.
2. Deploy logging scripts from [`/scripts`](./scripts).
3. Track KPIs from [`/docs/tuning.md`](./docs/tuning.md).

## Documentation
- Logging: [`/docs/logging.md`](./docs/logging.md)
- Tuning & KPIs: [`/docs/tuning.md`](./docs/tuning.md)
- Safety: [`/hardware/safety.md`](./hardware/safety.md)
- Bill of materials: [`/hardware/bom.md`](./hardware/bom.md)

## Contributing
Contributions are welcome, but please keep them lightweight:
- Small PRs (one change per PR)
- For tuning changes, include **before/after KPIs** (top-ups/week, peak voltage, time ≥13.8 V, PCB temp max)
- Use GitHub Issues for questions, bugs, and proposals

## License
MIT (scripts + docs). See [`LICENSE`](./LICENSE).
