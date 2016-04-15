property :version, String, name_property: true
property :source, String, default: nil
default_action :install

action :install do
  chef_gem 'artifactory' do
    version new_resource.version
    source new_resource.source unless new_resource.source.nil?
  end
end

action :remove do
  chef_gem 'artifactory' do
    action :remove
  end
end
