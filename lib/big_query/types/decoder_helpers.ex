defmodule DecoderHelpers do
  @spec decode_member_list(struct, atom, any):: struct
  def decode_member_list(qrr, key, as) do
    list = Map.get(qrr, key) || []
    new_list = Enum.map(list, fn (elem) ->
      Poison.Decode.decode(elem, as: as)
    end)

    Map.put(qrr, key, new_list)
  end

  @spec decode_member(struct, atom, any) :: struct
  def decode_member(qrr, key, as) do
    result = case Map.get(qrr, key) do
      nil -> nil
      other -> Poison.Decode.decode(other, as: as)
    end

    Map.put(qrr, key, result)
  end
end