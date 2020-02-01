# Linear collections of data elements(nodes)
class LinkedList
  include Enumerable

  attr_accessor :head, :tail

  # Initialize an empty lits.
  def initialize
    @head = nil
    @tail = nil
  end

  # Node class
  class Node
    attr_reader :data
    attr_accessor :next

    def initialize(data)
      raise ArgumentError unless data

      @data = data
      @next = nil
    end

    def ==(other)
      @data == other.data
    end

    def to_s
      @data.to_s
    end
  end

  # Inserts a new item into the list.
  def <<(item)
    node = to_node(item)

    @head ? @tail.next = node : @head = node

    @tail = node
    self
  end

  # Inserts multiple items to the List
  def append(*items)
    items.each { |item| self.<<(item) }
    self
  end

  def self.append(*items)
    LinkedList.new.append(*items)
  end

  # Removes an item from the list.
  def remove(item)
    node = to_node(item)
    prev = find_prev(node)

    @head = head.next if node == @head

    @tail = prev if node == @tail

    prev.next = prev.next.next if prev
    self
  end

  # Removes all items form the list.
  def clear
    @head = nil
    @tail = nil
    self
  end

  # Concatenates a list at the end of the current list.
  def concat!(list)
    @tail.next = list.head
    @tail = list.tail
    self
  end

  # Finds first occurence of predicate.
  def find_first(item)
    node = to_node(item)

    find { |n| n == node }
  end

  # Enumerator
  def each
    return to_enum(:each) unless block_given?

    node = @head
    while node
      yield(node)
      node = node.next
    end

    self
  end

  def dup(list)
    nodes = list.map do |node|
      dup_node = node.dup
      dup_node.next = nil
      dup_node
    end
    LinkedList.append(*nodes)
  end

  # def last
  #   find { |n| n.next.nil? }
  # end

  # Prints the contents of the list.
  def to_s
    map(&:to_s).join('->')
  end

  private

  def to_node(data)
    return data if data.class == LinkedList::Node

    LinkedList::Node.new(data)
  end

  def find_prev(node)
    find { |n| n.next == node }
  end
end
