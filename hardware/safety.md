# Safety notes (read first)

This is a DIY power system. LiFePO₄ packs can deliver very high currents.
Assume any short circuit is dangerous.

## Must-have
- **Fuse each DC branch individually** (NAS / router / switches). Do not rely on a single upstream fuse only.
- Correct polarity everywhere (label + verify).
- Use appropriate cable gauge for expected current and fault current.
- Avoid exposed terminals where metal parts could fall onto them.
- Provide strain relief for all cables.

## Battery pack
- Use a pack with an integrated **BMS**.
- Place the battery on a stable, non-flammable surface.
- Ensure ventilation around electronics.

## OpenUPS temperature
In many setups, `battery.temperature` is effectively **OpenUPS PCB temperature**, not the battery cell temperature.
Design enclosures accordingly (convection, no tight hot pockets).

## Disclaimer
You are responsible for your build and local electrical/fire safety rules.
This repository is provided “as-is” without warranty.
