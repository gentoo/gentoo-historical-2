# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/externaleditor/externaleditor-0.7.ebuild,v 1.2 2003/10/10 23:16:00 robbat2 Exp $

inherit zproduct

MY_PN="ExternalEditor"
MY_P="${MY_PN}-${PV}"
MY_P2="zopeedit-${PV}-src"
DESCRIPTION="Allows you to use your favorite editor(s) from ZMI."
HOMEPAGE="http://www.zope.org/Members/Caseman/${MY_PN}/"
SRC_URI_BASE="${HOMEPAGE}/${PV}"
SRC_URI="${SRC_URI_BASE}/${MY_P}.tgz
	${SRC_URI_BASE}/${MY_P2}.tgz"
LICENSE="ZPL"
KEYWORDS="~x86 ~ppc"
ZPROD_LIST="${MY_PN}"

# the base of teh application is in Python2.1, but zopeedit.py wants Python2.2
RDEPEND="${RDEPEND}
		>=dev-lang/python-2.2*"

S_ZPROD=${WORKDIR}/${MY_PN}
S_SRC=${WORKDIR}/${MY_P2}
S=${S_SRC}
MYDOC="*.txt ${MYDOC}"

src_unpack() {
	mkdir ${S_ZPROD}.tmp
	unpack ${MY_P}.tgz
	mv ${S_ZPROD} ${S_ZPROD}.tmp
	mv ${S_ZPROD}.tmp ${S_ZPROD}
	unpack ${MY_P2}.tgz
}

DOCDIR=/usr/share/doc/${PF}

src_install()
{
	S=${S_ZPROD} zproduct_src_install
	mkdir -p ${T}${DOCDIR}/${MY_PN}
	mv ${D}${DOCDIR}/* ${T}${DOCDIR}/${MY_PN}
	mv ${T}${DOCDIR}/${MY_PN} ${D}${DOCDIR}

	into /usr
	dobin zopeedit.py
	doman man/zopeedit.1
	docinto zopeedit
	dodoc *.txt
	insinto /usr/share/${PN}/Plugins
	doins Plugins/*.py
}

pkg_postinst()
{
	zproduct_pkg_postinst
	ewarn "To use the External Editor Zope Product you will need to manually"
	ewarn "configure the helper application(/usr/bin/zopeedit.py) for your"
	ewarn "browser. Read the documention in ${DOCDIR}."
}
