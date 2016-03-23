defmodule BigQuery.Types.Schema do
  defstruct fields: nil

  @type t :: %__MODULE__{
    fields: [SchemaField.t]
  }

  defmodule SchemaField do
    defstruct [:name, :type, :mode, :fields, :description]

    @type t :: %__MODULE__{
      name: String.t,
      type: String.t,
      mode: String.t,
      fields: [__MODULE__.t],
      description: String.t
    }
  end
end