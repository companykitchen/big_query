defmodule BigQuery.Types.QueryResultsResponse.DecoderTest do
  use ExUnit.Case
  doctest BigQuery.Types.QueryResultsResponse

  alias BigQuery.Types.{Error, QueryResultsResponse, QueryResultCell, 
        QueryResultRow, Schema}

  test "result response with no errors" do
    response = %{"totalRows" => 0}
    expected = %QueryResultsResponse{totalRows: 0, errors: [], rows: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end

  test "result response with errors" do
    response = %{"totalRows" => 0, "errors" => [%{"reason" => "because"}]}
    expected = %QueryResultsResponse{totalRows: 0, errors: [%Error{reason: "because"}], rows: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end

  test "result response with no schema" do
    response = %{"totalRows" => 0}
    expected = %QueryResultsResponse{totalRows: 0, schema: nil, rows: [], errors: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end

  test "result response with a schema" do
    response = %{"totalRows" => 0, "schema" => %{"fields" => []}}
    expected = %QueryResultsResponse{totalRows: 0, schema: %Schema{fields: []}, rows: [], errors: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end

  test "result response with no rows" do
    response = %{"totalRows" => 0}
    expected = %QueryResultsResponse{totalRows: 0, rows: [], errors: []}
    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end

  test "result response with rows" do
    response = %{"totalRows" => 2, "rows" => [
      %{"f" => [%{"v" => true}, %{"v" => 1.23}, %{"v" => 11}, %{"v" => "hello"}]},
      %{"f" => [%{"v" => false}]}
    ]}
    expected = %QueryResultsResponse{totalRows: 2, rows: [
      %QueryResultRow{f: [%QueryResultCell{v: true}, %QueryResultCell{v: 1.23}, %QueryResultCell{v: 11}, %QueryResultCell{v: "hello"}]},
      %QueryResultRow{f: [%QueryResultCell{v: false}]}], errors: []}

    result = Poison.Decode.decode(response, as: %QueryResultsResponse{})

    assert result == expected
  end
end