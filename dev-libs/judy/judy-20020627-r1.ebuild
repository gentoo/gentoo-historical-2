# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/judy/judy-20020627-r1.ebuild,v 1.4 2005/06/05 12:26:14 hansmi Exp $

inherit eutils

DESCRIPTION="A C library that implements a dynamic array"
HOMEPAGE="http://judy.sourceforge.net/"
MY_PN=${PN/judy/Judy}
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-initial_LGPL.src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="ppc x86"

DEPEND=""
IUSE=""

S="${WORKDIR}/${MY_PN}-initial_LGPL"

src_unpack() {
	unpack ${A}
	cd ${S}/tool
	epatch ${FILESDIR}/jhton.patch
	cd ${S}

	# Modify the Makefile so that it doesn't try
	# install itself into /opt and create symlinks
	# everywhere, nor try to bzip2 the man pages.
	#
	# This is likely to break in the next release,
	# so be careful.

	mv Makefile.multi Makefile.multi.orig || die
	sed -e "s|/opt/Judy|${D}|" \
		-e 's#| $(COMPRESSPATH)##' \
		-e '2410s|$(DELDIR)|$(DELDIR)/*|' \
		-e '2414s|&&.*||' \
		-e '2409d' -e '2415,2419d' \
		Makefile.multi.orig > Makefile.multi || die
}

src_compile() {
	cd ${S}
	./configure || die "./configure failed"
	make MANFILE_SUFFIX='' || die
}

src_install () {
	make DESTDIR=${D} install || die
}
