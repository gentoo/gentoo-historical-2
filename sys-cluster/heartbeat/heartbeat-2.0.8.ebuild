# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/heartbeat/heartbeat-2.0.8.ebuild,v 1.1 2007/02/28 17:29:28 xmerlin Exp $

inherit flag-o-matic eutils

DESCRIPTION="Heartbeat high availability cluster manager"
HOMEPAGE="http://www.linux-ha.org"
SRC_URI="http://www.linux-ha.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -mips ~ppc -s390 ~x86"
IUSE="ldirectord doc snmp management"

DEPEND="
	=dev-libs/glib-2*
	net-libs/libnet
	dev-util/pkgconfig
	>=dev-lang/perl-5.8.8
	net-misc/iputils
	virtual/ssh
	net-libs/gnutls
	ldirectord? (	sys-cluster/ipvsadm
			dev-perl/Net-DNS
			dev-perl/libwww-perl
			dev-perl/perl-ldap
			perl-core/libnet
			dev-perl/Crypt-SSLeay
			dev-perl/HTML-Parser
			dev-perl/perl-ldap
			dev-perl/Mail-IMAPClient
			dev-perl/Mail-POP3Client
			dev-perl/MailTools
	)
	snmp? ( net-analyzer/net-snmp )
	net-misc/telnet-bsd
	dev-lang/swig
	management? (
		>=dev-lang/python-2.4
		>=dev-python/pygtk-2.4
		>=sys-libs/pam-0.78-r3
	)
	"

src_unpack() {
	unpack ${A}
	cd ${S}
	#epatch ${FILESDIR}/${P}-update-resources-failcount.patch || die
	epatch ${FILESDIR}/${P}-crm-leaks.patch || die
}

src_compile() {
	append-ldflags $(bindnow-flags)

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-group-name=cluster \
		--with-group-id=65 \
		--with-ccmuser-name=cluster \
		--with-ccmuser-id=65 \
		--enable-checkpointd \
		--enable-crm \
		--enable-lrm \
		$(use_enable management mgmt) \
		|| die
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

	if use management ; then
		keepdir /var/lib/heartbeat/mgmt
	fi

	# if ! USE="ldirectord" then don't install it
	if ! use ldirectord ; then
		rm ${D}/etc/init.d/ldirectord
		rm ${D}/etc/logrotate.d/ldirectord
		rm ${D}/etc/ha.d/resource.d/ldirectord
		rm ${D}/usr/share/man/man8/supervise-ldirectord-config.8
		rm ${D}/usr/share/man/man8/ldirectord.8
		rm ${D}/usr/sbin/ldirectord
		rm ${D}/usr/sbin/supervise-ldirectord-config
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/heartbeat-init heartbeat

	dodoc ldirectord/ldirectord.cf doc/*.cf doc/haresources doc/authkeys || die
	if use doc ; then
		dodoc README doc/*.txt doc/AUTHORS doc/COPYING  || die
	fi
}
