# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/imcom/imcom-1.30_beta2-r1.ebuild,v 1.1 2003/01/19 13:06:06 lordvan Exp $

S=${WORKDIR}/${PN}-1.30beta2
#SRC_URI="http://imcom.floobin.cx/files/${P}.tar.gz"
SRC_URI="http://nafai.dyndns.org/files/imcom-betas/${PN}-1.30beta2.tar.gz"
HOMEPAGE="http://imcom.floobin.cx"
DESCRIPTION="Python commandline Jabber Client"

DEPEND=">=dev-lang/python-2.2
	>=dev-python/PyXML-0.7"
RDEPEND=""

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	# patch for 1.30beta2  (most likely fixed in later versions)
        patch -p1 JabberHandler.py < ${FILESDIR}/JabberHandler.py.patch
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/imcom
	dodoc AutoStatus.API CONTRIBUTORS LICENSE README* TODO WHATSNEW
	dodoc docs/*
	cp *.py ${D}/usr/share/imcom
	mv imcom imcom.orig
	sed -e 's:/usr/local/share:/usr/share:' imcom.orig | cat > imcom
	chmod 755 imcom 
	dobin imcom

}
