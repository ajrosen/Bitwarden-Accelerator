# Remove sensitive data
. | del(.data.data[].login.password)
  | del(.data.data[].login.totp)
  | del(.data.data[].passwordHistory)
  | del(.data.data[].card.number)
  | del(.data.data[].card.code)
