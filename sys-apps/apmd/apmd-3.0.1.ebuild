# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Craig Joly <joly@ee.ualberta.ca>

S=${WORKDIR}/${P}
DESCRIPTION="Advanced Power Management Daemon"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/a/apmd/apmd_3.0.1-1.tar.gz"
HOMEPAGE="http://www.worldvisions.ca/~apenwarr/apmd/"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e "s:PREFIX=\/usr:PREFIX=\$\{DESTDIR\}\/usr:" Makefile | cat > Makefile
	sed -e "s:install\ \-b \-Vt:\#install\ \-b \-Vt:" Makefile | cat > Makefile
}

src_compile() {

    try emake

}

src_install () {

	try make DESTDIR=${D} install

	insinto /etc/apm
	insopts -m 0755
	doins ${S}/debian/apmd_proxy

	insinto /etc/rc.d/init.d
	insopts -m 0755 
	doins ${FILESDIR}/apmd
	doins ${FILESDIR}/svc-apmd

	insinto /var/lib/supervise/services/apmd
	insopts -m 0755
	doins ${FILESDIR}/run

	dodoc ANNOUNCE BUGS.apmsleep COPYING COPYING.LIB ChangeLog LSM \
		README README.transfer 
}
