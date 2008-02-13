# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/source-highlight/source-highlight-2.8.ebuild,v 1.1 2008/02/13 13:24:23 dev-zero Exp $

inherit bash-completion

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="http://www.gnu.org/software/src-highlite/source-highlight.html"
SRC_URI="mirror://gnu/src-highlite/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
SLOT="0"
IUSE="doc"

DEPEND=">=dev-libs/boost-1.34.1
	dev-util/ctags"
RDEPEND="${DEPEND}"

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"

	dobashcompletion "${FILESDIR}/${PN}-2.8.bash-completion"

	# That's not how we want it
	rm -fr "${D}/usr/share/doc"
	dodoc AUTHORS ChangeLog CREDITS NEWS README THANKS TODO.txt

	if use doc ; then
		cd "${S}/doc"
		dohtml *.{html,css,java}
	fi
}
