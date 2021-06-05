# ASDF Role
This role's purpose is to make sure the current user account has ASDF installed in the default "home" location, `~/.asdf`.

You should not need to directly include this role in normal use -- its primary function is to serve as a dependency by which roles that install software using ASDF can ensure that it is present before using the asdf module to actually install software.

## Using the ASDF role as a dependency for custom roles
If you are creating a new role that uses ASDF to manage versions of software, you should include this role as a dependency to help ensure that its available for use. If its missing, this role will install ASDF for you.

In `meta/$name.yaml` define the asdf role as a dependency:

```yaml
---
dependencies:
  - role: asdf
```

Your custom role will then automatically run the ASDF role when executed.