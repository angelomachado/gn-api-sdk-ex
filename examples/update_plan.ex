defmodule Sample.Gerencianet.Service do
  def update_plan do
    response = [params: %{id: 1}, body: %{name: "Updated name"}]
    |> Gerencianet.Endpoints.update_plan()
    IO.inspect reponse
  end
end
