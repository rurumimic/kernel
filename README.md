# kernel

- [docs](https://docs.kernel.org/)
- [torvalds/linux](https://github.com/torvalds/linux)
  - [v2.6.39](https://github.com/torvalds/linux/tree/v2.6.39)
- kernel.org: [kernel/git/stable/linux.git](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git)
  - [v2.6.39.4](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tag/?h=v2.6.39.4)

```bash
# github: torvalds
git clone -b v2.6.39 https://github.com/torvalds/linux.git

# git.kernel.org
git clone -b v2.6.39.4 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

# tgz: kernel.org
curl -O https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/linux-2.6.39.4.tar.gz
tar xzf linux-2.6.39.4.tar.gz
```

## Make

```bash
make help
```

### gnu gloabl

SpaceVim: [gtags](https://spacevim.org/layers/gtags/)

```bash
sudo apt install global
```

```bash
make gtags

GEN gtags
```

```bash
├── [3.1M]  GPATH
├── [196M]  GRTAGS
├── [ 63M]  GTAGS
```

## distro

| Release                    | Kernel Version |
| -------------------------- | -------------- |
| RHEL 6.10                  | 2.6.32-754     |
| Fedora 15 Lovelock         | 2.6.38         |
| Ubuntu 11.04 Natty Narwhal | 2.6.38         |
