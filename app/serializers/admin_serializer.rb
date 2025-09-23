class AdminSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at

  # Exclude password fields
end