# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-fs/autofs/autofs-3.1.7-r5.ebuild,v 1.4 2003/01/10 00:38:43 kain Exp $

IUSE="ldap"

S=${WORKDIR}/${P}
DESCRIPTION="Kernel based automounter"
HOMEPAGE="http://www.linux-consulting.com/Amd_AutoFS/autofs.html"
SRC_URI="ftp://ftp.kernel.org/pub/linux/daemons/autofs/${P}.tar.bz2
	ftp://ftp.de.kernel.org/pub/linux/daemons/autofs/${P}.tar.bz2
	ftp://ftp.uk.kernel.org/pub/linux/daemons/autofs/${P}.tar.bz2"

DEPEND="ldap? ( >=net-nds/openldap-1.2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 alpha ppc"

src_unpack() {
	unpack ${A}  
	cd ${S}
	patch -p0 < ${FILESDIR}/ldap_config.patch || die
	
	cd ${S}/include
	patch -p0 < ${FILESDIR}/automount.diff || die

	cd ${S}/daemon
	mv Makefile Makefile.orig
	sed -e 's/LIBS \= \-ldl/LIBS \= \-ldl \-lnsl \$\{LIBLDAP\}/' Makefile.orig > Makefile 
}

src_compile() {
	local myconf
	use ldap || myconf="--without-openldap"
	
	./configure \
	    --host=${HOST} \
	    --prefix=/usr \
	    ${myconf} || die
	make || die
}

src_install() {
	into /usr
	dosbin daemon/automount
	insinto /usr/lib/autofs
	insopts -m 755
	doins modules/*.so

	dodoc COPYING COPYRIGHT NEWS README* TODO
	cd man
	doman auto.master.5 autofs.5 autofs.8 automount.8

	cd ../samples
	dodir /etc/autofs
	cp ${FILESDIR}/auto.master ${D}/etc/autofs
	cp ${FILESDIR}/auto.misc ${D}/etc/autofs

	exeinto /etc/init.d ; newexe ${FILESDIR}/autofs.rc8 autofs
	insinto /etc/conf.d ; newins ${FILESDIR}/autofs.confd autofs
}

pkg_postinst() {

	einfo "Note: If you plan on using autofs for automounting"
	einfo "remote NFS mounts without having the NFS daemon running"
	einfo "please add portmap to your default run-level."
	echo ""
	einfo "Also the normal autofs status has been renamed stats"
	einfo "as there is already a predefined Gentoo status"
}	
