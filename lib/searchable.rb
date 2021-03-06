require_relative 'db_connection'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?" }.join(' AND ')

    parse_all(DBConnection.execute(<<-SQL, *params.values))
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
  end

  def find_by(params)
    where(params)
  end
end
