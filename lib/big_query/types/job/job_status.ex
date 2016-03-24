defmodule BigQuery.Types.JobStatus do
  alias BigQuery.Types.Error

  defstruct [:errors, :errorResult, :state]

  @type t :: %__MODULE__{
    errors: [Error.t],
    errorResult: Error.t,
    state: String.t
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.JobStatus do
  import DecoderHelpers
  alias BigQuery.Types.Error

  def decode(status, _options) do
    status
    |> decode_member_list(:errors, %Error{})
    |> decode_member(:errorResult, %Error{})
  end
end