.global make_node
make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)             #storing value to insert
    
    addi a0, x0, 24
    call malloc              #node=malloc(24)

    ld t0, 0(sp)             #restoring value to be inserted

    sw t0, 0(a0)             #node->val=val
    sd x0, 8(a0)             #node->left=NULL
    sd x0, 16(a0)            #node->right=NULL

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

.global insert
insert:
    addi sp, sp, -32
    sd ra, 8(sp)
    sd a1, 16(sp)
    sd a0, 24(sp)               #saving parent node

    beq a0, x0, createroot      #root==NULL
    lw t0, 0(a0)                #root->val
    
    blt a1, t0, insert_lefttree        #val < root->val ? root->left : root->right

    insert_righttree:
        ld t2, 24(sp) 
        ld a0, 16(t2)            #root=root->right
        jal ra, insert           #insert(root->right, val)

        ld t2, 24(sp)            #restoring parent node in t2
        sd a0, 16(t2)            #parent->right = modified right tree
        add a0, t2, x0

        beq x0, x0, insert_end

    insert_lefttree:
        ld t2, 24(sp)
        ld a0, 8(t2)             #root=root->left
        jal ra, insert           #insert(root->left, val)

        ld t2, 24(sp)            #restoring parent node in t2
        sd a0, 8(t2)             #parent->left = modified left tree
        add a0, t2, x0

        beq x0, x0, insert_end
    
    createroot:
        add a0, x0, a1
        jal ra, make_node

    insert_end:
        ld ra, 8(sp)
        addi sp, sp, 32
        ret

.global get
get:
    addi sp, sp, -16
    sd ra, 8(sp)

    beq a0, x0, get_end              #root==NULL : return NULL

    lw t0, 0(a0)
    blt a1, t0, get_lefttree         #val < root->val ? root->left : root->right
    beq a1, t0, get_end              #val==root->val : return root

    get_righttree:
        ld a0, 16(a0)            #root=root->right
        jal ra, get
        beq x0, x0, get_end

    get_lefttree:
        ld a0, 8(a0)             #root=root->left
        jal ra, get
        beq x0, x0, get_end

    get_end:
        ld ra, 8(sp)
        addi sp, sp, 16
        ret

.global getAtMost
getAtMost:
    addi t0, x0, -1
    beq a1, x0, getatmost_end             #root==NULL : return NULL

    loop:
        beq a1, x0, getatmost_end         #root==NULL : return NULL
        lw t1, 0(a1)                      #t1 = root->val

        blt a0, t1, getatmost_lefttree

        add t0, t1, x0                    #ans=root
        ld a1, 16(a1)                     #root=root->right
        beq x0, x0, loop

    getatmost_lefttree:
        ld a1, 8(a1)
        beq x0, x0, loop

    getatmost_end:
        add a0, t0, x0                    #store ans
        ret
