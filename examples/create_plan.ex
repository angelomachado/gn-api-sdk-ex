defmodule Sample.Gerencianet.Service do
  def create_plan do
    response = [body: %{name: "Plan", interval: 2, repeats: 2}]
    |> Gerencianet.Endpoints.create_plan()
    IO.inspect response
  end
end
