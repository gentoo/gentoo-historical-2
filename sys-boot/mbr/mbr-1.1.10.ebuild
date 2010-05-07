# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/mbr/mbr-1.1.10.ebuild,v 1.1 2010/05/07 20:54:31 ulm Exp $

DESCRIPTION="A replacement master boot record for IBM-PC compatible computers"
HOMEPAGE="http://www.chiark.greenend.org.uk/~neilt/mbr/"
SRC_URI="http://www.chiark.greenend.org.uk/~neilt/mbr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha ~amd64 -ppc -sparc x86"
IUSE=""

DEPEND="sys-devel/bin86"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# do not treat warnings as errors
	sed -i -e "s: -Werror::" {,harness/}Makefile.{in,am}
}

src_install() {
	dosbin install-mbr
	doman install-mbr.8
	dodoc AUTHORS ChangeLog install-mbr.8 NEWS README TODO
}

pkg_postinst() {
	elog "To install the MBR, run /sbin/install-mbr"
}
