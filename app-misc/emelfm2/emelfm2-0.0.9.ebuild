# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.0.9.ebuild,v 1.4 2005/01/01 15:00:21 eradicator Exp $

inherit eutils

DESCRIPTION="A file manager that implements the popular two-pane design based on gtk+-2"
HOMEPAGE="http://dasui.prima.de/e2wiki/"
SRC_URI="http://dasui.prima.de/~tooar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2.4*"

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf

	use nls && myconf="-DENABLE_NLS"
	emake PREFIX=/usr \
		CC="gcc ${CFLAGS}" \
		NLS=${myconf} || die "emake failed"
}

src_install() {
	local myconf

	use nls && myconf="-DENABLE_NLS"
	dodir /usr/bin

	make PREFIX=${D}/usr \
		NLS=${myconf} \
		DOC_DIR=${D}/usr/share/doc/${PF} \
		install || die "make install failed"
	prepalldocs
}

pkg_postinst() {

	einfo "This application prefers that you set your LANG variable."
	einfo "This is best done by placing 'export LANG=en_US' (example"
	einfo "is for english systems - customize for your language) into "
	einfo "your shell environment. Other locales can be found in "
	einfo "/usr/share/locale. Export the corresponding directory name "
	einfo "into your LANG variable."
	einfo ""
	einfo "You can launch emelfm2 without setting this variable by running"
	einfo "it with the -i flag."

}
