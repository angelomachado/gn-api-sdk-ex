defmodule Sample.Gerencianet.Service do
  def delete_plan(id) do
    response = [params: %{id: id}]
    |> Gerencianet.Endpoints.delete_plan()
    IO.inspect reponse
  end
end
