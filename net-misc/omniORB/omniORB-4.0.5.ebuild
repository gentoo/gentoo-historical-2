# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/omniORB/omniORB-4.0.5.ebuild,v 1.4 2005/04/24 09:40:15 blubb Exp $

DESCRIPTION="A robust, high-performance CORBA 2 ORB"
SRC_URI="mirror://sourceforge/omniorb/${PF}.tar.gz"
HOMEPAGE="http://omniorb.sourceforge.net/"

IUSE="ssl"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~ia64 amd64 ~ppc ~ppc64"

DEPEND="dev-lang/python
	ssl? ( >=dev-libs/openssl-0.9.6b )"

src_unpack() {
	unpack ${A}
	sed -i -e "s/^CXXDEBUGFLAGS.*/CXXDEBUGFLAGS = ${CXXFLAGS}/" \
		-e "s/^CDEBUGFLAGS.*/CDEBUGFLAGS = ${CFLAGS}/" \
		${S}/mk/beforeauto.mk.in \
		${S}/mk/platforms/i586_linux_2.0_*.mk
}

src_compile() {
	cd ${S}

	mkdir ${S}/build
	cd ${S}/build

	MY_CONF="--prefix=/usr --with-omniORB-config=/etc/omniorb/omniORB.cfg --with-omniNames-logdir=/var/log/omniORB"

	use ssl && MY_CONF="${MY_CONF} --with-openssl=/usr"

	MY_PY=/usr/bin/python`python -c "import sys; print sys.version[:3]"`

	PYTHON=${MY_PY} ../configure ${MY_CONF} || die "./configure failed"
	emake || die "make failed"
}

src_install () {

	cd ${S}/build
	emake DESTDIR=${D} install

	cd ${S}
	dodoc COPYING* CREDITS README* ReleaseNotes*

	cd ${S}/doc
	docinto print
	dodoc *.ps
	dodoc *.tex
	dodoc *.pdf

	dodir /etc/env.d/
	echo "PATH=/usr/share/omniORB/bin/scripts" > ${D}/etc/env.d/90omniORB
	echo "OMNIORB_CONFIG=/etc/omniorb/omniORB.cfg" >> ${D}/etc/env.d/90omniORB
	exeinto /etc/init.d
	newexe ${FILESDIR}/omniORB-4.0.0 omniORB

	cp ${S}/sample.cfg ${S}/omniORB.cfg
	dodir /etc/omniorb
	insinto /etc/omniorb
	doins ${S}/omniORB.cfg

}

pkg_postinst() {
	echo "Performing post-installation routines for ${P}."

	if [ ! -f "${ROOT}etc/omniorb/omniORB.cfg" ] ; then
		echo "ORBInitialHost `uname -n`" > ${ROOT}etc/omniorb/omniORB.cfg
		echo "ORBInitialPort 2809" >> ${ROOT}etc/omniorb/omniORB.cfg
	fi
	#/usr/bin/python ${ROOT}usr/share/doc/${PF}/mkomnistubs.py
}
