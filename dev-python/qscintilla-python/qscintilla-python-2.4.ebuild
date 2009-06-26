# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla-python/qscintilla-python-2.4.ebuild,v 1.3 2009/06/26 22:09:59 hwoarang Exp $

EAPI="2"

inherit eutils multilib python toolchain-funcs

MY_P="QScintilla-gpl-${PV/_pre/-snapshot-}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug +qt4"

DEPEND=">=dev-python/sip-4.8
	~x11-libs/qscintilla-${PV}[qt4=]
	qt4? ( >=dev-python/PyQt4-4.5[X] )
	!qt4? ( >=dev-python/PyQt-3.18 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/Python"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4-nostrip.patch"
}

src_configure() {
	python_version

	local myconf="${python} configure.py
			--destdir=$(python_get_sitedir)/PyQt$(use qt4 && echo 4)
			-n /usr/include
			-o /usr/$(get_libdir)
			-p $(use qt4 && echo 4 || echo 3)
			$(use debug && echo '--debug')"
	echo ${myconf}
	${myconf} || die "configuration failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINK="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	python_need_rebuild
	emake DESTDIR="${D}" install || die "emake install failed"
}
