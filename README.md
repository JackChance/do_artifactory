# artifactory_do
Series of resources for using artifactory with Chef

Tested on:
* Windows 2012r2
## resources

### artifact

Properties
* endpoint - artifactory server url, name property, String
* username - artifactory credentials - username, optional, String
* password - artifactory credentials - password, optional, String
* search_type - Search type to find artifact. Valid properties are 'name' or any value contained in property checksums, String
* search - search term to find artifact. Either the name or checksum, as specified by search_type, String
* destination - Directory for artifact to be downloaded to, defaults to Chef::Config['file_cache_path']
* property_hash - Hash of properties to add or replace if they already exist, optional, Hash
* download_path - Location artifact is downloaded to, Identity.
* checksums - valid values for search_type (other than 'name'), Array[String], default ['md5', 'sha1']

Actions

* :search - find and download artifact by name or checksum, returns location downloaded to, default Actions
* :update_properties - find artifact by name or checksum and merge the property_hash with the artifact's properties then save on artifactory server. Requires property_hash to not be empty. Only adds or modifies.

Usage

``` ruby
artifact_location = artifactory_do_artifact 'http://artifactory.mycompany.com' do
  username 'my_user'
  password 'my_password'
  search_type 'sha256'
  search '3915ed48d8764758bacb5aa9f15cd276'
  destination '/my_artifacts/this_artifact_type'
  checksums %w(sha256 sha1 md5)
end

puts "artifact exists at #{artifact_location.destination}"
```

```ruby
artifactory_do_artifact 'http://artifactory.mycompany.com' do
  username 'my_user'
  password 'my_password'
  search_type 'sha256'
  search '3915ed48d8764758bacb5aa9f15cd276'
  property_hash {'chef.cookbook.download_date' => Time.now.utc, 'it.hasbeen.downloaded' => 'true'}
  checksums %w(sha256 sha1 md5)
  action :update_properties
end
```

### gem

Properties
* version - Version of the gem or 'latest', String, name property
* source - Source of the gem, String, Optional

Actions
* :install - Installs the artifactory gem and makes it ready for use immediately at compile time
* :remove - Uninstalls the artifactory gem

Usage

```ruby
artifactory_do_gem 'latest' do
  source '/my/local/gem/dl'
end
```
```ruby
artifactory_do_gem '2.3.0'do
  :remove
end
```
