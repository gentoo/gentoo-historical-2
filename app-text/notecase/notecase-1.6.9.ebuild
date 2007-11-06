# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/notecase/notecase-1.6.9.ebuild,v 1.2 2007/11/06 17:23:02 drac Exp $

inherit eutils fdo-mime

DESCRIPTION="Hierarchical note manager written using GTK+ and C++"
HOMEPAGE="http://notecase.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}_src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND=">=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

# test doesn't work
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Respect CFLAGS and don't use --as-needed by default
	epatch "${FILESDIR}/notecase-1.6.9-CFLAGS.patch"

	if ! use gnome; then
		# Comment variable in the Makefile if we don't have gnome
		sed -i -e 's/HAVE_GNOME_VFS=1/#HAVE_GNOME_VFS=1/g' \
				-e 's/AUTODETECT_GNOME_VFS=1/#AUTODETECT_GNOME_VFS=1/g' \
			 Makefile || die "gnome sed failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc readme.txt
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
