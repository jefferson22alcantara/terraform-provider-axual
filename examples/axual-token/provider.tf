terraform {
  required_providers {
    axual = {
      source  = "Axual/axual"
      version = "3.1.0"
    }
  }
}

# Provider configuration using an already-issued bearer token instead of a
# username/password token exchange. Useful when a token is minted by your own
# CI/CD pipeline or SSO integration. Every API request is sent with an
# "Authorization: Bearer <token>" header.

provider "axual" {
  authmode = "token"
  # (String) URL that will be used by the client for all resource requests
  apiurl   = "https://platform.local/api"
  # (String, Sensitive) Already-issued bearer token. It can be omitted if the
  # environment variable AXUAL_AUTH_TOKEN is used instead (recommended, so the
  # token is not stored in the .tf file or in version control).
  token    = "PLEASE_CHANGE_TOKEN"
}
