# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pax/pax-3.3.4.ebuild,v 1.10 2005/01/01 11:51:41 eradicator Exp $

inherit eutils rpm

MY_PS=${P%.*}-${PV##*.}ras
MY_P=${P%.*}
S=${WORKDIR}/${MY_P}
DESCRIPTION="pax (Portable Archive eXchange) is the POSIX standard archive tool"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/src/bin/pax/"
SRC_URI="ftp://rpmfind.net/linux/contrib/libc6/SRPMS/${MY_PS}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips alpha hppa ~amd64 ~ia64"
IUSE=""

DEPEND="virtual/libc
	app-arch/rpm2targz"

src_unpack() {
	rpm_src_unpack
	cd ${MY_P}
	epatch ${WORKDIR}/pax-3.3-gcc.patch
	epatch ${WORKDIR}/pax-3.3-modifyWarn.patch
	epatch ${WORKDIR}/pax-3.3-doc.patch
	epatch ${WORKDIR}/pax-3.3-bzip2.patch
}

src_install() {
	dobin src/pax || die
	doman src/pax.1
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
