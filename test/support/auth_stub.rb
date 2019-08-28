module AuthStub

  # Yao::Resources::* のテストで Yao.default.pool の設定を都度都度 記述しなくていいよういするヘルパー
  # endpoint の URL がマチマチだとテストを記述するのが面倒なので example.com で統一している
  def stub_client
    auth_url = "http://example.com:12345"
    username = "yao"
    tenant   = "default"
    password = "password"

    stub_auth_request(auth_url, username, password, tenant)

    Yao.config.set :auth_url, auth_url
    Yao::Auth.new(tenant_name: tenant, username: username, password: password)

    client = Yao::Client.gen_client("https://example.com:12345")
    Yao.default_client.admin_pool["identity"] = client
    Yao.default_client.pool["network"]        = client
    Yao.default_client.pool["compute"]        = client
    Yao.default_client.pool["metering"]       = client
  end

  def stub_auth_request(auth_url, username, password, tenant)
    stub_request(:post, "#{auth_url}/tokens")
      .with(
        body: auth_json(username, password, tenant)
      ).to_return(
        status: 200,
        body: response_json(auth_url, username, tenant),
        headers: {'Content-Type' => 'application/json'}
      )
  end

  private

  def auth_json(username, password, tenant)
    json = <<-JSON
{"auth":{"passwordCredentials":{"username":"#{username}","password":"#{password}"},"tenantName":"#{tenant}"}}
    JSON

    json.strip
  end

  def response_json(auth_url, username, tenant)
    <<-JSON
{
  "access": {
    "token": {
      "issued_at": "#{Time.now.iso8601}",
      "expires": "#{(Time.now + 3600).utc.iso8601}",
      "id": "aaaa166533fd49f3b11b1cdce2430000",
      "tenant": {
        "description": "Testing",
        "enabled": true,
        "id": "aaaa166533fd49f3b11b1cdce2430000",
        "name": "#{tenant}"
      }
    },
    "serviceCatalog": [
      {
        "endpoints": [
          {
            "adminURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionOne",
            "internalURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9",
            "publicURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44"
          },
          {
            "adminURL": "https://global-endpoint.example.com/api/nova/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionTest",
            "internalURL": "http://192.168.10.52:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "id": "18df07456cda4af1a7031f0de68637ea",
            "publicURL": "https://global-endpoint.example.com/api/nova/b598bf98671c47e1b955f8c9660e3c44"
          }
        ],
        "endpoints_links": [],
        "type": "compute",
        "name": "nova"
      },
      {
        "endpoints": [
          {
            "adminURL": "http://neutron-endpoint.example.com:9696/",
            "region": "RegionOne",
            "internalURL": "http://neutron-endpoint.example.com:9696/",
            "id": "0418104da877468ca65d739142fa3454",
            "publicURL": "http://neutron-endpoint.example.com:9696/"
          },
          {
            "adminURL": "https://global-endpoint.example.com/api/neutron/",
            "region": "RegionTest",
            "internalURL": "http://192.168.10.53:9696/",
            "id": "5e5cf4ffecfa4ce1a956fe517baf3154",
            "publicURL": "https://global-endpoint.example.com/api/neutron/"
          }
        ],
        "endpoints_links": [],
        "type": "network",
        "name": "neutron"
      },
      {
        "endpoints": [
          {
            "adminURL": "http://glance-endpoint.example.com:9292",
            "region": "RegionOne",
            "internalURL": "http://glance-endpoint.example.com:9292",
            "id": "246f33509ff64802b86eb081307ecec0",
            "publicURL": "http://glance-endpoint.example.com:9292"
          },
          {
            "adminURL": "https://global-endpoint.example.com/api/glance/",
            "region": "RegionTest",
            "internalURL": "http://192.168.10.54:9292/",
            "id": "62d6f676ff0c491e9671a7ab6a596493",
            "publicURL": "https://global-endpoint.example.com/api/glance/"
          }
        ],
        "endpoints_links": [],
        "type": "image",
        "name": "glance"
      },
      {
        "endpoints": [
          {
            "adminURL": "#{auth_url}",
            "region": "RegionOne",
            "internalURL": "http://endpoint.example.com:5000/v2.0",
            "id": "2b982236cc084128bf42b647c1b7fb49",
            "publicURL": "http://endpoint.example.com:5000/v2.0"
          },
          {
            "adminURL": "https://global-endpoint.example.com/api/admin/keystone/",
            "region": "RegionTest",
            "internalURL": "http://192.168.10.52:35357/v2.0",
            "id": "11ae249e090d4b548ae992c08ea3b35a",
            "publicURL": "https://global-endpoint.example.com/api/keystone/"
          }
        ],
        "endpoints_links": [],
        "type": "identity",
        "name": "keystone"
      },
      {
        "endpoints": [
          {
            "adminURL": "#{auth_url}",
            "region": "RegionOne",
            "internalURL": "http://endpoint.example.com:9876",
            "id": "bde3abca8864400a809f0089f025370a",
            "publicURL": "http://endpoint.example.com:9876"
          },
          {
            "adminURL": "https://global-endpoint.example.com/api/octavia/",
            "region": "RegionTest",
            "internalURL": "http://192.168.10.52:9876",
            "id": "2c3197eb24ef433eb5d9386c46ff1eb0",
            "publicURL": "https://global-endpoint.example.com/api/octavia/"
          }
        ],
        "endpoints_links": [],
        "type": "load-balancer",
        "name": "octavia"
      }
    ],
    "user": {
      "username": "#{username}",
      "roles_links": [],
      "id": "a9994b2dee82423da7da572397d3157a",
      "roles": [
        {
          "name": "admin"
        }
      ],
      "name": "#{username}"
    },
    "metadata": {
      "is_admin": 0,
      "roles": [
        "ce5330c512cc4bd289b3a725ad1106b7"
      ]
    }
  }
}
    JSON
  end
end
