#!/usr/bin/env ruby
# drop_zone.rb

require "fileutils"

ICLOUD_BASE = File.expand_path(
  "~/Library/Mobile Documents/com~apple~CloudDocs"
)

DROP_ZONE_NAME = "Drop Zone"
README_NAME = "_README.txt"

USAGE = <<~TEXT
  Usage:
    ruby drop_zone.rb ensure <app-name>
    ruby drop_zone.rb list
TEXT

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
  TEXT
end

def sanitize_app_name(name)
  cleaned = name.to_s
                .strip
                .downcase
                .gsub(/\s+/, "-")
                .gsub(/[^a-z0-9\-_]/, "")

  if cleaned.empty?
    warn "Error: invalid app name."
    exit 1
  end

  cleaned
end

def usage_error(message = nil)
  warn message if message
  warn USAGE
  exit 1
end

def app_folder_path(app_name)
  File.join(drop_zone_root, sanitize_app_name(app_name))
end

def ensure_drop_zone!
  unless Dir.exist?(ICLOUD_BASE)
    warn "Error: iCloud Drive not found."
    exit 1
  end

  FileUtils.mkdir_p(drop_zone_root) unless Dir.exist?(drop_zone_root)
  File.write(readme_path, default_readme) unless File.exist?(readme_path)
end

def ensure_app_folder!(app_name)
  full_path = app_folder_path(app_name)
  FileUtils.mkdir_p(full_path) unless Dir.exist?(full_path)
  full_path
end

def list_app_folders
  Dir.children(drop_zone_root)
     .sort
     .select do |entry|
       File.directory?(File.join(drop_zone_root, entry))
     end
end

def list_app_folders!
  list_app_folders.each do |app_folder|
    puts app_folder
  end
end

case ARGV[0]
when "ensure"
  usage_error("Error: missing app name.") unless ARGV[1]
  usage_error("Error: too many arguments.") unless ARGV.length == 2
  ensure_drop_zone!
  puts ensure_app_folder!(ARGV[1])
when "list"
  usage_error("Error: too many arguments.") unless ARGV.length == 1
  ensure_drop_zone!
  list_app_folders!
else
  usage_error
end
