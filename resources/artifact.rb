property :endpoint, String, name_property: true
property :username, String
property :password, String
property :search_type, String, required: true
property :search, String, default: 'name'
property :repo, String, required: false
property :destination, String, default: Chef::Config['file_cache_path']
property :property_hash, String
property :download_path, identity: true, desired_state: false
property :checksums, desired_state: false, default: %w(md5 sha1)
default_action :search

include Artifactory::Resource

def set_artifactory
  Artifactory.configure do |config|
    config.endpoint = new_resource.endpoint
    config.username = new_resource.username
    config.password = new_resource.password
  end
end

def artifactory_checksum_search
  uri = Artifact.checksum_search(new_resource.search_type.to_sym => new_resource.seach).first.download_url
  uri
end

def artifactory_search
  uri = Artifact.seach(name: new_resource.search).first.download_url
  uri
end

def artifactory_property
end

action :search do
  set_artifactory
  uri = nil
  uri = artifactory_checksum_search if checksums.include?(search_type)
  uri = artifactory_search if search_type == 'name'
  log "Artifact search at #{new_resource.endpoint} for #{search_type}: #{search} returned no results" do
    log_level :error
    only_if uri.nil?
  end
  download_path
  remote_file download_path do
    source uri
    not_if uri.nil?
  end
end

action :update_property do
  set_artifactory
  artifactory_property
end
