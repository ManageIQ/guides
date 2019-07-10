# Configuring Git and GitHub

## GitHub Settings

* Enable [SSH keypair authentication](https://help.github.com/articles/generating-ssh-keys). It is *strongly* recommended when cloning and working with git repositories hosted on GitHub.
* Set up your [GitHub profile](https://github.com/settings/profile), including name, avatar and [email addresses](https://github.com/settings/emails).
* If you are a [member](https://github.com/ManageIQ?tab=members) of the [ManageIQ organization](https://github.com/ManageIQ), you may opt to publicize your membership.

## Git Configuration

Set global user, push and pull options. If you want to set options on a per-repository basis, omit `--global`.

```bash
git config --global user.name "Joe Smith"
git config --global user.email joe.smith@example.com
git config --global --bool pull.rebase true
git config --global push.default simple
```

## Git Workflow

### Fork

Fork [ManageIQ/manageiq](https://github.com/ManageIQ/manageiq) by clicking on the *Fork* button.

### Clone

Once your fork has been created, clone it and create an upstream remote.

```bash
git clone git@github.com:<username>/manageiq.git
cd manageiq
git remote add upstream git@github.com:ManageIQ/manageiq.git
git fetch upstream
```

You can pull upstream changes into your local repository using pull.

```bash
git pull upstream master --ff
```

### Pull Request

Once your changes are ready, open a [Pull Request](https://github.com/ManageIQ/manageiq/compare) against the upstream project.

