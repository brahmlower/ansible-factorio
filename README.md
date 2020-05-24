# Factorio

[![Install from Ansible Galaxy](https://img.shields.io/badge/role-bplower.factorio-blue.svg)](https://galaxy.ansible.com/bplower/factorio/)
![Ansible Lint](https://github.com/bplower/ansible-factorio/workflows/Ansible%20Tests/badge.svg)

A role for creating Factorio servers
https://galaxy.ansible.com/bplower/factorio/

## Requirements

No requirements

## Role Variables

Variables can be roughly divided into two groups: deployment configurations and
Factorio configurations.

### Deployment Configurations

The deployment configurations are all related to the way in which ansible
installs the factorio server. These should be abstracted enough to allow
multiple factorio servers to be run simultaneously.

```
server_sources: "/opt/games/sources/factorio"
server_version: "0.17.79"
download_url: "https://www.factorio.com/get-download/{{ server_version }}/headless/linux64"
service_name: "factorio-server"
service_user: "factorio"
service_group: "factorio"
service_root: "/home/{{ service_user }}"
service_port: 34197
service_restart_permitted: true
factorio_default_save: "{{ service_root }}/factorio/saves/default-save.zip"
factorio_target_save: "{{ factorio_default_save }}"
```

More detailed information about these variables is as follows:

- Variable: `server_sources`<br>
  Default: `"/opt/games/sources/factorio"`<br>
  Comments: <br>
  Where to cache server binaries downloaded from the download_url

- Variable: `server_version`<br>
  Default: `"0.17.79"`<br>
  Choices:
  - "0.18.26"
  - "0.17.79"
  - "0.17.74"
  - "0.16.51"
  - "0.15.40"
  - "0.14.23"
  - "0.13.20"
  - "0.12.35"

  Comments:<br>
   You must set the `download_checksum` value if you set this variable. This
   value is used in the default `download_url`.

- Variable: `download_url`<br>
  Default: `"https://www.factorio.com/get-download/{{ server_version }}/headless/linux64"`<br>
  Comments:<br>
  The URL to download the server binary from. This will only be downloaded if
  the path `"{{ server_sources }}/factorio-{{ server_version }}.tar.gz"` does
  not exist.

- Variable: `download_checksum`<br>
  Default: `"sha256:9ace12fa986df028dc1851bf4de2cb038044d743e98823bc1c48ba21aa4d23df"`
  Comments:<br>
  The checksum that must match the downloaded server binary. This ensures the integrity.
  If you change the `download_url` or `server_version`, you need to adapt the checksum as well. To get the
  checksum of a server binary, you can use `curl --silent --location <download_url> | sha256sum`.
  To disable the checksum verification, just set it to an empty string (`""`).

- Variable: `service_name`<br>
  Default: `"factorio-server"`<br>
  Comments:<br>
  The name of the service to create. Multiple instances of factorio servers can
  be run on a single host by providing different values for this variable (See
  the examples section of this document).

- Variable: `service_user`<br>
  Default: `"factorio"`<br>
  Comments:<br>
  The user the service should be run as.

- Variable: `service_group`<br>
  Default: `"factorio"`<br>
  Comments:<br>
  The group the service user should be a member of.

- Variable: `service_root`<br>
  Default: `"/home/{{ service_user }}"`<br>
  Comments:<br>
  The directory in which to store the contents of the factorio zip file
  downloaded from the server. This will result in the factorio resources being
  stored at `{{ service_root }}/factorio/`.

- Variab: `service_port`<br>
  Default: `34197`<br>
  Comments:<br>
  The port to host the service on. This default is the factorio default value.

- Variable: `service_restart_permitted`<br>
  Default: `true`<br>
  Comments:<br>
  Setting this to `false` will prevent the service from being restarted if
  changes were applied. This allows settings to be applied in preparation for
  the next service restart without immediately causing service interruption.

- Variable: `factorio_default_save`<br>
  Default: `"{{ service_root }}/factorio/saves/default-save.zip"`<br>
  Comments:<br>
  The default save file used by the server.

- Variable: `factorio_target_save`<br>
  Default: `"{{ factorio_default_save }}"`<br>
  Comments:<br>
  The save file to be run by the server. This distinction is provided to
  facilitate switching between multiple save files.

### Factorio Configurations

Settings for various config files can be set in dictionaries loosely named after
the file. Each dictionary starts with `factorio_` followed by the filename
(excluding the filetype extension) where hyphens ( - ) are replaced by
underscores ( _ ). For example, the `server-settings.json` file is associated
with the dictionary variable `factorio_server_settings`.

The `default/` folder contains serveral files showing example dictionaries
representing the values provided by the Factorio servers various examples JSON
files.

The following is a list of config files that have been implemented:

- Filename: `server-settings.json`<br>
  Variable: `factorio_server_settings`<br>
  Example:
  ```
  factorio_server_settings:
    name: "My Public Server"
    max_players: 10
    game_password: "mypassword"
    visibility:
      public: true
      lan: true
  ```

- Filename: `server-whitelist.json`<br>
  Variable: `factorio_server_whitelist`<br>
  Example:
  ```
  factorio_server_whitelist:
  - Oxyd
  ```

- Filename: `map-settings.json`<br>
  Variable: `factorio_map_settings`<br>
  Example:
  ```
  factorio_map_settings:
    pollution:
      enabled: false
  ```

- Filename: `map-gen-settings.json`<br>
  Variable: `factorio_map_gen_settings`<br>
  Example:
  ```
  factorio_map_gen_settings:
    water: "high"
    autoplace_controles:
      coal:
        size: "very-low"
  ```

## Example Playbooks

An out of the box example might look as follows:

```
---
- name: Create a default factorio server
  hosts: localhost
  roles:
  - role: bplower.factorio
```

An example with a non-default port, and customized name:
```
---
- name: My slightly changed factorio server
  hosts: localhost
  roles:
  - role: bplower.factorio
    service_port: 12345
    factorio_server_settings:
      name: "My factorio server"
```

An example of multiple servers on a single host:
```
---
- name: Factorio farm
  hosts: localhost
  roles:
  - role: bplower.factorio
    service_port: 50001
    service_name: factorio_1
    service_root: /home/{{ service_user }}/{{ service_name }}
  - role: bplower.factorio
    service_port: 50002
    service_name: factorio_2
    service_root: /home/{{ service_user }}/{{ service_name }}
```

## License

GNU GPLv3

# Development & Contributions

I don't use this project regularly anymore, but I try to keep it up to date when
possible. If you have any issues or questions about it, I encourage you to open
a PR or issue.

## Testing

This role uses yamllint for yaml validation, and molecule + docker for testing.
Both tools can be installed using the `dev-requirements.txt` file. You will need
to install docker separately.

```
pip install -r dev-requirements.txt`
```

Grouping all supported platforms together caused issues for CI, so the test are
split into 3 scenarios based on the platforms being tested.

The makefile can be used to start each of the tests, and supports a helpmenu with
descriptions for each target:

```
$ make help

Usage:
  make

Targets:
  help        Display this help
  lint        Lint yaml files
  test_all    Run all molecule tests
  test_centos  Run molecule centos tests
  test_debian  Run molecule debian tests
  test_ubuntu  Run molecule ubuntu tests
```
