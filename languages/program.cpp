#include <algorithm>
#include <chrono>
#include <concepts>
#include <functional>
#include <iostream>
#include <ranges>
#include <string>
#include <vector>

// ── Concept ───────────────────────────────────────────────────────────────────
template <typename T>
concept Numeric = std::integral<T> || std::floating_point<T>;

// ── Pipeline builder ──────────────────────────────────────────────────────────
template <Numeric T>
class Pipeline {
public:
    using TransformFn = std::function<std::vector<T>(std::vector<T>)>;

    Pipeline& map(std::function<T(T)> fn) {
        steps_.emplace_back([fn](std::vector<T> v) {
            std::ranges::transform(v, v.begin(), fn);
            return v;
        });
        return *this;
    }

    Pipeline& filter(std::function<bool(T)> pred) {
        steps_.emplace_back([pred](std::vector<T> v) {
            auto end = std::ranges::remove_if(v, std::not_fn(pred));
            v.erase(end.begin(), end.end());
            return v;
        });
        return *this;
    }

    Pipeline& sort_asc() {
        steps_.emplace_back([](std::vector<T> v) {
            std::ranges::sort(v);
            return v;
        });
        return *this;
    }

    std::vector<T> run(std::vector<T> input) const {
        for (const auto& step : steps_)
            input = step(input);
        return input;
    }

private:
    std::vector<TransformFn> steps_;
};

// ── Timer helper ──────────────────────────────────────────────────────────────
template <typename Fn>
auto timed(Fn&& fn) {
    auto t0     = std::chrono::high_resolution_clock::now();
    auto result = fn();
    auto t1     = std::chrono::high_resolution_clock::now();
    auto us     = std::chrono::duration_cast<std::chrono::microseconds>(t1 - t0).count();
    return std::pair{ result, us };
}

int main() {
    std::vector<int> data(100);
    std::iota(data.begin(), data.end(), -50); // -50 .. 49

    Pipeline<int> pipe;
    pipe.filter([](int x) { return x != 0; })
        .map([](int x) { return x * x; })
        .filter([](int x) { return x % 3 != 0; })
        .sort_asc();

    auto [result, elapsed_us] = timed([&] { return pipe.run(data); });

    std::cout << "Result (" << result.size() << " elements, "
              << elapsed_us << " µs):\n";

    for (auto v : result | std::views::take(10))
        std::cout << "  " << v << "\n";
    if (result.size() > 10)
        std::cout << "  ...\n";

    return 0;
}
