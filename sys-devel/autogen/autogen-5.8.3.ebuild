# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autogen/autogen-5.8.3.ebuild,v 1.6 2007/02/12 17:35:49 kloeri Exp $

DESCRIPTION="Program and text file generation"
HOMEPAGE="http://www.gnu.org/software/autogen/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh ~sparc ~x86"
IUSE=""

# autogen doesn't build with lower versions of guile on ia64
DEPEND=">=dev-scheme/guile-1.6.6
	dev-libs/libxml2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# immediate.test does a sed on CFLAGS, that assumes it does not contain
	# '-gXXX' (e.g. -ggdb2)
	sed -i -e 's:s/-g//:s/-g\\b//:' autoopts/test/immediate.test ||
		die "sed immediate.test failed"

}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	rm -f ${D}/usr/share/autogen/libopts-*.tar.gz
}
