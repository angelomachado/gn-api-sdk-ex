defmodule Sample.Gerencianet.Service do
  def create_subscription do
    response = Gerencianet.Endpoints.create_subscription([
      params: %{id: 1},
      body: %{
        items: [
          %{
            name: "Subscription name",
            value: 600,
            amount: 1
            }
        ],
        metadata: %{notification_url: "https://example.org/callback/notification"}
      }
    ])
  end
end
