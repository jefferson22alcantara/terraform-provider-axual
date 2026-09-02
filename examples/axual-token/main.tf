# Minimal example proving the token-based provider configuration works.
# Look up yourself by e-mail - change the address
data "axual_user" "my-user" {
  email = "<your_email>"
}

# Replace with the short name of your instance
data "axual_instance" "testInstance" {
  short_name = "dta"
}

resource "axual_group" "tenant_admin_group" {
  name    = "Tenant Admin Group"
  members = [
    data.axual_user.my-user.id,
  ]
}
