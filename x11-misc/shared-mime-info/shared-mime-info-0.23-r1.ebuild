# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shared-mime-info/shared-mime-info-0.23-r1.ebuild,v 1.1 2008/03/24 01:16:57 leio Exp $

inherit fdo-mime eutils

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="http://freedesktop.org/wiki/Software/shared-mime-info"
SRC_URI="http://www.freedesktop.org/~hadess/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.3.2
	>=dev-libs/libxml2-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix warning spew from x-content/*, used by GNOME-2.22
	epatch "${FILESDIR}/${P}-ignore-x-content.patch"
}

src_compile() {
	econf --disable-update-mimedb
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog HACKING NEWS README
}

pkg_postinst() {
	fdo-mime_mime_database_update
}
