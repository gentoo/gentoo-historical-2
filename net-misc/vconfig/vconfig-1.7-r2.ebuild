# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vconfig/vconfig-1.7-r2.ebuild,v 1.2 2004/02/23 00:16:54 agriffis Exp $

MY_PN="vlan"
S=${WORKDIR}/${MY_PN}

DESCRIPTION="802.1Q vlan control utility"
HOMEPAGE="http://www.candelatech.com/~greear/vlan.html"
SRC_URI="http://www.candelatech.com/~greear/vlan/${MY_PN}.${PV}.tar.gz
mirror://gentoo/vconfig-1.7-gcc33-multiline.patch"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc "
IUSE="static"
DEPEND=">=sys-kernel/linux-headers-2.4.14"
RDEPEND=">=virtual/kernel-2.4.14"

src_unpack() {
	unpack ${MY_PN}.${PV}.tar.gz
	epatch ${DISTDIR}/vconfig-1.7-gcc33-multiline.patch
}

src_compile() {
	use static && LDFLAGS="${LDFLAGS} -static"
	emake CC="${CC}" CCFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	into /
	dosbin vconfig || die "dosbin error"

	sed -e "s:/usr/local/bin/vconfig:/sbin/vconfig:g" -i vlan_test.pl
	sed -e "s:/usr/local/bin/vconfig:/sbin/vconfig:g" -i vlan_test2.pl

	doman vconfig.8 || die "doman error"
	dohtml howto.html vlan.html || die "dohtml error"
	dodoc CHANGELOG README vlan_test*.pl || die "dodoc error"
}

pkg_postinst() {
	einfo "802.1Q VLAN support is now in the linux kernel as of 2.4.14."
	ewarn "MTU problems exist for many ethernet drivers."
	ewarn "Reduce the MTU on the interface to 1496 to work around them."

}
