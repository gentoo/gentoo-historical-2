# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/msyslog/msyslog-1.08a-r3.ebuild,v 1.4 2002/10/04 03:44:03 vapier Exp $

MY_P=${PN}-v${PV}
S=${WORKDIR}/${MY_P}
S2=${WORKDIR}/${PN}-gentoo
DESCRIPTION="Flexible and easy to integrate syslog with modularized input/output"
HOMEPAGE="http://www.core-sdi.com/download/download1.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz
	mirror://gentoo/${P}-gentoo.diff.tar.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="mysql? ( >=dev-db/mysql-3.23 )
	postgres? ( >=dev-db/postgresql-7 )"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A} ; cd ${S}
	# fix paths for pidfile, config file, libdir, logdir, manpages, etc...
	patch -p1 < ${S2}/${P}-gentoo.diff || die "bad patchfile"
}

src_compile() {
	local myconf
	use mysql || myconf="${myconf} --without-mysql"
	use postgres || myconf="${myconf} --without-pgsql"

	econf \
		--with-daemon-name=msyslogd \
		${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

src_install() {
	dodir /var/lib/msyslog
	dosbin src/msyslogd src/peo/peochk

	exeinto /usr/lib
	doexe src/modules/lib${PN}.so.${PV/a/}
	( cd ${D}/usr/lib ; ln -s lib${PN}.so.${PV/a/} lib${PN}.so )

	# rename these puppies...
	mv src/man/syslogd.8 src/man/msyslogd.8
	mv src/man/syslog.conf.5 src/man/msyslog.conf.5
	doman src/man/*.[85]

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS \
		QUICK_INSTALL README src/TODO doc/*
	docinto examples ; dodoc src/examples/*

	insinto /etc/msyslog ; doins ${S2}/msyslog.conf
	insinto /etc/conf.d ; newins ${S2}/msyslog-confd msyslog
	exeinto /etc/init.d ; newexe ${S2}/msyslog-init msyslog
}

pkg_postinst() {
	# the default /etc/msyslog/msyslog.conf uses these, so make sure
	# it 'just works' for those who wont bother changing the config.
	touch ${ROOT}/var/log/messages
	touch ${ROOT}/var/log/syslog
}
