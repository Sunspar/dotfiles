#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule

DOCUMENTATION = '''
---
module: asdf
short_description: Manages software installation via ASDF version manager.
author:
  - Sunspar <me@sunspar.net>
options:
  asdf_path:
    required: true
    description:
      - The path to the installed ASDF on the system.
  name: 
    required: true
    default: null
    description:
      - The name of the plugin to be installed.
  state:
    required: false
    default: 'present'
    options: ['present', 'missing']
    description:
      - The desired state of the ASDF plugin. 'missing' will completely remove the plugin,
        while 'present' will install the plugin as well as specified versions.
  repo:
    required: false
    default: null
    description:
      - The repository URL to use if this plugin is not int he community repository, or
        if you want to use a specific fork even if it is. This is only necessary if you
        explicitly want to avoid the community plugin of the same name.
  versions:
    required: false
    default: []
    description:
      - The version strings you want to make sure are installed. If this isn't present,
        we default to not setting any specific versions up, and calling this module amounts
        to simply ensuring the plugin itself is available.
  global_version:
    required: false
    default: null
    description:
      - The global version to assign. It must have either been pre-installed outside of
        this module or included in the versions field, or you'll get errors trying to
        assign it.
  preinstall_commands:
    required: false
    default: None
    description:
      - A list of commands to execute between the `plugin-add` and `install` phases. Useful
        when  additional commands are required by the plugin (eg importing the nodejs GPG
        keyring).
'''

RETURN = '''
'''

EXAMPLES = '''
'''


def plugin_installed(module, name):
  """Determine if a given ASDF plugin is installed."""

  # `asdf list` returns a zero exit code if the plugin is already installed
  command = [module.params['asdf_path'], 'list', name]
  rc, out, err = module.run_command(command, check_rc=False)
  return rc == 0


def version_installed(module, name, version):
  """Determine if a given ASDF plugin version is installed."""
  
  # `asdf where` returns zero if the plugin version is installed, and non-zero otherwise
  command = [module.params['asdf_path'], 'where', name, version]
  rc, out, err = module.run_command(command, check_rc=False)
  return rc == 0


def check_install(module):
  """Performs checks to see what would have been installed, if the module was run fully with the parameters given."""

  plugin_name       = module.params['name']
  plugin_repository = module.params['repository']
  plugin_versions   = module.params['versions']
  global_version    = module.params['global_version']
  
  if not plugin_installed(module, plugin_name):
    # If the plugin is missing, then none of the versions would be installed either
    module.exit_json(
      changed=True,
      msg="Would install plugin and specified version(s)."
    )
  else:
    # Must check, since some versions could be installed already.
    versions_missing = []

    for plugin_version in plugin_versions:
      if not version_installed(module, plugin_name, plugin_version):
        versions_missing.append(plugin_version)

    if len(versions_missing) > 0:
      module.exit_json(
        changed = True,
        msg = "The following versions would be installed: {}".format(', '.join(versions_missing))
      )
    else:
      module.exit_json(changed = False)


def install(module):
  """Install the ASDF plugin, and then run setup on whatever versions were requested."""

  plugin_name         = module.params['name']
  plugin_repository   = module.params['repository']
  plugin_versions     = module.params['versions']
  global_version      = module.params['global_version']
  preinstall_commands = module.params['preinstall_commands']
  results             = {
    'changed':  False,
    'rc':       0,
    'msg':      ""
  }

  if not plugin_installed(module, plugin_name):
    install_command = [module.params['asdf_path'], 'plugin-add', name]
    if plugin_repository:
      install_command.append(plugin_repository)
    rc, out, err = module.run_command(install_command, check_rc=True)
    results['changed'] = True

  if preinstall_commands is not None:
    results['changed'] = True
    for command in preinstall_commands:
      module.run_command(command, check_rc=True)

  for version in plugin_versions:
    if not version_installed(module, plugin_name, version):
      version_install_command = [module.params['asdf_path'], 'install', plugin_name, version]
      rc, out, err = module.run_command(version_install_command, check_rc=True)
      results['changed'] = True

  if global_version != None:
    global_command = [module.params['asdf_path'], 'global', plugin_name, global_version]
    rc, out, err = module.run_command(global_command, check_rc=True)
    # TODO: Only flag this change if the version has actually changed.
    results['changed'] = True

  # Make sure to reshim so that your changes are instantly usable.
  if results['changed']:
    rc, out, err = module.run_command([module.params['asdf_path'], 'reshim', plugin_name], check_rc=True)
  
  module.exit_json(**results)


def initialize_module():
  """Construct the Ansible module and define the parameters available."""

  return AnsibleModule(
    argument_spec = {
      'asdf_path': { 'type': 'str', 'required': True },
      'name': { 'type': 'str', 'required': True },
      'state': { 'type': 'str', 'default': 'present', 'options': ['present', 'missing'] },
      'repository': { 'type': 'str', 'required': False },
      'versions': { 'type': 'list', 'default': [] },
      'global_version': { 'type': 'str', 'default': None },
      'preinstall_commands': { 'type': 'list', 'default': None }
    },
    supports_check_mode = True
  )


def main():
  module = initialize_module()

  if module.params['state'] == 'present':
    if module.check_mode:
      check_install(module)
    else:
      install(module)


if __name__ == '__main__':
  main()