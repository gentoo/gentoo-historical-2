# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt/PyQt-3.14.1-r1.ebuild,v 1.2 2005/12/12 15:10:22 swegener Exp $

inherit distutils eutils

MY_P="PyQt-x11-gpl-${PV/*_pre/snapshot-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="set of Python bindings for the QT 3.x Toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/pyqt/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ppc64"
IUSE="debug doc examples"

RDEPEND="x11-libs/qt
	~dev-python/sip-4.2.1
	<dev-python/qscintilla-1.6"
DEPEND="${RDEPEND}
	sys-devel/libtool"


src_unpack() {
	unpack ${A}
	sed -i -e "s:  check_license():# check_license():" ${S}/configure.py
	epatch "${FILESDIR}/PyQt-3.14.1-examples.diff"
}

src_compile() {
	distutils_python_version
	addpredict ${QTDIR}/etc/settings

	local myconf="-d ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages \
			-b ${ROOT}/usr/bin \
			-v ${ROOT}/usr/share/sip \
			-n ${ROOT}/usr/include \
			-o ${ROOT}/usr/$(get_libdir)"
	use debug && myconf="${myconf} -u"

	python configure.py ${myconf}
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc ChangeLog LICENSE NEWS README README.Linux THANKS
	use doc && dohtml doc/PyQt.html
	if use examples ; then
		dodir /usr/share/doc/${PF}/examples
		cp -r examples3/* ${D}/usr/share/doc/${PF}/examples
	fi
}
