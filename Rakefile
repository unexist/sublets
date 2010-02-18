#
# @file Rake build file
# @copyright (c) 20010 Christoph Kappel <unexist@dorfelite.net>
# @version $Id$
#
# This program can be distributed under the terms of the GNU GPL.
# See the file COPYING.
#

require("fileutils")

task :default => [ :build ]


# Build manpages
task :build do |t|
  files = []

  # Collect files
  FileList["*.*"].collect do |f|
    if(Dir.directory?(f) && "testing" != f)
      files.push(f)
    end
  end

  files.each do |f|
    `sur build #{f}/#{f}.spec`
  end
end

# Submit sublets
task :install => [ :build ] do |t|
  FileList["*.sublet"].collect do |f|
    `sur submit #{f}`
  end
end
