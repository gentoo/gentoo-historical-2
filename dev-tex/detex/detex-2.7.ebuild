# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/detex/detex-2.7.ebuild,v 1.18 2007/07/13 06:20:20 mr_bones_ Exp $

inherit eutils

DESCRIPTION="A filter program that removes the LaTeX (or TeX) control sequences"
HOMEPAGE="http://www.cs.purdue.edu/homes/trinkle/detex/"
SRC_URI="http://www.cs.purdue.edu/homes/trinkle/detex/${P}.tar"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 s390 ~sparc x86"
IUSE=""

DEPEND="virtual/libc
	sys-devel/flex"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:CFLAGS	= -O \${DEFS}:CFLAGS	= ${CFLAGS} \${DEFS}:" \
		-e 's:LEX	= lex:#LEX	= lex:' \
		-e 's:#LEX	= flex:LEX	= flex:' \
		-e 's:#DEFS	+= ${DEFS} -DNO_MALLOC_DECL:DEFS += -DNO_MALLOC_DECL:' \
		-e 's:	${CC} ${CFLAGS} -o $@ ${D_OBJ} -ll:	${CC} ${CFLAGS} -o $@ ${D_OBJ} -lfl:' \
		Makefile || die "sed failed"

	# This is a hack to get round bug 127042 until flex is fixed.
	epatch ${FILESDIR}/${PN}-flexbrackets.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin detex || die
	dodoc README
	doman detex.1l
}
