# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/eudev/eudev-9999.ebuild,v 1.5 2012/12/12 14:06:33 axs Exp $

EAPI=4

KV_min=2.6.39

inherit autotools eutils linux-info

if [[ ${PV} = 9999* ]]
then
	EGIT_REPO_URI="git://github.com/gentoo/eudev.git"
	inherit git-2
else
	SRC_URI="https://github.com/downloads/gentoo/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://github.com/gentoo/udev-ng"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="doc gudev hwdb kmod introspection keymap +modutils +openrc selinux static-libs"

RESTRICT="test"

COMMON_DEPEND="gudev? ( dev-libs/glib:2 )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	selinux? ( sys-libs/libselinux )
	>=sys-apps/util-linux-2.20
	!<sys-libs/glibc-2.11"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	virtual/os-headers
	!<sys-kernel/linux-headers-${KV_min}
	doc? ( dev-util/gtk-doc )"

if [[ ${PV} = 9999* ]]
then
	DEPEND="${DEPEND}
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"
fi

RDEPEND="${COMMON_DEPEND}
	hwdb? ( sys-apps/hwids )
	openrc? ( >=sys-fs/udev-init-scripts-18 )
	!sys-fs/udev
	!sys-apps/coldplug
	!sys-apps/systemd
	!<sys-fs/lvm2-2.02.97
	!sys-fs/device-mapper
	!<sys-fs/udev-init-scripts-18"

PDEPEND=">=virtual/udev-180"

udev_check_KV()
{
	if kernel_is lt ${KV_min//./ }
	then
		return 1
	fi
	return 0
}

pkg_pretend()
{
	if has_version "<sys-fs/udev-180"; then
	ewarn "This version of eudev does not contain the libudev.so.0 library."
	ewarn "Although we try to ensure that library file is preseved, this will not work"
	ewarn "if you manually --unmerge your current version of sys-fs/udev prior to "
	ewarn "emerging this package, as may be necessary to resolve blockages."
	ewarn ""
	ewarn "When migrating from udev please emerge sys-fs/eudev-0 before upgrading to this"
	ewarn "version"
	ewarn ""
	ewarn "Removal of libudev.so.0 will effectively break any active Xorg sessions, and "
	ewarn "will probably have repercussions with other software as well.  A revdep-rebuild"
	ewarn "is required to resolve these issues."
	ewarn ""
	ewarn "We apologize for the inconvenience that this will cause."
	fi
}

pkg_setup()
{
	# required kernel options
	CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~SIGNALFD ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2"
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
	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' \
		-i rules/*.rules \
	|| die "failed to change group dialout to uucp"

	epatch_user

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
		--with-rootprefix="${EROOT}"
		--docdir="${EROOT}/usr/share/doc/${PF}"
		--libdir="${EROOT}/usr/$(get_libdir)"
		--with-firmware-path="${EROOT}/usr/lib/firmware/updates:${EROOT}/usr/lib/firmware:${EROOT}/lib/firmware/updates:${EROOT}/lib/firmware"
		--with-html-dir="${EROOT}/usr/share/doc/${PF}/html"
		--with-rootlibdir="${EROOT}/$(get_libdir)"
		--exec-prefix="${EROOT}"
		--enable-split-usr
		$(use_enable doc gtk-doc)
		$(use_enable gudev)
		$(use_enable introspection)
		$(use_enable keymap)
		$(use_enable kmod libkmod)
		$(use_enable modutils modules)
		$(use_enable selinux)
		$(use_enable static-libs static)
	)
	econf "${econf_args[@]}"
}

src_install()
{
	emake DESTDIR="${D}" install

	prune_libtool_files --all
	rm -rf "${ED}"/usr/share/doc/${PF}/LICENSE.*

	# install gentoo-specific rules
	insinto /usr/lib/udev/rules.d
	doins "${FILESDIR}"/40-gentoo.rules
}

pkg_preinst()
{
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${EROOT}/usr/share/gtk-doc/html/${htmldir} ]]
		then
			rm -rf "${EROOT}"/usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]
		then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
}

pkg_postinst()
{
	mkdir -p "${EROOT}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${EROOT}"/dev/loop 2>/dev/null
	if [[ -d ${EROOT}/dev/loop ]]
	then
		ewarn "Please make sure you remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	# 64-device-mapper.rules now gets installed by sys-fs/device-mapper
	# remove it if user don't has sys-fs/device-mapper installed, 27 Jun 2007
	if [[ -f ${EROOT}/etc/udev/rules.d/64-device-mapper.rules ]] &&
		! has_version sys-fs/device-mapper
	then
		rm -f "${EROOT}"/etc/udev/rules.d/64-device-mapper.rules
		einfo "Removed unneeded file 64-device-mapper.rules"
	fi

	ewarn
	ewarn "You need to restart eudev as soon as possible to make the"
	ewarn "upgrade go into effect."

	elog
	elog "For more information on eudev on Gentoo, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "         http://www.gentoo.org/doc/en/udev-guide.xml"
}
