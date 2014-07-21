csv_datsource_path = './stock-datasources/Azteca BAS.csv'

# the row is assumend to be an array
def is_row_empty(row)
  return row.all? { |item| item == nil }
end

# --------------------------------------------------------------------------------------------

require 'csv'
require 'date'

counter = 1
test_row = nil

CSV.foreach(csv_datsource_path) do |row|

  if counter == 15
    test_row = row
    break
  end

  # puts("#{counter} \t #{row.inspect}")
  counter += 1
end

# puts(test_row)
date_str = test_row[0]

splitted = date_str.split('/')
month= splitted[0].to_i()
day = splitted[1].to_i()
year = splitted[2].to_i()

puts(year)
puts(month)
puts(day)

date = Date.new(year, month, day)
puts(date)

puts('----------------------------------------------------------------------------------')

# --------------------------------------------------------------------------------------------

h = Hash.new()
h[0] = 1
h[1] = 2
h[2] = 3

puts(h.has_key?(5))
puts(h.has_key?(0))

puts(h.has_value?(0))
puts(h.has_value?(1))

puts(h.keys)
puts(h.values)

puts('----------------------------------------------------------------------------------')

# -------------------------------------------------------------------------------------------

require 'set'

s1 = Set.new(h.keys)
s2 = Set.new(h.values)

s3 = s1.union(s2)

s3.each { |item| puts(item) }

puts('----------------------------------------------------------------------------------')

# -------------------------------------------------------------------------------------------

class X

  public
    @@my_class_var = 5.13



end

x = X.my_class_var
puts(x)