# drop_zone.rb

Creates and initializes a shared `Drop Zone` folder in **iCloud Drive on macOS**.

This script is **macOS-specific**. It assumes:

- iCloud Drive is enabled
- the standard macOS iCloud Drive path exists at  
  `~/Library/Mobile Documents/com~apple~CloudDocs`

If needed, it creates:

- the `Drop Zone` folder
- a `_README.txt` file inside it
- an app subfolder when requested via `ensure`

## Usage

Ensure the shared folder and an app folder:

```bash
ruby drop_zone.rb ensure codex_limit_tracker
```

List app folders:

```bash
ruby drop_zone.rb list
```

## macOS System-Wide Usage

```bash
ln -sf ~/Documents/path-to-drop_zone/drop_zone.rb /usr/local/bin/drop-zone
chmod +x ~/Documents/path-to-drop_zone/drop_zone.rb

drop-zone
```

macOS system-wide usage via symlink so `drop-zone` can be run from anywhere.
`chmod +x` makes the script executable and avoids `zsh: permission denied: drop-zone`.
If `/usr/local/bin` is not writable for your user, run the `ln` command with `sudo`.

## How AI tools use it

AI tools should not know the full iCloud Drive path.

Instead, a tool should call:

```bash
ruby drop_zone.rb ensure <app-name>
```

Example:

```bash
ruby drop_zone.rb ensure codex-limit
```

The `ensure` command will:

* ensure `Drop Zone` exists
* ensure `_README.txt` exists
* ensure the app subfolder exists
* print only the resolved full filesystem path for the app folder

The `list` command will:

* print only app subfolder names
* print one app name per line
* sort names alphabetically
* print nothing when no app folders exist

This lets each tool use only its own app name, while `drop_zone.rb` handles the actual path resolution.

## Platform note

This script is intended for **macOS only**.

It does not currently support:

* Linux
* Windows
* non-iCloud storage paths

## Example integration

Example with `[codex-limit-tracker](https://github.com/atillalab/codex_limit_tracker)`:

```zsh
codex-limit-snapshot() {
  local app_dir
  app_dir="$(drop-zone ensure codex_limit_tracker)" || return 1
  codex-limit-tracker --json > "$app_dir/latest.json"
  echo "Saved: $app_dir/latest.json"
}