#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule


DOCUMENTATION = '''
module: yay
short_description: Manages packages form the AUR with Yay
description:
  - Manages AUR and main repo packages with Yay
author:
  - Sunspar <me@sunspar.net>
options:
  packages:
    description:
      - the name or a list of names of packages to manage.
  state:
    description:
      - The desired status for the packages.
    default: present
    choices: [ present, latest, missing ]
'''


RETURN = '''
msg:
  description: A message about what was performed
'''


EXAMPLES = '''
- name: Installs kitty if not present
  yay:
    packages:
      - kitty

- name: Removes urxvt
  yay:
    status: missing
    packages:
      - urxvt
'''


def is_package_installed(module, package_name):
  rc, _, _ = module.run_command(['pacman', '-Q', package_name], check_rc=False)
  return rc == 0


def install_packages(module, package_list):
  install_packages_command = ['yay', '-S', '--noconfirm', '--needed', '--cleanafter']
  packages = []
  found_packages_to_install = False
  for package_name in package_list:
    if not is_package_installed(module, package_name):
      packages.append(package_name)
  if len(packages) > 0:
    install_packages_command.extend(packages)
    rc, out, err = module.run_command(install_packages_command, check_rc=True)
    module.exit_json(
      changed=True,
      message=out if not rc else err,
      rc=rc
    )
  else:
    module.exit_json(
      changed=False
    )


def check_install_packages(module, package_list):
  packages = []
  for package_name in package_list:
    if not is_package_installed(module, package_name):
      packages.append(package_name)
  diff = dict(before='', after=', '.join(packages))
  if len(packages) > 0:
    changed = True
    msg = "The following packages would be installed: {}".format(diff['after'])
  else:
    changed = False
    msg = "No packages would be installed."
  module.exit_json(changed=changed, msg=msg, diff=diff)


def remove_packages(module, package_list):
  remove_packages_command = ['pacman', '-Rs', '--noconfirm']
  packages = []
  found_packages_to_install = False
  for package_name in package_list:
    if is_package_installed(module, package_name):
      packages.append(package_name)
  if len(packages) > 0:
    remove_packages_command.extend(packages)
    rc, out, err = module.run_command(remove_packages_command, check_rc=True)
    module.exit_json(
      changed=True,
      message=out if not rc else err,
      rc=rc
    )
  else:
    module.exit_json(
      changed=False
    )


def check_remove_packages(module, package_list):
  packages = []
  for package_name in package_list:
    if is_package_installed(module, package_name):
      packages.append(package_name)
  diff = dict(before='', after=packages.join(', '))
  if len(packagges) > 0:
    changed = True
    msg = "The following packages would be removed: {}".format(diff['after'])
  else:
    changed = False
    msg = "No packages would be removed."
  module.exit_json(changed=changed, msg=msg, diff=diff)


def initialize_module():
  return AnsibleModule(
    argument_spec = {
      'packages': {
        'type':     'list',
        'required': True
      },
      'state': {
        'type':    'str',
        'default': 'present',
        'choices': ['present', 'missing']
      }
    },
    supports_check_mode = True
  )


def main():
  module = initialize_module()
  params = module.params
  if params['state'] == 'present':
    if module.check_mode:
      check_install_packages(module, params['packages'])
    else:
      install_packages(module, params['packages'])
  elif params['state'] == 'missing':
    if module.check_mode:
      check_remove_packages(module, params['packages'])
    else:
      remove_packages(module, params['packages'])


if __name__ == '__main__':
  main()