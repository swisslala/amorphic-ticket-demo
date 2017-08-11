FROM node:6.11-alpine

EXPOSE 3000

#RUN apk update && apk add --no-cache \
#    git

RUN addgroup amorphic \
    && adduser -s /bin/bash -D -G amorphic amorphic

WORKDIR /app

# Default to production npm install unless otherwise specified
ARG NODE_ENV=production
ENV NODE_PATH=/app/node_modules/

COPY ./package.json ./
#RUN npm install --no-progress
RUN yarn install --production=true

COPY ./ ./

# the project should have a tsconfig.json in the root... right now userman is a ts dep
#RUN NODE_ENV=development npm install --no-progress \
RUN yarn install --production=false \
    && npm run compile:ts \
    && npm run build:app \
    #&& npm prune --production \
    && yarn install --production --ignore-scripts --prefer-offline \
    #amorphic creates this and it should be addressed
    && mkdir download \
    && chown amorphic:amorphic download

USER amorphic
