# Factorio

A role for deploying a Factorio server.

## Requirements

No requirements

## Role Variables

These set the version of the server to run, and where to store the downloaded
server binaries, and where to download the binaries from.

```
server_version: "0.14.23"
server_sources: "/opt/games/sources/factorio"
download_domain: www.factorio.com
download_proto: https
download_url: "{{ download_proto }}://{{ download_domain }}/get-download/{{ server_version }}/headless/linux64"
```

### Service settings

These variables set how the service is run. These include the user and group to
run the service as, in addition to

```
service_user: "{{ service_name }}"
service_group: "{{ service_name }}"
service_root: "/opt/games/{{ service_name }}"
factorio_default_save: "{{ service_root }}/factorio/saves/default-save.zip"
factorio_target_save: "{{ factorio_default_save }}"
```

### Factorio server settings

A limited number of factorio settings have been implemented. These variables
named the same as the factorio setting, but prefixed with `factorio_`.

```
factorio_name: "Default server"
factorio_description: "Default description"
factorio_max_players: 0
factorio_token: ""
factorio_game_password: ""
factorio_require_user_verification: true
factorio_max_upload_in_kilobytes_per_second: 0
factorio_minimum_latency_in_ticks: 0
factorio_ignore_player_limit_for_returning_players: false
factorio_allow_commands: "admins-only"
factorio_autosave_interval: 10
factorio_autosave_slots: 5
factorio_afk_autokick_interval: 0
factorio_auto_pause: true
factorio_only_admins_can_pause_the_game: true
factorio_autosave_only_on_server: true
factorio_admins: []
```

TODO: Document the server settings not implemented.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Example Playbook

Usage example:

```
  - hosts: factorio-server.fqdn.local
    roles:
    - role: factorio
      service_name: "my-factorio-service"
      server_version: "0.15.3"
      service_port: 12346
      factorio_name: "The coolest server"
      factorio_game_password: "Serv3r_Pa$$w0rd"
```

## License

GNU GPLv3

# Development

## Testing

Tests are run by applying example playbooks to docker instances. All testing
resources (save for the `test.sh` script in the root) can be found in the `tests`
directory. At this time, there is only one test playbook (`tests/test.yml`).

Before running tests, you will need to initialize your development environment
by running `init.sh`. At this time, all it does is create a vendor folder and
download the supported versions of the factorio server from www.factorio.com.
The url structure has been copied in `ventor/mock.factorio.local/` to use for
testing, that way tests don't hammer the production web server.
