acl {
  enabled = true
}

vault {
  enabled = true
  address = "http://127.0.0.1:18200"

  default_identity {
    aud = ["vault.io"]
    ttl = "1h"
  }
}



