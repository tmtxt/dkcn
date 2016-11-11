defmodule ApiServer.Util do

  @doc """
  Convert a map to a specified struct
  to_struct $User{}, params
  """
  def to_struct(kind, attrs) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  @doc """
  Response a map to json, convert key to camelCase
  """
  def json(conn, map) do
    IO.puts "--------------------------------------------------------------------------------"
    map = ProperCase.to_camel_case map
    Phoenix.Controller.json conn, map
  end
end
