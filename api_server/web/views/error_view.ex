defmodule ApiServer.ErrorView do
  use ApiServer.Web, :view

  def render(_error, assigns) do
    assigns.reason.message
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
