class TestKeypair < TestYaoResource

  def test_keypair
    # https://docs.openstack.org/api-ref/compute/?expanded=list-keypairs-detail#list-keypairs
    params = {
      "fingerprint" => "7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd",
      "name" => "keypair-5d935425-31d5-48a7-a0f1-e76e9813f2c3",
      "type" => "ssh",
      "public_key" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkF3MX59OrlBs3dH5CU7lNmvpbrgZxSpyGjlnE8Flkirnc/Up22lpjznoxqeoTAwTW034k7Dz6aYIrZGmQwe2TkE084yqvlj45Dkyoj95fW/sZacm0cZNuL69EObEGHdprfGJQajrpz22NQoCD8TFB8Wv+8om9NH9Le6s+WPe98WC77KLw8qgfQsbIey+JawPWl4O67ZdL5xrypuRjfIPWjgy/VH85IXg/Z/GONZ2nxHgSShMkwqSFECAC5L3PHB+0+/12M/iikdatFSVGjpuHvkLOs3oe7m6HlOfluSJ85BzLWBbvva93qkGmLg4ZAc8rPh2O+YIsBUHNLLMM/oQp Generated-by-Nova\n"
    }

    keypair = Yao::Keypair.new(params)

    # friendly_attributes
    assert_equal("keypair-5d935425-31d5-48a7-a0f1-e76e9813f2c3", keypair.name)
    assert_equal("7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd", keypair.fingerprint)
    assert_equal(<<EOS, keypair.public_key)
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkF3MX59OrlBs3dH5CU7lNmvpbrgZxSpyGjlnE8Flkirnc/Up22lpjznoxqeoTAwTW034k7Dz6aYIrZGmQwe2TkE084yqvlj45Dkyoj95fW/sZacm0cZNuL69EObEGHdprfGJQajrpz22NQoCD8TFB8Wv+8om9NH9Le6s+WPe98WC77KLw8qgfQsbIey+JawPWl4O67ZdL5xrypuRjfIPWjgy/VH85IXg/Z/GONZ2nxHgSShMkwqSFECAC5L3PHB+0+/12M/iikdatFSVGjpuHvkLOs3oe7m6HlOfluSJ85BzLWBbvva93qkGmLg4ZAc8rPh2O+YIsBUHNLLMM/oQp Generated-by-Nova
EOS
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/os-keypairs")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
            "keypairs": [
                {
                    "keypair": {
                      "fingerprint": "7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd",
                      "name": "keypair-5d935425-31d5-48a7-a0f1-e76e9813f2c3",
                      "type": "ssh",
                "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkF3MX59OrlBs3dH5CU7lNmvpbrgZxSpyGjlnE8Flkirnc/Up22lpjznoxqeoTAwTW034k7Dz6aYIrZGmQwe2TkE084yqvlj45Dkyoj95fW/sZacm0cZNuL69EObEGHdprfGJQajrpz22NQoCD8TFB8Wv+8om9NH9Le6s+WPe98WC77KLw8qgfQsbIey+JawPWl4O67ZdL5xrypuRjfIPWjgy/VH85IXg/Z/GONZ2nxHgSShMkwqSFECAC5L3PHB+0+/12M/iikdatFSVGjpuHvkLOs3oe7m6HlOfluSJ85BzLWBbvva93qkGmLg4ZAc8rPh2O+YIsBUHNLLMM/oQp Generated-by-Nova\\n"
                    }
                }
            ],
            "keypairs_links": [
                {
                }
            ]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    keypairs = Yao::Keypair.list
    assert_equal("7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd", keypairs.first.fingerprint)
    assert_requested(stub)
  end
end
