defmodule BarkTest do
  use ExUnit.Case
  use Bark

  test "levels" do
    assert log_d("msg") == :ok
    assert log_i("msg") == :ok
    assert log_w("msg") == :ok
    assert log_e("msg") == :ok
  end
end
