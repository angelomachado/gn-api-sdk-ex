defmodule Sample.Gerencianet.Service do
  def detail_charge(id) do
    response = [params: %{id: id}]
    |> Gerencianet.Endpoints.detail_charge()
    IO.inspect response
  end
end
