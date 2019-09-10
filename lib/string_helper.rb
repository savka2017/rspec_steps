module StringHelper
  def decomment(line)
    line.gsub(/\S*#.*$/, '').rstrip
  end
end
