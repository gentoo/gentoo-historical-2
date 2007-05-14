# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/proftpd/proftpd-1.3.1_rc2-r1.ebuild,v 1.6 2007/05/14 21:09:48 gustavoz Exp $

inherit eutils flag-o-matic toolchain-funcs

KEYWORDS="alpha ~amd64 hppa ~mips ~ppc ppc64 sparc x86"

IUSE="acl authfile clamav hardened ifsession ipv6 ldap mysql ncurses nls noauthunix opensslcrypt pam postgres radius rewrite selinux shaper sitemisc softquota ssl tcpd vroot xinetd"

SHAPER_VER="0.6.2"
VROOT_VER="0.7.2"

DESCRIPTION="An advanced and very configurable FTP server."
SRC_URI="ftp://ftp.proftpd.org/distrib/source/${P/_/}.tar.bz2
		clamav? ( http://www.uglyboxindustries.com/mod_clamav_new.c http://www.uglyboxindustries.com/mod_clamav_new.html )
		shaper? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-shaper-${SHAPER_VER}.tar.gz )
		vroot? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-vroot-${VROOT_VER}.tar.gz )"
HOMEPAGE="http://www.proftpd.org/
		http://www.castaglia.org/proftpd/
		http://www.uglyboxindustries.com/open-source.php"

SLOT="0"
LICENSE="GPL-2"

DEPEND="acl? ( sys-apps/acl sys-apps/attr )
		clamav? ( app-antivirus/clamav )
		ldap? ( >=net-nds/openldap-1.2.11 )
		mysql? ( virtual/mysql )
		ncurses? ( sys-libs/ncurses )
		opensslcrypt? ( >=dev-libs/openssl-0.9.6f )
		pam? ( virtual/pam )
		postgres? ( >=dev-db/postgresql-7.3 )
		ssl? ( >=dev-libs/openssl-0.9.6f )
		tcpd? ( >=sys-apps/tcp-wrappers-7.6-r3 )
		xinetd? ( sys-apps/xinetd )"

RDEPEND="${DEPEND}
		net-ftp/ftpbase
		selinux? ( sec-policy/selinux-ftpd )"

S="${WORKDIR}/${P/_/}"

pkg_setup() {
	# Add the proftpd user to make the default config
	# work out-of-the-box
	enewgroup proftpd
	enewuser proftpd -1 -1 -1 proftpd
}

src_unpack() {
	unpack ${P/_/}.tar.bz2

	cd "${S}"

	# Fix bugs #164612, #167003 and #175082
	epatch "${FILESDIR}/${P}-bug164612.patch"
	epatch "${FILESDIR}/${P}-bug167003.patch"
	epatch "${FILESDIR}/${P}-bug175082.patch"

	# Fix stripping of files
	sed -e "s| @INSTALL_STRIP@||g" -i Make*

	if use shaper ; then
		unpack ${PN}-mod-shaper-${SHAPER_VER}.tar.gz
		cp -f mod_shaper/mod_shaper.c contrib/
	fi

	if use clamav ; then
		cp -f "${DISTDIR}/mod_clamav_new.c" contrib/mod_clamav.c
		cp -f "${DISTDIR}/mod_clamav_new.html" doc/mod_clamav.html
	fi

	if use vroot ; then
		unpack ${PN}-mod-vroot-${VROOT_VER}.tar.gz
		cp -f mod_vroot/mod_vroot.c contrib/
		cp -f mod_vroot/mod_vroot.html doc/
	fi
}

src_compile() {
	addpredict /etc/krb5.conf
	local modules myconf

	modules="mod_ratio:mod_readme"
	use acl && modules="${modules}:mod_facl"
	use clamav && modules="${modules}:mod_clamav"
	use pam && modules="${modules}:mod_auth_pam"
	use radius && modules="${modules}:mod_radius"
	use rewrite && modules="${modules}:mod_rewrite"
	use shaper && modules="${modules}:mod_shaper"
	use sitemisc && modules="${modules}:mod_site_misc"
	use ssl && modules="${modules}:mod_tls"
	use tcpd && modules="${modules}:mod_wrap"
	use vroot && modules="${modules}:mod_vroot"

	# pam needs to be explicitely disabled
	use pam || myconf="${myconf} --enable-auth-pam=no"

	if use ldap ; then
		modules="${modules}:mod_ldap"
		append-ldflags "-lresolv"
	fi

	if use opensslcrypt ; then
		append-ldflags "-lcrypto"
		myconf="${myconf} --enable-openssl --with-includes=/usr/include/openssl"
		CFLAGS="${CFLAGS} -DHAVE_OPENSSL"
	fi

	if use nls ; then
		myconf="${myconf} --enable-nls"
	fi

	if use mysql && use postgres ; then
		ewarn "ProFTPD only supports either the MySQL or PostgreSQL modules."
		ewarn "Presently this ebuild defaults to mysql. If you would like to"
		ewarn "change the default behaviour, merge ProFTPD with:"
		ewarn "USE='-mysql postgres' emerge proftpd"
		epause 5
	fi

	if use mysql ; then
		modules="${modules}:mod_sql:mod_sql_mysql"
		myconf="${myconf} --with-includes=/usr/include/mysql"
	elif use postgres ; then
		modules="${modules}:mod_sql:mod_sql_postgres"
		myconf="${myconf} --with-includes=/usr/include/postgresql"
	fi

	if use softquota ; then
		modules="${modules}:mod_quotatab"
		if use mysql || use postgres ; then
			modules="${modules}:mod_quotatab_sql"
		fi
		if use ldap ; then
			modules="${modules}:mod_quotatab_file:mod_quotatab_ldap"
		else
			modules="${modules}:mod_quotatab_file"
		fi
	fi

	# mod_ifsession should be the last module in the --with-modules list
	# see http://www.castaglia.org/proftpd/modules/mod_ifsession.html#Installation
	use ifsession && modules="${modules}:mod_ifsession"

	# bug #30359
	use hardened && echo > lib/libcap/cap_sys.c
	gcc-specs-pie && echo > lib/libcap/cap_sys.c

	if use noauthunix ; then
		myconf="${myconf} --disable-auth-unix"
	else
		myconf="${myconf} --enable-auth-unix"
	fi

	econf \
		--sbindir=/usr/sbin \
		--localstatedir=/var/run \
		--sysconfdir=/etc/proftpd \
		--enable-shadow \
		--enable-autoshadow \
		--enable-ctrls \
		--with-modules=${modules} \
		$(use_enable acl facl) \
		$(use_enable authfile auth-file) \
		$(use_enable ipv6) \
		$(use_enable ncurses) \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# Note rundir needs to be specified to avoid sandbox violation
	# on initial install. See Make.rules
	emake DESTDIR="${D}" install || die "emake install failed"

	keepdir /var/run/proftpd

	dodoc "${FILESDIR}/proftpd.conf" \
		COPYING CREDITS ChangeLog NEWS README* \
		doc/license.txt
	dohtml doc/*.html

	use shaper && dohtml mod_shaper/mod_shaper.html

	docinto rfc
	dodoc doc/rfc/*.txt

	mv -f "${D}/etc/proftpd/proftpd.conf" "${D}/etc/proftpd/proftpd.conf.distrib"

	insinto /etc/proftpd
	newins "${FILESDIR}/proftpd.conf" proftpd.conf.sample

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/proftpd.xinetd" proftpd
	fi

	newinitd "${FILESDIR}/proftpd.rc6" proftpd
}

pkg_postinst() {
	elog
	elog "You can find the config files in /etc/proftpd"
	elog
	ewarn "With the introduction of net-ftp/ftpbase the ftp user is now ftp."
	ewarn "Remember to change that in the configuration file."
	ewarn
	if use clamav ; then
		ewarn "mod_clamav was updated to a new version, which uses Clamd"
		ewarn "only for virus scanning, so you'll have to set Clamd up"
		ewarn "and start it, also re-check the mod_clamav docs."
		ewarn
	fi
}
