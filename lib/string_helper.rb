module StringHelper
  def decomment(line)
    line.gsub(/\S*#.*$/, '').rstrip
  end

  def deprefix(line, prefixes)
    prefixes.each { |prefix| return line.delete_prefix(prefix) if line.start_with? prefix }
    nil
  end
end
