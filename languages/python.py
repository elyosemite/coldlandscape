from __future__ import annotations

import asyncio
import dataclasses
import time
from collections.abc import AsyncIterator
from typing import Any, Generic, TypeVar

T = TypeVar("T")
SENTINEL = object()


@dataclasses.dataclass(frozen=True)
class Message(Generic[T]):
    value: T
    timestamp: float = dataclasses.field(default_factory=time.monotonic)

    def age(self) -> float:
        return time.monotonic() - self.timestamp


class BroadcastChannel(Generic[T]):
    """Fan-out channel: every subscriber receives every message."""

    def __init__(self, maxsize: int = 0) -> None:
        self._subscribers: list[asyncio.Queue[Any]] = []
        self._maxsize = maxsize
        self._closed = False

    def subscribe(self) -> asyncio.Queue[Message[T]]:
        if self._closed:
            raise RuntimeError("Channel is closed")
        queue: asyncio.Queue[Message[T]] = asyncio.Queue(maxsize=self._maxsize)
        self._subscribers.append(queue)
        return queue

    async def publish(self, value: T) -> None:
        if self._closed:
            raise RuntimeError("Channel is closed")
        msg = Message(value)
        for q in self._subscribers:
            await q.put(msg)

    def close(self) -> None:
        self._closed = True
        for q in self._subscribers:
            q.put_nowait(SENTINEL)  # type: ignore[arg-type]

    async def __aenter__(self) -> BroadcastChannel[T]:
        return self

    async def __aexit__(self, *_: object) -> None:
        self.close()


async def consume(name: str, queue: asyncio.Queue[Message[str]]) -> None:
    while True:
        item = await queue.get()
        if item is SENTINEL:
            print(f"[{name}] channel closed")
            break
        print(f"[{name}] received '{item.value}' (age={item.age():.3f}s)")


async def main() -> None:
    async with BroadcastChannel[str](maxsize=16) as ch:
        q1 = ch.subscribe()
        q2 = ch.subscribe()

        consumers = asyncio.gather(
            consume("alpha", q1),
            consume("beta", q2),
        )

        for word in ("cold", "landscape", "dark", "theme"):
            await ch.publish(word)
            await asyncio.sleep(0.1)

    await consumers


if __name__ == "__main__":
    asyncio.run(main())
