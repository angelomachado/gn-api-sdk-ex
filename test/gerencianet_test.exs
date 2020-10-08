defmodule GerencianetTest do
  use ExUnit.Case, async: true

  test "endpoints where created" do
    assert is_function(&Gerencianet.Endpoints.get_plans/1)
  end
end
