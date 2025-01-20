# test/models/jwt_denylist_test.rb
require 'test_helper'

class JwtDenylistTest < ActiveSupport::TestCase
  test "should be valid with jti and exp" do
    jwt_denylist = JwtDenylist.new(jti: "some_unique_id", exp: Time.now + 1.hour)
    assert jwt_denylist.valid?
  end

  test "should not allow duplicate jti" do
    JwtDenylist.create(jti: "some_unique_id", exp: Time.now + 1.hour)
    jwt_denylist = JwtDenylist.new(jti: "some_unique_id", exp: Time.now + 1.hour)
    assert_not jwt_denylist.valid?
  end

  test "expired scope should return expired tokens" do
    expired_token = JwtDenylist.create(jti: "expired_jti", exp: Time.now - 1.hour)
    valid_token = JwtDenylist.create(jti: "valid_jti", exp: Time.now + 1.hour)
    
    assert_includes JwtDenylist.expired, expired_token
    assert_not_includes JwtDenylist.expired, valid_token
  end
end
