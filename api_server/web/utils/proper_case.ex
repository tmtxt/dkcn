defmodule ApiServer.ProperCase do
  alias Plug.Conn

  def init(_) do
    false
  end

  def call(%{params: params} = conn, _opts) do
    conn = %{conn | params: ProperCase.to_snake_case(params)}
    Conn.register_before_send(conn, fn conn ->
      IO.inspect conn.resp_headers
      conn
    end)
  end

end
