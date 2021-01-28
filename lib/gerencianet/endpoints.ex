defmodule Gerencianet.Endpoints do
  @urls Gerencianet.Constants.url()
  @sandbox true
  @endpoints Gerencianet.Constants.endpoints()

  @endpoints
    |> Map.keys
    |> Enum.map(fn endpoint ->
      def unquote(endpoint)(options \\ []) do
        %{params: params, body: body} = [params: %{}, body: %{}]
          |> Keyword.merge(options)
          |> Enum.into(%{})

        settings = Map.get(@endpoints, unquote(endpoint))
        apply(__MODULE__, :create_request, [params, body, settings])
      end
    end
    )

  def create_request(params, body, settings) do
    if get_env(:access_token) == nil do
      authenticate()
    end

    case make_request(params, body, settings)
    do
      {:ok, %HTTPoison.Response{body: _, headers: _, status_code: 401}} ->
        authenticate()
        create_request(params, body, settings)
      {:ok, response} ->
        Poison.decode!(response.body)
    end
  end

  defp make_request(params, body, settings) do
    url = get_url(params, settings[:route])

    HTTPoison.start
    case settings[:method] do
      "get" ->
        HTTPoison.get(url, headers(get_env(:access_token)))
      "post" ->
        HTTPoison.post(url, Poison.encode!(body), headers(get_env(:access_token)))
      "put" ->
        HTTPoison.put(url, Poison.encode!(body), headers(get_env(:access_token)))
      "delete" ->
        HTTPoison.delete(url, headers(get_env(:access_token)))
    end
  end

  defp authenticate do
    HTTPoison.start
    response = get_url(%{}, @endpoints[:authorize][:route])
    |> HTTPoison.post(auth_body(), headers(), [hackney: [basic_auth: {get_env(:client_id), get_env(:client_secret)}]])

    case response do
      {:ok, %HTTPoison.Response{body: _body, headers: _headers, request: _request, request_url: _request_url, status_code: 401}} ->
        "unable to authenticate"
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: _}} ->
        access_token = Poison.decode!(body)
          |> Map.get("access_token")
        Application.put_env(:gerencianet, :access_token, access_token)
    end
  end

  defp headers(token) do
    Map.merge(headers(), %{"Authorization" => "Bearer #{token}"})
  end

  defp headers do
    %{"Content-Type" => "application/json"}
  end

  defp auth_body do
    "{\"grant_type\":\"client_credentials\"}"
  end

  defp get_env(key, defaults \\ nil) do
    Application.get_env(:gerencianet, key, defaults)
  end

  defp get_url(params, route) do
    full_url(params, remove_placeholders(params, route))
  end

  defp remove_placeholders(params, route) do
    if params == %{} do
      route
    else
      params
        |> Map.keys
        |> Enum.reduce(route, fn key, r ->
          String.replace(r, ":#{key}", Gerencianet.Converter.to_string!(params[key]))
        end)
    end
  end

  def full_url(params, route) do
    mapped = URI.encode_query(params)

    if mapped != "" do
      "#{current_base_url()}#{route}?#{mapped}"
    else
      "#{current_base_url()}#{route}"
    end
  end

  def current_base_url do
    sandbox = get_env(:sandbox, @sandbox)
      |> Gerencianet.Converter.to_boolean!()

    if (sandbox) do
      @urls[:sandbox]
    else
      @urls[:production]
    end
  end
end
