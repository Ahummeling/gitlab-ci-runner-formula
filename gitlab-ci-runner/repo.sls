# Enable HTTPS Transport for Apt, as the GitLab PackageCloud repo uses HTTPS
gitlab-ci-multi-runner-repo-repo-dependency:
  pkg.installed:
    - name: apt-transport-https
    - require_in: gitlab-ci-multi-runner-repo-repo #We must block the repo as it will break APT if HTTPS was not installed yet!

gitlab-ci-multi-runner-install-debian-archive-keyring:
  pkg.installed:
    - name: debian-archive-keyring

# Install the actual repo
gitlab-ci-multi-runner-repo:
  pkgrepo.managed:
    - humanname: GitLab Multi-Runner Packagecloud Repository
    - name: deb https://packages.gitlab.com/runner/gitlab-runner/{{ grains['os_family']|lower }}/ {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list
    - key_url: https://packages.gitlab.com/runner/gitlab-runner/gpgkey
    


gitlab-ci-multi-runner-repo-pin:
  file.managed:
    - name: /etc/apt/preferences.d/pin-gitlab-runner.pref 
    - contents: |

                Explanation: Prefer GitLab provided packages over the Debian native ones
                Package: gitlab-runner
                Pin: origin packages.gitlab.com
                Pin-Priority: 1001