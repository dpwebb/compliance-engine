package ce.triggers

default actions := []

# Input shape (example):
# input = {
#   "jurisdiction": {"province": "ON"},
#   "tradeline": {"id":"...", "status":"collections", "creditor_id":"...", "doFD":"2022-01-01"},
#   "flags": {"consumer_disputed": true, "cease_requested": false},
#   "evidence": {...}
# }

# Always contact bureau on accuracy dispute
contact_bureau[msg] {
  input.flags.consumer_disputed == true
  msg := {"type":"contact_bureau","reason":"accuracy_dispute"}
}

# Conditional creditor outreach
contact_creditor[msg] {
  some trigger
  trigger := furnisher_obligation_applies
  msg := {"type":"contact_creditor","tradeline_id": input.tradeline.id, "trigger":"furnisher_obligation","severity":"medium"}
}

# Conditional collector outreach
contact_collector[msg] {
  input.tradeline.status == "collections"
  input.flags.consumer_disputed == true
  msg := {"type":"contact_collector","tradeline_id": input.tradeline.id, "trigger":"dispute_requires_verification","severity":"high"}
}

# Example predicate — extend per province/federal packs
furnisher_obligation_applies {
  input.tradeline.creditor_id != ""
}

# Aggregate
actions := arr {
  arr := concat_arrays([contact_bureau, contact_creditor, contact_collector])
}