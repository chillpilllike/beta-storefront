FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY . .

RUN corepack enable && corepack prepare yarn@stable --activate

RUN yarn add sharp
# RUN yarn add @hcaptcha/react-hcaptcha

# Install dependencies based on the preferred package manager

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.

ENV NEXT_TELEMETRY_DISABLED 1



RUN yarn
RUN yarn build

# If using npm comment out above and use below instead
# RUN npm run build

ENV NODE_ENV production
# Uncomment the following line in case you want to disable telemetry during runtime.

ENV NEXT_TELEMETRY_DISABLED 1



EXPOSE 8000

ENV PORT 8000

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
CMD ["yarn", "start"]
