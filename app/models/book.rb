class Book < ActiveRecord::Base
  scope :slow, select("DISTINCT(books.id), books.*").
    joins("LEFT JOIN (SELECT * FROM books) AS books1
                  ON books.id = books1.id
               WHERE books.published_at IS NULL")
end

# == Schema Information
#
# Table name: books
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  published_at :datetime
#

