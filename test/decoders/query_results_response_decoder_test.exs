defmodule BigQuery.Types.QueryResultsResponse.DecoderTest do
  use ExUnit.Case
  doctest BigQuery.Types.QueryResultsResponse

  alias BigQuery.Types.{Error, JobReference, QueryResultsResponse,
        QueryResultRow, Schema}

  test "result response with no errors" do
    response = %{"totalRows" => 0}
    expected = %QueryResultsResponse{totalRows: 0, errors: [], rows: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{errors: [%Error{}]})

    assert result == expected
  end

  test "result response with errors" do
    response = %{"totalRows" => 0, "errors" => [%{"reason" => "because"}]}
    expected = %QueryResultsResponse{totalRows: 0, errors: [%Error{reason: "because"}], rows: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{errors: [%Error{}]})

    assert result == expected
  end

  test "result response with no schema" do
    response = %{"totalRows" => 0}
    expected = %QueryResultsResponse{totalRows: 0, schema: nil, rows: [], errors: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{schema: %Schema{}})

    assert result == expected
  end

  test "result response with a schema" do
    response = %{"totalRows" => 0, "schema" => %{"fields" => []}}
    expected = %QueryResultsResponse{totalRows: 0, schema: %Schema{fields: []}, rows: [], errors: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{schema: %Schema{}})

    assert result == expected
  end
end