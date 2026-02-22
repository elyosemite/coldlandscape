/**
 * A minimal observable / reactive store.
 * No dependencies — works in browser and Node.
 */

const EMPTY = Symbol("EMPTY");

function createStore(initialState) {
  let state = structuredClone(initialState);
  const listeners = new Set();

  function getState() {
    return state;
  }

  function setState(updater) {
    const next = typeof updater === "function" ? updater(state) : updater;
    if (Object.is(next, state)) return;
    const prev = state;
    state = next;
    listeners.forEach((fn) => fn(state, prev));
  }

  function subscribe(listener) {
    listeners.add(listener);
    return () => listeners.delete(listener);
  }

  function select(selector) {
    let lastInput = EMPTY;
    let lastOutput = EMPTY;

    return () => {
      const input = selector(state);
      if (!Object.is(input, lastInput)) {
        lastInput = input;
        lastOutput = input;
      }
      return lastOutput;
    };
  }

  return { getState, setState, subscribe, select };
}

// ── Demo ──────────────────────────────────────────────────────────────────────

const store = createStore({ count: 0, user: null, theme: "cold-landscape" });

const unsubscribe = store.subscribe((next, prev) => {
  if (next.count !== prev.count) {
    console.log(`count changed: ${prev.count} → ${next.count}`);
  }
});

const selectCount = store.select((s) => s.count);

store.setState((s) => ({ ...s, count: s.count + 1 }));
store.setState((s) => ({ ...s, count: s.count + 1 }));
store.setState((s) => ({ ...s, user: { name: "Alfredo", role: "admin" } }));

console.log("current count:", selectCount());
console.log("full state:", store.getState());

unsubscribe();

store.setState((s) => ({ ...s, count: 99 })); // silent — no listener
console.log("after unsubscribe:", store.getState().count);
