#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "uproc.h"
#include "spinlock.h"

struct StateLists{
	struct proc* ready[MAX];
	struct proc* free;
	struct proc* sleep;
	struct proc* zombie;
	struct proc* running;
	struct proc* embryo;
};

struct {
  uint PromoteAtTime;
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists;
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.

void
assertState(struct proc * p, enum procstate state)
{
	if(p->state != state){
		panic("ERROR: Process of state is not of the correct state");
	}
}

int
removeFromStateList(struct proc ** sList, enum procstate state, struct proc *p)
{
	if(*sList == 0) return 0;
        struct proc * current;
        if(*sList == p)
        {
		assertState(*sList,state);
		current = *sList;
                *sList = (*sList)->next;
		current->next = 0;
                return 1;
        }
        current = *sList;
        while(current->next)
        {
                if(current->next == p)
                {
			assertState(p,state);
                        current->next = current->next->next;
			p->next = 0;
                        return 1;
                }
		else current = current->next;
        }
        return 0;
}

int
insertRoundRobin(struct proc **sList, enum procstate state, struct proc *p)
{
	assertState(p,state);
	struct proc * current;
	if(*sList== 0)
	{
		p->next = 0;
		*sList = p;
		return 1;
	}
	current = *sList;
	while(current->next)
	{
		current = current->next;
	}
	p->next = 0;
	current->next = p;
	return 1;
}

int
insertAtHead(struct proc ** sList,enum procstate state, struct proc * p)
{
	assertState(p,state);
	p->next = *sList;
	*sList = p;
	return 1;
}

void
killState(struct proc ** sList, enum procstate state, int pid)
{
	struct proc * current = *sList;
	while(current){
  	  if(current->pid == pid){
  	    current->killed = 1;
  	    current = current->next;
  	  }
  	  else current = current->next;
  	}

}

int
clipToBack(struct proc ** sList1, struct proc ** sList2)
{
	if(!*sList1)
	{
		*sList1 = *sList2;
		return 1;
	}
	struct proc * current = *sList1;
	while(current->next)
	{
		current = current->next;
	}
	current->next = *sList2;
	return 1;
}

int
setPrioBudgetList(struct proc ** sList, int toSet)
{
	struct proc * current;
	if(!*sList)return 0;
	current = *sList;
	while(current)
	{
		current->prio = toSet;
		current->budget = BUDGET_MAX;
		current = current->next;
	}
	return 1;
}

struct proc*
findPid(struct proc ** sList, int pid)
{
	if(!*sList) return 0;
	struct proc * current = *sList;
	while(current){
		if(current->pid == pid)
			return current;
		current = current->next;
	}
	return 0;
}

struct proc*
findReadyPid(int pid)
{
	struct proc * current;
	for(int i = 0; i < MAX; ++i)
	{
		current = ptable.pLists.ready[i];
		while(current)
		{
			if (current->pid == pid)
				return current;
			current = current->next;
		}
		
	}
	return 0;
}

static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  #ifndef CS333_P3P4
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  #else
  acquire(&ptable.lock);
  if(ptable.pLists.free)
  {
	assertState(ptable.pLists.free,UNUSED);
	p = ptable.pLists.free;
	goto found;
  }
  release(&ptable.lock);
  return 0;
  #endif
found:
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.free,UNUSED,p);
  #endif
  p->state = EMBRYO;
  p->pid = nextpid++;
  #ifdef CS333_P3P4
  p->next = ptable.pLists.embryo;
  ptable.pLists.embryo = p;
  #endif
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    removeFromStateList(&ptable.pLists.embryo,EMBRYO,p);
    p->state = UNUSED;
    insertAtHead(&ptable.pLists.free,UNUSED,p);
    release(&ptable.lock);
    #else
    p->state = UNUSED;
    #endif
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->start_ticks = ticks;
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  p->prio = 0;
  p->budget = 0;
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  int i = 0;
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; 
  ptable.pLists.free = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;
  for(i = 0; i < MAX; ++i)
  	ptable.pLists.ready[i] = 0;
  struct proc *temp = 0;
  for(temp = ptable.proc; temp < &ptable.proc[NPROC];++temp)
  {
	insertAtHead(&ptable.pLists.free,UNUSED,temp);
  }
  release(&ptable.lock);
  #endif
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->uid = UID;
  p->gid = GID;
  p->budget = BUDGET_MAX;
  p->tf->eip = 0;  // beginning of initcode.S
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
  p->state = RUNNABLE;
  insertRoundRobin(&ptable.pLists.ready[0],RUNNABLE,p);
  ptable.pLists.ready[0]->next = 0;
  release(&ptable.lock);
  #else
  p->state = RUNNABLE;
  #endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    removeFromStateList(&ptable.pLists.embryo,EMBRYO,np);
    np->state = UNUSED;
    insertAtHead(&ptable.pLists.free,UNUSED,np);
    release(&ptable.lock);
    #else
    np->state = UNUSED;
    #endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  np->uid = proc->uid;
  np->gid = proc->gid;
  np->budget = BUDGET_MAX;
  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.embryo,EMBRYO,np);
  np->state = RUNNABLE;
  insertRoundRobin(&ptable.pLists.ready[0],RUNNABLE,np);
  #else
  np->state = RUNNABLE;
  #endif
  release(&ptable.lock);
  //proc->start_ticks = ticks;
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else

int
switchParent(struct proc ** sList)
{
	if(!*sList) return 0;
	struct proc * current = *sList;
	struct proc * p;
  	while(current){
        	p = current;
        	current = current->next;
        	if(p->parent == proc){
        	  p->parent = initproc;
        	}
  	}
	return 1;
}

void
exit(void)
{
  int i = 0;
  int fd;
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for (i = 0;i < MAX; ++i)
  	switchParent(&ptable.pLists.ready[i]);
  switchParent(&ptable.pLists.sleep);
  switchParent(&ptable.pLists.running);
  switchParent(&ptable.pLists.embryo);
  switchParent(&ptable.pLists.zombie);
  // Jump into the scheduler, never to return.
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
  proc->state = ZOMBIE;
  insertAtHead(&ptable.pLists.zombie,ZOMBIE,proc);
  sched();
  panic("zombie exit");

}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifdef CS333_P3P4

int
findKids(struct proc ** sList)
{
	int havekids = 0;
	struct proc * p;
	struct proc * current = *sList;
	if(!*sList)return 0;
	while(current){
   	   p = current;
   	   if(p->parent != proc){
   	     current = current->next;
   	     continue;
   	   }
   	   havekids = 1;
   	   current = current->next;
   	}
	return havekids;
}

int
wait(void)
{
  int i = 0;
  struct proc *p;
  int havekids, pid;
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    struct proc * current = ptable.pLists.zombie;
    while(current){
      p = current;
      if(p->parent != proc){
	current = current->next;
        continue;
      }
      havekids = 1;
      current = current->next;
      // Found one.
      pid = p->pid;
      kfree(p->kstack);
      p->kstack = 0;
      freevm(p->pgdir);
      p->pid = 0;
      p->parent = 0;
      p->name[0] = 0;
      p->killed = 0;
      p->budget = 0;
      p->prio = 0;
      removeFromStateList(&ptable.pLists.zombie,ZOMBIE,p);
      p->state = UNUSED;
      insertAtHead(&ptable.pLists.free,UNUSED,p);
      release(&ptable.lock);
      return pid;
    }
    for(i = 0; i < MAX; i++)
    	havekids += findKids(&ptable.pLists.ready[i]);
    havekids += findKids(&ptable.pLists.sleep);
    havekids += findKids(&ptable.pLists.embryo);
    havekids += findKids(&ptable.pLists.running);
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1gcall in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }

}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->cpu_ticks_in = ticks;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle
  int i = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(i = 0; i < MAX; ++i){
    	if(ptable.pLists.ready[i]){
    	  p= ptable.pLists.ready[i];
    	  removeFromStateList(&ptable.pLists.ready[i],RUNNABLE,p);
    	  // Switch to chosen process.  It is the process's job
    	  // to release ptable.lock and then reacquire it
    	  // before jumping back to us.
    	  idle = 0;  // not idle this timeslice
    	  proc = p;
    	  switchuvm(p);
    	  p->state = RUNNING;
    	  insertAtHead(&ptable.pLists.running,RUNNING,p);
    	  p->cpu_ticks_in = ticks;
    	  swtch(&cpu->scheduler, proc->context);
    	  switchkvm();
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  proc = 0;
	  if(ptable.PromoteAtTime <= ticks){
	  	for(i = 1;i < MAX;++i){
			setPrioBudgetList(&ptable.pLists.ready[i],i-1);
			p = ptable.pLists.ready[i];
			ptable.pLists.ready[i] = 0;
			clipToBack(&ptable.pLists.ready[i-1],&p);
		}
		ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; 
	  }
	  i = MAX;
    	}
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
  swtch(&proc->context, cpu->scheduler);
  
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
  proc->state = RUNNABLE;
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
  if(proc->budget <= 0 ){
	if(proc->prio < MAX-1)
		proc->prio = proc->prio + 1;
	proc->budget = BUDGET_MAX;
  }
  insertRoundRobin(&ptable.pLists.ready[proc->prio],RUNNABLE,proc);
  #else
  proc->state = RUNNABLE;
  #endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
  proc->state = SLEEPING;
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
  if(proc->budget <= 0){
	if(proc->prio >= 0)
		proc->prio = proc->prio + 1;
	proc->budget = BUDGET_MAX;
  }
  insertAtHead(&ptable.pLists.sleep,SLEEPING,proc);
  #else
  proc->state = SLEEPING;
  #endif
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *p;
  struct proc * current =ptable.pLists.sleep;
  while(current){
    p = current;
    if(p->chan == chan){
        current = current->next;
	removeFromStateList(&ptable.pLists.sleep,SLEEPING,p);
      	p->state = RUNNABLE;
	insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
      }
    else
    {
	current = current->next;
    }
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  int i = 0;
  struct proc *p;
  struct proc *current;
  acquire(&ptable.lock);
  killState(&ptable.pLists.running,RUNNING,pid);
  killState(&ptable.pLists.embryo,EMBRYO,pid);
  for(i = 0; i < MAX; i++)
  	killState(&ptable.pLists.ready[i],RUNNABLE,pid);
  current = ptable.pLists.sleep;
  while(current){
    p = current;
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      current = current->next;
      removeFromStateList(&ptable.pLists.sleep,SLEEPING,p);
      p->state = RUNNABLE;
      insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
      release(&ptable.lock);
      return 0;
    }
    else current = current->next;
  }
  release(&ptable.lock);
  return -1;

}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

int
spacehelper(int curstring,int largeststring)
{
	int i = 0;
	if(curstring > largeststring)
		return curstring;
	else{
		for(i = 0; i < (largeststring - curstring);++i)
			cprintf(" ");
		return largeststring;
	}
}


//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint overalltime;
  uint sec;
  uint millisec;
  uint cpusec;
  uint cpumillisec;
  uint pc[10];
  cprintf("\nPID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size	PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
      overalltime = ticks - p-> start_ticks;
      sec = 0.01 * overalltime;
      millisec = overalltime % 100;
      cpusec = p->cpu_ticks_total * 0.01;
      cpumillisec = p->cpu_ticks_total % 100;
      cprintf("%d   	%s	%d	%d	", p->pid, p->name,p->uid,p->gid);
      if(p->parent == 0)
        cprintf("%d	", p->pid);
      else 
	cprintf("%d	",p->parent->pid);
      cprintf("%d	%d.%d	%d.%d	%s	%d	",p->prio,sec, millisec,cpusec,cpumillisec,state,p->sz);
      
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
getprocs(int max, struct uproc * table)
{
	int maxnumber = 0;
        struct proc *p;
        acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++)
	{
		if(p->state == SLEEPING||p->state == RUNNABLE||p->state == RUNNING||p->state == ZOMBIE)
		{
			if(max <= maxnumber)
				return max;
			table[maxnumber].prio = p->prio;
			table[maxnumber].pid = p->pid;
			table[maxnumber].uid = p->uid;
			table[maxnumber].gid = p->gid;
			table[maxnumber].elapsed_ticks = ticks - p->start_ticks;
			table[maxnumber].CPU_total_ticks = p->cpu_ticks_total;
			table[maxnumber].size = p->sz;
			safestrcpy(table[maxnumber].name,p->name,STRMAX);
			safestrcpy(table[maxnumber].state,states[p->state],STRMAX);
			if(p->parent->pid < 0 || p->parent->pid > 100)
                	        table[maxnumber].ppid = p->pid;
                	else table[maxnumber].ppid = p->parent->pid;
			++maxnumber;
		}
	}
	release(&ptable.lock);
	return maxnumber;
}

void
freedump(void)
{
	int counter = 0;
	struct proc * current;
	acquire(&ptable.lock);
	current = ptable.pLists.free;
	while(current)
	{
		++counter;
		current = current->next;
	}
	release(&ptable.lock);
	cprintf("Free List Size: %d  Processes\n", counter);
}

void
sleepdump(void)
{
	struct proc * current = ptable.pLists.sleep;
	cprintf("Sleep List Processes: \n");
	acquire(&ptable.lock);
	while(current)
	{
		cprintf("%d -> ", current->pid);
		current = current->next;
	}
	release(&ptable.lock);
	cprintf("\n");
}
void
readydump(void)
{
	int i = 0;
        struct proc * current;
        cprintf("Ready List Processes: \n");
	acquire(&ptable.lock);
	for(i = 0; i < MAX; ++i){
		current = ptable.pLists.ready[i];
		cprintf("%d: ", i);
        	while(current)
        	{
        	        cprintf("(%d,%d) -> ", current->pid, current->budget);
        	        current = current->next;
        	}
        	cprintf("\n");
	}
	release(&ptable.lock);
}

void
zombiedump(void)
{	
	struct proc * current = ptable.pLists.zombie;
        cprintf("Zombie List Processes: \n");
	acquire(&ptable.lock);
        while(current)
        {
                cprintf("(%d,", current->pid);
		if(!current->parent)
			cprintf("%d) -> ", current->pid);
		else
			cprintf("%d) -> ", current->parent->pid);
                current = current->next;
        }
	release(&ptable.lock);
        cprintf("\n");

}

int setpriority(int pid, int priority)
{
	if(priority < 0 || priority >= MAX)
		return -1;
	if(pid < 0)
		return -2;
	struct proc * p = 0;
	acquire(&ptable.lock);
	p = findPid(&ptable.pLists.sleep,pid);
	if(p > 0){
		if(p->prio != priority){
			p->budget = BUDGET_MAX;
			p->prio = priority;
			cprintf("Sleeping process' priority changed");
		}
		release(&ptable.lock);
		return 0;
	}
	p = findPid(&ptable.pLists.running,pid);
	if(p > 0){
		if(p->prio != priority){
                        p->budget = BUDGET_MAX;
                        p->prio = priority;
			cprintf("Running process' priority changed \n");
                }
		release(&ptable.lock);
                return 0;
	}
	p = findReadyPid(pid);
	if(p > 0){
		if(p->prio != priority){
                        p->budget = BUDGET_MAX;
			removeFromStateList(&ptable.pLists.ready[p->prio],RUNNABLE, p);
			p->prio = priority;
			insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
			cprintf("Ready process' priority changed \n");
                }
		release(&ptable.lock);
		return 1;
	}
	release(&ptable.lock);
	return -2;
}
