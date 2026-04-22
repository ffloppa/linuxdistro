.PHONY: dependencies pack

dependencies:
	make -C dependencies ROOT_PATH=$(CURDIR)

pack:
	cd fs && \
	find | cpio -o -H newc > ../init.cpio
	

run:
	qemu-system-x86_64 -serial stdio -kernel ~/distro/dependencies/kernel/arch/x86/boot/bzImage -initrd ~/distro/init.cpio -append "init=/init console=ttyS0 earlyprintk=ttyS0,115200 systemd.log_leve=debug" -m 2G
