# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Don Seiler <don@seiler.us>
# $Header: /var/cvsroot/gentoo-x86/app-editors/forte/forte-3.0.ebuild,v 1.1 2002/06/14 19:45:31 rphillips Exp $

S=${WORKDIR}/usr/local
DESCRIPTION="Forte/Sun ONE Studio Developer"
SRC_URI="ffj-ce-30_ml.noarch.rpm"
HOMEPAGE="http://forte.sun.com/ffj/index.html"
LICENSE="forte"

DEPEND=">=app-arch/rpm-3.0.6"
RDEPEND="virtual/x11
		>=virtual/jdk-1.3"
RESTRICT="fetch"

dyn_fetch() {
	for y in ${A} 
	do
		digest_check ${y}
			if [ $? -ne 0 ]; then
				einfo "Please download this yourself http://forte.sun.com/ffj/index.html"
   			einfo "and place it in ${DISTDIR}"
				exit 1
			fi
	done
}

src_unpack() {
	# You must download ffj-ce-30_ml.noarch.rpm
	# from real.com and put it in ${DISTDIR}
	rpm2cpio ${DISTDIR}/${A} | cpio -i --make-directories
}

src_install () {

	cp bin/runide bin/runide.orig
	sed -e "s:/usr/local/forte4j:/opt/forte4j:g" \
		bin/runide.orig >bin/runide
	rm -f bin/runide.orig

	dobin bin/runide

	dodir /opt/forte4j
	cp -Rdp ${S}/forte4j/* ${D}/opt/forte4j

	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/21forte

}

