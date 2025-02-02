FROM python:3.14.0a2-alpine



# Install packages
RUN apk add --update --no-cache supervisor python3-dev jpeg-dev libpng-dev freetype-dev gcc musl-dev

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install dependencies
RUN pip install Flask

# Add user
RUN adduser -D -u 1000 -g 1000 -s /bin/sh www

# Copy flag
COPY data/flag.txt data/flag.txt

# Setup app
RUN mkdir -p /app

# Switch working environment
WORKDIR /app

# Add application
COPY challenge .
RUN chown -R www:www .

# Install python dependencies
RUN python -m pip install -r requirements.txt

# Setup supervisor
COPY config/supervisord.conf /etc/supervisord.conf

# Expose port the server is reachable on
EXPOSE 1337

# Disable pycache
ENV PYTHONDONTWRITEBYTECODE=1

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]