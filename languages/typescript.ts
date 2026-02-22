type Status = "pending" | "running" | "done" | "failed";

interface Task<T> {
  id: string;
  label: string;
  status: Status;
  result?: T;
  error?: Error;
  createdAt: Date;
}

type TaskRunner<T> = (signal: AbortSignal) => Promise<T>;
type EventMap<T> = {
  enqueued: Task<T>;
  started:  Task<T>;
  done:     Task<T>;
  failed:   Task<T>;
};
type Listener<T, K extends keyof EventMap<T>> = (payload: EventMap<T>[K]) => void;

class TaskQueue<T> {
  private queue: Array<{ task: Task<T>; runner: TaskRunner<T> }> = [];
  private running = 0;
  private listeners = new Map<keyof EventMap<T>, Set<Listener<T, any>>>();

  constructor(private readonly concurrency: number = 4) {}

  on<K extends keyof EventMap<T>>(event: K, listener: Listener<T, K>): this {
    if (!this.listeners.has(event)) this.listeners.set(event, new Set());
    this.listeners.get(event)!.add(listener);
    return this;
  }

  off<K extends keyof EventMap<T>>(event: K, listener: Listener<T, K>): this {
    this.listeners.get(event)?.delete(listener);
    return this;
  }

  private emit<K extends keyof EventMap<T>>(event: K, payload: EventMap<T>[K]): void {
    this.listeners.get(event)?.forEach((fn) => fn(payload));
  }

  enqueue(id: string, label: string, runner: TaskRunner<T>): Task<T> {
    const task: Task<T> = { id, label, status: "pending", createdAt: new Date() };
    this.queue.push({ task, runner });
    this.emit("enqueued", task);
    this.drain();
    return task;
  }

  private async drain(): Promise<void> {
    while (this.running < this.concurrency && this.queue.length > 0) {
      const entry = this.queue.shift()!;
      this.running++;
      this.execute(entry.task, entry.runner);
    }
  }

  private async execute(task: Task<T>, runner: TaskRunner<T>): Promise<void> {
    const controller = new AbortController();
    task.status = "running";
    this.emit("started", task);

    try {
      task.result = await runner(controller.signal);
      task.status = "done";
      this.emit("done", task);
    } catch (err) {
      task.error = err instanceof Error ? err : new Error(String(err));
      task.status = "failed";
      this.emit("failed", task);
    } finally {
      this.running--;
      this.drain();
    }
  }

  get pending(): number {
    return this.queue.length;
  }
}

// ── Usage ─────────────────────────────────────────────────────────────────────

const queue = new TaskQueue<string>(2);

queue
  .on("done",   (task) => console.log(`[${task.id}] finished: ${task.result}`))
  .on("failed", (task) => console.error(`[${task.id}] error: ${task.error?.message}`));

for (let i = 0; i < 5; i++) {
  queue.enqueue(`task-${i}`, `Job ${i}`, async (signal) => {
    await new Promise<void>((res) => setTimeout(res, Math.random() * 1000));
    if (signal.aborted) throw new Error("Aborted");
    return `result-${i}`;
  });
}

console.log(`Queued ${queue.pending} pending tasks`);
