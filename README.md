# drop_zone.rb

Creates and initializes a shared `Drop Zone` folder in iCloud Drive.

If needed, it creates:

- the `Drop Zone` folder
- a `_README.txt` file inside it
- an optional app subfolder

## Usage

Initialize the shared folder:

```bash
ruby drop_zone.rb
```

Initialize the shared folder and an app folder:

```bash
ruby drop_zone.rb codex-limit
```

## How AI tools use it

AI tools should not know the full iCloud Drive path.

Instead, a tool should call:

```bash
ruby drop_zone.rb <app-name>
```

Example:

```bash
ruby drop_zone.rb codex-limit
```

The script will:

* ensure `Drop Zone` exists
* ensure `_README.txt` exists
* ensure the app subfolder exists
* print the resolved full filesystem path for the app folder

This lets each tool use only its own app name, while `drop_zone.rb` handles the actual path resolution.
