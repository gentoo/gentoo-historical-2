# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gle/gle-3.0.1-r3.ebuild,v 1.2 2007/01/26 09:40:58 vapier Exp $

inherit eutils

DESCRIPTION="GL extrusion library"
HOMEPAGE="http://www.linas.org/gle"
SRC_URI="http://www.linas.org/gle/pub/gle-3.0.1.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="doc"

DEPEND="virtual/opengl
	virtual/glu
	virtual/glut"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/configure-LANG.patch

	# Replace inclusion of malloc.h with stdlib.h as needed by Mac OS X and
	# FreeBSD.
	sed -i -e 's:malloc.h:stdlib.h:g' ${S}/src/*
}

src_compile() {
	econf --with-x || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	use doc && dohtml -r public_html
}
