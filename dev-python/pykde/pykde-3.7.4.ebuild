# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pykde/pykde-3.7.4.ebuild,v 1.2 2003/09/02 12:18:51 liquidx Exp $

inherit eutils distutils

MAJ_PV=${PV%.[0-9]*}
MIN_PV=${PV##*[0-9].}
MY_PN="PyKDE"
MY_P=${MY_PN}-${MAJ_PV}-${MIN_PV}

S=${WORKDIR}/${MY_P}
DESCRIPTION="set of Python bindings for the KDE libs"
SRC_URI="http://www.river-bank.demon.co.uk/download/PyKDE2/${MY_P}.tar.gz"
HOMEPAGE="http://www.riverbankcomputing.co.uk/pykde/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc
	sys-devel/libtool
	>=dev-lang/python-2.2.1
	=dev-python/sip-3.7
	=dev-python/PyQt-3.7
	>=kde-base/kdelibs-3.0.4"

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/${P}-sandbox-patch.diff
}

src_compile() {
	dodir /usr/lib/python2.2/site-packages
	dodir /usr/include/python2.2
	python build.py \
		-d ${D}/usr/lib/python2.2/site-packages \
		-s /usr/lib/python2.2/site-packages \
		-o ${KDEDIR}/lib \
		-c+ -l qt-mt -v /usr/share/sip/qt || die
	make || die
}

src_install() {
	# bug #27401 and 27619
	distutils_python_version
	
	mkdir -p ${D}/usr/lib/python${PYVER}/site-packages
	make DESTDIR=${D} install || die
	dodoc ChangeLog AUTHORS THANKS README NEWS COPYING DETAILS BUGS README.importTest
	dodir /usr/share/doc/${PF}/
	mv ${D}/usr/share/doc/* ${D}/usr/share/doc/${PF}/
}
