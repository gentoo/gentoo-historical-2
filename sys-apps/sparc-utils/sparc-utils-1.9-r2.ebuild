# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sparc-utils/sparc-utils-1.9-r2.ebuild,v 1.5 2004/08/08 00:38:51 slarti Exp $

inherit eutils

DESCRIPTION="Various sparc utilities from Debian GNU/Linux"
HOMEPAGE="http://www.debian.org/"
SRC_URI=" http://http.us.debian.org/debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://gentoo/${PN}_${PV}-2.diff.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~sparc -x86 -ppc"
IUSE=""

DEPEND="virtual/os-headers"
RDEPEND="virtual/libc
	sys-devel/sparc32"

S="${WORKDIR}/${P}.orig"

src_unpack() {
	unpack ${A}
	epatch ${WORKDIR}/${PN}_${PV}-2.diff
}

src_compile() {
	local CFLAGS="-O3"

	emake -C elftoaout-2.3 CFLAGS="${CFLAGS}" || die
	emake -C src piggyback piggyback64 CFLAGS="${CFLAGS}" || die
	emake -C prtconf-1.3 all || die
	emake -C audioctl-1.3 || die

	# sparc32 is in sys-devel/sparc32
	# emake -C sparc32-1.1
}

src_install() {

	# since the debian/piggyback64.1 manpage is a pointer to the
	# debian/piggyback.1 manpage, copy debian/piggyback.1 to
	# debian/piggyback64.1

	cp ${S}/debian/piggyback.1 ${S}/debian/piggyback64.1

	dobin elftoaout-2.3/elftoaout || die
	dobin src/piggyback || die
	dobin src/piggyback64 || die
	dosbin prtconf-1.3/prtconf || die
	dosbin prtconf-1.3/eeprom || die

	dobin audioctl-1.3/audioctl || die

	exeinto /etc/init.d; newexe ${FILESDIR}/audioctl.init audioctl || die
	insinto /etc/conf.d; newins debian/audioctl.def audioctl || die

	doman audioctl-1.3/audioctl.1
	doman elftoaout-2.3/elftoaout.1
	doman prtconf-1.3/prtconf.8
	doman prtconf-1.3/eeprom.8
	doman debian/piggyback.1
	doman debian/piggyback64.1
}

pkg_postinst() {
	ewarn "In order to /usr/sbin/eeprom, make sure you build /dev/openprom"
	ewarn "device support (CONFIG_SUN_OPENPROMIO) into the kernel, or as a"
	ewarn "module (and that the module is loaded)."
	ewarn ""
	ewarn "If you are not using devfs, you can create /dev/openprom"
	ewarn "with the following command:"
	ewarn "\tcd /dev ; mknod openprom c 10 139"
}
