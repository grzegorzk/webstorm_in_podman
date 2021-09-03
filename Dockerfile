ARG GROUP_ID=1001
ARG USER_ID=1001

FROM docker.io/techgk/arch:latest AS firefox

RUN pacman -Sy --disable-download-timeout --noconfirm \
        git \
        base-devel \
        fakeroot \
        binutils \
        jre11-openjdk \
        sudo \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        xorg-server \
        xorg-apps \
        ffmpeg \
        mesa \
    && rm -rf /var/cache/pacman/pkg/* \
    && sed -i -- 's/#[ ]*\(%wheel ALL=(ALL) NOPASSWD: ALL\)$/\1/gw /tmp/sed.done' /etc/sudoers

ARG GROUP_ID
ARG USER_ID

RUN groupadd -g $GROUP_ID webstorm \
    && useradd -u $USER_ID -g $GROUP_ID -G audio,video,wheel -m webstorm

COPY docker_files/pulse-client.conf /etc/pulse/client.conf

RUN su -l webstorm -c "cd /tmp && git clone https://aur.archlinux.org/trizen.git && cd trizen && makepkg -si --noconfirm" \
    && su -l webstorm -c "trizen -S --disable-download-timeout --noconfirm webstorm" \
    && sed -i /opt/webstorm/bin/webstorm.sh -e 's/ || \[ ! -x "$JAVA_BIN" \]//g'

USER webstorm

ENTRYPOINT []
CMD []
