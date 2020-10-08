defmodule Gerencianet.Converter do
  def to_boolean!(nil), do: false
  def to_boolean!(""), do: false
  def to_boolean!("false"), do: false
  def to_boolean!("true"), do: true
  def to_boolean!("0"), do: false
  def to_boolean!("1"), do: true
  def to_boolean!(:true), do: true
  def to_boolean!(:false), do: false
  def to_boolean!(_), do: false
  def to_string!(nil), do: ""
  def to_string!(num) when is_integer(num), do: Integer.to_string(num)
  def to_string!(any), do: any
end
