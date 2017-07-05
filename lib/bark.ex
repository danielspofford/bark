defmodule Bark do
  @moduledoc """
  Facilitates rich and convenient logging.
  """

  @typedoc """
  A binary or a function that evaluates to a binary.
  """
  @type log_msg :: binary() | fun()

  @typedoc """
  A `{module, function, args}` tuple like `{String, :replace_suffix, ["\n", ""]}` or an anonymous function of any arity that returns a binary. If the function takes any arguments the first it will be passed will be the binary result of the relevant log_msg.
  """
  @type option :: (... -> msg :: binary()) | {module(), atom(), list()}

  defmacro __using__(_opts) do
    quote do
      require Logger

      @default_options [{String, :replace_suffix, ["\n", ""]}]

      @doc """
      Logs a debug message.

      Returns the atom `:ok` or an `{:error, reason}` tuple.
      """
      @spec log_d(log_msg :: Bark.log_msg, options :: [Bark.option]) :: msg :: binary() | {:error, any()}
      def log_d(log_msg, options \\ @default_options),
        do: {__MODULE__, log_msg} |> Bark.resolve_message(options) |> Logger.debug

      @doc """
      Logs an info message.

      Returns the atom `:ok` or an `{:error, reason}` tuple.
      """
      @spec log_i(log_msg :: Bark.log_msg, options :: [Bark.option]) :: msg :: binary() | {:error, any()}
      def log_i(log_msg, options \\ @default_options),
        do: {__MODULE__, log_msg} |> Bark.resolve_message(options) |> Logger.info

      @doc """
      Logs an error message.

      Returns the atom `:ok` or an `{:error, reason}` tuple.
      """
      @spec log_w(log_msg :: Bark.log_msg, options :: [Bark.option]) :: msg :: binary() | {:error, any()}
      def log_w(log_msg, options \\ @default_options),
        do: {__MODULE__, log_msg} |> Bark.resolve_message(options) |> Logger.warn

      @doc """
      Logs a warning message.

      Returns the atom `:ok` or an `{:error, reason}` tuple.
      """
      @spec log_e(log_msg :: Bark.log_msg, options :: [Bark.option]) :: msg :: binary() | {:error, any()}
      def log_e(log_msg, options \\ @default_options),
        do: {__MODULE__, log_msg} |> Bark.resolve_message(options) |> Logger.error
    end
  end

  def resolve_message({module, log_msg}, options) do
    fn ->
      log_msg
      |> expand()
      |> prefix(module)
      |> apply_options(options)
    end
  end

  defp expand(log_msg) when is_function(log_msg), do: log_msg.()

  defp expand(log_msg) when is_binary(log_msg), do: log_msg

  defp prefix(msg, module), do: "#{module} | (#{inspect self()}) | " <>  msg

  defp apply_options(msg, []), do: msg

  defp apply_options(msg, options), do: Enum.reduce(options, msg, &apply_option/2)

  defp apply_option({fun, args}, msg), do: apply(fun, [msg | args])

  defp apply_option({module, fun, args}, msg), do: apply(module, fun, [msg | args])
end
