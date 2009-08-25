# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope/zope-2.9.10-r1.ebuild,v 1.3 2009/08/25 11:54:14 fauli Exp $
EAPI=2

inherit eutils multilib

DESCRIPTION="Zope is a web application platform used for building high-performance, dynamic web sites"
HOMEPAGE="http://www.zope.org"
SRC_URI="http://www.zope.org/Products/Zope/${PV}/Zope-${PV}-final.tgz"

LICENSE="ZPL"
SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="=dev-lang/python-2.4*"

S="${WORKDIR}/Zope-${PV}-final"
ZUID=zope
ZGID=zope
ZS_DIR=${ROOT%/}/usr/$(get_libdir)
ZSERVDIR=${ZS_DIR}/${P}

# Narrow the scope of ownership/permissions.
# Security plan:
# * ZUID is the superuser for all zope instances.
# * ZGID is for a single instance's administration.
# * Other' should not have any access to ${ZSERVDIR},
#   because they can work through the Zope web interface.
#   This should protect our code/data better.
#
# UPDATE: ${ZSERVDIR} is a lib directory and should be world readable
# like e.g /usr/lib/python we do not store any user data there,
# currently removed all custom permission stuff, for ${ZSERVDIR}

src_prepare() {
	epatch "${FILESDIR}"/CVE-2009-0668+0669.patch
}

src_configure() {
	./configure  --prefix="${D}${ZSERVDIR}" --with-python=/usr/bin/python2.4 || die "Failed to execute ./configure ..."
}

src_install() {
	dodoc README.txt
	dodoc Zope/doc/*.txt
	docinto PLATFORMS ; dodoc Zope/doc/PLATFORMS/*
	docinto ZEO ; dodoc Zope/doc/ZEO/*

	make install prefix="${D}"${ZSERVDIR} || die "Failed to install into ${D}${ZSERVDIR}"
	rm -rf "${D}"${ZSERVDIR}/doc
	dosym ../../share/doc/${PF} ${ZSERVDIR}/doc

	# copy the init script skeleton to skel directory of our installation
	cp "${FILESDIR}"/zope.initd "${D}"/${ZSERVDIR}/skel/zope.initd
}

src_test() {
	einfo "Tests disabled by Gentoo team."
}

pkg_postinst() {
	# create the zope user and group for backward compatibility
	enewgroup ${ZGID} 261
	usermod -g ${ZGID} ${ZUID} 2>&1 >/dev/null || \
	enewuser ${ZUID} 261 -1 /var/$(get_libdir)/zope  ${ZGID}

	einfo "Be warned that you need at least one zope instance to run zope."
	einfo "Please emerge zope-config for futher instance management."
}

pkg_prerm() {
	#Remove old compiled code
	rm ${ZSERVDIR}/bin/copyzopeskel.pyc

	#need to remove this symlink because portage keeps links to
	#existing targets
	rm ${ZSERVDIR}/bin/python
}
