lwrp_dsl Cookbook
=================
This cookbook lets you run Resources/Providers in Chef via an attributes DSL.

Requirements
------------
This cookbook has no requirements.

Attributes
----------

#### lwrp_dsl::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>'run_list'</tt></td>
    <td>Array</td>
    <td>This contains the list of instructions that will be run in the default recipe of this cookbook. Look below for more information</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

Usage
-----
#### lwrp_dsl::default
A classic example would be installing `grunt` or `bower`.
To do that, normally you'd have to add the `nodejs` cookbook to your chef server and then create a new empty cookbook to access the `nodejs_npm` resource.
This cookbook works around this pesky task, so instead you can just adjust your JSON-attributes (e.g. in Vagrant):

```ruby
chef.json = {
  "lwrp_dsl" => {
    "run_list" => [
      ["nodejs_npm", "grunt"],
      ["nodejs_npm", "bower"]
    ]
  }
}
```

evaluates to (note that the order is preserved):

```ruby
nodejs_npm "grunt"
nodejs_npm "bower"
```

You can also pass a Ruby-Hash as the third argument. It will be executed in the ruby block, e.g.:

```ruby
chef.json = {
  "lwrp_dsl" => {
    "run_list" => [
      [
        "docker_image", "webhippie/nginx", { 
          source: "/vagrant/docker-nginx",
          action: :build,
          cmd_timeout: 3600 
        }
      ],
      [
        "docker_container", "webhippie/nginx", {
          container_name: "nginx",
          cmd_timeout: 600,
          port: [
            "80:80",
            "443:443"
          ]
        }
      ]
    ]
  }
}
```

evaluates to:

```ruby
docker_image "webhippie/nginx" do
  source "/vagrant/docker-nginx"
  action :build
  cmd_timeout 3600
end

docker_container "webhippie/nginx" do
  container_name "nginx"
  cmd_timeout 600
  port ["80:80", "443:443"]
end
```

The array 'port' is passed as is, so for attributes / methods that take multiple arguments (e.g. `notifies`),
we can use an array instead of a Ruby Hash as the following example shows.

```ruby
chef.json = {
  "lwrp_dsl" => {
    "run_list" => [
      [
        "docker_container", "webhippie/nginx", [
          [:container_name, "nginx"],
          [:port, ["80:80", "443:443"]],
          [:notifies, :restart, "service[jenkins]", :immediately]
        ] 
      ]
    ]
  }
}
```

evaluates to:

```ruby
docker_container "webhippie/nginx" do
  container_name "nginx"
  port ["80:80", "443:443"]
  notifies :restart, "service[jenkins]", :immediately
end
```

Note that the latter array-approach allows multiple calls to the same method as opposed to the Hash approach.


What this cookbook DOESN'T do
-----------------------------
Using this cookbook, we cannot embed Ruby code that is evaluated at runtime.
This cookbook only allows passing JSON Objects to the resources vide supra.


Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Danyel Bayraktar