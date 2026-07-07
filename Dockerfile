# Use a tiny secure base image (Alpine is small)
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy our files into the container
COPY package.json .
COPY server.js .

# Tell the container to run our server on port 3000
EXPOSE 3000

# The command to start the app
CMD ["node", "server.js"]