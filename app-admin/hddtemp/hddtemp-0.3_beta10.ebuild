# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/hddtemp/hddtemp-0.3_beta10.ebuild,v 1.6 2004/06/25 16:12:01 vapier Exp $

MY_P=${P/_beta/-beta}

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives"
HOMEPAGE="http://coredump.free.fr/linux/hddtemp.php"
SRC_URI="http://coredump.free.fr/linux/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc -sparc -amd64"
IUSE=""

DEPEND="virtual/libc
	net-misc/wget"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A} ; cd ${S}

	ebegin "Trying to download the latest hddtemp.db file"
	wget -q --timeout=10 http://coredump.free.fr/linux/hddtemp.db
	eend $?
}

src_compile() {
	local myconf

	myconf="--with-db-path=/usr/share/hddtemp/hddtemp.db"
# disabling nls breaks compiling
#	use nls || myconf="--disable-nls ${myconf}"
	econf $myconf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README TODO Changelog

	insinto /usr/share/hddtemp
	if [ -f hddtemp.db ]; then
		doins hddtemp.db
	else
		doins ${FILESDIR}/hddtemp.db
	fi
}
