class Person
  include MongoMapper::Document

  key :name, String
  key :age, Integer
  key :zipcode, String

end
