FROM node:latest

RUN apt-get update && apt-get install -y \
    chromium \
    libnss3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -o -u 1000 user

USER user

ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME/app

COPY --chown=user package*.json $HOME/app

RUN npm i

RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && sudo dpkg -i cloudflared.deb && sudo cloudflared service install eyJhIjoiZmUyZTIwNjBiOTc1YzA2NzQ2NDc0M2RiZDE2Yzg0MWMiLCJ0IjoiYTgwZWJmZDgtMDZjZS00NzQ3LTg1NTctMDc1MDllODA0OGViIiwicyI6Ik1XRTVOek0yTlRFdE56Y3laQzAwWmpKaUxXSTRaVE10T1RWa1ltUmhZelV6WTJVdyJ9

COPY --chown=user . $HOME/app

EXPOSE 7860

CMD ["node", "index"]