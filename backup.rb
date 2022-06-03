require "fileutils"
require "minitar"
require "zlib"

require_relative "backup_conf.rb"

include FileUtils

# backup script
#
# usage
# 1 connect HDD (ELECOM USBHDD).
# 2 run this script.

def usage
  $stderr.print "Usage: ruby backup.rb [--help]\n"
  $stderr.print "     --help: show this message.\n"
  $stderr.print "You need to modify 'backup_conf.rb' to fit your environment first.\n"
  exit 0
end

# Hidden files (the name of the file beggins with dot like ".bashrc", ends with tilde like "sample.txt~") aren't copied.
# Link files (e.g. symbolic link) are not copied.
# If you want to copy all the files, modify this program.

def get_files dir
  files = []
  Dir.children(dir).each do |f|
    if f[0] == '.' && (! @hidden_include.include?(f)) # hidden files
      # do nothing
    elsif f =~ /~$/ # gedit backup files
      # do nothing
    elsif Dir.exist?("#{dir}/#{f}")
      files = files + get_files("#{dir}/#{f}")
    elsif File.ftype("#{dir}/#{f}") == "file" # not link
      files << "#{dir}/#{f}"
    end
  end
  files
end

@dst_dir = dst_dir()
@src_dirs = src_dirs()
@src_files = src_files()
@hidden_include = hidden_include()

# check files and directories
@src_files.each do |f|
  raise "#{f} doesn't exist." unless File.exist?(f)
  raise "#{f} isn't a file. (maybe link or directory)" unless File.ftype(f) == "file"
end
@src_dirs.each do |d|
  raise "#{d} isn't a directory." unless Dir.exist?(d)
end

if ARGV[0] == "--help"
  usage()
  exit 0
end

mkdir @dst_dir

unless @src_files.empty?
  Minitar.pack(@src_files, Zlib::GzipWriter.new(File.open("#{@dst_dir}/files.tar.gz", 'wb')))
end

@src_dirs.each do |dir|
  cd(dir){|d| Minitar.pack(get_files('.'), Zlib::GzipWriter.new(File.open("#{@dst_dir}/#{dir}.tar.gz", 'wb')))}
end
