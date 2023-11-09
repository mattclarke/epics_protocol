defmodule ConnectionValidationTest do
  use ExUnit.Case

  test "decode validation request" do
    request = "hello"
    assert Epics.ConnectionValidation.decode_request(request) == %Epics.ConnectionValidation{}
  end
end
