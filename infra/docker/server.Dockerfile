FROM oven/bun:1-alpine AS base
WORKDIR /app

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json /temp/dev/
COPY packages/shared/package.json /temp/dev/packages/shared/
COPY apps/server/package.json /temp/dev/apps/server/
RUN cd /temp/dev && bun install --filter '@apps/server'

# install with --production (exclude devDependencies)
RUN mkdir -p /temp/prod
COPY package.json /temp/prod/
COPY packages/shared/package.json /temp/prod/packages/shared/
COPY apps/server/package.json /temp/prod/apps/server/
RUN cd /temp/prod && bun install --filter '@apps/server' --production

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules ./node_modules
COPY apps/server/ ./apps/server/
COPY packages/shared/ ./packages/shared/

ENV NODE_ENV=production
# RUN bun test
RUN cd apps/server && bun run build

FROM base AS release
COPY --from=install /temp/prod/node_modules ./node_modules
COPY --from=prerelease /app/apps/server/dist .
COPY --from=prerelease /app/apps/server/package.json .

# run the app
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "run", "index.js" ]
