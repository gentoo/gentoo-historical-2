# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev/udev-9999.ebuild,v 1.121 2012/12/02 06:05:40 ssuominen Exp $

EAPI=4

KV_min=2.6.39

inherit autotools eutils linux-info

if [[ ${PV} = 9999* ]]
then
	EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"
	inherit git-2
else
	patchset=
	SRC_URI="http://www.freedesktop.org/software/systemd/systemd-${PV}.tar.xz"
	if [[ -n "${patchset}" ]]
		then
				SRC_URI="${SRC_URI}
					http://dev.gentoo.org/~williamh/dist/${P}-patches-${patchset}.tar.bz2"
			fi
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl doc gudev introspection keymap +openrc selinux static-libs"

RESTRICT="test"

COMMON_DEPEND=">=sys-apps/kmod-11-r3
	>=sys-apps/util-linux-2.20
	acl? ( sys-apps/acl )
	gudev? ( >=dev-libs/glib-2 )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	selinux? ( sys-libs/libselinux )
	!<sys-libs/glibc-2.11"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.50
	virtual/os-headers
	virtual/pkgconfig
	!<sys-kernel/linux-headers-${KV_min}
	doc? ( dev-util/gtk-doc )"

if [[ ${PV} = 9999* ]]
then
	DEPEND="${DEPEND}
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"
fi

RDEPEND="${COMMON_DEPEND}
	openrc? ( >=sys-fs/udev-init-scripts-16
		!<sys-apps/openrc-0.9.9 )
	!sys-apps/coldplug
	!<sys-fs/lvm2-2.02.45
	!sys-fs/device-mapper
	!<sys-fs/udev-init-scripts-16
	!<sys-kernel/dracut-017-r1
	!<sys-kernel/genkernel-3.4.25"

PDEPEND=">=virtual/udev-180"

S=${WORKDIR}/systemd-${PV}

QA_MULTILIB_PATHS="usr/lib/systemd/systemd-udevd"

udev_check_KV()
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
	local udev_rules_md5=66bb698deeae64ab444b710baf54a412
	MD5=$(md5sum < "${S}"/rules/50-udev-default.rules)
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

	if ! udev_check_KV
	then
		eerror "Your kernel version (${KV_FULL}) is too old to run ${P}"
		eerror "It must be at least ${KV_min}!"
	fi

	KV_FULL_SRC=${KV_FULL}
	get_running_version
	if ! udev_check_KV
	then
		eerror
		eerror "Your running kernel version (${KV_FULL}) is too old"
		eerror "for this version of udev."
		eerror "You must upgrade your kernel or downgrade udev."
	fi
}

src_prepare()
{
	# backport some patches
	if [[ -n "${patchset}" ]]
	then
		EPATCH_SUFFIX=patch EPATCH_FORCE=yes epatch
	fi

	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' \
		-i rules/*.rules \
	|| die "failed to change group dialout to uucp"

	if [[ ! -e configure ]]
	then
		if use doc
		then
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

src_configure()
{
	local econf_args

	econf_args=(
		ac_cv_search_cap_init=
		ac_cv_header_sys_capability_h=yes
		DBUS_CFLAGS=' '
		DBUS_LIBS=' '
		--docdir=/usr/share/doc/${PF}
		--libdir=/usr/$(get_libdir)
		--with-distro=gentoo
		--with-firmware-path=/usr/lib/firmware/updates:/usr/lib/firmware:/lib/firmware/updates:/lib/firmware
		--with-html-dir=/usr/share/doc/${PF}/html
		--with-rootlibdir=/usr/$(get_libdir)
		--with-rootprefix=/usr
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
		$(use_enable acl)
		$(use_enable doc gtk-doc)
		$(use_enable gudev)
		$(use_enable introspection)
		$(use_enable keymap)
		$(use_enable selinux)
		$(use_enable static-libs static)
	)
	econf "${econf_args[@]}"
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

	emake "${targets[@]}"
	if use doc
	then
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

	if use gudev
	then
		lib_LTLIBRARIES+=" libgudev-1.0.la"
		pkgconfiglib_DATA+=" src/gudev/gudev-1.0.pc"
	fi

	# add final values of variables:
	targets+=(
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
	if use doc
	then
		emake -C docs/libudev DESTDIR="${D}" install
		use gudev && emake -C docs/gudev DESTDIR="${D}" install
	fi
	dodoc TODO

	prune_libtool_files --all
	rm -f "${D}"/usr/lib/udev/rules.d/99-systemd.rules
	rm -rf "${D}"/usr/share/doc/${PF}/LICENSE.*

	# install gentoo-specific rules
	insinto /usr/lib/udev/rules.d
	doins "${FILESDIR}"/40-gentoo.rules

	# install udevadm symlink
	dosym ../usr/bin/udevadm /sbin/udevadm

	insinto /usr/lib/udev/hwdb.d
	doins hwdb/*.hwdb
}

pkg_preinst()
{
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${ROOT}usr/share/gtk-doc/html/${htmldir} ]]
		then
			rm -rf "${ROOT}"usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${D}/usr/share/doc/${PF}/html/${htmldir} ]]
		then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
	preserve_old_lib /$(get_libdir)/libudev.so.0
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

	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 189 ]]; then
		ewarn
		ewarn "Upstream has removed the persistent-net and persistent-cd rules"
		ewarn "generator. If you need persistent names for these devices,"
		ewarn "place udev rules for them in ${ROOT}etc/udev/rules.d."
		ewarn "Be aware that you cannot directly swap device names, so persistent"
		ewarn "rules for network devices should be like the ones at the following"
		ewarn "URL:"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=433746#c1"
	fi

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
		ewarn
		ewarn "For more information on setting up an initramfs, see the"
		ewarn "following URL:"
		ewarn "http://www.gentoo.org/doc/en/initramfs-guide.xml"
	fi

	if [[ -d ${ROOT}lib/udev ]]
	then
		ewarn
		ewarn "This version of udev moves the files which were installed in"
		ewarn "/lib/udev to /usr/lib/udev. We include a backward compatibility"
		ewarn "patch for gentoo to allow the rules in /lib/udev/rules.d to be"
		ewarn "read; however, bugs should be filed against packages which are"
		ewarn "installing things in /lib/udev so they can be fixed."
	fi

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into effect."
	ewarn "The method you use to do this depends on your init system."

	preserve_old_lib_notify /$(get_libdir)/libudev.so.0

	elog
	elog "For more information on udev on Gentoo, writing udev rules, and"
	elog "         fixing known issues visit:"
	elog "         http://www.gentoo.org/doc/en/udev-guide.xml"

	udevadm hwdb --update
}
