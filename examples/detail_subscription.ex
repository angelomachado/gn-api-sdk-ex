defmodule Sample.Gerencianet.Service do
  def detail_subscription(id) do
    response = [params: %{id: id}]
    |> Gerencianet.Endpoints.detail_subscription()
    IO.inspect response
  end
end
