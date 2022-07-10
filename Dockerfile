FROM docker

# Default ENV value
ENV SCHEDULER_ENVIRONMENT="development"
# Install required packages
RUN apk add --update --no-cache bash dos2unix

WORKDIR /usr/scheduler

# Copy files
COPY development/* ./development/
COPY start.sh .
COPY sched /usr/local/bin/
# Fix line endings && execute permissions
RUN dos2unix development/* *.sh  && \
    find . -type f -iname "*.sh" -exec chmod +x {} \; && \
    chmod +x /usr/local/bin/sched

# Run cron on container startup
CMD ["/usr/scheduler/start.sh"]