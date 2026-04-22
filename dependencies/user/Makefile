THREADS := $(shell nproc 2>/dev/null || echo 1) 
DEST := /home/lfs/distro/fs

define build_env
	cd $@ && mkdir -p build && rm -rf build/* && cd build &&
endef

.PHONY: all kmod kwin qt6 util-linux wayland

all: kmod kwin qt6 util-linux wayland

kmod:
	$(build_env) \
	../configure --prefix=/usr && \
	$(MAKE) -j$(THREADS) && \
	$(MAKE) DESTDIR=$(DEST) install
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +

kwin:
	$(build_env) \
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
	$(MAKE) -j$(THREADS) && \
	$(MAKE) DESTDIR=$(DEST) install

qt6:
	cd qtbase \
	$(build_env) \
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
	cmake --build . --parallel $(THREADS) && \
	cmake --install . && \
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} + \
	cd ../../qtwayland \
	$(build_env) \
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
	cmake --build . --parallel $(THREADS) && \
	cmake --install . && \
	find . -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +

util-linux:
	$(build_env) \
	../configure --prefix=/usr --bindir=/usr/bin --libdir=/usr/lib --runstatedir=/run --sbindir=/usr/bin --without-python && \
	$(MAKE) -j$(THREADS) && \
	$(MAKE) DESTDIR=$(DEST) install

wayland:
	cd $@ && mkdir -p build && rm -rf build/* && \
	meson setup build . --prefix=/usr && \
	meson compile -C build -j $(THREADS) && \
	DESTDIR=$(DEST) meson install -C build && \
	find build -name "*.so*" -exec mv -t $(DEST)/usr/lib {} +
