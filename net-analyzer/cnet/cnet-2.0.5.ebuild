# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cnet/cnet-2.0.5.ebuild,v 1.2 2003/12/08 21:54:57 rizzo Exp $

DESCRIPTION="Network simulation tool"
SRC_URI="http://www.csse.uwa.edu.au/cnet/${P}.tgz"
HOMEPAGE="http://www.csse.uwa.edu.au/cnet"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/tk-8.3.4"
#RDEPEND=""

# unpacking the source
src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/cnet-2.0.5-gentoo.patch
	sed -i.orig -e "s/^CFLAGS.*/CFLAGS=${CFLAGS}/" ${S}/src/Makefile.linux
}

src_install() {
	# these directories aren't created during the make install
	# process, so we'll need to make them beforehand, or else
	# we'll have nowhere to put the files
	mkdir -p ${D}/usr/{bin,lib,share}
	mkdir -p ${D}/usr/share/man/man1
	# install with make now
	emake PREFIX=${D}/usr install || die

	#install examples
	DOCDESTTREE=EXAMPLES
	dodir /usr/share/doc/${PF}/${DOCDESTTREE}
	dodoc EXAMPLES/*
}
