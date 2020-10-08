defmodule Sample.Gerencianet.Service do
  def pay_subscription do
    trial_end = DateTime.add(DateTime.utc_now, 7*24*60*60, :second)
    expire_at = [trial_end.year, trial_end.month, trial_end.day]
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.pad_leading(&1, 2, "0"))
    |> Enum.join("-")

    payment_info = %{
      payment: %{
        banking_billet: %{
          customer: %{
            email: "user@example.org",
            phone_number: "9999999999",
            juridical_person: %{
              corporate_name: "Company Name",
              cnpj: "00000000000000"
            }
          },
          expire_at: expire_at
        }
      }
    }

    response = Gerencianet.Endpoints.pay_subscription([
      params: %{id: 1},
      body: payment_info
    ])
  end
end
