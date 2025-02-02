FROM nginx:alpine

# Create a temporary build stage
COPY . /tmp/build/
WORKDIR /tmp/build

# Make build script executable and run it
RUN chmod +x build.sh && ./build.sh

# Copy the built files to nginx directory
COPY --from=0 /tmp/build/*.html /usr/share/nginx/html/
COPY --from=0 /tmp/build/*.css /usr/share/nginx/html/
COPY --from=0 /tmp/build/*.js /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
