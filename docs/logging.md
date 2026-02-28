# Logging (Synology DSM / NUT / OpenUPS)

This project uses Synology DSM's UPS integration (NUT) and periodically reads values via `upsc`.

## 1) Verify UPS visibility
Enable SSH in DSM and run:

```sh
upsc -l
upsc ups | head -n 60
