module StringHelper
  def decomment(line)
    line.gsub(/\S*#.*$/, '').rstrip
  end

  def deprefix(line, prefixes)
    prefixes.each { |prefix| return line.delete_prefix(prefix) if line.start_with? prefix }
    nil
  end

  def has_args?(method)
    !!(method&.index(' ') || method&.index('('))
  end

  def depoet(method)
    unless (method.index('(') || method.length) <= (method.index(' ') || method.length)
      method_name = method[0..method.index(' ')].strip
      args = method.gsub(method_name, '').strip
      method = method_name + '(' + args + ')'
    end
    method
  end

  def to_name_and_args(method)
    method += ')' unless method[-1] == ')'
    args = method.scan(/\((.*)\)/).flatten[0]
    name = method.gsub('(' + args + ')', '')
    [name, args]
  end

  def dequote(args)
    args.gsub(/['"]([^['"]]*)['"]/, 'arg')
  end

  def args_count(args)
    args.split(',').count
  end
end
