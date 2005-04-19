# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.2.1.ebuild,v 1.9 2005/04/19 12:47:21 ka0ttic Exp $

inherit eutils fixheadtails perl-module

DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://net-snmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~arm ~hppa ~amd64 ~ia64 ~s390 ppc64 ~mips"
IUSE="perl ipv6 ssl tcpd X lm_sensors minimal smux selinux doc rpm elf"

DEPEND="virtual/libc
	!minimal? ( <sys-libs/db-2 )
	>=sys-libs/zlib-1.1.4
	ssl? ( >=dev-libs/openssl-0.9.6d )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	lm_sensors? (
		x86?   ( sys-apps/lm_sensors )
		amd64? ( sys-apps/lm_sensors )
	)
	rpm? ( app-arch/rpm
		dev-libs/popt
		app-arch/bzip2
	)
	elf? ( dev-libs/elfutils )"

RDEPEND="${DEPEND}
	dev-perl/TermReadKey
	perl? ( X? ( dev-perl/perl-tk ) )
	selinux? ( sec-policy/selinux-snmpd )"

DEPEND="${DEPEND}
	>=sys-apps/sed-4
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd ${S}

	if use lm_sensors; then
		if use x86 || use amd64; then
			epatch ${FILESDIR}/${PN}-lm_sensors.patch
		else
			eerror "Unfortunatly you are trying to enable lm_sensors support for an unsupported arch."
			eerror "please check the availability of sys-apps/lm_sensors - if it is available on"
			eerror "your arch, please file a bug about this."
			die "lm_sensors patch error: unsupported arch."
		fi
	fi

	#wrt to bugs 68467, 68254
	sed -i -e \
		's/^NSC_AGENTLIBS="@AGENTLIBS@"/NSC_AGENTLIBS="@AGENTLIBS@ @WRAPLIBS@"/' \
		net-snmp-config.in || die "sed net-snmp-config.in"
	sed -i -e 's;embed_perl="yes",;embed_perl=$enableval,;' configure.in \
		|| die "sed configure.in failed"

	ht_fix_all

	epatch ${FILESDIR}/${P}-conf-elf-rpm-bz2.patch || die "patch failed"

	# fix access violation in make check
	sed -i 's/\(snmpd.*\)-Lf/\1-l/' testing/eval_tools.sh || \
		die "sed eval_tools.sh failed"
}

src_compile() {
	local myconf mibs

	autoconf || die "autoconf failed"

	myconf="${myconf} `use_enable perl embedded-perl`"
	myconf="${myconf} `use_with ssl openssl` `use_enable !ssl internal-md5`"
	myconf="${myconf} `use_with tcpd libwrap`"
	myconf="${myconf} `use_enable ipv6`"

	mibs="host ucd-snmp/dlmod"
	use smux && mibs="${mibs} smux"

	econf \
		--with-sys-location="Unknown" \
		--with-sys-contact="root@Unknown" \
		--with-default-snmp-version="3" \
		--with-mib-modules="${mibs}" \
		--with-logfile="${ROOT}/var/log/net-snmpd.log" \
		--with-persistent-directory="${ROOT}/var/lib/net-snmp" \
		--enable-ucd-snmp-compatibility \
		--enable-shared \
		--with-zlib \
		`use_with rpm` \
		`use_with rpm bzip2` \
		`use_with elf` \
		--with-install-prefix="${D}" \
		${myconf} || die "econf failed"

	emake -j1 || die "compile problem"

	if use perl ; then
		emake perlmodules || die "compile perl modules problem"
	fi

	if use doc ; then
		einfo "Building HTML Documentation"
		make docsdox || die "failed to build docs"
	fi
}

src_test() {
	cd testing
	make test || die "make test failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	if use perl ; then
		make DESTDIR="${D}" perlinstall || die "make perlinstall failed"
		fixlocalpod

		use X || rm -f "${D}/usr/bin/tkmib"
	else
		rm -f "${D}/usr/bin/mib2c" "${D}/usr/bin/tkmib"
	fi

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO
	newdoc EXAMPLE.conf.def EXAMPLE.conf

	use doc && dohtml docs/html/*

	keepdir /etc/snmp /var/lib/net-snmp

	newinitd ${FILESDIR}/snmpd-5.1.rc6 snmpd
	newconfd ${FILESDIR}/snmpd-5.1.conf snmpd

	# snmptrapd can use the same rc script just slightly modified
	sed -e 's/net-snmpd/snmptrapd/g' \
		-e 's/snmpd/snmptrapd/g' \
		-e 's/SNMPD/SNMPTRAPD/g' \
		${D}/etc/init.d/snmpd > ${D}/etc/init.d/snmptrapd || die
	chmod 0755 ${D}/etc/init.d/snmptrapd

	newconfd ${FILESDIR}/snmptrapd.conf snmptrapd

	# Remove everything, keeping only the snmpd, snmptrapd, MIBs, libs, and includes.
	if use minimal; then
		einfo "USE=minimal is set. Cleaning up excess cruft for a embedded/minimal/server only install."
		rm -rf ${D}/usr/bin/{encode_keychange,snmp{get,getnext,set,usm,walk,bulkwalk,table,trap,bulkget,translate,status,delta,test,df,vacm,netstat,inform}}
		rm -rf ${D}/usr/share/snmp/snmpconf-data ${D}/usr/share/snmp/*.conf
		rm -rf ${D}/usr/bin/{net-snmp-config,fixproc,traptoemail} ${D}/usr/bin/snmpc{heck,onf}
		find ${D} -name '*.pl' -exec rm -f '{}' \;
		use ipv6 || rm -rf ${D}/usr/share/snmp/mibs/IPV6*
	fi
}
