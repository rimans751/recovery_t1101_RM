# Cloud Build — GitHub Actions (OrangeFox-Action-Builder)

This tree is built on GitHub Actions using the
[`niels-space/tecno-t1101-OrangeFox-Action-Builder`](https://github.com/niels-space/tecno-t1101-OrangeFox-Action-Builder)
harness (a fork of the generic OrangeFox-Action-Builder that ships the correct
`OrangeFox-Compile.yml` workflow). The harness is a generic build runner — the
device-specific work all lives in THIS device tree.

## Step 1 — Push this tree to GitHub

Create a repo, e.g. `YOUR_USER/device_tecno_T1101`, branch `fox_12.1`, and push
the contents of `/tmp/opencode/device_tecno_t1101/`.

```
cd /tmp/opencode/device_tecno_t1101
git init -b fox_12.1
git add .
git commit -m "TECNO MegaPad 11 (koto/T1101) OrangeFox device tree"
git remote add origin https://github.com/YOUR_USER/device_tecno_T1101.git
git push -u origin fox_12.1
```

> The 207 kernel modules (~28 MB) and prebuilt DTB (~0.2 MB) are committed
> because they are required for the working touchscreen. Verify your repo has
> LFS available if GitHub warns about large files (they are all well under the
> 100 MB single-file limit).

## Step 2 — Fork + configure the Action Builder

Fork `niels-space/tecno-t1101-OrangeFox-Action-Builder` or push the workflow
`.github/workflows/OrangeFox-Compile.yml` into a repo where you have GitHub
Actions enabled.

## Step 3 — Run the workflow (Actions → OrangeFox - Build → Run workflow)

| Input | Value |
|-------|-------|
| `MANIFEST_BRANCH` | `12.1` |
| `DEVICE_TREE` | `https://github.com/YOUR_USER/device_tecno_T1101` |
| `DEVICE_TREE_BRANCH` | `fox_12.1` |
| `DEVICE_PATH` | `device/tecno/koto` |
| `DEVICE_NAME` | `koto` |
| `BUILD_TARGET` | `vendorboot` |

The workflow runs:

```
git clone <DEVICE_TREE> -b <BRANCH> ./device/tecno/koto
lunch twrp_koto-eng && make clean && mka adbd vendorbootimage
```

Artifacts are uploaded to a GitHub Release:
`out/target/product/koto/OrangeFox*.img` and `OrangeFox*.zip`.

## Step 4 — Download + report back

The built `OrangeFox-*.img` is the **fresh `vendor_boot.img`** with a working
touchscreen. Download it and report the filename/md5. **Do not flash without
explicit approval** — the next step (flashing + verification) is gated.

## Notes / caveats

- **Kernel**: not built; the device uses its own stock `boot.img` kernel
  (`gf82f736`). `TARGET_NO_KERNEL=true` + `TARGET_PREBUILT_DTB` mirror the
  reference GKI device.
- **Modules**: the 207 stock factory modules (incl. touch `chipone_icnl9951r`,
  `adaptive-ts`, `jadard_touch`) are auto-bundled from `recovery/root/lib/modules/`
  and loaded via `modules.load.recovery`. They were verified `Live` on the
  `gf82f736` kernel with a working touchscreen.
- If the build errors on a missing `android.hardware.health@2.1` or `keymaster`
  module, they are declared in `device.mk`; adjust versions to whatever the
  `12.1` manifest ships.
