# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/heartbeat/heartbeat-2.0.2.ebuild,v 1.1 2005/11/13 18:22:49 xmerlin Exp $

inherit flag-o-matic

DESCRIPTION="Heartbeat high availability cluster manager"
HOMEPAGE="http://www.linux-ha.org"
SRC_URI="http://www.linux-ha.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 -mips -ppc -amd64"
IUSE="ldirectord stonith pils doc"


#dev-libs/popt

DEPEND="
	=dev-libs/glib-2*
	net-libs/libnet
	dev-util/pkgconfig
	dev-lang/perl
	net-misc/iputils
	net-misc/openssh
	ldirectord? (	sys-cluster/ipvsadm
			dev-perl/Net-DNS
			dev-perl/libwww-perl
			dev-perl/perl-ldap
			dev-perl/libnet
			dev-perl/Crypt-SSLeay
			dev-perl/HTML-Parser
			dev-perl/perl-ldap
			dev-perl/Mail-IMAPClient
	)
	stonith? (
			net-misc/telnet-bsd
	)
"


src_unpack() {
	unpack ${A}
	cd ${S}
	#epatch ${FILESDIR}/heartbeat-1.2.3-misc_security_fixes.patch || die
}

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
	#keepdir /var/lib/heartbeat/ckpt /var/lib/heartbeat/ccm /var/lib/heartbeat

	keepdir /var/lib/heartbeat/crm /var/lib/heartbeat/lrm /var/lib/heartbeat/fencing
	keepdir /var/lib/heartbeat/cores/cluster /var/lib/heartbeat/cores/root /var/lib/heartbeat/cores/nobody

	keepdir /var/run/heartbeat/ccm /var/run/heartbeat/crm

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
	fi

	if ! use stonith ; then
		rm ${D}/usr/include/stonith
		rm -r ${D}/usr/lib/*stonith*
		rm ${D}/usr/sbin/stonith
		rm ${D}/usr/sbin/meatclient
		rm ${D}/usr/man/man8/stonith.8*
		rm ${D}/usr/man/man8/meatclient.8*
	fi

	if ! use pils ; then
		rm ${D}/usr/include/pils
		rm -r ${D}/usr/lib/*pils*
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/heartbeat-init heartbeat

	dodoc ldirectord/ldirectord.cf doc/*.cf doc/haresources doc/authkeys || die
	if use doc ; then
		dodoc README doc/*.txt doc/AUTHORS doc/COPYING  || die
	fi
}
