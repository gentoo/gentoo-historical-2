# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nedit/nedit-5.3-r1.ebuild,v 1.1 2002/10/23 02:31:35 seemant Exp $

S=${WORKDIR}/${P}
MY_PV=${PV/./_}
DESCRIPTION="NEdit is a multi-purpose text editor for the X Window System"
SRC_URI="http://www.nedit.org/ftp/v${MY_PV}/${P}-source.tar.gz"
HOMEPAGE="http://nedit.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

RDEPEND=">=x11-libs/openmotif-2.1.30"

DEPEND="${RDEPEND}
	dev-util/yacc"

src_unpack() {

	unpack ${A}
	cd ${S}/makefiles
	cp Makefile.linux Makefile.orig
	sed -e "s:-O:${CFLAGS}:" -e "s/-lm/-lm -lXmu/" \
	Makefile.orig > Makefile.linux || die

}

src_compile() {

	make linux || die

}

src_install () {

	into /usr
	dobin source/nedit
	exeinto /usr/bin
	newexe source/nc neditc
	newman doc/nedit.man nedit.1
	newman doc/nc.man neditc.1

	dodoc README ReleaseNotes ChangeLog COPYRIGHT
	cd doc
	dodoc *.txt nedit.doc README.FAQ NEdit.ad
	dohtml *.{dtd,xsl,xml,html,awk}

}
