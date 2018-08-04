FROM debian:latest AS gcc-build

ARG VERSION

RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    binutils \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    g++ \
    gnupg \
    libc6-dev \
    make \
    xz-utils \
  ; \
  rm -rf /var/lib/apt/lists/*

# B215C1633BCA0477615F1B35A5B3A004745C015A: dsa1024 1999-11-09 Gerald Pfeifer <gerald@pfeifer.com>
# B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8: dsa1024 2003-04-10 Mark Mitchell <mark@codesourcery.com>
# 90AA470469D3965A87A5DCB494D03953902C9419: dsa1024 2004-12-06 Gabriel Dos Reis <gdr@acm.org>
# 80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C: dsa1024 2000-02-13 Joseph Samuel Myers <jsm@polyomino.org.uk>
# 7F74F97C103468EE5D750B583AB00996FC26A641: dsa1024 2001-06-26 Richard Guenther <richard.guenther@gmail.com>
# 33C235A34C46AA3FFB293709A328C3A2C3C45C06: dsa1024 2004-04-21 Jakub Jelinek <jakub@redhat.com>
RUN set -ex; \
  key_ids='B215C1633BCA0477615F1B35A5B3A004745C015A \
           B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
           90AA470469D3965A87A5DCB494D03953902C9419 \
           80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
           7F74F97C103468EE5D750B583AB00996FC26A641 \
           33C235A34C46AA3FFB293709A328C3A2C3C45C06'; \
  for key_server in 'hkp://keys.gnupg.net:80' \
                    'hkp://zimmermann.mayfirst.org:80' \
                    'hkp://pgp.key-server.io:80' \
                    'hkp://keyserver.ubuntu.com:80' \
                    'hkp://p80.pool.sks-keyservers.net:80'; do \
    gpg --keyserver "$key_server" --recv-keys $key_ids && break; \
  done

RUN set -ex; \
  mkdir -p /usr/local/src/gcc; \
  cd /usr/local/src/gcc; \
  curl -fLsSo gcc.tar.xz "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.xz"; \
  curl -fLsSo gcc.tar.xz.sig "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.xz.sig"; \
  gpg --batch --verify gcc.tar.xz.sig gcc.tar.xz; \
  tar -xf gcc.tar.xz -C /usr/local/src/gcc --strip-components=1; \
  rm gcc.tar.xz*; \
  ./contrib/download_prerequisites; \
  rm *.tar.* || true; \
  objdir="$(mktemp -d)"; \
  cd "$objdir"; \
  /usr/local/src/gcc/configure --disable-multilib --enable-languages=c,c++; \
  make -j $(nproc); \
  make install-strip; \
  cd /usr/local/src; \
  rm -rf "$objdir"; \
  rm -rf gcc

RUN set -ex; \
  echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf; \
  ldconfig -v



FROM debian:latest

RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    binutils \
    libc6-dev \
  ; \
  rm -rf /var/lib/apt/lists/*

COPY --from=gcc-build /usr/local/ /usr/local/
RUN set -ex; \
  echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf; \
  ldconfig -v
