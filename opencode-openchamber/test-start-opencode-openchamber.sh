#!/usr/bin/env bash
set -euo pipefail

kit_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
launcher="$kit_dir/files/home/bin/start-opencode-openchamber"
test_root=$(mktemp -d)
bin_dir="$test_root/bin"
mkdir -p "$bin_dir"

existing_pid=""
launcher_pid=""
child_pid=""

cleanup() {
  for pid in "$launcher_pid" "$existing_pid" "$child_pid"; do
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill -KILL "$pid" 2>/dev/null || true
    fi
  done
  rm -rf "$test_root"
}
trap cleanup EXIT

wait_for_file() {
  local path="$1"
  for _ in $(seq 1 100); do
    [[ -f "$path" ]] && return 0
    sleep 0.05
  done
  echo "Timed out waiting for $path" >&2
  return 1
}

assert_running() {
  local pid="$1"
  kill -0 "$pid" 2>/dev/null || {
    echo "Expected PID $pid to still be running" >&2
    return 1
  }
}

assert_stopped() {
  local pid="$1"
  for _ in $(seq 1 100); do
    kill -0 "$pid" 2>/dev/null || return 0
    sleep 0.05
  done
  echo "Expected PID $pid to stop" >&2
  return 1
}

cat >"$bin_dir/nc" <<'EOF'
#!/usr/bin/env bash
if [[ "${NC_TEST_MODE:-}" == "unreachable" ]]; then
  exit 1
fi
exit 0
EOF

cat >"$bin_dir/opencode" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${OPENCODE_TEST_MODE:-}" == "wait-for-openchamber" ]]; then
  for _ in $(seq 1 100); do
    [[ -f "$TEST_ROOT/openchamber.started" ]] && exit 0
    sleep 0.05
  done
  exit 1
fi
EOF

cat >"$bin_dir/openchamber" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "stop" ]]; then
  kill "$(cat "$TEST_ROOT/openchamber.child")"
  touch "$TEST_ROOT/openchamber.stopped"
  exit 0
fi

echo "$$" >"$TEST_ROOT/openchamber.parent"
setsid sleep 60 &
echo "$!" >"$TEST_ROOT/openchamber.child"
touch "$TEST_ROOT/openchamber.started"
EOF

chmod +x "$bin_dir/nc" "$bin_dir/opencode" "$bin_dir/openchamber"

run_launcher() {
  HOME="$test_root/home" \
    PATH="$bin_dir:$PATH" \
    TEST_ROOT="$test_root" \
    OPENCHAMBER_PORT=39001 \
    OPENCODE_TEST_MODE="$1" \
    NC_TEST_MODE="${2:-}" \
    bash "$launcher" &
  launcher_pid=$!
}

# A stale PID record must not terminate an independently started instance.
sleep 60 &
existing_pid=$!
mkdir -p "$test_root/home/.local/state/opencode-openchamber"
printf '%s 1\n' "$existing_pid" >"$test_root/home/.local/state/opencode-openchamber/openchamber.pid"
run_launcher immediate-exit unreachable
wait "$launcher_pid"
assert_running "$existing_pid"
kill "$existing_pid"
wait "$existing_pid" 2>/dev/null || true
existing_pid=""
rm -f "$test_root/openchamber.started" "$test_root/openchamber.parent" "$test_root/openchamber.child"

# Cleanup must terminate both the owned UI process and its child process.
run_launcher wait-for-openchamber
wait_for_file "$test_root/openchamber.child"
child_pid=$(cat "$test_root/openchamber.child")
wait "$launcher_pid"
assert_stopped "$child_pid"

if HOME="$test_root/home" PATH="$bin_dir:$PATH" OPENCHAMBER_PORT='3000.*' bash "$launcher" >/dev/null 2>&1; then
  echo "Expected invalid OPENCHAMBER_PORT to fail" >&2
  exit 1
fi