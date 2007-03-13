# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyqwt/pyqwt-4.2-r1.ebuild,v 1.1 2007/03/13 19:17:30 pythonhead Exp $


inherit distutils eutils

MY_P=PyQwt-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Python bindings for the Qwt library"
SRC_URI="mirror://sourceforge/pyqwt/${MY_P}.tar.gz"
HOMEPAGE="http://pyqwt.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="debug"

DEPEND=">=dev-lang/python-2.3.2
	~x11-libs/qwt-4.2.0
	>=dev-python/PyQt-3.14
	>=dev-python/sip-4.2
	>=dev-python/numarray-1.1.1
	>=dev-python/numeric-23.7"

src_compile() {
	cd ${S}/sip
	sed -i s/"[[:space:]]*const QLabel \*titleLabel() const\;"// qwtplot.sip
	sed -i s/"[[:space:]]*const QwtPlotCanvas \*canvas() const\;"// qwtplot.sip
	cd ${S}/configure
	local myconf="-d /usr/$(get_libdir)/python${PYVER}/site-packages -l /usr/$(get_libdir) \
			-i /usr/include/qwt -v /usr/share/sip  -x /usr/share/sip"
	use debug && myconf="${myconf} -u"
	has distcc ${FEATURES} || myconf="${myconf} -c"
	python configure.py ${myconf}
	emake || die "emake failed"
}

src_install() {
	cd ${S}
	sed -i s/2,4,9/2,5,9/ setup.py
	python setup.py install --prefix=/usr --root=${D} || die "install failed"
	dodoc ANNOUNCEMENT-4.2.TXT AUTHORS COPYING* README THANKS
	use doc && mv ${D}/usr/share/doc/${MY_P}/* ${D}/usr/share/doc/${PF}
	rm -rf ${D}/usr/share/doc/${MY_P}
}
