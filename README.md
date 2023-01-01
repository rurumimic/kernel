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

### Vim

### Tags

- [universal-ctags/ctags](https://github.com/universal-ctags/ctags)
- [cscope](https://cscope.sourceforge.net/)
- [GNU global](https://www.gnu.org/software/global/)

```bash
sudo apt install universal-ctags
sudo apt install cscope
sudo apt install global
```

#### SpaceVim

- [cscope](https://spacevim.org/layers/cscope/)
- [gtags](https://spacevim.org/layers/gtags/)

```bash
make TAGS
make cscope
make gtags
```

```bash
├── [3.1M]  GPATH
├── [196M]  GRTAGS
├── [ 63M]  GTAGS
├── [ 82M]  TAGS
├── [542K]  cscope.files
├── [232M]  cscope.out
├── [ 46M]  cscope.out.in
├── [335M]  cscope.out.po
```

## distro

| Release                    | Kernel Version |
| -------------------------- | -------------- |
| RHEL 6.10                  | 2.6.32-754     |
| Fedora 15 Lovelock         | 2.6.38         |
| Ubuntu 11.04 Natty Narwhal | 2.6.38         |

---

## Content

- syscall/[helloworld](src/syscall/helloworld/README.md)
