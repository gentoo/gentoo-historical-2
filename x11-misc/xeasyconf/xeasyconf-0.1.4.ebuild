# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xeasyconf/xeasyconf-0.1.4.ebuild,v 1.2 2002/10/04 06:44:10 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Xeasyconf is a PPC only tool to assist in xfree 4.x configs"
SRC_URI="http://gentoo.org/~gerk/xeasyconf/${P}.tar.gz"
HOMEPAGE="http://gentoo.org/~gerk/xeasyconf/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc -x86 -sparc -sparc64"

DEPEND="x11-base/xfree 
	sys-apps/pciutils"
RDEPEND="dev-util/dialog"

src_compile() {

	make || die "sorry, failed to compile"
}

src_install() {
	
	dodir /usr/bin/
	dodir /usr/sbin/
	into /usr/
	dobin fbcheck
	into /usr/
	dosbin Xeasyconf

}
