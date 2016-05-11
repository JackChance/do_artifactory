# do_artifactory
Series of resources for using artifactory with Chef

Tested on:
* Windows 2012r2
* Oel 6.5

## Resources
### artifact
#### Properties

| Name | Description | Property Modifiers | Type
| ---- | ----------- | ------------------ | ----
|endpoint|Artifactory server url|name property|String
|username|Artifactory credentials, username|optional|String
|password|Artifactory credentials, password|optional|String
|search_type|Search type to find artifact. Valid properties are 'name' or any value contained in property checksums|n/a|String
|search|Search term to find artifact. Either the name or checksum, as specified by search_type|n/a| String
|destination|Directory for artifact to be downloaded to|default: Chef::Config['file_cache_path']|String
|property_hash|Hash of properties to add or replace if they already exist|optional|Hash{String => String}
|download_path|Location artifact is downloaded to|Identity|String
|checksums|Valid values for search_type (other than 'name')| Array[String]| default ['md5', 'sha1']

#### Actions

| Name | Description | Default?
| ---- | ----------- | --------
|:search|Find and download artifact by name or checksum, returns location downloaded to|Yes
|:update_properties|Search artifactory then merge the property_hash with the artifact's properties and save on Artifactory server. Requires property_hash to not be empty. Only adds or modifies|No

Usage

``` ruby
artifact_location = do_artifactory_artifact 'http://artifactory.mycompany.com' do
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
do_artifactory_artifact 'http://artifactory.mycompany.com' do
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
#### Properties

| Name | Description | Property Modifiers | Type
| ---- | ----------- | ------------------ | ----
|version|Version of the gem or 'latest'|name property| String
|source|Source of the gem|Optional|String

#### Actions

| Name | Description | Default?
| ---- | ----------- | --------
|:install|Installs the artifactory gem and makes it ready for use immediately at compile time|Yes
|:remove|Uninstalls the artifactory gem|No

Usage

```ruby
do_artifactory_gem 'latest' do
  source '/my/local/gem/dl'
end
```
```ruby
do_artifactory_gem '2.3.0'do
  :remove
end
```
