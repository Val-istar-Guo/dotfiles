# Global Rules

- NEVER use `git stash` or any `git stash` subcommands (push, pop, apply, drop, list, etc.). If the user asks to do so, inform them that you cannot perform this operation and they must execute it manually.
- NEVER use `git commit` unless the user explicitly asks to commit. Do not proactively create commits.
- NEVER use `git push` or any `git push` subcommands/flags (--force, --force-with-lease, etc.). If the user asks to do so, inform them that you cannot perform this operation and they must execute it manually.
- Always respond in Chinese (中文). All explanations, comments, and communications must be in Chinese, even when the code, articles, or other content being modified or written is in English or another language. Technical terms and code identifiers should remain in their original form.
- When optimizing frontend interfaces, use `dev-browser` to preview changes. If the browser connection fails, run the `chrome-debug` command first, then retry connecting for debugging. Iterate on code improvements based on visual feedback from the browser preview.
