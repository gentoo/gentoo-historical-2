# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/webmin/webmin-1.170-r2.ebuild,v 1.1 2004/12/31 22:14:12 eradicator Exp $

IUSE="ssl apache2 webmin-minimal"

inherit eutils

VM_V="2.31"

DESCRIPTION="Webmin, a web-based system administration interface"
HOMEPAGE="http://www.webmin.com/"
SRC_URI="webmin-minimal? ( mirror://sourceforge/webadmin/${P}-minimal.tar.gz )
	 !webmin-minimal? ( mirror://sourceforge/webadmin/${P}.tar.gz
	                   http://www.webmin.com/download/virtualmin/virtual-server-${VM_V}.wbm.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~s390 sparc x86 ~mips"

DEPEND="dev-lang/perl"
RDEPEND="ssl? ( dev-perl/Net-SSLeay )
	dev-perl/XML-Generator"

src_unpack() {
	unpack ${A}

	# in webmin-minimal webalizer and apache2 are not present
	if ! use webmin-minimal ; then
		cd ${S}
		# Bug #47020
		epatch ${FILESDIR}/${PN}-1.130-webalizer.patch

		# Bug #50810, #51943
		if use apache2; then
			epatch ${FILESDIR}/${PN}-1.140-apache2.patch
		fi

		# Postfix should modify the last entry of the maps file
		epatch ${FILESDIR}/${PN}-1.170-postfix.patch

		mv ${WORKDIR}/virtual-server-${VM_V}.wbm ${T}/vs.tar
		tar -xf ${T}/vs.tar

		# Don't create ${HOME}/cgi-bin on new accounts
		epatch ${FILESDIR}/virtual-server-2.31-nocgibin.patch

		# Check if a newly added IP is already active
		epatch ${FILESDIR}/virtual-server-2.31-checkip.patch

		# Verify Postgres usernames
		epatch ${FILESDIR}/virtual-server-2.31-pgsql.patch

		# Fix some all name virtual items
		epatch ${FILESDIR}/virtual-server-2.31-namevirtual.patch
	fi
}

src_install() {
	rm -f mount/freebsd-mounts*
	rm -f mount/openbsd-mounts*
	rm -f mount/macos-mounts*
	(find . -name '*.cgi' ; find . -name '*.pl') | perl perlpath.pl /usr/bin/perl -
	dodir /usr/libexec/webmin
	dodir /etc/init.d
	dodir /var
	dodir /etc/pam.d
	cp -rp * ${D}/usr/libexec/webmin

	# in webmin-minimal openslp is not present
	if [ ! -f "${D}/usr/libexec/webmin/openslp/config-gentoo-linux" ] ; then
		cp ${D}/usr/libexec/webmin/openslp/config \
			${D}/usr/libexec/webmin/openslp/config-gentoo-linux
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/init.d.webmin webmin

	insinto /etc/pam.d/
	newins ${FILESDIR}/webmin-pam webmin
	echo gentoo > ${D}/usr/libexec/webmin/install-type

	# Fix ownership
	chown -R root:root ${D}

	dodir /etc/webmin
	dodir /var/log/webmin

	config_dir=${D}/etc/webmin
	var_dir=${D}/var/log/webmin
	perl=${ROOT}/usr/bin/perl
	autoos=1
	port=10000
	login=root
	crypt=`grep "^root:" ${ROOT}/etc/shadow | cut -f 2 -d :`
	host=`hostname`
	use ssl && ssl=1 || ssl=0
	atboot=0
	nostart=1
	nochown=1
	autothird=1
	nouninstall=1
	noperlpath=1
	tempdir="${T}"
	export config_dir var_dir perl autoos port login crypt host ssl nochown autothird nouninstall nostart noperlpath tempdir
	${D}/usr/libexec/webmin/setup.sh > ${T}/webmin-setup.out 2>&1 || die "Failed to create initial webmin configuration."

	# Fixup the config files to use their real locations
	sed -i 's:^pidfile=.*$:pidfile=/var/run/webmin.pid:' ${D}/etc/webmin/miniserv.conf
	find ${D}/etc/webmin -type f -exec sed -i "s:${D}:${ROOT}:g" {} \;

	# Cleanup from the config script
	rm -rf ${D}/var/log/webmin
	keepdir /var/log/webmin/

	exeinto /etc/webmin
	doexe ${FILESDIR}/uninstall.sh
}

pkg_postinst() {
	${ROOT}/etc/init.d/webmin stop >/dev/null 2>&1
	stopstatus=$?
	if [ "$stopstatus" = "0" ]; then
		# Start if it was running before
		${ROOT}/etc/init.d/webmin start
	fi

	einfo "To make webmin start at boot time, run: 'rc-update add webmin default'."
	einfo "Point your web browser to http://localhost:10000 to use webmin."
}

pkg_prerm() {
	${ROOT}/etc/init.d/webmin stop >& /dev/null
}
