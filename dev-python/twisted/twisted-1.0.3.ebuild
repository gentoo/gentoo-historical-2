# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted/twisted-1.0.3.ebuild,v 1.3 2003/06/21 22:30:25 drobbins Exp $

S=${WORKDIR}/Twisted-${PV}
DESCRIPTION="Twisted is a collection of servers and clients, which can be used either by developers of new applications or directly. Documentation included." 
SRC_URI="http://twisted.sourceforge.net/Twisted-${PV}.tar.bz2"
HOMEPAGE="http://www.twistedmatrix.com/"
LICENSE="LGPL-2.1"
SLOT="0"
DEPEND="virtual/python
	>=dev-python/pycrypto-1.9_alpha4"
KEYWORDS="x86 amd64 ~alpha ~sparc "
IUSE=""

inherit distutils

src_install() {
	distutils_src_install
		
	# next few lines will install docs: 9.4 megs! 
	dodir /usr/share/doc/${PF}
	# of course it's documentation!
	doman doc/man/*.[0-9n]
	rm -rf doc/man	# don't dupe the man pages
	cd doc
	cp -r . ${D}/usr/share/doc/${PF}
	cd ../
# should be taken care of by the distutils install
#	 dodoc README TODO CREDITS
}

