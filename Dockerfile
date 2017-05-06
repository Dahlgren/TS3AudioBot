FROM ubuntu:16.04

# Create work directory
RUN mkdir /audiobot
WORKDIR /audiobot

# Install dependencies
RUN apt-get update \
  && apt-get install -y
    curl \
    ffmpeg \
    libopus0 \
    mono-complete \
    nuget \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
  chmod a+rx /usr/local/bin/youtube-dl

# Copy source files
ADD . /audiobot

# Build source
RUN nuget restore
RUN xbuild /p:Configuration=Release /p:Platform=x86 /tv:12.0 TS3AudioBot.sln

# Add Opus dependency
RUN ln -s /usr/lib/x86_64-linux-gnu/libopus.so.0 /audiobot/TS3AudioBot/bin/Release/libopus.so

CMD ["mono", "/audiobot/TS3AudioBot/bin/Release/TS3AudioBot.exe"
