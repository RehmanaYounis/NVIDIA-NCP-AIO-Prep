# Linux Permissions Lab

**Status:** Not attempted

**Goal:** Diagnose permission problems, apply the smallest appropriate fix, and verify it as an ordinary user.

## Before starting

- Use Bash in your personal Linux learning environment, 
- Run the common setup once, then each scenario's setup in the same terminal. Do not rerun a setup over your completed work; start a fresh lab instead.
- All examples use harmless data in a new temporary directory. Never apply these changes to system files, your home directory, SSH keys, or this repository.
- Do not use `sudo` to make a failing operation succeed. The optional two-user scenario uses `sudo -u iqra` only to test as that ordinary user.
- Setup commands deliberately create problematic permissions. They are not solutions.
- Record your prediction before testing, then the command, output, explanation, fix, and verification. No scenarios are marked complete automatically.

### Common prerequisites and setup

You need Bash and standard Linux tools: `mktemp`, `mkdir`, `printf`, `chmod`, `cat`, `ls`, `stat`, `id`, `touch`, and `rm`.

```bash
LAB_ROOT=$(mktemp -d /tmp/ncp-permissions.XXXXXX)
export LAB_ROOT
printf 'Lab directory: %s\n' "$LAB_ROOT"
id
ls -ld "$LAB_ROOT"
```

Keep this terminal open: later commands use `$LAB_ROOT`. It starts as a private directory owned by your current user. A new terminal needs a new lab or the exact existing path assigned to that variable.

## Scenario 1: A supposedly private configuration file

**Problem:** A file contains dummy internal notes, but its mode permits access by other users. Only its owner should be able to read and modify it.

**Prerequisites and setup:** Run the common setup first.

```bash
mkdir -m 700 "$LAB_ROOT/01-private"
printf 'Dummy configuration; no real secrets\n' > "$LAB_ROOT/01-private/config.txt"
chmod 666 "$LAB_ROOT/01-private/config.txt"
stat -c '%A %a %U %G %n' "$LAB_ROOT/01-private/config.txt"
```

**Tasks:** Decode the current mode. Does the private parent directory already restrict access? Change the file mode so only its owner can read and write it, even if it is later moved to a traversable directory. Express your target mode in symbolic and numeric notation.

**Success checks:** Inspect the resulting mode, read the file with `cat`, and append harmless text with `printf`. Explain why mode inspection alone is not an access test as another user.

## Scenario 2: The owner cannot update a report

**Problem:** You own a report and can read it, but appending a new entry fails. The report should remain private.

**Prerequisites and setup:** Run the common setup first.

```bash
mkdir -m 700 "$LAB_ROOT/02-report"
printf 'Initial report\n' > "$LAB_ROOT/02-report/report.txt"
chmod 400 "$LAB_ROOT/02-report/report.txt"
stat -c '%A %a %U %G %n' "$LAB_ROOT/02-report/report.txt"
```

**Reproduce:**

```bash
cat "$LAB_ROOT/02-report/report.txt"
printf 'New entry\n' >> "$LAB_ROOT/02-report/report.txt"
```

**Tasks:** Explain which permission is missing. Fix only the necessary owner permission, without granting group or others access or changing ownership.

**Success checks:** Repeat the append, confirm the new entry appears, and inspect the final mode. Why would testing as root hide the problem?

## Scenario 3: A readable file is unreachable

**Problem:** A report has owner read/write permission, but reading it through its directory path fails.

**Prerequisites and setup:** Run the common setup first. Change the directory mode last, after creating the file.

```bash
mkdir -m 700 "$LAB_ROOT/03-traversal"
printf 'Deployment succeeded\n' > "$LAB_ROOT/03-traversal/status.txt"
chmod 600 "$LAB_ROOT/03-traversal/status.txt"
chmod 600 "$LAB_ROOT/03-traversal"
ls -ld "$LAB_ROOT/03-traversal"
```

**Reproduce:**

```bash
ls "$LAB_ROOT/03-traversal"
ls -l "$LAB_ROOT/03-traversal/status.txt"
cat "$LAB_ROOT/03-traversal/status.txt"
```

**Tasks:** Explain why listing names can succeed while accessing a contained file fails. Fix the directory so its owner can list, traverse, and modify it, but no other user gains access. Do not change the file mode.

**Success checks:** Repeat all three operations and inspect both modes. Explain the different meanings of `r`, `w`, and `x` on a directory.

## Scenario 4: Known-path access without directory listing

**Problem:** You can open a file by its exact name, but cannot list the containing directory.

**Prerequisites and setup:** Run the common setup first.

```bash
mkdir -m 700 "$LAB_ROOT/04-listing"
printf 'Known filename content\n' > "$LAB_ROOT/04-listing/known.txt"
chmod 600 "$LAB_ROOT/04-listing/known.txt"
chmod 100 "$LAB_ROOT/04-listing"
```

**Reproduce:**

```bash
cat "$LAB_ROOT/04-listing/known.txt"
ls "$LAB_ROOT/04-listing"
```

**Tasks:** Explain both results. Allow the owner to list and traverse the directory, but not create or delete entries. Keep group and others permissions disabled.

**Success checks:** Reading and listing should succeed. Attempt `touch "$LAB_ROOT/04-listing/new.txt"`; it should fail. Inspect the mode and explain why file editing and directory-entry creation require different permissions.

## Scenario 5: A script works through Bash but not directly

**Problem:** A health-check script can be read and interpreted by Bash, but direct execution fails.

**Prerequisites and setup:** Run the common setup first. This script only prints a message.

```bash
mkdir -m 700 "$LAB_ROOT/05-script"
printf '%s\n' '#!/bin/bash' 'printf "Health check OK\n"' > "$LAB_ROOT/05-script/health-check.sh"
chmod 600 "$LAB_ROOT/05-script/health-check.sh"
```

**Reproduce:**

```bash
bash "$LAB_ROOT/05-script/health-check.sh"
"$LAB_ROOT/05-script/health-check.sh"
```

**Tasks:** Explain why the invocations behave differently. Allow direct execution by the owner only, preserving existing read/write permissions.

**Success checks:** Both invocations should print `Health check OK`. If direct execution still fails, inspect the interpreter path and the mount's `noexec` setting rather than granting broader permissions. A `noexec` mount is an environment limitation; do not remount it for this lab.

## Scenario 6: A read-only file can still be deleted

**Problem:** Someone assumes removing write permission from a file prevents its deletion.

**Prerequisites and setup:** Run the common setup first. Delete only the disposable file named below.

```bash
mkdir -m 700 "$LAB_ROOT/06-delete"
printf 'Disposable test data\n' > "$LAB_ROOT/06-delete/disposable.txt"
chmod 400 "$LAB_ROOT/06-delete/disposable.txt"
ls -ld "$LAB_ROOT/06-delete"
ls -l "$LAB_ROOT/06-delete/disposable.txt"
```

**Tasks:**

- Predict whether appending succeeds. Test with `printf 'Extra\n' >> "$LAB_ROOT/06-delete/disposable.txt"`.
- Predict whether deletion succeeds. Test with `rm -i "$LAB_ROOT/06-delete/disposable.txt"`; answer the confirmation yourself.
- Explain which directory permissions govern deletion and why a confirmation prompt is not a permission denial.
- Recreate the file using the setup's `printf` and file `chmod` commands. Change only the directory mode so the owner can list and traverse it but cannot delete or create entries.

**Success checks:** Reading the recreated file should work, while deletion should fail after confirmation. Explain how a sticky bit changes deletion rules in a shared writable directory, and why it does not stop an owner deleting their own file.

## Scenario 7: New files have overly broad defaults

**Problem:** A process creates a normal text file and directory with a `umask` of `000`. New files should instead permit owner read/write, group read, and no others access; new directories should permit full owner access, group read/traverse, and no others access.

**Prerequisites and setup:** Run the common setup first. The subshell keeps your normal shell's mask unchanged.

```bash
mkdir -m 700 "$LAB_ROOT/07-defaults"
umask
(
	umask 000
	printf 'Existing file\n' > "$LAB_ROOT/07-defaults/existing.txt"
	mkdir "$LAB_ROOT/07-defaults/existing-dir"
)
stat -c '%A %a %n' "$LAB_ROOT/07-defaults/existing.txt" "$LAB_ROOT/07-defaults/existing-dir"
```

**Tasks:**

- Calculate the required mask from normal creation modes `666` for files and `777` for directories. Explain why a mask clears bits rather than granting permissions.
- In a subshell using your chosen mask, create `new.txt` with `printf` and `new-dir` with `mkdir` inside this scenario's directory.
- Predict whether the existing file and directory change when you set the new mask.

**Success checks:** Inspect all four modes. New objects should match the stated policy; existing objects should retain their original modes. Confirm your outer shell's `umask` is unchanged.

## Scenario 8: Verify access as a second user (optional)

**Problem:** A dummy note must remain readable and writable by its owner but unreadable by `iqra`, even when its directory path is traversable.

**Prerequisites:** Complete the earlier scenarios first. `iqra` must already exist, be a different non-root user, and not own the test file. Check with `id` and `id iqra`. You need permission to run commands as `iqra`; enter any password only in your own terminal. Do not create users or change group memberships for this exercise.

**Setup:** These directory modes intentionally allow traversal for this test, but not directory listing by other users. Earlier scenarios remain behind their own restricted directories.

```bash
mkdir -m 711 "$LAB_ROOT/08-second-user"
printf 'Dummy note, not a secret\n' > "$LAB_ROOT/08-second-user/note.txt"
chmod 644 "$LAB_ROOT/08-second-user/note.txt"
chmod 711 "$LAB_ROOT"
stat -c '%A %a %U %G %n' "$LAB_ROOT/08-second-user/note.txt"
```

**Reproduce, in your terminal:**

```bash
sudo -u iqra -- id
sudo -u iqra -- cat "$LAB_ROOT/08-second-user/note.txt"
```

**Tasks:** Explain why `iqra` can initially read the note. Change only the file mode to satisfy the policy, then repeat the read as `iqra`. Do not test as root or grant administrator privileges to `iqra`.

**Success checks:** The owner can read and append; `iqra` receives `Permission denied` when reading. Inspect ownership and permissions to explain the result. If the prerequisite user or authorization is unavailable, mark this scenario as not executed.

## Cleanup and evidence

Some scenarios leave directories without owner write or execute access. Once you have finished, restore access only inside this lab:

```bash
chmod 700 "$LAB_ROOT"
chmod -R u+rwX -- "$LAB_ROOT"
```

Keep the directory until you have recorded evidence. Temporary files may disappear on reboot; store sanitized findings in this repository, not real credentials or sensitive logs.

For each scenario, record:

- Prediction and reasoning
- Initial permissions and ownership
- Reproduction commands and actual output
- Your fix and why it is sufficient
- Verification results and environment limitations

**Answers and evidence:** Not recorded yet. Start with Scenario 1; solve one scenario at a time.