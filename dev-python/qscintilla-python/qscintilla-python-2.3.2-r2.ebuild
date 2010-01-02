# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla-python/qscintilla-python-2.3.2-r2.ebuild,v 1.9 2010/01/02 16:45:07 yngwin Exp $

EAPI="2"

inherit eutils python

MY_PN="qscintilla"
MY_P="${MY_PN/qs/QS}-gpl-${PV}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.com/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/sip
	~x11-libs/qscintilla-${PV}[qt4]
	dev-python/PyQt4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/Python

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2-nostrip.patch
	epatch "${FILESDIR}"/qscintilla-gcc44.patch
}

src_configure() {
	local myconf="-o /usr/lib -n /usr/include -p 4"
	python_version
	${python} configure.py ${myconf} || die "configure.py failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	python_need_rebuild
	emake DESTDIR="${D}" install || die "emake install failed"
}
