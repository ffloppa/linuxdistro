BUILDS_WITHOUT_PARAMETERS := libxml2 coreutils
THREADS := $(shell nproc 2>/dev/null || echo 1)
DEST := /home/lfs/distro/fs

define build_env
	cd $@ && mkdir -p build && rm -rf build/* && cd build &&
endef

.PHONY: all $(BUILDS_WITHOUT_PARAMETERS) libffi kernel ncurses systemd user clean glibc

all: kernel libffi $(BUILDS_WITHOUT_PARAMETERS) ncurses glibc systemd user

kernel:
	$(MAKE) -C kernel ROOT_PATH=$(CURDIR) -j$(THREADS)

libffi:
	$(build_env) \
	../configure --prefix=/usr --disable-static --with-gcc-arch=native && \
	$(MAKE) -j$(THREADS) && \
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +

$(BUILDS_WITHOUT_PARAMETERS):
	export FORCE_UNSAFE_CONFIGURE=1 && \
	$(build_env) \
	../configure --prefix=/usr && \
	$(MAKE) -j$(THREADS) && \
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +

ncurses:
	$(build_env) \
	../configure CPPFLAGS="-DNCURSES_NOMACROS" --prefix=/usr --with-shared --without-debug --enable-widec && \
	$(MAKE) -j$(THREADS) && \
	$(MAKE) DESTDIR=$(DEST) install

glibc:
	$(build_env) \
	../configure --prefix=/usr --enable-add-ons --with-headers=/usr/include && \
	$(MAKE) -j$(THREADS) && \
	$(MAKE) DESTDIR=$(DEST) install

systemd:
	cd $@ && mkdir -p build && rm -rf build/* && \
	meson setup build/ -Dman=false --buildtype=release --prefix=/usr --sysconfdir=/etc --localstatedir=/var -Dsysvinit-path=/etc/init.d -Drc-local=/etc/rc.local && \
	ninja -C build && \
	DESTDIR=$(DEST) ninja -C build/ install && \
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +

dbus-broker:
	cd $@ && mkdir -p build && rm -rf build/* && \
	meson setup build && \
	meson compile -C build && \
	DESTDIR=$(DEST) meson install -C build

expat:
	cd libexpat && \
	$(build_env) \
	../configure --prefix=/usr && \
	make -j$(THREADS) && \
	make install DESTDIR=$(DEST)

user:
	$(MAKE) -C user ROOT_PATH=$(CURDIR)

clean:
	find . -name "*.o*" -exec rm -rf {} + && \
	find . -name "*.a*" -exec rm -rf {} + && \
	find . -name "*.lo*" -exec rm -rf {} + && \
	find . -name "*.p*" -exec rm -rf {} + &&
