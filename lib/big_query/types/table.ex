defmodule BigQuery.Types.Table do
  alias BigQuery.Types.{Schema, TableReference}

  defstruct kind: "bigquery#table", etag: nil, id: nil, selfLink: nil,
            tableReference: nil, friendlyName: nil, description: nil,
            schema: nil, numBytes: nil, numRows: nil, creationTime: nil,
            expirationTime: nil, lastModifiedTime: nil, type: nil, view: nil,
            externalDataConfiguration: nil, location: nil, streamingBuffer: nil

  @type t :: %__MODULE__{
    creationTime: non_neg_integer,
    description: String.t,
    etag: String.t,
    expirationTime: non_neg_integer,
    externalDataConfiguration: map(),
    friendlyName: String.t,
    id: String.t,
    kind: String.t,
    lastModifiedTime: non_neg_integer,
    location: String.t,
    numBytes: non_neg_integer,
    numRows: non_neg_integer,
    schema: Schema.t,
    selfLink: String.t,
    streamingBuffer: map(),
    tableReference: TableReference.t,
    type: String.t,
    view: map()
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.Table do
  import DecoderHelpers

  alias BigQuery.Types.{Schema, TableReference}

  def decode(table, _options) do
    table
    |> decode_member(:schema, %Schema{})
    |> decode_member(:tableReference, %TableReference{})
  end
end

defmodule BigQuery.Types.TableList do
  alias BigQuery.Types.Table

  defstruct kind: "bigquery#tableList", etag: nil, nextPageToken: nil,
            tables: nil, totalItems: nil

  @type t :: %__MODULE__{
    kind: String.t,
    etag: String.t,
    nextPageToken: String.t,
    tables: [Table.t],
    totalItems: non_neg_integer
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.TableList do
  import DecoderHelpers

  alias BigQuery.Types.Table

  def decode(table_list, _options) do
    table_list
    |> decode_member_list(:tables, %Table{})
  end
end