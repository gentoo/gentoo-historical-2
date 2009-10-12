# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qtunit/qtunit-0.9.8.ebuild,v 1.10 2009/10/12 08:30:30 ssuominen Exp $

DESCRIPTION="Unit testing framework for c++"
SRC_URI="http://www.uwyn.com/download/qtunit/${P}.tar.bz2"
HOMEPAGE="http://www.uwyn.com/projects/qtunit/"

SLOT="0"
IUSE=""

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc sparc x86"

DEPEND="=x11-libs/qt-3*"

#export QTDIR="/usr/qt/3"
#export PATH="$QTDIR/bin:$PATH"
#export LD_LIBRARY_PATH="$QTDIR/lib:$LD_LIBRARY_PATH"
export QMAKESPEC="linux-g++"

src_compile() {
	# Need to fake out Qt or we'll get sandbox problems, see Bug 45220
	REALHOME="$HOME"
	mkdir -p "${T}"/fakehome/.kde
	mkdir -p "${T}"/fakehome/.qt
	export HOME="${T}/fakehome"
	addwrite "${QTDIR}/etc/settings"

	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake qtunit.pro || die
	make || die	# emake doesn't work
}

src_install() {
	insinto /usr

	dolib lib/libqtunit.so.1.0.0
	dosym /usr/lib/libqtunit.so.1.0.0 /usr/lib/libqtunit.so.1.0
	dosym /usr/lib/libqtunit.so.1.0 /usr/lib/libqtunit.so.1
	dosym /usr/lib/libqtunit.so.1 /usr/lib/libqtunit.so
	dobin bin/guitestrunner
	dobin bin/texttestrunner

	dodir /usr/include/qtunit
	find src -name "*.h" -exec cp '{}' "${D}"/usr/include/qtunit ';'

	dodoc ChangeLog

	dohtml -r html

	docinto plugins
	dodoc plugins/libexampletestmodule.so

	docinto samples/standalonerunner
	dodoc samples/standalonerunner/*.{cpp,h,pro}

	docinto samples/testmodule
	dodoc samples/testmodule/*.{cpp,h,pro}

	docinto samples/guitestrunner
	dodoc samples/guitestrunner/*.{cpp,pro}

	docinto samples/texttestrunner
	dodoc samples/texttestrunner/*.{cpp,pro}

	sed -e "s#<FILEPATH>#<FILEPATH>/usr/share/doc/${PF}/#" \
		-e "s#<SOURCEPATH>#<SOURCEPATH>/usr/share/doc/${PF}/#" \
		testproject.qpj > "${D}"/usr/share/doc/${PF}/testproject.qpj
}
