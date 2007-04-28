# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/heartbeat/heartbeat-1.2.5.ebuild,v 1.3 2007/04/28 17:46:56 swegener Exp $

inherit flag-o-matic

DESCRIPTION="Heartbeat high availability cluster manager"
HOMEPAGE="http://www.linux-ha.org"
SRC_URI="http://www.linux-ha.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -mips ~ppc ~amd64"
IUSE="ldirectord"

DEPEND="dev-libs/popt
	=dev-libs/glib-1.2*
	net-libs/libnet
	ldirectord? (	sys-cluster/ipvsadm
			dev-perl/libwww-perl
			dev-perl/perl-ldap
			virtual/perl-libnet )"

# need to add dev-perl/Mail-IMAPClient inside ldirectord above

src_compile() {
	append-ldflags -Wl,-z,now

	./configure --prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-group-name=cluster \
		--with-group-id=65 \
		--with-ccmuser-name=cluster \
		--with-ccmuser-id=65 || die
	emake -j 1 || die "compile problem"
}

pkg_preinst() {
	# check for cluster group, if it doesn't exist make it
	if ! grep -q cluster.*65 /etc/group ; then
		groupadd -g 65 cluster
	fi
	# check for cluster user, if it doesn't exist make it
	if ! grep -q cluster.*65 /etc/passwd ; then
		useradd -u 65 -g cluster -s /dev/null -d /var/lib/heartbeat cluster
	fi
}

src_install() {
	make DESTDIR=${D} install || die

	# heartbeat modules need these dirs
	keepdir /var/lib/heartbeat/ckpt /var/lib/heartbeat/ccm /var/lib/heartbeat

	keepdir /etc/ha.d/conf

	dosym /usr/sbin/ldirectord /etc/ha.d/resource.d/ldirectord || die

	# if ! USE="ldirectord" then don't install it
	if ! use ldirectord ; then
		rm ${D}/etc/init.d/ldirectord
		rm ${D}/etc/logrotate.d/ldirectord
		rm ${D}/usr/man/man8/supervise-ldirectord-config.8
		rm ${D}/usr/man/man8/ldirectord.8
		rm ${D}/usr/sbin/ldirectord
		rm ${D}/usr/sbin/supervise-ldirectord-config
		rm ${D}/etc/ha.d/resource.d/ldirectord
	fi

	newinitd ${FILESDIR}/heartbeat-init heartbeat
}
