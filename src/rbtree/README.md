# Red Black Trees

- [include/linux/rbtree.h](https://github.com/torvalds/linux/blob/v2.6.39/include/linux/rbtree.h)
- [lib/rbtree.c](https://github.com/torvalds/linux/blob/v2.6.39/lib/rbtree.c)
- [Documentation/rbtree.txt](https://github.com/torvalds/linux/blob/v2.6.39/Documentation/rbtree.txt)

---

#### node struct

`rbtree.h`: [L100-L107](https://github.com/torvalds/linux/blob/v2.6.39/include/linux/rbtree.h#L100-L107)

```c
struct rb_node
{
	unsigned long  rb_parent_color;
#define	RB_RED		0
#define	RB_BLACK	1
	struct rb_node *rb_right;
	struct rb_node *rb_left;
} __attribute__((aligned(sizeof(long))));
```

#### root node

`rbtree.h`: [L110-L113](https://github.com/torvalds/linux/blob/v2.6.39/include/linux/rbtree.h#L110-L113)

```c
struct rb_root
{
	struct rb_node *rb_node;
};

#define RB_ROOT	(struct rb_root) { NULL, }
```

`rbtree.txt`: [L73](https://github.com/torvalds/linux/blob/61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf/Documentation/rbtree.txt#L73)

```c
struct rb_root mytree = RB_ROOT;
```

#### search

`rbtree.txt`: [L83-L101](https://github.com/torvalds/linux/blob/v2.6.39/Documentation/rbtree.txt#L83-L101)

```c
struct mytype *my_search(struct rb_root *root, char *string)
{
  struct rb_node *node = root->rb_node;

  while (node)
  {
    struct mytype *data = container_of(node, struct mytype, node);
    int result = strcmp(string, data->keystring);

    if (result < 0)
        node = node->rb_left;
    else if (result > 0)
        node = node->rb_right;
    else
        return data;
  }
  return NULL;
}
```

#### insert

`rbtree.txt`: [L115-L138](https://github.com/torvalds/linux/blob/v2.6.39/Documentation/rbtree.txt#L115-L138)

```c
int my_insert(struct rb_root *root, struct mytype *data)
{
  struct rb_node **new = &(root->rb_node);
  struct rb_node *parent = NULL;

  /* Figure out where to put new node */
  while (*new)
  {
    struct mytype *this = container_of(*new, struct mytype, node);
    int result = strcmp(data->keystring, this->keystring);

    parent = *new;

    if (result < 0)
      new = &((*new)->rb_left);
    else if (result > 0)
      new = &((*new)->rb_right);
    else
      return FALSE;
  }

  /* Add new node and rebalance tree. */
  rb_link_node(&data->node, parent, new);
  rb_insert_color(&data->node, root);

  return TRUE;
}
```

#### remove

`rbtree.txt`: [L149-L154](https://github.com/torvalds/linux/blob/v2.6.39/Documentation/rbtree.txt#L149-L154)

```c
struct mytype *data = mysearch(&mytree, "walrus");

if (data) {
	rb_erase(&data->node, &mytree);
	myfree(data);
}
```
