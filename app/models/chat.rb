class Chat < ApplicationRecord
  belongs_to :sender, classname: User.name
  belongs_to :receiver, classname: User.name
end
