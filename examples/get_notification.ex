defmodule Sample.Gerencianet.Service do
  def get_notification(token) do
    response = [params: %{token: token}]
    |> Gerencianet.Endpoints.get_notification()
    IO.inspect response
  end
end
