# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/hddtemp/hddtemp-0.3_beta15.ebuild,v 1.3 2006/06/17 17:28:52 gmsoft Exp $

inherit eutils

MY_P=${P/_beta/-beta}

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives
	foobar"
HOMEPAGE="http://www.guzu.net/linux/hddtemp.php"
SRC_URI="http://www.guzu.net/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 hppa ~ppc ~sparc ~x86"
IUSE="nls"

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-byteswap.patch
	cp ${FILESDIR}/hddtemp.db ${T}
	EPATCH_OPTS="-d ${T}" epatch ${FILESDIR}/${P}-maxtor-diamondmax10.patch
}

src_compile() {
	local myconf

	myconf="--with-db-path=/usr/share/hddtemp/hddtemp.db"
	# disabling nls breaks compiling
	use nls || myconf="--disable-nls ${myconf}"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README TODO ChangeLog

	insinto /usr/share/hddtemp
	doins ${T}/hddtemp.db

	newconfd ${FILESDIR}/hddtemp-conf.d hddtemp
	newinitd ${FILESDIR}/hddtemp-init hddtemp
}

pkg_postinst() {
	einfo "In order to update your hddtemp database, run:"
	einfo "  ebuild /var/db/pkg/app-admin/${PF}/${PF}.ebuild config"
}

pkg_config() {
	cd ${ROOT}/usr/share/hddtemp

	einfo "Trying to download the latest hddtemp.db file"
	wget http://www.guzu.net/linux/hddtemp.db -O hddtemp.db

	einfo "Attempting to apply gentoo patches for further entries."
	epatch ${FILESDIR}/${P}-maxtor-diamondmax10.patch
}
