# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hal/hal-0.5.7.1-r3.ebuild,v 1.10 2007/01/30 16:42:06 cardoe Exp $

inherit eutils linux-info

DESCRIPTION="Hardware Abstraction Layer"
HOMEPAGE="http://www.freedesktop.org/Software/hal"
SRC_URI="http://freedesktop.org/~david/dist/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sh sparc x86"
IUSE="acpi crypt debug doc dmi pcmcia selinux"

RDEPEND=">=dev-libs/glib-2.6
	|| ( >=dev-libs/dbus-glib-0.71
		( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.60 ) )
	>=sys-fs/udev-083
	>=sys-apps/util-linux-2.12r
	|| ( >=sys-kernel/linux-headers-2.6 >=sys-kernel/mips-headers-2.6 )
	dev-libs/expat
	sys-libs/libcap
	sys-apps/pciutils
	dev-libs/libusb
	virtual/eject
	dmi? ( >=sys-apps/dmidecode-2.7 )
	crypt? ( >=sys-fs/cryptsetup-luks-1.0.1 )
	selinux? ( sys-libs/libselinux )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29
	doc? ( app-doc/doxygen app-text/docbook-sgml-utils )"

## HAL Daemon drops privledges so we need group access to read disks
HALDAEMON_GROUPS="haldaemon,plugdev,disk,cdrom,cdrw,floppy,usb"

function notify_uevent() {
	eerror
	eerror "You must enable Kernel Userspace Events in your kernel."
	eerror "This can be set under 'General Setup'.  It is marked as"
	eerror "CONFIG_KOBJECT_UEVENT in the config file."
	eerror
	ebeep 5
}

function notify_uevent_2_6_16() {
	eerror
	eerror "You must enable Kernel Userspace Events in your kernel."
	eerror "For this you need to enable 'Hotplug' under 'General Setup' and"
	eerror "basic networking.  They are marked CONFIG_HOTPLUG and CONFIG_NET"
	eerror "in the config file."
	eerror
	ebeep 5
}

function notify_procfs() {
	eerror
	eerror "You must enable the proc filesystem in your kernel."
	eerror "For this you need to enable '/proc file system support' under"
	eerror "'Pseudo filesystems' in 'File systems'.  It is marked"
	eerror "CONFIG_PROC_FS in the config file."
	eerror
	ebeep 5
}

pkg_setup() {
	get_version || eerror "Unable to calculate Linux Kernel version"

	kernel_is ge 2 6 15 || eerror "HAL requires a kernel version 2.6.15 or newer"

	if kernel_is lt 2 6 16 ; then
		linux_chkconfig_present KOBJECT_UEVENT || notify_uevent
	else
		(linux_chkconfig_present HOTPLUG && linux_chkconfig_present NET) \
			|| notify_uevent_2_6_16
	fi

	if use acpi ; then
		linux_chkconfig_present PROC_FS || notify_procfs
	fi

	if [ -d ${ROOT}/etc/hal/device.d ]; then
		eerror "HAL 0.5.x will not run with the HAL 0.4.x series of"
		eerror "/etc/hal/device.d/ so please remove this directory"
		eerror "with rm -rf /etc/hal/device.d/ and then re-emerge."
		eerror "This is due to configuration protection of /etc/"
		die "remove /etc/hal/device.d/"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# handle ignored volumes properly
	epatch "${FILESDIR}"/${PN}-0.5.7.1-ignored-volumes.patch

	# Fix bash in hald scripts
	epatch "${FILESDIR}"/${PN}-0.5.7-hald-scripts.patch

	# probe partition table
	epatch "${FILESDIR}"/${PN}-0.5.7-part-table.patch

	# fix pmu support crash
	epatch "${FILESDIR}"/${PN}-0.5.7-pmu-fix.patch

	# unclean unmount 
	epatch "${FILESDIR}"/${PN}-0.5.7-unclean-unmount-r1.patch

	# allow plugdev group people to mount
	epatch "${FILESDIR}"/${PN}-0.5.7-plugdev-allow-send.patch

	# rescan devices on resume
	epatch "${FILESDIR}"/${PN}-0.5.7-rescan-on-resume.patch

	# detect hibernate-ram script as well
	epatch "${FILESDIR}"/${PN}-0.5.7-hibernate.patch

	# dbus deprecated dbus_connection_disconnect
	epatch "${FILESDIR}"/${PN}-0.5.7.1-dbus-close.patch

	# sr driver fix
	epatch "${FILESDIR}"/${PN}-0.5.7.1-sr-driver.patch

	# hibernate sequence fix
	epatch "${FILESDIR}"/${PN}-0.5.7.1-hibernate-fix.patch
}

src_compile() {
	if [ -r "${ROOT}/usr/share/misc/pci.ids.gz" ] ; then
		hwdata="${ROOT}/usr/share/misc/pci.ids.gz"
	elif [ -r "${ROOT}/usr/share/misc/pci.ids" ] ; then
		hwdata="${ROOT}/usr/share/misc/pci.ids"
	else
		die "pci.ids file not found. please file a bug @ bugs.gentoo.org"
	fi

	econf \
		--with-doc-dir=/usr/share/doc/${PF} \
		--with-os-type=gentoo \
		--with-pid-file=/var/run/hald.pid \
		--with-hwdata=${hwdata} \
		--enable-hotplug-map \
		$(use_enable debug verbose-mode) \
		$(use_enable pcmcia pcmcia-support) \
		$(use_enable acpi acpi-proc) \
		$(use_enable doc docbook-docs) \
		$(use_enable doc doxygen-docs) \
		$(use_enable selinux) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README

	# remove dep on gnome-python
	mv "${D}"/usr/bin/hal-device-manager "${D}"/usr/share/hal/device-manager/

	# hal umount for unclean unmounts
	exeinto /lib/udev/
	newexe "${FILESDIR}"/hal-unmount.dev hal_unmount

	# initscript
	newinitd "${FILESDIR}"/0.5-hald.rc hald

	# Script to unmount devices if they are yanked out (from upstream)
	exeinto /etc/dev.d/default
	doexe "${FILESDIR}"/hal-unmount.dev

	# We now create and keep /media here as both gnome-mount and pmount
	# use these directories, to avoid collision.
	dodir /media
	keepdir /media
}

pkg_postinst() {
	# Despite what people keep changing this location. Either one works.. it doesn't matter
	# http://dev.gentoo.org/~plasmaroo/devmanual/ebuild-writing/functions/

	# Create groups for hotplugging and HAL
	enewgroup haldaemon || die "Problem adding haldaemon group"
	enewgroup plugdev || die "Problem adding plugdev group"

	# HAL drops priviledges by default now ...
	# ... so we must make sure it can read disk/cdrom info (ie. be in ${HALDAEMON_GROUPS} groups)
	enewuser haldaemon -1 "-1" /dev/null ${HALDAEMON_GROUPS} || die "Problem adding haldaemon user"

	# Make sure that the haldaemon user is in the ${HALDAEMON_GROUPS}
	# If users have a problem with this, let them file a bug
	usermod -G ${HALDAEMON_GROUPS} haldaemon

	elog "The HAL daemon needs to be running for certain applications to"
	elog "work. Suggested is to add the init script to your start-up"
	elog "scripts, this should be done like this :"
	elog "\`rc-update add hald default\`"
	echo
	elog "Looking for automounting support? Add yourself to the plugdev group"
}
