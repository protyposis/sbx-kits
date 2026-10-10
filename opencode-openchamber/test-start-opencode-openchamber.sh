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

cat >"$bin_dir/curl" <<'EOF'
#!/usr/bin/env bash
if [[ "${CURL_TEST_MODE:-}" == "unreachable" ]]; then
  exit 22
fi
printf '%s\n' "$*" >>"$TEST_ROOT/curl.args"
exit 0
EOF

cat >"$bin_dir/opencode" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "$*" >"$TEST_ROOT/opencode.tui"
printf '%s\n' "${OPENCODE_SERVER_PASSWORD:-}" >"$TEST_ROOT/opencode.password"

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
  exit 0
fi

printf '%s\n' "$*" >"$TEST_ROOT/openchamber.args"
printf '%s\n' "${OPENCODE_SERVER_PASSWORD:-}" >"$TEST_ROOT/openchamber.password"
printf '%s\n' "${OPENCHAMBER_OPENCODE_PORT:-}" >"$TEST_ROOT/openchamber.opencode_port"
setsid sleep 60 &
echo "$!" >"$TEST_ROOT/openchamber.child"
touch "$TEST_ROOT/openchamber.started"
EOF

chmod +x "$bin_dir/curl" "$bin_dir/opencode" "$bin_dir/openchamber"

run_launcher() {
  HOME="$test_root/home" \
    PATH="$bin_dir:$PATH" \
    TEST_ROOT="$test_root" \
    OPENCHAMBER_PORT=39001 \
    OPENCODE_READY_TIMEOUT=1 \
    OPENCODE_TEST_MODE="$1" \
    CURL_TEST_MODE="${2:-}" \
    bash "$launcher" &
  launcher_pid=$!
}

reset_state() {
  rm -f "$test_root"/openchamber.* "$test_root"/opencode.* "$test_root"/curl.args
}

# A stale PID record must not terminate an independently started instance,
# and a backend that never becomes ready must fail the launcher.
sleep 60 &
existing_pid=$!
mkdir -p "$test_root/home/.local/state/opencode-openchamber"
printf '%s 1\n' "$existing_pid" >"$test_root/home/.local/state/opencode-openchamber/openchamber.pid"
run_launcher immediate-exit unreachable
if wait "$launcher_pid"; then
  echo "Expected launcher to fail when OpenCode never becomes ready" >&2
  exit 1
fi
assert_running "$existing_pid"
kill "$existing_pid"
wait "$existing_pid" 2>/dev/null || true
existing_pid=""
child_pid=$(cat "$test_root/openchamber.child")
assert_stopped "$child_pid"
reset_state

# OpenChamber owns OpenCode; the TUI attaches to it with the shared password,
# and cleanup stops OpenChamber when the TUI exits.
run_launcher wait-for-openchamber
wait_for_file "$test_root/openchamber.child"
child_pid=$(cat "$test_root/openchamber.child")
wait "$launcher_pid"
assert_stopped "$child_pid"
grep -Fx -- '--lan --port 39001' "$test_root/openchamber.args" >/dev/null
grep -Fx '4096' "$test_root/openchamber.opencode_port" >/dev/null
grep -Fx -- '--server http://127.0.0.1:4096' "$test_root/opencode.tui" >/dev/null
password=$(cat "$test_root/opencode.password")
if [[ -z "$password" || "$password" != "$(cat "$test_root/openchamber.password")" ]]; then
  echo "Expected OpenChamber and the TUI to share one password" >&2
  exit 1
fi
grep -F -- "opencode:$password" "$test_root/curl.args" >/dev/null
reset_state

if HOME="$test_root/home" PATH="$bin_dir:$PATH" OPENCHAMBER_PORT='3000.*' bash "$launcher" >/dev/null 2>&1; then
  echo "Expected invalid OPENCHAMBER_PORT to fail" >&2
  exit 1
fi

echo "All tests passed"
