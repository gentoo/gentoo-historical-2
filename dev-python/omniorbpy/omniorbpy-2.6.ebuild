# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/omniorbpy/omniorbpy-2.6.ebuild,v 1.1 2005/04/20 15:31:18 liquidx Exp $

inherit eutils python

MY_P=${P/omniorb/omniORB}
S=${WORKDIR}/${MY_P}

DESCRIPTION="This is omniORBpy 2, a robust high-performance CORBA ORB for Python."
HOMEPAGE="http://omniorb.sourceforge.net/"
SRC_URI="mirror://sourceforge/omniorb/${MY_P}.tar.gz http://www-lce.eng.cam.ac.uk/~acnt2/code/omniORBpy-2.4-newstyleobjs02.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="ssl"

DEPEND=">=net-misc/omniORB-4.0.6
	ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A}
	sed -i -e "s/^CXXDEBUGFLAGS.*/CXXDEBUGFLAGS = ${CXXFLAGS}/" \
		-e "s/^CDEBUGFLAGS.*/CDEBUGFLAGS = ${CFLAGS}/" \
		${S}/mk/beforeauto.mk.in
	sed -i -e 's#^.*compileall[^\\]*#/bin/true;#' \
		${S}/python/dir.mk \
		${S}/python/omniORB/dir.mk \
		${S}/python/COS/dir.mk \
		${S}/python/CosNaming/dir.mk \
		${S}/CosNaming__POA/dir.mk

	cd ${S}
	epatch ${DISTDIR}/omniORBpy-2.4-newstyleobjs02.patch
}

src_compile() {
	MY_CONF=""

	use ssl && MY_CONF="${MY_CONF} --with-openssl=/usr"

	python_version
	MY_PY=/usr/bin/python${PYVER}

	PYTHON=${MY_PY} econf \
		--with-omniorb=/usr \
		${MY_CONF} || die "./configure failed"

	emake || die " make failed"
}

src_install() {
	# make files are crap!
	sed -i -e "s/'prefix[\t ]*:= \/usr'/'prefix := \${DESTDIR}\/usr'/" \
		mk/beforeauto.mk

	# won't work without these really very ugly hack... 
	# maybe someone can do better..

	mv python/omniORB/dir.mk python/omniORB/dir.mk_orig
	awk -v STR="ir\\\.idl" '{ if (/^[[:space:]]*$/) flag = 0; tmpstr = $0; if (gsub(STR, "", tmpstr)) flag = 1; if (flag) print "#" $0; else print $0; }' python/omniORB/dir.mk_orig > python/omniORB/dir.mk

	mv python/dir.mk python/dir.mk_orig
	awk -v STR="Naming\\\.idl" '{ if (/^[[:space:]]*$/) flag = 0; tmpstr = $0; if (gsub(STR, "", tmpstr)) flag = 1; if (flag) print "#" $0; else print $0; }' python/dir.mk_orig > python/dir.mk

	make DESTDIR=${D} install || die " install failed"

	dodoc COPYING.LIB README README.Python
	dohtml doc/omniORBpy
	dodoc doc/omniORBpy.p* # ps,pdf
	dodoc doc/tex/* # .bib, .tex

	dodir /usr/share/doc/${P}/examples
	cp -r examples/* ${D}/usr/share/doc/${P}/examples

	mv ${D}/usr/lib/python${PYVER}/site-packages/PortableServer.py \
		${D}/usr/lib/python${PYVER}/site-packages/omniorbpy_PortableServer.py

	mv ${D}/usr/lib/python${PYVER}/site-packages/CORBA.py \
		${D}/usr/lib/python${PYVER}/site-packages/omniorbpy_CORBA.py

}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/lib/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup ${ROOT}usr/lib/python${PYVER}/site-packages
}