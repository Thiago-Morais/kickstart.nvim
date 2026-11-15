# Continuity format

`docs/CONTINUITY.md` is gitignored. Each agent rewrites it before stopping so the next one can pick up.

- Under 4,000 characters (`wc -m docs/CONTINUITY.md`). When trimming, aim for about 2,000–2,500, so it has room to grow before the next trim. Rewrite stale parts instead of appending, and drop finished work the next agent doesn't need.
- First line after title: date, branch and last commit.
- Sections, in this order, skipping empty ones: Goal, Done, In progress, Next steps, Skills, Decisions, Open questions, Unverified.
- Skills: the skills the next agent should load for the next steps, one per line with the step it serves (e.g. `architecture-decision-records`: step 2).
- Write facts the next agent can check (commits, commands, names), not transcripts or logs.
- Lasting facts about the project or environment belong in the docs, not here.
