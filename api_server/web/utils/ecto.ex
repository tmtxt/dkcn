defmodule ApiServer.EctoUtil do

  @doc """
  Convert an error Ecto.Changeset's errors to json-able map
  """
  def errors_to_map(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)
    end)
  end

end
