class CartodbQuery
  def self.remove(table_name)
    <<-SQL
      UPDATE #{table_name} SET toggle = true FROM (
        SELECT prev_phase, the_geom
        FROM #{table_name} g
        INNER JOIN (SELECT MAX(phase) AS max_phase FROM #{table_name} g) a ON g.phase = a.max_phase
      ) a
      WHERE #{table_name}.phase = a.prev_phase
        AND #{table_name}.toggle = false
        AND ST_Intersects(#{table_name}.the_geom, a.the_geom);

      DELETE FROM #{table_name} WHERE phase = (SELECT MAX(phase) FROM #{table_name});
    SQL
  end
end
