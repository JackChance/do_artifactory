# do_artifactory
Series of resources for using artifactory with Chef

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
|checksums|Valid values for search_type (other than 'name')| default ['md5', 'sha1']| Array[String]

#### Actions

| Name | Description | Default?
| ---- | ----------- | --------
|:search|Find and download artifact by name or checksum, returns location downloaded to|Yes
|:update_properties|Search artifactory then merge the property_hash with the artifact's properties and save on Artifactory server. Requires property_hash to not be empty. Only adds or modifies|No

Usage

``` ruby
artifact = do_artifactory_artifact 'http://artifactory.mycompany.com' do
  username 'my_user'
  password 'my_password'
  search_type 'sha256'
  search '3915ed48d8764758bacb5aa9f15cd276'
  destination '/my_artifacts/this_artifact_type'
  checksums %w(sha256 sha1 md5)
end
artifact.run_action(:search)
# #run_action forces the resource to run during the compile step, populating its properties for use during the compile phase.
puts "artifact exists at #{artifact.download_path}"
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
``
