# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fcron/fcron-2.0.0-r4.ebuild,v 1.8 2004/10/11 14:19:17 ka0ttic Exp $

inherit eutils flag-o-matic

DESCRIPTION="A command scheduler with extended capabilities over cron and anacron"
HOMEPAGE="http://fcron.free.fr/"
SRC_URI="http://fcron.free.fr/archives/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips hppa amd64"
IUSE=""

DEPEND="virtual/editor"
RDEPEND="!virtual/cron
	>=sys-apps/cronbase-0.2.1-r3
	virtual/mta"
PROVIDE="virtual/cron"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-configure.diff
	epatch ${FILESDIR}/${P}-gcc34.diff
	# fix LIBOBJS vs AC_LIBOBJ problem
	sed -i -e 's|LIBOBJS|AC_LIBOBJ|g' configure.in
	# respect LDFLAGS
	sed -i "s:\(@LIBS@\):\$(LDFLAGS) \1:" Makefile.in || die "sed failed"
	autoconf || die "autoconf problem"
}

src_compile() {
	# QA security notice fix; see "[gentoo-core] Heads up changes in suid
	# handing with portage >=51_pre21" for more details.
	append-ldflags -Wl,-z,now

	econf \
		--with-username=cron \
		--with-groupname=cron \
		--with-piddir=/var/run \
		--with-etcdir=/etc/fcron \
		--with-spooldir=/var/spool/cron \
		--with-sendmail=/usr/sbin/sendmail \
		--with-editor="${EDITOR}" \
		--with-cflags="${CFLAGS}" \
		|| die "bad ./configure"

	emake || die "compile problem"
}

src_install() {
	insinto /usr/sbin
	insopts -o root -g root -m 0110 ; doins fcron
	insinto /usr/bin
	insopts -o cron -g cron -m 6110 ; doins fcrontab
	insopts -o root -g cron -m 6110 ; doins fcronsighup

	dosym fcrontab /usr/bin/crontab

	doman doc/*.{1,3,5,8}

	dodoc MANIFEST VERSION doc/{CHANGES,README,FAQ,INSTALL,THANKS}
	newdoc ${FILESDIR}/fcron.conf fcron.conf.sample
	docinto html ; dohtml doc/*.html
	dodoc ${FILESDIR}/crontab

	insinto /etc/fcron
	insopts -m 640 -o root -g cron
	doins ${FILESDIR}/{fcron.allow,fcron.deny,fcron.conf}

	exeinto /etc/init.d
	newexe ${FILESDIR}/fcron.rc6 fcron

	dodir /etc
	install -o root -g root -m 0644 ${FILESDIR}/crontab ${D}/etc/crontab
}

pkg_postinst() {
	# empty dir
	install -m0770 -o cron -g cron -d ${ROOT}/var/spool/cron/fcrontabs

	einfo
	einfo "To activate /etc/cron.{hourly|daily|weekly|montly} please run: "
	einfo "crontab /etc/crontab"
	einfo
	einfo "!!! That will replace root's current crontab !!!"
	einfo
}
