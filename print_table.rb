def clean_browser(b)
  return "Chrome " + $1 if /Chrome ([0-9]+)/ =~ b
  return "Firefox " + $1 if /Firefox ([0-9]+)/ =~ b
  return "Safari " + $1 if /Safari ([0-9]+)/ =~ b
  return "Opera " + $1 if /Opera ([0-9]+)/ =~ b
  return "nope"
end

def browsers(group)
  browsers = group.map {|x| x.sample.browser }.sort.uniq
  l = []

  chrome = browsers.select {|x| x =~ /Chrome/}
  chrome_versions = chrome.map{|w| /Chrome ([0-9]+)/.match(w)[1] }.uniq.map{|x| x.to_i}.sort.join(", ")
  l.push("Chrome (#{chrome_versions})") if chrome.length > 0

  firefox = browsers.select {|x| x =~ /Firefox/}
  firefox_versions = firefox.map{|w| /Firefox ([0-9]+)/.match(w)[1] }.uniq.map{|x| x.to_i}.sort.join(", ")
  l.push("Firefox (#{firefox_versions})") if firefox.length > 0

  opera = browsers.select {|x| x =~ /Opera/}
  opera_versions = opera.map{|w| /Opera ([0-9]+)/.match(w)[1] }.uniq.map{|x| x.to_i}.sort.join(", ")
  l.push("Opera (#{opera_versions})") if opera.length > 0

  safari = browsers.select {|x| x =~ /Safari/}
  safari_versions = safari.map{|w| /Safari ([0-9]+)/.match(w)[1] }.uniq.map {|x| x.to_i}.sort.join(", ")
  l.push("Safari (#{safari_versions})") if safari.length > 0

  return l.join("; ")
end

def graphics_cards(group)
  # not even going to try. do this manually.
  return ""
end

def oses(group)
  os = group.map {|x| x.sample.os }.sort.uniq
  l = []

  l.push("Linux") if os.select {|x| /Linux/ =~ x}.length > 0

  osx = os.select {|x| x =~ /OSX/}
  osx_versions = osx.map{|w| /OSX (.*)/.match(w)[1] }.join(", ")
  l.push("OSX (#{osx_versions})") if osx.length > 0

  windows = os.select {|x| x =~ /Windows/}
  windows_versions = windows.map{|w| /Windows (.*)/.match(w)[1] }.join(", ")
  l.push("Windows (#{windows_versions})") if windows.length > 0

  return l.join("; ")
end

def print_table(groups)
  #puts groups.each_with_index.map {|g, i| " #{i+1} & #{g.length} & #{browsers g} & #{graphics_cards g} & #{oses g}" }.join("\n")

  groups.each_with_index {|g,i|
    results = g.inject( Hash.new(0)) {|h,i| h[ {:os => i.sample.os, :browser => clean_browser(i.sample.browser), :graphics => i.sample.graphics_card} ] += 1; h }
    keys = results.keys.sort_by {|r| r[:graphics] + r[:browser] + r[:os] }

    group = i+1

    keys.each {|k|
      puts " #{group} & #{results[k]} & #{k[:graphics]} & #{k[:browser]} & #{k[:os]} \\\\"
      group = ""
    }
  }

  puts "\n"
end

