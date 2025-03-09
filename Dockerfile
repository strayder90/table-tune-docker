# Use an official Node.js runtime as a parent image
FROM node:18-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to install dependencies first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's files to the container
COPY . .

# Expose the port your app runs on
EXPOSE 5173

# Command to run the app (use `npm run build` for production)
CMD ["npm", "start"]
