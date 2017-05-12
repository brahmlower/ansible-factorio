# Factorio

[![Install from Ansible Galaxy](https://img.shields.io/badge/role-bplower.factorio-blue.svg)](https://galaxy.ansible.com/bplower/factorio/)

A role for deploying a Factorio server.
https://galaxy.ansible.com/bplower/factorio/

## Requirements

No requirements

## Role Variables

These set the version of the server to run, where to download the binaries from,
and where to store said binaries.

```
server_version: "0.14.23"
server_sources: "/opt/games/sources/factorio"
download_domain: www.factorio.com
download_proto: https
download_url: "{{ download_proto }}://{{ download_domain }}/get-download/{{ server_version }}/headless/linux64"
```

### Service settings

These settings define how and where the service runs.

```
service_name: "factorio-server"
service_user: "factorio"
service_group: "factorio"
service_root: "/home/{{ service_user }}"
factorio_default_save: "{{ service_root }}/factorio/saves/default-save.zip"
factorio_target_save: "{{ factorio_default_save }}"
```

### Factorio server settings

A limited number of factorio settings have been implemented. These variables
are defined under the `factorio_settings` variable, and are named the same as the setting key in the factorio settings file.

```
factorio_settings:
  name: "Default server"
  description: "Default description"
  max_players: 0
  token: ""
  game_password: ""
  require_user_verification: true
  max_upload_in_kilobytes_per_second: 0
  minimum_latency_in_ticks: 0
  ignore_player_limit_for_returning_players: false
  allow_commands: "admins-only"
  autosave_interval: 10
  autosave_slots: 5
  afk_autokick_interval: 0
  auto_pause: true
  only_admins_can_pause_the_game: true
  autosave_only_on_server: true
  admins: []
```

The same functionality is implemented for the server-whitelist, map-settings, and map-gen-settings files. The following is an example where in each file has a non-default value applied:

```
  - hosts: factorio-server.fqdn.local
    roles:
    - role: factorio
      service_name: "my-factorio-service"
      server_version: "0.15.3"
      service_port: 12346
      factorio_settings:
        name: "The coolest server"
        game_password: "Serv3r_Pa$$w0rd"
      factorio_map_gen_settings:
        water: "high"
        autoplace_controles:
          coal:
            size: "very-low"
      factorio_map_settings:
        pollution:
          enabled: false
      factorio_server_whitelist:
        - Oxyd
```

Examples of each of these files can be found in the defaults folder.

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
      factorio_settings:
        name: "The coolest server"
        game_password: "Serv3r_Pa$$w0rd"
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
