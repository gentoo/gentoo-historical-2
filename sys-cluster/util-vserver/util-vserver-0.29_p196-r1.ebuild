# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/util-vserver/util-vserver-0.29_p196-r1.ebuild,v 1.4 2004/06/24 22:41:24 agriffis Exp $

inherit eutils

MY_P="${P/_p/.}"
DESCRIPTION="Vserver admin-tools."
#SRC_URI="http://www-user.tu-chemnitz.de/~ensc/util-vserver/${P}.tar.bz2"
SRC_URI="http://www.13thfloor.at/vserver/d_release/v1.3.8/${MY_P}.tar.bz2"
HOMEPAGE="http://www.13thfloor.at/vserver/ http://savannah.nongnu.org/projects/util-vserver/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

## TODO: optional (though NOT recommended) depend on dietlibc?
## hmm, dietlibc-linking results in ld-errors ...
#DEPEND="dev-libs/dietlibc"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	#./configure --prefix=/usr --disable-internal-headers || die "configure failed"
	econf || die "econf failed"
	make || die "compile failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"

	## state-dir:
	keepdir /var/run/vservers
	## the actual vservers go there:
	keepdir /vservers
	fperms 000 /vservers

	dodoc README ChangeLog NEWS AUTHORS INSTALL THANKS util-vserver.spec

	## remove the non-gentoo init-scripts:
	rm -r ${D}/etc/init.d
	## ... and install gentoo'ized ones:
	insinto /etc/init.d/
	doins ${FILESDIR}/vservers.initd
	doins ${FILESDIR}/rebootmgr.initd
}
