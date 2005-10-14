# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblo/liblo-0.22.ebuild,v 1.1 2005/10/14 00:37:32 kito Exp $

IUSE="doc"

DESCRIPTION="Lightweight OSC (Open Sound Control) implementation"
HOMEPAGE="http://plugin.org.uk/liblo/"
SRC_URI="http://plugin.org.uk/liblo/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~ppc-macos"

DEPEND="dev-util/pkgconfig
		doc? ( app-doc/doxygen )"

src_compile() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

# tests fail when executed by ebuild/emerge,
# but succeed when executed manually, even from
# sandboxshell.
# if anybody knows why, please let me know..
src_test() {
	make test || die "make test failed"
}
