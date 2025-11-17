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

# Environment variables must be present at build time
ENV NODE_ENV=production
ARG SERVER_API_URL
ENV SERVER_API_URL=${SERVER_API_URL}

RUN cd apps/client && bun run build

FROM base AS release
COPY --from=install /temp/node_modules ./node_modules
COPY --from=prerelease /app/apps/client/dist ./dist

# Environment variables must be redefined at run time
ARG SERVER_API_URL
ENV SERVER_API_URL=${SERVER_API_URL}
ENV NODE_ENV=production
ENV HOST=0.0.0.0
 # Note: Don't expose ports here, Compose will handle that for us

CMD ["bun", "run", "./dist/server/entry.mjs"]