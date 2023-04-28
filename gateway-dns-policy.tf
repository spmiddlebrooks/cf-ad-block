# ==============================================================================
# POLICY: Block Ads
# ==============================================================================
locals {
  # Iterate through each domain_list resource and extract its ID
  domain_lists = [for k, v in cloudflare_teams_list.domain_lists : v.id]

  # Format the values: remove dashes and prepend $
  domain_lists_formatted = [for v in local.domain_lists : format("$%s", replace(v, "-", ""))]

  # Create filters to use in the policy
  ad_filters = formatlist("any(dns.domains[*] in %s)", local.domain_lists_formatted)
  ad_filter  = join(" or ", local.ad_filters)
}

resource "cloudflare_teams_rule" "block_ads" {
  account_id = var.cloudflare_api_token

  name        = "Block Ads"
  description = "Block Ads domains"

  enabled    = true
  precedence = 11

  # Block domain belonging to lists (defined below)
  filters = ["dns"]
  action  = "block"
  traffic = local.ad_filter

  rule_settings {
    block_page_enabled = false
  }
}


# ==============================================================================
# LISTS: AD Blocking domain list
#
# Remote source:
#   - https://firebog.net/
#   - https://adaway.org/hosts.txt
# Local file:
#   - ./assets/adaway_list.txt
#   - the file can be updated periodically via Github Actions (see README)
# ==============================================================================
locals {
  # The full path of the list holding the domain list
  domain_list_file = "${path.module}/assets/adaway_list.txt"

  # Parse the file and create a list, one item per line
  domain_list = split("\n", file(local.domain_list_file))

  # Remove empty lines
  domain_list_clean = [for x in local.domain_list : x if x != ""]

  # Use chunklist to split a list into fixed-size chunks
  # It returns a list of lists
  aggregated_lists = chunklist(local.domain_list_clean, 1000)

  # Get the number of lists (chunks) created
  list_count = length(local.aggregated_lists)
}


resource "cloudflare_teams_list" "domain_lists" {
  account_id = var.cloudflare_api_token

  for_each = {
    for i in range(0, local.list_count) :
    i => element(local.aggregated_lists, i)
  }

  name  = "domain_list_${each.key}"
  type  = "DOMAIN"
  items = each.value
}
