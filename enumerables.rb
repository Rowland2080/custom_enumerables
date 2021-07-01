module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    for i in self
      yield(i)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    index = 0
    for i in self
      yield(i,index)
      index += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    selected_array = []
    self.my_each {|i| selected_array << i if yield i}
    selected_array
  end

  def my_all?
    if block_given?
      self.my_each {|i| return false unless yield i}
    else
      self.my_each {|i| return false unless i}
    end
    true
  end


  def my_any?
    if block_given?
      self.my_each {|i| return true if yield i}
    else
      self.my_each {|i| return true if i}
    end
    false
  end

  def my_none?
    if block_given?
      self.my_each {|i| return false if yield i}
    else
      self.my_each {|i| return false if i}
    end
    true
  end

  # def my_none?(&block)
  #   !self.my_any?(&block)
  # end

  def my_count(arg=nil)
    count = 0
    if block_given?
      self.my_each {|i| count+=1 if yield i}
    elsif !arg.nil?
      self.my_each {|i| count+=1 if arg == i}
    else
      self.my_each {|i| count+=1}
    end
    count
  end

  def my_map(arg=nil)
    mapped_array = []
    if block_given?
      self.my_each {|i| mapped_array << yield(i)}
    elsif arg.instance_of?(Proc)
      self.my_each {|i| mapped_array << arg.call(i)}
    else
      return to_enum(:my_map)
    end
    mapped_array
  end

  def my_inject(arg1=nil,arg2=nil)
    injector = nil
    if block_given? && arg1==nil
      injector = self.first
      self.drop(1).my_each {|i| injector = yield injector,i}
    elsif !block_given? && arg1.kind_of?(Symbol)
      injector = self.first
      self.drop(1).my_each {|i| injector += i} if arg1==:+
      self.drop(1).my_each {|i| injector -= i} if arg1==:-
      self.drop(1).my_each {|i| injector *= i} if arg1==:*
      self.drop(1).my_each {|i| injector /= i} if arg1==:/
    elsif !block_given? && arg1 != nil && arg2.kind_of?(Symbol)
      injector = arg1
      self.my_each {|i| injector += i} if arg2==:+
      self.my_each {|i| injector -= i} if arg2==:-
      self.my_each {|i| injector *= i} if arg2==:*
      self.my_each {|i| injector /= i} if arg2==:/
    elsif block_given? && arg1 != nil
      injector = arg1
      self.my_each {|i| injector = yield injector,i}
    else
      return to_enum(:my_inject)
    end
    injector
  end
end
