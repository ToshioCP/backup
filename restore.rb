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
  $stderr.print "Usage: ruby restore.rb [--help]\n"
  $stderr.print "     --help: show this message.\n"
  $stderr.print "Don't change 'backup_conf.rb' after you backup files.\n"
  exit 0
end

@dst_dir = dst_dir()
@src_dirs = src_dirs()
@src_files = src_files()
@hidden_include = hidden_include()

@ar_files = Dir.children(@dst_dir)

if ARGV[0] == "--help"
  usage()
  exit 0
end

@ar_files.each do |f|
  restore_f = f.sub(/.tar.gz$/,'')
  if restore_f == 'files'
    Minitar.unpack(Zlib::GzipReader.new(File.open("#{dst_dir}/#{f}", 'rb')), '.')
  else
    Minitar.unpack(Zlib::GzipReader.new(File.open("#{dst_dir}/#{f}", 'rb')), restore_f)
  end
end
