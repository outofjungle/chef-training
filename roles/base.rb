name "base"
description "Base role applied to all node."
run_list(
    "recipe[chef-client::delete_validation]",
    "recipe[motd-tail]",
    "recipe[sudo]"
)

default_attributes(
    "authorization" => {
        "sudo" => {
            "users" => ["opscode"],
            "groups" => ["admin", "sudo"],
            "passwordless" => true
        }
    }
)
