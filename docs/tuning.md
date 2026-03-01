# Tuning the OpenUPS DC UPS (KPI-driven)

This document explains how to adjust your OpenUPS configuration to achieve minimal idle power and minimal high‑voltage dwell time. Instead of relying on guesswork, we use measurable KPIs—such as battery voltage, charge events, and output current—to guide the tuning process.

## Why tune?

By default, OpenUPS may keep the battery at full voltage, leading to unnecessary high‑voltage dwell and higher idle consumption. Fine‑tuning reduces wear on LiFePO₄ cells and improves efficiency.

## Key KPIs

- **Battery voltage** (e.g., `battery.voltage`): use this to determine when to start and stop charging. LiFePO₄ batteries are considered “full” around 14.4 V and should not be held there.
- **Charge/discharge events**: monitor `ups.status` transitions (OL, OB, CHRG) via `upsc` or the logging scripts. These events tell you when the battery is charging, discharging or idle.
- **Output current/voltage** (`output.current`, `output.voltage`): helps to quantify idle draw and load.
- **Temperature**: the `battery.temperature` reading reflects the OpenUPS PCB temperature, not the battery cells. Use it to ensure your enclosure does not overheat.

## Step 1: Gather baseline data

Before changing anything, collect at least 24 hours of logs using `scripts/openups_log_all.sh` and `scripts/openups_log_events.sh`. Inspect the JSONL to see how often the charger engages and what voltage it holds. Plot voltage over time to spot unnecessary top‑ups.

## Step 2: Adjust charge thresholds

OpenUPS parameters are set via EEPROM registers. The exact commands depend on firmware; consult the Mini‑Box documentation. The general approach is:

1. **Lower the charger enable voltage**: Set the “start charge” voltage just below your pack’s nominal voltage (e.g., 13.2 V for LiFePO₄). This prevents the charger from engaging until the battery has meaningfully discharged.
2. **Lower the charger cut‑off current**: Reduce the trickle or float current so the charger turns off sooner. Aim for < 0.3 A.
3. **Disable constant float charging** (if supported): Some firmware allows disabling float or “battery maintenance” mode. Turn this off so the battery is not kept at 100 %.

After writing new values, power‑cycle the OpenUPS (remove power + battery briefly) so the settings take effect.

> **Warning:** Never set thresholds below the BMS low‑cut voltage. For LiFePO₄, keep discharge above ~10 V to avoid damage.

## Step 3: Validate with KPIs

Run the logging scripts again and compare:

- The battery voltage should rise to full only occasionally (e.g., once every few days) and quickly return to nominal after a brief top‑up.
- Idle current drawn from the PSU should be stable and low (measured via an AC plug meter or DC shunt).
- `ups.status` should spend most time in `OL` (online) rather than `CHRG`.

If the UPS still enters charge too often, reduce the start‑charge voltage a bit more or increase the cut‑off current; if it never charges, raise thresholds slightly.

## Step 4: Iterate and monitor

Tuning is iterative. Repeat steps 2 and 3 until the high‑voltage dwell time and idle consumption meet your goals. Re‑check after environmental changes (seasonal temperature, load changes, new firmware).

## Troubleshooting

- **Unreliable SOC readings**: On some OpenUPS firmware/driver combinations, `battery.charge` remains at 100 %. Do not rely on SOC; use voltage and events instead.
- **Temperature drift**: Since `battery.temperature` reflects PCB temperature, it may climb during charge. Ensure good airflow around the OpenUPS.
- **Firmware resets**: A full power removal (battery and mains) is often required to apply new settings.

## Conclusion

By measuring and adjusting based on KPIs, you can tailor your DC UPS to minimize idle power, prolong LiFePO₄ life, and avoid constant high‑voltage stress. Always log, plot, and verify changes rather than relying on default behaviour.
