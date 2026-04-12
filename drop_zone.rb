#!/usr/bin/env ruby
# drop_zone.rb

require "fileutils"

ICLOUD_BASE = File.expand_path(
  "~/Library/Mobile Documents/com~apple~CloudDocs"
)

DROP_ZONE_NAME = "Drop Zone"
README_NAME = "_README.txt"

def drop_zone_root
  File.join(ICLOUD_BASE, DROP_ZONE_NAME)
end

def readme_path
  File.join(drop_zone_root, README_NAME)
end

def default_readme
  <<~TEXT
    Drop Zone

    This folder is used by local scripts and agents as a shared drop location
    for small status files and machine-generated outputs.

    Suggested structure:

      Drop Zone/
        codex-limit/
        gas-bill/
        calendar-status/

    Each agent or tool may store files like:

      current.json
      current.txt
      history.log

    This folder is intended for simple handoff between scripts, iPhone/iPad
    Shortcuts, and Apple Watch-friendly workflows.
  TEXT
end

def ensure_drop_zone!
  unless Dir.exist?(ICLOUD_BASE)
    warn "iCloud Drive base folder not found: #{ICLOUD_BASE}"
    exit 1
  end

  created_anything = false

  unless Dir.exist?(drop_zone_root)
    FileUtils.mkdir_p(drop_zone_root)
    created_anything = true
  end

  unless File.exist?(readme_path)
    File.write(readme_path, default_readme)
    created_anything = true
  end

  created_anything
end

ensure_drop_zone!