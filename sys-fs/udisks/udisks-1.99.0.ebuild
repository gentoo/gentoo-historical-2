# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udisks/udisks-1.99.0.ebuild,v 1.4 2012/08/03 08:32:35 ssuominen Exp $

EAPI=4
inherit eutils bash-completion-r1 linux-info systemd toolchain-funcs

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="http://udisks.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="debug crypt +gptfdisk +introspection systemd"

COMMON_DEPEND=">=dev-libs/glib-2.32
	>=sys-auth/polkit-0.106
	>=dev-libs/libatasmart-0.19
	>=sys-fs/udev-180[gudev,hwdb]
	virtual/acl
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
	systemd? ( >=sys-apps/systemd-44 )"
# gptfdisk -> src/udiskslinuxpartition.c -> sgdisk (see also #412801#c1)
# util-linux -> mount, umount, swapon, swapoff (see also #403073)
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/util-linux-2.20.1-r2
	>=sys-block/parted-3
	virtual/eject
	crypt? ( sys-fs/cryptsetup )
	gptfdisk? ( >=sys-apps/gptfdisk-0.8 )"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.32
	dev-util/intltool
	>=sys-kernel/linux-headers-3.1
	virtual/pkgconfig"

DOCS="AUTHORS HACKING NEWS README"

pkg_setup() {
	# Listing only major arch's here to avoid tracking kernel's defconfig
	if use amd64 || use arm || use ppc || use ppc64 || use x86; then
		CONFIG_CHECK="~!IDE" #319829
		CONFIG_CHECK+=" ~TMPFS_POSIX_ACL" #412377
		CONFIG_CHECK+=" ~USB_SUSPEND" #331065
		CONFIG_CHECK+=" ~SWAP" # http://forums.gentoo.org/viewtopic-t-923640.html
		CONFIG_CHECK+=" ~NLS_UTF8" #425562
		linux-info_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.x-ntfs-3g.patch
	use systemd || { sed -i -e 's:libsystemd-login:&use_USE_systemd:' configure || die; }
	[[ $(gcc-version) < 4.6 ]] && epatch "${FILESDIR}"/${PN}-2.x-pragma.patch
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		--disable-silent-rules \
		$(use_enable debug) \
		--disable-gtk-doc \
		$(use_enable introspection) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		"$(systemd_with_unitdir)"
}

src_install() {
	default

	prune_libtool_files

	local htmldir=udisks2
	if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]; then
		dosym /usr/share/doc/${PF}/html/${htmldir} /usr/share/gtk-doc/html/${htmldir}
	fi

	rm -rf "${ED}"/etc/bash_completion.d
	dobashcomp tools/udisksctl-bash-completion.sh

	keepdir /var/lib/udisks2 #383091
}

pkg_postinst() {
	mkdir -p "${EROOT}"/run #415987

	# See pkg_postinst() of >=sys-apps/baselayout-2.1-r1. Keep in sync?
	if ! grep -qs "^tmpfs.*/run " "${EROOT}"/proc/mounts ; then
		echo
		ewarn "You should reboot the system now to get /run mounted with tmpfs!"
	fi
}
