lz = (v) ->
  return v if v > 9
  "0#{v}"

export default {
  in: (date) ->
    new Date(date)

  out: (value) ->
    return unless value

    value.getFullYear() + '-' + lz(value.getMonth() + 1) + '-' + lz(value.getDate()) + 'T' + lz(value.getHours()) + ':' + lz(value.getMinutes())
}