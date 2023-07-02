# Use the official Node.js image as the base
FROM node:14
# Set the working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json to the container
COPY package.json /app
# Install dependencies
RUN npm install
# Copy the rest of the application code to the container
COPY . /app
#install docker dependencies
RUN npm install
#Port expose 
EXPOSE 8080
# Specify the command to run when the container starts
CMD ["npm", "start"]
