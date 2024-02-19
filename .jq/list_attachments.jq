# Format an item for Alfred
def alfred:
  {
    title: .fileName,
    subtitle: .sizeName,
    arg: .url,
    autocomplete: .fileName,
    variables: {
	attachmentName: .fileName,
	attachmentId: .id,
	attachmentUrl: .url,
	attachmentSize: .size,
	attachmentSizeName: .sizeName,
      }
  }
;

##################################################
# Main

[
  (select(.data.attachments) | .data.attachments[]
  | select(.fileName | tostring | test($search; "i"))
  | alfred) // { title: "No attachments" }
]
