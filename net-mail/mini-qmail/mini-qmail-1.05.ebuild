# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mini-qmail/mini-qmail-1.05.ebuild,v 1.2 2004/04/03 03:40:53 vapier Exp $

inherit eutils gcc fixheadtails

DESCRIPTION="a small null client that forwards mail via QMQP to a full qmail server"
HOMEPAGE="http://www.qmail.org/"
SRC_URI="http://www.qmail.org/netqmail-${PV}.tar.gz
	http://www.din.or.jp/~ushijima/mini-qmail-kit/mini-qmail-kit-0.52.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~mips ~hppa"

DEPEND="virtual/glibc
	sys-apps/groff"
RDEPEND="!virtual/mta
	virtual/glibc"
PROVIDE="virtual/mta
	 virtual/mda"

S=${WORKDIR}/netqmail-${PV}/netqmail-${PV}

src_unpack() {
	unpack netqmail-${PV}.tar.gz
	unpack mini-qmail-kit-0.52.tar.gz

	cd netqmail-${PV}
	./collate.sh || die "patching failed"
	mv ${WORKDIR}/mini-qmail-kit-0.52/* ${S}/

	cd ${S}
	echo -n "$(gcc-getCC) ${CFLAGS}" >${S}/conf-cc
	echo -n "$(gcc-getCC) ${LDFLAGS}" > ${S}/conf-ld
	ht_fix_file ${S}/Makefile
}

src_compile() {
	emake it man || die
}

src_install() {
	einfo "Setting up directory hierarchy ..."
	keepdir /var/mini-qmail/control

	dodoc FAQ UPGRADE SENDMAIL INSTALL* TEST* REMOVE* PIC* SECURITY
	dodoc SYSDEPS TARGETS THANKS THOUGHTS TODO VERSION README*

	exeinto /var/mini-qmail/bin
	doexe qmail-qmqpc forward qmail-inject \
		sendmail predate datemail mailsubj \
		qmail-showctl maildirmake maildir2mbox \
		maildirwatch qail elq pinq \
		|| die "doexe failed"
	dosym qmail-qmqpc /var/mini-qmail/bin/qmail-queue
	newexe config-mini.sh config-mini
	dosed "s:QMAIL:/var/mini-qmail/:g" /var/mini-qmail/bin/config-mini

	doman qmail-qmqpc.8 forward.1 qmail-inject.8 \
		mailsubj.1 qmail-showctl.8 maildirmake.1 \
		maildir2mbox.1 maildirwatch.1 qmail-queue.8 \
		qmail.7

	einfo "Adding env.d entry for qmail"
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/99qmail

	einfo "Creating sendmail replacement ..."
	diropts -m 755
	dodir /usr/sbin /usr/lib
	dosym /var/mini-qmail/bin/sendmail /usr/sbin/sendmail
	dosym /var/mini-qmail/bin/sendmail /usr/lib/sendmail
}

pkg_postinst() {
	einfo "In order for mini-qmail to work, you need to setup"
	einfo "the QMTP server information."
	einfo "Just run /var/mini-qmail/bin/config-mini for more information."
}
