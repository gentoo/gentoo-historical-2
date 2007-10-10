# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/teco/teco-1.00-r3.ebuild,v 1.7 2007/10/10 07:22:43 opfer Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Classic TECO editor, Predecessor to EMACS"
HOMEPAGE="http://www.ibiblio.org/pub/linux/apps/editors/tty/ http://www.ibiblio.org/pub/academic/computer-science/history/pdp-11/teco"
SRC_URI="http://www.ibiblio.org/pub/linux/apps/editors/tty/teco.tar.gz
	doc? ( mirror://gentoo/tecolore.txt.gz
		mirror://gentoo/tech.txt.gz
		mirror://gentoo/teco.doc.gz
		mirror://gentoo/tecoprog.doc.gz )"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc x86"
IUSE="doc"

RDEPEND="sys-libs/ncurses"
DEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	sed -i -e 's:-ltermcap:-lncurses:' ${S}/Makefile
	# bug 103257
	epatch ${FILESDIR}/teco-double-free.diff
}

src_compile() {
	append-flags -ansi -D_POSIX_SOURCE
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "compilation failed"
}

src_install() {
	dobin te || die
	doman te.1
	dodoc sample.tecorc sample.tecorc2 READ.ME MANIFEST
	use doc && dodoc tecolore.txt tech.txt teco.doc tecoprog.doc
}

pkg_postinst() {
	elog "The TECO binary is called te."
	elog "Sample configurations and documentation is available in /usr/share/doc/"
}
