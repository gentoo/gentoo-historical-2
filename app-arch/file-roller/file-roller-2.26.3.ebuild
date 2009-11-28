# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.26.3.ebuild,v 1.5 2009/11/28 17:36:52 armin76 Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="nautilus"

RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.13
	gnome-base/gconf
	nautilus? ( gnome-base/nautilus )"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-scrollkeeper
		--disable-run-in-place
		--disable-static"

	if ! use nautilus ; then
		G2CONF="${G2CONF} --disable-nautilus-actions"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Use absolute path to GNU tar since star doesn't have the same
	# options. On Gentoo, star is /usr/bin/tar, GNU tar is /bin/tar
	epatch "${FILESDIR}"/${PN}-2.10.3-use_bin_tar.patch

	# Fix compilation error, due to a bad file generated using glib-mkenums
	epatch "${FILESDIR}"/${P}-typedefs-header-typo.patch

	# use a local rpm2cpio script to avoid the dep
	sed -e "s/rpm2cpio/rpm2cpio-file-roller/g" \
		-i src/fr-command-rpm.c || die "sed failed"

	# Fix intltoolize broken file, see upstream #577133 and #579464
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_install() {
	gnome2_src_install
	dobin "${FILESDIR}/rpm2cpio-file-roller" || die "dobin failed"
}

pkg_postinst() {
	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format support, see ${HOMEPAGE}"
	elog "and install the relevant package."
	elog
	elog "for example:"
	elog "  7-zip   - app-arch/p7zip"
	elog "  ace     - app-arch/unace"
	elog "  arj     - app-arch/arj"
	elog "  lzma    - app-arch/lzma"
	elog "  lzop    - app-arch/lzop"
	elog "  cpio    - app-arch/cpio"
	elog "  iso     - app-cdr/cdrtools"
	elog "  jar,zip - app-arch/zip and app-arch/unzip"
	elog "  lha     - app-arch/lha"
	elog "  rar     - app-arch/unrar"
	elog "  rpm     - app-arch/rpm"
	elog "  unstuff - app-arch/stuffit"
	elog "  zoo     - app-arch/zoo"
}
