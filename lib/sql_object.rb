require_relative 'db_connection'
require_relative 'searchable'
require 'active_support/inflector'

class SQLObject
  extend Searchable

  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2("SELECT * FROM #{self.table_name}").first
    cols.map!(&:to_sym)

    @columns = cols
  end

  def self.finalize!
    self.columns.each do |name|
      define_method("#{name}=") do |val|
        self.attributes[name] = val
      end

      define_method("#{name}") do
        self.attributes[name]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    parse_all(DBConnection.execute("SELECT * FROM #{table_name}"))
  end

  def self.parse_all(results)
    results.map { |value_hash| self.new(value_hash) }
  end

  def self.find(id)
    results = (DBConnection.execute(<<-SQL, id: id))
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = :id
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| send(attr) }
  end

  def insert
    columns = self.class.columns.drop(1)
    col_names = columns.map(&:to_s).join(', ')
    question_marks = (['?'] * columns.count).join(', ')

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id =  DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns.map {|attr| "#{attr} = ?"}.join(', ')

    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
