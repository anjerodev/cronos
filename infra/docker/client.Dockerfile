FROM oven/bun:1-alpine AS base
WORKDIR /app

FROM base AS install
RUN mkdir -p /temp
COPY package.json bun.lock /temp/
COPY packages/shared/package.json /temp/packages/shared/
COPY apps/client/package.json /temp/apps/client/
RUN cd /temp && bun install --filter '@apps/client'

FROM base AS prerelease
COPY --from=install /temp/node_modules ./node_modules
COPY apps/client/ ./apps/client/
COPY packages/shared/ ./packages/shared/

ENV NODE_ENV=production
RUN cd apps/client && bun run build

FROM base AS release
COPY --from=install /temp/node_modules ./node_modules
COPY --from=prerelease /app/apps/client/dist ./dist

ENV HOST=0.0.0.0
EXPOSE ${PORT:-4321}
CMD ["bun", "run", "./dist/server/entry.mjs"]