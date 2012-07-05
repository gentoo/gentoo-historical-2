# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev/udev-186.ebuild,v 1.2 2012/07/05 17:11:15 williamh Exp $

EAPI=4

KV_min=2.6.39

inherit autotools eutils linux-info

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"
	inherit git-2
else
	SRC_URI="http://www.freedesktop.org/software/systemd/systemd-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="doc gudev hwdb introspection keymap +openrc selinux static-libs"

RESTRICT="test"

COMMON_DEPEND="gudev? ( dev-libs/glib:2 )
	introspection? ( dev-libs/gobject-introspection )
	selinux? ( sys-libs/libselinux )
	>=sys-apps/kmod-5
	>=sys-apps/util-linux-2.20
	!<sys-libs/glibc-2.10"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	virtual/os-headers
	!<sys-kernel/linux-headers-${KV_min}
	doc? ( dev-util/gtk-doc )"

if [[ ${PV} = 9999* ]]; then
	DEPEND="${DEPEND}
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"
fi

RDEPEND="${COMMON_DEPEND}
	hwdb? ( sys-apps/hwids )
	openrc? ( >=sys-fs/udev-init-scripts-12
		!<sys-apps/openrc-0.9.9 )
	!sys-apps/coldplug
	!<sys-fs/lvm2-2.02.45
	!sys-fs/device-mapper
	!<sys-fs/udev-init-scripts-12
	!<sys-kernel/dracut-017-r1
	!<sys-kernel/genkernel-3.4.25"

S="${WORKDIR}/systemd-${PV}"

check_KV()
{
	if kernel_is lt ${KV_min//./ }
	then
		return 1
	fi
	return 0
}

check_default_rules()
{
	# Make sure there are no sudden changes to upstream rules file
	# (more for my own needs than anything else ...)
	local udev_rules_md5=18843fc4a8dd1d8074b98a583454cb9e
	MD5=$(md5sum < "${S}/rules/50-udev-default.rules")
	MD5=${MD5/  -/}
	if [[ ${MD5} != ${udev_rules_md5} ]]
	then
		eerror "50-udev-default.rules has been updated, please validate!"
		eerror "md5sum: ${MD5}"
		die "50-udev-default.rules has been updated, please validate!"
	fi
}

pkg_setup()
{
	# required kernel options
	CONFIG_CHECK="~DEVTMPFS"
	ERROR_DEVTMPFS="DEVTMPFS is not set in this kernel. Udev will not run."

	linux-info_pkg_setup

	if ! check_KV
	then
		eerror "Your kernel version (${KV_FULL}) is too old to run ${P}"
		eerror "It must be at least ${KV_min}!"
	fi

	KV_FULL_SRC=${KV_FULL}
	get_running_version
	if ! check_KV
	then
		eerror
		eerror "Your running kernel version (${KV_FULL}) is too old"
		eerror "for this version of udev."
		eerror "You must upgrade your kernel or downgrade udev."
	fi
}

src_prepare()
{
	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' \
		-i rules/*.rules \
	|| die "failed to change group dialout to uucp"

	if [ ! -e configure ]
	then
		if use doc; then
			gtkdocize --docdir docs || die "gtkdocize failed"
		else
			echo 'EXTRA_DIST =' > docs/gtk-doc.make
		fi
		eautoreconf
	else
		check_default_rules
		elibtoolize
	fi
}

config_workarounds()
{
	export ac_cv_search_cap_init= ac_cv_header_sys_capability_h=yes
	export PKG_CONFIG_PATH="${T}:${PKG_CONFIG_PATH}"
	printf 'Name: dbus\nDescription: Fake dbus\n' > "${T}"/dbus-1.pc
	printf 'Version: 1.6.0\nLibs:\nCflags:' >> "${T}"/dbus-1.pc
}

src_configure()
{
	local switches

	switches=(
		--docdir=/usr/share/doc/${PF}
		--libdir=/usr/$(get_libdir)
		--with-distro=gentoo
		--with-html-dir=/usr/share/doc/${PF}/html
		--with-pci-ids-path=/usr/share/misc/pci.ids
		--with-usb-ids-path=/usr/share/misc/usb.ids
		--disable-acl
		--disable-audit
		--disable-coredump
		--disable-hostnamed
		--disable-ima
		--disable-libcryptsetup
		--disable-localed
		--disable-logind
		--disable-nls
		--disable-pam
		--disable-quotacheck
		--disable-readahead
		--enable-split-usr
		--disable-tcpwrap
		--disable-timedated
		--disable-xz
		$(use_enable doc gtk-doc)
		$(use_enable gudev)
		$(use_enable introspection)
		$(use_enable keymap)
		$(use_enable selinux)
		$(use_enable static-libs static)
	)
	config_workarounds
	econf "${switches[@]}"
}

src_compile()
{
	echo 'BUILT_SOURCES: $(BUILT_SOURCES)' > "${T}"/Makefile.extra
	emake -f Makefile -f "${T}"/Makefile.extra BUILT_SOURCES
	local targets=(
		systemd-udevd
		udevadm
		libudev.la
		ata_id
		cdrom_id
		collect
		scsi_id
		v4l_id
		accelerometer
		mtd_probe
		man/udev.7
		man/udevadm.8
		man/systemd-udevd.8
		man/systemd-udevd.service.8
	)
	use keymap && targets+=( keymap )
	use gudev && targets+=( libgudev-1.0.la )

	emake udevlibexecdir=/lib/udev "${targets[@]}"
	if use doc; then
		emake -C docs/libudev
		use gudev && emake -C docs/gudev
	fi
}

src_install()
{
	local lib_LTLIBRARIES=libudev.la \
		pkgconfiglib_DATA=src/libudev/libudev.pc

	local targets=(
		install-libLTLIBRARIES
		install-includeHEADERS
		install-libgudev_includeHEADERS
		install-binPROGRAMS
		install-rootlibexecPROGRAMS
		install-udevlibexecPROGRAMS
		install-dist_systemunitDATA
		install-dist_udevconfDATA
		install-dist_udevhomeSCRIPTS
		install-dist_udevkeymapDATA
		install-dist_udevkeymapforcerelDATA
		install-dist_udevrulesDATA
		install-girDATA
		install-man7
		install-man8
		install-nodist_systemunitDATA
		install-pkgconfiglibDATA
		install-sharepkgconfigDATA
		install-typelibsDATA
		install-dist_docDATA
		udev-confdirs
		systemd-install-hook
	)

	if use gudev; then
		lib_LTLIBRARIES+=" libgudev-1.0.la"
		pkgconfiglib_DATA+=" src/gudev/gudev-1.0.pc"
	fi

	# add final values of variables:
	targets+=(
		udevlibexecdir=/lib/udev
		rootlibexec_PROGRAMS=systemd-udevd
		bin_PROGRAMS=udevadm
		lib_LTLIBRARIES="${lib_LTLIBRARIES}"
		MANPAGES="man/udev.7 man/udevadm.8 man/systemd-udevd.service.8"
		MANPAGES_ALIAS="man/systemd-udevd.8"
		dist_systemunit_DATA="units/systemd-udevd-control.socket \
			units/systemd-udevd-kernel.socket"
		nodist_systemunit_DATA="units/systemd-udevd.service \
				units/systemd-udev-trigger.service \
				units/systemd-udev-settle.service"
		pkgconfiglib_DATA="${pkgconfiglib_DATA}"
	)

	emake DESTDIR="${D}" "${targets[@]}"

	rm -rf "${ED}"/usr/share/doc/${PF}/LICENSE.*
	dodoc TODO

	if use doc; then
		emake -C docs/libudev DESTDIR="${D}" install
		use gudev && emake -C docs/gudev DESTDIR="${D}" install
	fi

	prune_libtool_files --all

	# remove rule that should be installed by systemd
	rm -f "${ED}"/lib/udev/rules.d/99-systemd.rules

	# udevadm is now in /usr/bin
	dosym ../usr/bin/udevadm /sbin/udevadm

	# Now install rules
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/40-gentoo.rules
}

pkg_preinst()
{
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${EROOT}usr/share/gtk-doc/html/${htmldir} ]]; then
			rm -rf "${EROOT}"usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]; then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
}

# This function determines if a directory is a mount point.
# It was lifted from dracut.
ismounted()
{
	while read a m a; do
		[[ $m = $1 ]] && return 0
	done < "${ROOT}"/proc/mounts
	return 1
}

pkg_postinst()
{
	mkdir -p "${ROOT}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${ROOT}"/dev/loop 2>/dev/null
	if [[ -d ${ROOT}/dev/loop ]]
	then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	# people want reminders, I'll give them reminders.  Odds are they will
	# just ignore them anyway...

	# 64-device-mapper.rules now gets installed by sys-fs/device-mapper
	# remove it if user don't has sys-fs/device-mapper installed, 27 Jun 2007
	if [[ -f ${ROOT}/etc/udev/rules.d/64-device-mapper.rules ]] &&
		! has_version sys-fs/device-mapper
	then
			rm -f "${ROOT}"/etc/udev/rules.d/64-device-mapper.rules
			einfo "Removed unneeded file 64-device-mapper.rules"
	fi

	ewarn
	ewarn "If you build an initramfs including udev, then please"
	ewarn "make sure the /usr/bin/udevadm binary gets included,"
	ewarn "and your scripts changed to use it,as it replaces the"
	ewarn "old helper apps udevinfo, udevtrigger, ..."

	ewarn
	ewarn "mount options for directory /dev are no longer"
	ewarn "set in /etc/udev/udev.conf, but in /etc/fstab"
	ewarn "as for other directories."

	ewarn
	ewarn "Rules for /dev/hd* devices have been removed"
	ewarn "Please migrate to libata."

	ewarn
	ewarn "action_modeswitch has been removed by upstream."
	ewarn "Please use sys-apps/usb_modeswitch."

	if ismounted /usr
	then
		ewarn
		ewarn "Your system has /usr on a separate partition. This means"
		ewarn "you will need to use an initramfs to pre-mount /usr before"
		ewarn "udev runs."
		ewarn "This must be set up before your next reboot, or you may"
		ewarn "experience failures which are very difficult to troubleshoot."
		ewarn "For a more detailed explanation, see the following URL:"
		ewarn "http://www.freedesktop.org/wiki/Software/systemd/separate-usr-is-broken"
		ewarn "For more information on setting up an initramfs, see the"
		ewarn "following url:"
		ewarn "http://www.gentoo.org/doc/en/initramfs-guide.xml"
	fi

	ewarn
	ewarn "The udev-acl functionality has been removed from standalone udev."
	ewarn "If you are using standalone udev, consolekithandles this"
	ewarn "functionality."

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into affect."
	ewarn "The method you use to do this depends on your init system."

	ewarn
	ewarn "Upstream has removed the persistent-net and persistent-cd rules"
	ewarn "generator. If you need persistent names for these devices,"
	ewarn "place udev rules for them in ${ROOT}etc/udev/rules.d."

	elog
	elog "For more information on udev on Gentoo, writing udev rules, and"
	elog "         fixing known issues visit:"
	elog "         http://www.gentoo.org/doc/en/udev-guide.xml"
}
