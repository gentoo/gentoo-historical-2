# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt4/PyQt4-4.3.ebuild,v 1.3 2007/08/21 20:43:18 caleb Exp $

inherit distutils qt4

MY_P=PyQt-x11-gpl-${PV}

DESCRIPTION="PyQt is a set of Python bindings for the Qt toolkit."
HOMEPAGE="http://www.riverbankcomputing.co.uk/pyqt/"
SRC_URI="http://www.riverbankcomputing.com/Downloads/PyQt4/GPL/${MY_P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples"

RDEPEND="=x11-libs/qt-4*
	>=dev-python/sip-4.7"
DEPEND="${RDEPEND}
	sys-devel/libtool"

S=${WORKDIR}/${MY_P}

QT4_BUILT_WITH_USE_CHECK="zlib"

src_unpack() {
	unpack ${A}
	sed -i -e "s:^[ \t]*check_license():# check_license():" ${S}/configure.py
	sed -i -e "s:join(qt_dir, \"mkspecs\":join(\"/usr/share/qt4\",	\"mkspecs\":g" ${S}/configure.py
	sed -i -e "s:\"QT_INSTALL_HEADERS\"\:   os.path.join(qt_dir, \"include\":\"QT_INSTALL_HEADERS\"\:   os.path.join(qt_dir, \"include/qt4\":g" ${S}/configure.py
	sed -i -e "s:\"QT_INSTALL_LIBS\"\:      os.path.join(qt_dir, \"lib\":\"QT_INSTALL_LIBS\"\:      os.path.join(qt_dir, \"lib/qt4\":g" ${S}/configure.py
}

src_compile() {
	distutils_python_version
	addpredict ${QTDIR}/etc/settings

	local myconf="-d /usr/$(get_libdir)/python${PYVER}/site-packages -b /usr/bin -v /usr/share/sip"
	use debug && myconf="${myconf} -u"

	"${python}" configure.py ${myconf}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install || die "install failed"
	dodoc ChangeLog NEWS README THANKS
	use doc && dohtml -r doc/html/*
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
