# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.32.2.ebuild,v 1.1 2011/04/30 16:14:29 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="nautilus"

RDEPEND=">=dev-libs/glib-2.25.5:2
	>=x11-libs/gtk+-2.21.4:2
	>=gnome-base/gconf-2.6:2
	nautilus? ( >=gnome-base/nautilus-2.22.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	app-text/gnome-doc-utils"
# eautoreconf needs:
#	gnome-base/gnome-common

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-scrollkeeper
		--disable-run-in-place
		--disable-static
		--disable-packagekit
		--disable-deprecations
		--with-gtk=2.0
		$(use_enable nautilus nautilus-actions)"
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"
}

src_prepare() {
	gnome2_src_prepare

	# Use absolute path to GNU tar since star doesn't have the same
	# options. On Gentoo, star is /usr/bin/tar, GNU tar is /bin/tar
	epatch "${FILESDIR}"/${PN}-2.10.3-use_bin_tar.patch
}

src_install() {
	gnome2_src_install
	if use nautilus; then
		find "${ED}"usr/$(get_libdir)/nautilus -name "*.la" -delete \
			|| die "la file removal failed"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format support, see ${HOMEPAGE}"
	elog "and install the relevant package."
	elog
	elog "for example:"
	elog "  7-zip   - app-arch/p7zip"
	elog "  ace     - app-arch/unace"
	elog "  arj     - app-arch/arj"
	elog "  cpio    - app-arch/cpio"
	elog "  deb     - app-arch/dpkg"
	elog "  iso     - app-cdr/cdrtools"
	elog "  jar,zip - app-arch/zip and app-arch/unzip"
	elog "  lha     - app-arch/lha"
	elog "  lzma    - app-arch/xz-utils"
	elog "  lzop    - app-arch/lzop"
	elog "  rar     - app-arch/unrar"
	elog "  rpm     - app-arch/rpm"
	elog "  unstuff - app-arch/stuffit"
	elog "  zoo     - app-arch/zoo"
}
