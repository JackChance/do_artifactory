property :endpoint, String, name_property: true
property :username, String
property :password, String
property :checksum_type, String
property :checksum, String
property :gvac, String
property :name, String
property :repo, String
property :property_name, String
property :property_value, String
default_action :search

action :search do
end

action :update_property do
end
