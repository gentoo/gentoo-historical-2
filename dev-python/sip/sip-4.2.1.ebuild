# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.2.1.ebuild,v 1.13 2008/08/11 19:08:06 yngwin Exp $

inherit distutils

MY_P=${P/"?.?.?_pre"/"snapshot-"}
MY_P=${MY_P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="SIP is a tool for generating bindings for C++ classes so that they can be used by Python."
HOMEPAGE="http://www.riverbankcomputing.co.uk/sip/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
#SRC_URI="http://www.river-bank.demon.co.uk/download/sip/${MY_P}.tar.gz"
#SRC_URI="http://www.river-bank.demon.co.uk/download/snapshots/sip/${MY_P}.tar.gz"

SLOT="0"
LICENSE="sip"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="debug doc"

DEPEND="virtual/libc
	=x11-libs/qt-3*
	>=dev-lang/python-2.3"

src_compile(){
	distutils_python_version

	local myconf="-l qt-mt -b /usr/bin -d /usr/$(get_libdir)/python${PYVER}/site-packages -e /usr/include/python${PYVER}"
	use debug && myconf="${myconf} -u"

	python configure.py ${myconf} "CFLAGS+=${CFLAGS}" "CXXFLAGS+=${CXXFLAGS}"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc ChangeLog LICENSE NEWS README THANKS TODO
	if use doc ; then dohtml doc/* ; fi
}

pkg_postinst() {
	echo ""
	elog "Please note, that you have to emerge PyQt again, when upgrading from sip-3.x."
	echo ""
}
