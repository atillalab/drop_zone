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

def display_root
  "iCloud Drive/#{DROP_ZONE_NAME}"
end

def display_readme
  "#{display_root}/#{README_NAME}"
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

def app_folder_path(app_name)
  File.join(drop_zone_root, sanitize_app_name(app_name))
end

def display_app_folder(app_name)
  "#{display_root}/#{sanitize_app_name(app_name)}"
end

def ensure_drop_zone!(verbose: true)
  unless Dir.exist?(ICLOUD_BASE)
    warn "Error: iCloud Drive not found."
    exit 1
  end

  if Dir.exist?(drop_zone_root)
    puts "Folder exists: #{display_root}" if verbose
  else
    FileUtils.mkdir_p(drop_zone_root)
    puts "Folder created: #{display_root}" if verbose
  end

  if File.exist?(readme_path)
    puts "README exists: #{display_readme}" if verbose
  else
    File.write(readme_path, default_readme)
    puts "README created: #{display_readme}" if verbose
  end
end

def ensure_app_folder!(app_name)
  full_path = app_folder_path(app_name)
  display_path = display_app_folder(app_name)

  if Dir.exist?(full_path)
    puts "App folder exists: #{display_path}"
  else
    FileUtils.mkdir_p(full_path)
    puts "App folder created: #{display_path}"
  end

  puts "Full path: #{full_path}"
end

def list_app_folders
  Dir.children(drop_zone_root)
     .sort
     .select do |entry|
       File.directory?(File.join(drop_zone_root, entry))
     end
end

def list_app_folders!
  app_folders = list_app_folders

  if app_folders.empty?
    puts "No app folders found."
    return
  end

  app_folders.each do |app_folder|
    puts app_folder
  end
end

case ARGV[0]
when nil
  ensure_drop_zone!
  nil
when "list"
  ensure_drop_zone!(verbose: false)
  list_app_folders!
else
  ensure_drop_zone!
  ensure_app_folder!(ARGV[0])
end
