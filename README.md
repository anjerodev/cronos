# cronos

To install dependencies:

```bash
bun install
```

To run the project:

```bash
bun dev
```

```bash
docker compose up -d --no-deps $(git diff --name-only HEAD~1 | grep -E 'apps/(server|client)|packages/shared|infra/docker|bun.lockb' | cut -d/ -f2 | sort -u | grep -E 'server|client' | xargs)
```
