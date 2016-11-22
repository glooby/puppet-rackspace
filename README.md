# puppet-rackspace

Puppet module to manage cloudmonitoring and cloudbackup services

## Module Installation

* Add the 'rackspace' folder into your module path
* Include the class and configure the relevant variables for your Rackspace account:
* __username__ - your rackspace cloud username
* __api_key__ - found under Your Account > API Access here: https://manage.rackspacecloud.com/APIAccess.do

```ruby
class { 'rackspace':
    cloudbackup_install => true,
    cloudmonitoring_install => true,
    username => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    api_key  => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
}
```

Contributing
------------

See
[CONTRIBUTING](https://github.com/glooby/debug-bundle/blob/master/CONTRIBUTING.md)
file.

License
-------

This bundle is released under the MIT license. See the complete license in the
bundle: [LICENSE.md](https://github.com/glooby/debug-bundle/blob/master/LICENSE.md)

[www.glooby.com](https://www.glooby.com)
[www.glooby.se](https://www.glooby.se)
