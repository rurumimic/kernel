# LXC

- kernel
  - [v2.6.19](https://github.com/torvalds/linux/tree/v2.6.19): namespace
  - [v2.6.24](https://github.com/torvalds/linux/tree/v2.6.24): [cgroups.txt](https://github.com/torvalds/linux/blob/v2.6.24/Documentation/cgroups.txt)
  - [v4.6](https://github.com/torvalds/linux/tree/v4.6)
- [lxc](https://github.com/lxc/lxc)

## Namespace

- [v2.4.19.tar.gz](https://www.kernel.org/pub/linux/kernel/v2.4/linux-2.4.19.tar.gz): [include/linux/sched.h](https://elixir.bootlin.com/linux/2.4.19/source/include/linux/sched.h#L45) - `CLONE_NEWNS`

네임스페이스는 커널 v2.4.19에서 실험적으로 도입되었다.

### CLONE_NEWNS

- [include/linux/sched.h#L45](https://elixir.bootlin.com/linux/2.4.19/source/include/linux/sched.h#L45)

힌트:

```bash
rg CLONE_NEWNS

kernel/fork.c
584:    if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))

fs/namespace.c
764:    if (! (flags & CLONE_NEWNS))

include/linux/sched.h
45:#define CLONE_NEWNS  0x00020000      /* New namespace group? */
```

#### kernel/fork.c

- [kernel/fork.c#L577-L782](https://elixir.bootlin.com/linux/2.4.19/source/kernel/fork.c#L577-L782)

리눅스에서 프로세스를 복제할 때, 네임스페이스를 포함하여 여러 정보를 공유하거나 복사한다.

```c
int do_fork(unsigned long clone_flags, unsigned long stack_start,
	    struct pt_regs *regs, unsigned long stack_size)
{
// ...
	/* copy all the process information */
	if (copy_files(clone_flags, p))
		goto bad_fork_cleanup;
	if (copy_fs(clone_flags, p))
		goto bad_fork_cleanup_files;
	if (copy_sighand(clone_flags, p))
		goto bad_fork_cleanup_fs;
	if (copy_mm(clone_flags, p))
		goto bad_fork_cleanup_sighand;
	if (copy_namespace(clone_flags, p))
		goto bad_fork_cleanup_mm;
	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
	if (retval)
		goto bad_fork_cleanup_namespace;
// ...
}
```

---

## Control Groups

- 트리 형태의 계층 구조로 프로세스 그룹을 관리하는 기능
- 기존 리눅스에는 리소스를 추적 관리할 수 있는 여러가지 다양한 방법들이 있었다.
  - cpusets, CKRM/ResGroups, UserBeanCounters, and virtual server
namespaces
- 일관된 프로세스 관리를 위해서 cgroup 기능을 개발함.

### 다중 계층 구조 Multiple Hierarchy 지원

- 각 서브시스템이 필요로 하는 작업 분류 방식에 맞춤
  - CPU가 필요한 사용자와 네트워크 리소스가 필요한 사용자 그룹을 구분하여 유연하게 리소스 할당 가능

### init/main.c

- [init/main.c#L638](https://github.com/torvalds/linux/blob/49914084e797530d9baaf51df9eda77babc98fa8/init/main.c#L638)

시스템 부팅 시 Root cgroup과 서브시스템을 초기화:

```c
asmlinkage void __init start_kernel(void)
{
//...
  cgroup_init();
//...
}
```

### kernel/fork.c

- [kernel/fork.c#L1087](https://github.com/torvalds/linux/blob/49914084e797530d9baaf51df9eda77babc98fa8/kernel/fork.c#L1087)

리눅스에서 프로세스를 복제할 때, cgroup도 복제한다.

```c
static struct task_struct *copy_process(unsigned long clone_flags,
					unsigned long stack_start,
					struct pt_regs *regs,
					unsigned long stack_size,
					int __user *child_tidptr,
					struct pid *pid)
{
// ...
	cgroup_fork(p);
// ...
}
```

### kernel/cgroup.c

- [kernel/cgroup.c#L557-L562](https://github.com/torvalds/linux/blob/49914084e797530d9baaf51df9eda77babc98fa8/kernel/cgroup.c#L557-L562)

#### **cgroup_create()** 순서

1. 사용자가 `mkdir /sys/fs/cgroup/cpu/my_cgroup` 실행
2. `cgroup_mkdir()` 호출
3. `cgroup_create()` 호출
4. 새로운 cgroup 자료구조(`cgroup`) 동적 할당
5. 부모-자식 관계 설정 및 초기화
6. 서브시스템(`cpu`, `memory` 등) 초기화
7. 파일 시스템에서 cgroup 디렉터리 생성 (`cgroup_create_dir()`)
8. `cgroup_populate_dir()`을 호출하여 기본 속성 파일 생성
9. 성공하면 0 반환, 실패하면 정리 후 오류 반환

---

## 리눅스 컨테이너

Container = Namespace(격리) + cgroups(자원제한) + 루트 파일시스템(rootfs)

### Namespace Cloning Flags

- [include/uapi/linux/sched.h#L24-L29](https://github.com/torvalds/linux/blob/2dcd0af568b0cf583645c8a317dd12e344b1c72a/include/uapi/linux/sched.h#L24-L29)

`clone()` 함수에 다음 플래그를 설정하면 같은 커널을 공유하면서도 독립된 환경을 만들 수 있다.

```c
#define CLONE_NEWNS	0x00020000	/* New mount namespace group */
#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
#define CLONE_NEWUTS		0x04000000	/* New utsname namespace */
#define CLONE_NEWIPC		0x08000000	/* New ipc namespace */
#define CLONE_NEWUSER		0x10000000	/* New user namespace */
#define CLONE_NEWPID		0x20000000	/* New pid namespace */
#define CLONE_NEWNET		0x40000000	/* New network namespace */
```

### LXC Start

- 한국어: [lxc-start](https://manpages.debian.org/unstable/lxc/lxc-start.1.ko.html)

`lxc-start` 명령어로 Container를 생성한다.

#### Namespace Info

- [src/lxc/namespace.c#L38-L47](https://github.com/lxc/lxc/blob/fc77e20953b87bc1a3f2f07a079647bec990da57/src/lxc/namespace.c#L38-L47)

LXC에서 Namespace의 정보를 관리한다.

```c
const struct ns_info ns_info[LXC_NS_MAX] = {
	[LXC_NS_USER]    = { "user",   "ns/user",   CLONE_NEWUSER,   "CLONE_NEWUSER",   "LXC_USER_NS"    },
	[LXC_NS_MNT]    =  { "mnt",    "ns/mnt",    CLONE_NEWNS,     "CLONE_NEWNS",     "LXC_MNT_NS"     },
	[LXC_NS_PID]    =  { "pid",    "ns/pid",    CLONE_NEWPID,    "CLONE_NEWPID",    "LXC_PID_NS"     },
	[LXC_NS_UTS]    =  { "uts",    "ns/uts",    CLONE_NEWUTS,    "CLONE_NEWUTS",    "LXC_UTS_NS"     },
	[LXC_NS_IPC]    =  { "ipc",    "ns/ipc",    CLONE_NEWIPC,    "CLONE_NEWIPC",    "LXC_IPC_NS"     },
	[LXC_NS_NET]    =  { "net",    "ns/net",    CLONE_NEWNET,    "CLONE_NEWNET",    "LXC_NET_NS"     },
	[LXC_NS_CGROUP] =  { "cgroup", "ns/cgroup", CLONE_NEWCGROUP, "CLONE_NEWCGROUP", "LXC_CGROUP_NS"  },
	[LXC_NS_TIME]	=  { "time",   "ns/time",   CLONE_NEWTIME,   "CLONE_NEWTIME",   "LXC_TIME_NS"    },
};
```

#### lxc/start.c

- [src/lxc/start.c#L1621-L2000](https://github.com/lxc/lxc/blob/fc77e20953b87bc1a3f2f07a079647bec990da57/src/lxc/start.c#L1621-L2000)
- [src/lxc/start.c#L1050-L1454](https://github.com/lxc/lxc/blob/fc77e20953b87bc1a3f2f07a079647bec990da57/src/lxc/start.c#L1050-L1454)

1. LXC를 시작하면 지정한 자원들을 차례로 분리한다.
1. 파일시스템을 설정한다.
1. 컨테이너 내부에서 실행할 프로세스를 실행한다.

```c
/*
 * After this call, we are in error because this ops should not return
 * as it execs.
 */
handler->ops->start(handler, handler->data);
```

---

## Root Filesystem

- [fs/namespace.c#L2986-L3082](https://github.com/torvalds/linux/blob/2dcd0af568b0cf583645c8a317dd12e344b1c72a/fs/namespace.c#L2986-L3082)

```c
SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
		const char __user *, put_old)
{
  // ...
}
```

1. 사용자 입력(`new_root`, `put_old`) 검증
1. 보안 검토 (`security_sb_pivotroot()`)
1. 새로운 루트 파일 시스템(`new_root`)이 마운트 포인트인지 확인
1. 기존 루트 파일 시스템(`root`)이 마운트 포인트인지 확인
1. `new_root`가 `root` 아래에 위치하는지 확인
1. 기존 루트(`root_mnt`)를 `put_old` 위치로 이동
1. 새로운 루트(`new_mnt`)를 `/`로 설정
1. 네임스페이스(`mnt_ns`) 업데이트

namespaces와 cgroups로 컨테이너를 격리했지만,
Host의 파일 시스템(`put_old`)와 컨테이너의 새 파일 시스템(`new_root`)이 다르기 때문에
완전히 독립된 사용자 공간으로 사용 가능하다.

컨테이너는 Host와 커널은 공유하고, 사용자 공간은 분리됐기 때문에
Host OS와 Container OS가 다르더라도 실행 가능하다.
