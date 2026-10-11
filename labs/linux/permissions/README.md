# Linux Permissions Lab

**Status:** Not attempted

**Goal:** Explain, change, and verify Linux file and directory permissions.

## Safety and evidence

- Use only your personal learning environment, not your work distribution.
- Perform exercises in a new disposable directory such as `~/permissions-lab`. Keep all test files inside it.
- Do not change permissions on system directories, your entire home directory, SSH keys, or this repository.
- Do not use `sudo` to bypass a failed permission test. Ownership changes may require administrator access; discuss those commands before running them.
- Use harmless test content. Record your commands, expected results, actual results, and explanations after each exercise.
- If another user or group is unavailable, discuss the scenario instead and mark it as not executed.

## Part 1: Understanding permissions

1. In `-rw-r-----`, what does each character mean? Who can read, write, and execute the file?
2. What is the difference between the owner, group, and others? Which permission class applies when you own a file and also belong to its group?
3. Translate `640`, `750`, and `600` into symbolic permissions. What does each digit represent?
4. How do read, write, and execute permissions differ between a regular file and a directory?
5. Can someone delete a file they cannot write to? Which permissions control deletion, and how can the sticky bit change this?
6. Why is `chmod 777` usually an inappropriate fix for a permission error?

## Part 2: Hands-on challenges

### Challenge 1: Inspect your environment

- Identify your current user and group memberships.
- Create the disposable lab directory and a harmless text file inside it.
- Inspect the owner, group, and permissions of both.
- Predict whether your current user can read and modify the file. Test both predictions.

### Challenge 2: Make a private file

- Set the file permissions so only its owner can read and write it.
- Show the symbolic and numeric permissions.
- Explain whether another ordinary user could read it, and what evidence would be needed to verify that claim.

### Challenge 3: Compare symbolic and numeric modes

- Give the owner read/write access, the group read access, and others no access.
- Express the same target permissions using both symbolic and numeric notation.
- Remove group read access without changing any other permission bits. Verify the result.

### Challenge 4: Test directory permissions

- Create a test subdirectory containing a text file.
- Predict what happens when the directory has owner read permission but no owner execute permission.
- Test listing its names, inspecting a contained file, and reading that file. Explain any differences.
- Next, give the directory owner execute permission but no read permission. Test listing and accessing a file by its known name.
- Restore owner read/write/execute access before continuing.

### Challenge 5: Read-only file versus deletion

- Create a separate test file in a directory you own and can write to and traverse.
- Remove write permission from the file. Predict whether you can edit it and whether you can delete it.
- Test both actions as your ordinary user. Distinguish a command's confirmation prompt from an operating-system permission denial.

### Challenge 6: Shared access scenario

- Suppose `rehmana` and `iqra` need to read a shared file, but only `rehmana` should modify it. No other ordinary user should have access.
- Propose an owner, shared group, file mode, and parent-directory permissions.
- Which commands would inspect or change ownership and group membership? Which changes require administrator access?
- How would you test access as each user without borrowing credentials or using root as the test user?
- Do not create users, change memberships, or change ownership yet. Present your proposed commands for review first.

### Challenge 7: Investigate a permission error

- A user has read permission on a file but receives `Permission denied` when opening it. What would you inspect along the full path?
- A script has execute permission but cannot be run directly. What else could cause this failure?
- What would you check if ordinary mode bits appear correct but access is still denied? Consider ACLs, mount options, and security policies.

### Challenge 8: Default permissions

- Inspect your current `umask` and explain its effect on newly created files and directories.
- Predict the permissions of a normal new text file and directory with a `umask` of `027`.
- Test that prediction in a subshell so your usual shell settings remain unchanged.
- Does changing `umask` alter existing files? Verify your answer.

## Completion check

- [ ] I explained the concepts in my own words.
- [ ] I recorded predictions before testing.
- [ ] I verified the practical exercises as an ordinary user.
- [ ] I distinguished executed tests from discussion-only scenarios.
- [ ] I documented permission failures and their causes.
- [ ] I restored access to my test directory and recorded the results in the progress journal.

## Answers and evidence

Not recorded yet. Start with Part 1, Question 1; add answers and command output only as we work through the lab.