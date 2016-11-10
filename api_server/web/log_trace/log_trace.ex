defmodule ApiServer.LogTrace do
  alias Plug.Conn

  def init(opts) do
    log_level = Keyword.get(opts, :log_level) || raise_missing_log_level()
  end

  def call(conn, _opts) do
    log_trace = create_log_data conn
    conn = Conn.assign conn, :log_trace, log_trace

    Conn.register_before_send(conn, fn conn ->
      IO.inspect conn.assigns
      conn
    end)
  end

  def add(conn, level, title, content) do
    %{log_trace: log_trace} = conn.assigns
    log_trace = log_trace ++ [
      %{level: level,
        title: title,
        content: content}
    ]
    Conn.assign conn, :log_trace, log_trace
  end


  @doc """
  Create initial log data
  """
  defp create_log_data(conn) do
    correlation_id = Conn.get_req_header(conn, "correlationId") ||
      Conn.get_req_header(conn, "correlationid") ||
      Conn.get_req_header(conn, "correlation_id") ||
      Conn.get_req_header(conn, "correlation-id") ||
      UUID.uuid4()
    started_at = :os.system_time(:milli_seconds)

    %{
      correlation_id: correlation_id,
      started_at: started_at,
      messages: []
    }
  end

  defp raise_missing_log_level do
    raise ArgumentError, "ApiServer.LogTrace expects log_level to be set"
  end

end
